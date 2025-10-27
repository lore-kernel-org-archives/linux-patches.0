Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387EF32F755;
	Mon, 27 Oct 2025 18:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591027; cv=none; b=KLf9kgix0zF+LDZ59Wk4QF+uU3yggxTGtIWyd4I57HopOslUFKeGdwQuhjCQAZpldkxAJYKHfUcf9sodJYDRB8m0upWx48KoeXExf3XPNNQFCzEGc8lehDRNqIcje7l/eQ16FqbQG3LgenxnvUvEzPh3f3Xi6FKSQ48AzatuSw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591027; c=relaxed/simple;
	bh=Y5YJYW8f3S3LRRjg75HF3KUYH5q74x7zk4/W5qGan1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2vKxkUfua+bi/0fweeVybkKBUdYtyAxqpcK69lCp31b7GpmGzMWwFcPj9eHzjnxt53w3LYfoIJCoI5m9/7i34hj2C9ipyyD972MWT0blzbfG2wlFvJr7Og9zFDEzIAdgfeuXWMDJzs1to2uxetLmFISHoZBuJehaa0KK4yUQMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Txtbd/W5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Txtbd/W5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A70C4CEF1;
	Mon, 27 Oct 2025 18:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591027;
	bh=Y5YJYW8f3S3LRRjg75HF3KUYH5q74x7zk4/W5qGan1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Txtbd/W5IXhYJerMpzigjSZRHn7sGZZBQusMKq2G4wAtmHnYHBZ1xxiZZfQAdDB/q
	 UhRIu1JX4k3s06nC4scGxOxTg/MVxwIzTzrGy69ZEhARTTgntPyYG0D3xckjb5iomr
	 OxmWHtpkDklQicPK4j9dIxM0mpUKex0e9j6hOV34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/332] pinctrl: renesas: Use int type to store negative error codes
Date: Mon, 27 Oct 2025 19:31:25 +0100
Message-ID: <20251027183525.468842949@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 212a4a9c3a8fc..59dc5a965fb82 100644
--- a/drivers/pinctrl/renesas/pinctrl.c
+++ b/drivers/pinctrl/renesas/pinctrl.c
@@ -745,7 +745,8 @@ static int sh_pfc_pinconf_group_set(struct pinctrl_dev *pctldev, unsigned group,
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



