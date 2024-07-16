Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121791DDCE;
	Tue, 16 Jul 2024 16:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145988; cv=none; b=ZYc26MQrGyNvt5OODzs0Guy3xpqfL2oWKEza7Q08MI+s2xZeyCtOHpzqK5QV3IeWhnoYhCLzAogYvl/kKjujfeEfDqtp55du/UBGDqJkW1NtA0cbojYd/dO9pjr2uD6cnKSlGyA7lABZ7eF2xvR521j4a+je5TnODr2gvUlfETo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145988; c=relaxed/simple;
	bh=dbJdl/N3liWQp0bn74ak7YEEt0HwVe/e+YOyMBKt4nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I25s0Cl9TR2np36DsnZshM+u4QYSUp/D8MryITfxMhrjmzyOwdkXblT+JqWVkN2HDp2VcHN4F/nFxv048DUaW66St5GOZa38YmCum1LfCGAGE1fCNY9Q1tJRRtOJxhcMLFG9OQAyzmTukAoyU37gIrjayEfyVMpk7BjvFH7Tfd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2GVhVNPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2GVhVNPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C75C116B1;
	Tue, 16 Jul 2024 16:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145987;
	bh=dbJdl/N3liWQp0bn74ak7YEEt0HwVe/e+YOyMBKt4nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2GVhVNPdIctEDzGwNZvO7/9qjMUjwD+VCdd1188nxZZCb9PrJIgzRE0+/w8Opn4Xf
	 h/KQSTWMyY+cA1vBkCgnuMHXlZIT8OzAxWejXuY06Ulh+mZ4k8iKuV6dGEpaZgp04s
	 jd8XWTWInlEURvBl3FM6gbDoArv7rYWopTg88NGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/144] i2c: i801: Annotate apanel_addr as __ro_after_init
Date: Tue, 16 Jul 2024 17:31:30 +0200
Message-ID: <20240716152753.348642491@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 355b1513b1e97b6cef84b786c6480325dfd3753d ]

Annotate this variable as __ro_after_init to protect it from being
overwritten later.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 7844fba281905..758bbb13b8be3 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1045,7 +1045,7 @@ static const struct pci_device_id i801_ids[] = {
 MODULE_DEVICE_TABLE(pci, i801_ids);
 
 #if defined CONFIG_X86 && defined CONFIG_DMI
-static unsigned char apanel_addr;
+static unsigned char apanel_addr __ro_after_init;
 
 /* Scan the system ROM for the signature "FJKEYINF" */
 static __init const void __iomem *bios_signature(const void __iomem *bios)
-- 
2.43.0



