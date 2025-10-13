Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24B3309DCD;
	Mon, 13 Oct 2025 15:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367605; cv=none; b=QscUh4ApuR73LfDEw/d5YZDBO8yQviZ0Pdj/woa76EKPoFzpZzNsPenm7ayyfFUJLZ7PlOJTX1fUvxd2ltXM5TVBfEoDd/l46HrUXnvOkJO/u9bFX/Q3hGcz85zXguzkAG/XmGzppNyj9YuHfg42c9po4BNCK02IO1DVbtY50b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367605; c=relaxed/simple;
	bh=FYJVcH03nAsCXLG8Ou3d9hVV0MwVUP3GOkjF3NBSxh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=op/eVHX9YhijP7kUfOBGkfmlUPqtIMIaWwyVKoAWDZE9C8ApqLbJ3wLrHJRu05FEUX+ezviY7Q+zNJAmHdrHx5FQulkpJ5Dmby3R0I8kxisGs0TXylmGZtspc0PJwqDnU8Pe0fjFbjdyrnTMl1NPk/ztEJ9l3yho11ktrxBE6+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fa9K8Svx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fa9K8Svx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AADC4CEE7;
	Mon, 13 Oct 2025 15:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367604;
	bh=FYJVcH03nAsCXLG8Ou3d9hVV0MwVUP3GOkjF3NBSxh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fa9K8SvxK3Ex66z0+FrNRvVHjlehFYFLLTuI90JzOuJIaPukXBYtiXvOw9+XLIq+x
	 mup+YCju/osD+4RdUZbETQ1+vviWQ5/2uoxQ5P3DQhJlfDD93KpLHAsZpNozkqYzoe
	 HGD+VYHVtIol66n45UbOOyMKsZwjpLxInjD+sQXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/196] pinctrl: renesas: Use int type to store negative error codes
Date: Mon, 13 Oct 2025 16:43:47 +0200
Message-ID: <20251013144316.508940386@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 9f062fc5b0ff44550088912ab89f9da40226a826 ]

Change the 'ret' variable in sh_pfc_pinconf_group_set() from unsigned
int to int, as it needs to store either negative error codes or zero
returned by sh_pfc_pinconf_set().

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Fixes: d0593c363f04ccc4 ("pinctrl: sh-pfc: Propagate errors on group config")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250831084958.431913-4-rongqianfeng@vivo.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/renesas/pinctrl.c b/drivers/pinctrl/renesas/pinctrl.c
index 4d9d58fc1356f..852e179f9e383 100644
--- a/drivers/pinctrl/renesas/pinctrl.c
+++ b/drivers/pinctrl/renesas/pinctrl.c
@@ -730,7 +730,8 @@ static int sh_pfc_pinconf_group_set(struct pinctrl_dev *pctldev, unsigned group,
 	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
 	const unsigned int *pins;
 	unsigned int num_pins;
-	unsigned int i, ret;
+	unsigned int i;
+	int ret;
 
 	pins = pmx->pfc->info->groups[group].pins;
 	num_pins = pmx->pfc->info->groups[group].nr_pins;
-- 
2.51.0



