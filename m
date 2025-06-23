Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880622367B0;
	Mon, 23 Jun 2025 13:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684927; cv=none; b=J+68v+8JxjnJGT3GHQiA0Z09bE5PCWjFCj549z1Xiwnpyj2ZypvGDHcCGk7gWiWC1HsWwUzy9SKLytQJUUEZ4NnETlBdwo0SW8qOkl2yerVa0P82h3kApeY4LFrucJ296R/wuPEsah8klAspfTk9SIdir97FqXkNtTUqVinEv4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684927; c=relaxed/simple;
	bh=Bwr+bU+p+WwJVRjrN2WAdbC+Y5d4Ty2X77qBBkM8sDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IK/+s7Owbh7THErZzW3fOYmwt+TCEVHGUb+KbdBdhoyPYDcx/0ienj45IpHwbO1cjBJLO0xgQD54pk/9zvguR6ZYrGiENITwUVuWHRo4e3FkSyz/8WaUzrl0zCl/GF0knUmm8SnRmujxMzrYX/336kXb5WSvN5+f5/LIWW10z2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vot51BdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vot51BdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89D7C4CEEA;
	Mon, 23 Jun 2025 13:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684927;
	bh=Bwr+bU+p+WwJVRjrN2WAdbC+Y5d4Ty2X77qBBkM8sDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vot51BdDymxmPWSTqvn2HqlNtlDRhRbUQkFn9/H6oHFlvjNZA1gfOyVZIlCMEIKBx
	 VPR+/W6s0/a2bHLOxonbrKbwhxlmI4V0xoOa1Bl3r9mLiuicl+CuT1YDmUC/F2khrd
	 s6biwbhlRlnb/qJIepJo+2KEbhqiiAa135+Vp4QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Hou <lizhi.hou@amd.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.15 191/592] accel/ivpu: Use firmware names from upstream repo
Date: Mon, 23 Jun 2025 15:02:29 +0200
Message-ID: <20250623130704.829403024@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit 1c2c0e29f24360b3130c005a3c261cb8c7b363c6 upstream.

Use FW names from linux-firmware repo instead of deprecated ones.
The vpu_37xx.bin style names were never released and were only used for
internal testing, so it is safe to remove them.

Fixes: c140244f0cfb ("accel/ivpu: Add initial Panther Lake support")
Cc: stable@vger.kernel.org # v6.13+
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://lore.kernel.org/r/20250506092030.280276-1-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_fw.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/accel/ivpu/ivpu_fw.c
+++ b/drivers/accel/ivpu/ivpu_fw.c
@@ -55,18 +55,18 @@ static struct {
 	int gen;
 	const char *name;
 } fw_names[] = {
-	{ IVPU_HW_IP_37XX, "vpu_37xx.bin" },
+	{ IVPU_HW_IP_37XX, "intel/vpu/vpu_37xx_v1.bin" },
 	{ IVPU_HW_IP_37XX, "intel/vpu/vpu_37xx_v0.0.bin" },
-	{ IVPU_HW_IP_40XX, "vpu_40xx.bin" },
+	{ IVPU_HW_IP_40XX, "intel/vpu/vpu_40xx_v1.bin" },
 	{ IVPU_HW_IP_40XX, "intel/vpu/vpu_40xx_v0.0.bin" },
-	{ IVPU_HW_IP_50XX, "vpu_50xx.bin" },
+	{ IVPU_HW_IP_50XX, "intel/vpu/vpu_50xx_v1.bin" },
 	{ IVPU_HW_IP_50XX, "intel/vpu/vpu_50xx_v0.0.bin" },
 };
 
 /* Production fw_names from the table above */
-MODULE_FIRMWARE("intel/vpu/vpu_37xx_v0.0.bin");
-MODULE_FIRMWARE("intel/vpu/vpu_40xx_v0.0.bin");
-MODULE_FIRMWARE("intel/vpu/vpu_50xx_v0.0.bin");
+MODULE_FIRMWARE("intel/vpu/vpu_37xx_v1.bin");
+MODULE_FIRMWARE("intel/vpu/vpu_40xx_v1.bin");
+MODULE_FIRMWARE("intel/vpu/vpu_50xx_v1.bin");
 
 static int ivpu_fw_request(struct ivpu_device *vdev)
 {


