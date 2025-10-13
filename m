Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9575430F7FA;
	Mon, 13 Oct 2025 15:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368110; cv=none; b=WdhkQscxwb5221A3e7pWn1ZzUVIAD1MpQoUyXwFYgYvVmWxkELz/Iw40xSP1GRhs8PLhWuvFNzNp3g9aipkC4Iz2ypeDWNBYzemWEggSAIRVX9lBSR+hZuhKQDmP9TUDG9fitzg9O4aIbRU7Mj1mue+kzPmG7xiIfbFHWhhNHz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368110; c=relaxed/simple;
	bh=J9RzZ3SiqnCd9dk7bAxESHvgj//pMLT9a/P9ThOlwlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fU0X0pzp8C1mYmBNgIByztnwdd99iqNxarCmnCKNDtghcuRDJVjRbZPH4fC/SIfAjWEaiF6ggh/v0BEd2KfNblE7xbvWyG/qDH4aJzpSeejXss1rKUErLMjh9tvRAYfHjJwu6K/L6EwTEA66RFwm4R3VFjrwAd6pox3zmB7ioLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hITL/EU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hITL/EU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1766FC4CEE7;
	Mon, 13 Oct 2025 15:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368110;
	bh=J9RzZ3SiqnCd9dk7bAxESHvgj//pMLT9a/P9ThOlwlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hITL/EU+pjLDrwccx7JoILXNfW4ndg/ko4b6Uw0o5Kr31UWOfIjklh4H7L97bxH1a
	 os8JDth52xvNhIn9nAM6P03J19f9sULo63dXJXAwxfDNJNRZjXIgt5nJzOWelHBXv7
	 HEX0XqGdayoejlhy4ZlQj0AL677T8btVCRzaYMxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/262] pinctrl: renesas: Use int type to store negative error codes
Date: Mon, 13 Oct 2025 16:43:10 +0200
Message-ID: <20251013144327.860756782@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



