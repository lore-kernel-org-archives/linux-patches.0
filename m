Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC0620EB;
	Mon, 14 Oct 2024 14:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916841; cv=none; b=QS2LWUrZEzT0gUHEMJjOroWI04Bvp/1xdwTYsrcoazu2XPny/nH4+2jAPX5CNGlsC7D3mBoLInagv2D7uNy3dKrWPM8+rFQ4CmEyGGOrlfgXeTzKwvnv3f4hJkna0UR8aigkNZqqU3A6wDcAcGWfcixSlZxmp4CI4fby6QNUVek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916841; c=relaxed/simple;
	bh=cXYvmEszmiYc5TLkZoHvGil1P63AcRbbzmHkr25cAUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgYmF1qv3x4yKGBsaop+ZGt1kM6GHZT1DbsB07+eAES2EbjJLhQXRRh71MCBybZB7UbOG4VjFDdPsfH8WlggKGFBL6wkvR/XsPYvxIrqlmLss5+2vQOfwIEceroEnd/B9fCm7YdmY7hxdXA/rTGp2AfRG0YD1KS697FJ2HLdu6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9jB1++q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9jB1++q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF730C4CEC3;
	Mon, 14 Oct 2024 14:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916841;
	bh=cXYvmEszmiYc5TLkZoHvGil1P63AcRbbzmHkr25cAUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9jB1++q8lRlamELmY/zGfOWC8avhL9+V0zDAn/6TFu5dniDY1hTj/lYyLhbNYNE3
	 tGCiD5mzQ+Q6g+ptAEDpGClAOpK8ORYBPZNEyM6B9xvCo2h5ceKK976gINp0+C34xn
	 BuDaveGlyu5QWaDEyS6BI142eHmTShWKEOKJGCAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andy@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/213] mfd: intel_soc_pmic_chtwc: Make Lenovo Yoga Tab 3 X90F DMI match less strict
Date: Mon, 14 Oct 2024 16:19:46 +0200
Message-ID: <20241014141046.101944283@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit ae7eee56cdcfcb6a886f76232778d6517fd58690 ]

There are 2G and 4G RAM versions of the Lenovo Yoga Tab 3 X90F and it
turns out that the 2G version has a DMI product name of
"CHERRYVIEW D1 PLATFORM" where as the 4G version has
"CHERRYVIEW C0 PLATFORM". The sys-vendor + product-version check are
unique enough that the product-name check is not necessary.

Drop the product-name check so that the existing DMI match for the 4G
RAM version also matches the 2G RAM version.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20240825132617.8809-1-hdegoede@redhat.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_soc_pmic_chtwc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mfd/intel_soc_pmic_chtwc.c b/drivers/mfd/intel_soc_pmic_chtwc.c
index 7fce3ef7ab453..2a83f540d4c9d 100644
--- a/drivers/mfd/intel_soc_pmic_chtwc.c
+++ b/drivers/mfd/intel_soc_pmic_chtwc.c
@@ -178,7 +178,6 @@ static const struct dmi_system_id cht_wc_model_dmi_ids[] = {
 		.driver_data = (void *)(long)INTEL_CHT_WC_LENOVO_YT3_X90,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "Blade3-10A-001"),
 		},
 	},
-- 
2.43.0



