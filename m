Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3D226A0F2;
	Tue,  8 Apr 2025 11:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113378; cv=none; b=HxrIeRl1/GfeEKbLUuVrqh0vKSOc1oIoQrufqHiE+z0Z4391TglG+7CekSFZDfYt0U5n9pNrKEBrd/lm1UQRmxKCgghCCBK6/24SrkLJYv7B/DozYcPop2w6Gfs8dvR77YwMFsW7GI+cWCzTWxW3OQIAtMA1pMlo6oGytEx3sO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113378; c=relaxed/simple;
	bh=kuvy55qNrQm3BCaVm/pm/koG0JxrRZVZV0WHEzrqmAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAbkSNrnhPE2TdapTQRxoPZs3Ml4j2nZ8qaSz62klbdgCBxxROPYZ0EK5QjPb0I0ykj/rTUwGV54Qq0YeF3fepy78ayLc5rbQrkYmE8HdRip2lEsdnr+99SNjonUrrOofBEIFEohvrObSsLhmuiOKbPMhAceOVA5yES8EyRRrQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BzVSjJXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BzVSjJXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D584C4CEE5;
	Tue,  8 Apr 2025 11:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113377;
	bh=kuvy55qNrQm3BCaVm/pm/koG0JxrRZVZV0WHEzrqmAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzVSjJXkEXtNOKS1EDrpJZ2Wxfh2RPoWN74VU904ehRSgBdECAUEn9IxkbTuGchXS
	 wJAVeWja7ujwPslNUqJ3gX8uz2lPBRr6Nz0combP2X1BPwhHfxdlf7A3aYUAnwxgyz
	 +kFdRGKSEz370v6hrha9kEKMIVfXy3MTa3Cqh8zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/268] ucsi_ccg: Dont show failed to get FW build information error
Date: Tue,  8 Apr 2025 12:48:41 +0200
Message-ID: <20250408104831.467961646@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cf3c8e552defe..7c7f388aac96b 100644
--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -1366,11 +1366,10 @@ static int ucsi_ccg_probe(struct i2c_client *client)
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



