Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD031F91E3;
	Mon, 13 Oct 2025 14:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367038; cv=none; b=PNktrQGOYfMLBDG7czk33zQfZcq1XqU+4sCDgUXtPysN+weXk7PWjW70Ok93p3I+tl8laPZ9qMrykGfmE7Sg2Tr2CmeXZsX/OLLDS0bLQrGZBhVFyuGDIkv4B36TlgGuRhfM+bx9LyDaIRsFGNTMXr8AsqSRCbc1eBHjTiQ767c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367038; c=relaxed/simple;
	bh=Ehl8dyoJPrGI1Tun25PoE2BAMMHpKvtCzJb/vgmFBuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nf2EnlAi8IQ0cNPXe5Iet+fNtWQDdvJ0fIUdPzbaJYx+nnZDBah7ZP139ckUtJ4Di/+25NGjBrybr8s7UH8n5u1BSu1BBg5vW/u0Hx7VbUSdhymvFPBRi0e0JqF3wo55coCJlIzjj5TdmNWbrA1Wbut5AkMEC82HDSDWsrfiSrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WiTS28zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WiTS28zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79C1C4CEE7;
	Mon, 13 Oct 2025 14:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367038;
	bh=Ehl8dyoJPrGI1Tun25PoE2BAMMHpKvtCzJb/vgmFBuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WiTS28zh/CTH7qbvJdBwne4B6T4KM/bxuDuWIlXkKRTc7EoNzIqaSHKxDBh3Xe8ui
	 lf4HvymoWAbyhzV8CjNYhOOZHPbqmxuGdaOTJcimRsD/7jUGbfOTnRy/ErFVHYHBqv
	 lkH3tVQjARIvcysd8g2wNqaEdPwHWfEOBrD+mO6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/196] pinctrl: renesas: Use int type to store negative error codes
Date: Mon, 13 Oct 2025 16:44:03 +0200
Message-ID: <20251013144317.111198911@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b438d24c13b5c..ea2fbabe1c64b 100644
--- a/drivers/pinctrl/renesas/pinctrl.c
+++ b/drivers/pinctrl/renesas/pinctrl.c
@@ -747,7 +747,8 @@ static int sh_pfc_pinconf_group_set(struct pinctrl_dev *pctldev, unsigned group,
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



