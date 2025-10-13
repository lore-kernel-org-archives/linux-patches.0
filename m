Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2357C30F95C;
	Mon, 13 Oct 2025 15:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369024; cv=none; b=YVerRqBCQoGP5GCjOjmlMDCVPSbMfy4nE1j3i3WtZgOaolRpr+tBIvhZZRKldYqBDfQBN2IE5Yl/UehDbcr2T4IDyPa/rw9HOIVWx+jM17++1qmm8f9nrVgrlD/WJIA1p1CRsEoks/SEGuUF/4iS1wIHhQq6iMK6EhReudV0VdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369024; c=relaxed/simple;
	bh=6tyXyLU+yNTLz77DU1dBCOq/eYLdljfbrlvwgkmR5zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPYLCc/RFvep4j7gtPHzzpVTavNvk4puPQHn4wVqD+cyUXJ03wQ/GDX9CIyHtVSYs3ZecsdQZ5EIslS3XV62x9fePvAOqnHx/ed0+m3lXT88y4FnDneRQIe4wNSqDFt2GBr01HLsSOkeabeoEYi+KrkUgkwbtaStFrIQJ30o1+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BuKc8Xq5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BuKc8Xq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EF1C4CEE7;
	Mon, 13 Oct 2025 15:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369024;
	bh=6tyXyLU+yNTLz77DU1dBCOq/eYLdljfbrlvwgkmR5zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BuKc8Xq5sF4XbtFpAWFk8NJVl1mBDErb8KWh0aqkM/KlezkqawNtKdwSYmU6EI6FJ
	 vknRg6RbJSHBAImVq9ZqShUkaySlIZibtRrJhVIHNCoiiyFn0OJgG2u8NM+V2KvYkv
	 SkCVtxzHQJmrOIMtbmRHs+juoX7oxW9bVS00ZVCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 102/563] pinctrl: renesas: Use int type to store negative error codes
Date: Mon, 13 Oct 2025 16:39:23 +0200
Message-ID: <20251013144414.989561253@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 29d16c9c1bd19..3a742f74ecd1d 100644
--- a/drivers/pinctrl/renesas/pinctrl.c
+++ b/drivers/pinctrl/renesas/pinctrl.c
@@ -726,7 +726,8 @@ static int sh_pfc_pinconf_group_set(struct pinctrl_dev *pctldev, unsigned group,
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



