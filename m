Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545512641FC;
	Wed, 25 Feb 2026 01:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983473; cv=none; b=FBUsQgUJyiPG3xEi/TxQUj7WnLNd6p+XS21pXlT3AvY2dzApOlSrp2rc1Hr8OAFw17OR4MoG2sb1lNEXrY8ZbnB3jTC9mjTdLYlUueOAuFlmPVLRD0p8QEgKtuWdiAefpamHtf4/6p34gS6VCIjDjExUeFRBkyrCokgA9nxb524=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983473; c=relaxed/simple;
	bh=Fy4Bum+LPWZoIW7y+e+o6SsisYxYwJ+Wm1r0MsIXk9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EahJVGvCc1gncEm3TamZ0KiVQitRT7olaktuUZk+ma6+Qz5QRKvfrr0lAPX3+9CWHrZTUkgrGG38XrJntHSDOF8EbyvCDnFPX7RjQDFal9w0omviCiJwZ/JaZ8hWDSGm0Epo4qxKA+CmP9g+aQ2O6951yAgKN5uEjGwyFqfEn20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksYFuwpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksYFuwpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170C1C116D0;
	Wed, 25 Feb 2026 01:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983473;
	bh=Fy4Bum+LPWZoIW7y+e+o6SsisYxYwJ+Wm1r0MsIXk9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksYFuwpb3AMeTM7MbR6yt/78LgM10/14lsbkXNBAaNuhnUwLYD1n7sQ7RKAv/+2bs
	 3axzkxxIj/0IO2Xf40+Qj7ob4gUgc0TgoM+lP5GSyN/9dBibmoZ21xK2Ibs/HeNN46
	 q/gBYvqzq+A/ofmujq22jmha0l5ZKZS4Nx56qmOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 588/781] Revert "mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms"
Date: Tue, 24 Feb 2026 17:21:37 -0800
Message-ID: <20260225012414.220418513@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit ff112f1ecd10b72004eac05bae395e1c65f0c63c ]

This reverts commit aced969e9bf3701dc75cfca57c78c031b7875b9d.

It was determined that this was not the correct "fix", so should be
reverted.

Fixes: aced969e9bf3 ("mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms")
Cc: Matthew Schwartz <matthew.schwartz@linux.dev>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index b6cf1803c7d27..4db3328f46dfb 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -937,7 +937,7 @@ static int sd_power_on(struct realtek_pci_sdmmc *host, unsigned char power_mode)
 	if (err < 0)
 		return err;
 
-	mdelay(5);
+	mdelay(1);
 
 	err = rtsx_pci_write_register(pcr, CARD_OE, SD_OUTPUT_EN, SD_OUTPUT_EN);
 	if (err < 0)
-- 
2.51.0



