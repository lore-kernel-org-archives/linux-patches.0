Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B920426B945;
	Tue,  8 Apr 2025 12:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114743; cv=none; b=XaIA37GrpHqb3BuZCCeWo6EZm4GKVrsFS7scjHAVEWE+xsuJ/w8WhZU5sOmWd3/j0gJCU3rDuvji5ZFuSjg/I95FECVOL6E1POkzW49mXAJJDFj6jDqznC1nALeYGCrPKekLnT16Dw7P1XiwHKjmatXB9ACtTKIZKFN5jqjBSZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114743; c=relaxed/simple;
	bh=HxBFhtZdmeQakWGmLCB69NRu10y1a4u0UNwLx1/wyd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0Ln9p9sgIuhOMCNHhCzAtzzvPvsdhKaWh6cAJHTgwP4p0GeMhsQ3rLg/La5lBxJdCnvn56VkT0DdRXgUYEyK/myZLx3QYdWKsO95g7fEMgi32blKgEIYqtBsDrfm9NNsI7QaOitDBfcnfzk/Cx5pdg2h7r4qT31sd/Y5kyMEQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRF12BMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRF12BMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4633BC4CEE7;
	Tue,  8 Apr 2025 12:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114743;
	bh=HxBFhtZdmeQakWGmLCB69NRu10y1a4u0UNwLx1/wyd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iRF12BMvshRh7oWyy4pE58a14NuKMT/GxP+8pi0I6x2JU7OgkvxxikHKEYZPxu79x
	 HKDNemErSOVfDCG0y5U26sDLqWpxGjQB4mu0CRBwCsXJEe1fEGDOqIyU/4CifMdgoV
	 1HzhGkRCyOnCo//0P6P+JAg7kQNNNso9FRfmfT4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 220/499] ucsi_ccg: Dont show failed to get FW build information error
Date: Tue,  8 Apr 2025 12:47:12 +0200
Message-ID: <20250408104856.697645770@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit c16006852732dc4fe37c14b81f9b4458df05b832 ]

The error `failed to get FW build information` is added for what looks
to be for misdetection of the device property firmware-name.

If the property is missing (such as on non-nvidia HW) this error shows up.
Move the error into the scope of the property parser for "firmware-name"
to avoid showing errors on systems without the firmware-name property.

Fixes: 5c9ae5a87573d ("usb: typec: ucsi: ccg: add firmware flashing support")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250221054137.1631765-2-superm1@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_ccg.c b/drivers/usb/typec/ucsi/ucsi_ccg.c
index 4b1668733a4be..511dd1b224ae5 100644
--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -1433,11 +1433,10 @@ static int ucsi_ccg_probe(struct i2c_client *client)
 			uc->fw_build = CCG_FW_BUILD_NVIDIA_TEGRA;
 		else if (!strcmp(fw_name, "nvidia,gpu"))
 			uc->fw_build = CCG_FW_BUILD_NVIDIA;
+		if (!uc->fw_build)
+			dev_err(uc->dev, "failed to get FW build information\n");
 	}
 
-	if (!uc->fw_build)
-		dev_err(uc->dev, "failed to get FW build information\n");
-
 	/* reset ccg device and initialize ucsi */
 	status = ucsi_ccg_init(uc);
 	if (status < 0) {
-- 
2.39.5



