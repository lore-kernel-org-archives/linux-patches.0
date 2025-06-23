Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E95E1EE7C6;
	Mon, 23 Jun 2025 21:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714809; cv=none; b=NURWYxxV+Y01PdBEP/p6Uc1+A2GhlLY57HwUXCuPXsBBIeIGy9sk9RpkWoZfU/xsV0BsoamagQQbZdW16P2A+BJ0I5QQYa2jb0HgODGhvlx3vmtbtTISfALiAQnM5IlRq60W3wyV65diyHJAW9emuqO3pB/wMwVBDbnk8Qa2sFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714809; c=relaxed/simple;
	bh=dlUosOSeJGjNd9flPs+UjVMaZ/CBofuY9Py5qDh/svo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yc/pZNp0/z5IeT+KFa5ugsiHti0UzNivphaReXmUYbpPHxAlVPllaYMaEK/7NU8K+4AwHOvzVMqURfDvpojvWDNkopEzI00JvNplmcY8hENkWud4RxZfOrUmLfzT2IzV6y1iHfzxC7/IRi+CguCcfbe3N6AKKOMhKKhWQ7Yv4Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sXq3Yu21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sXq3Yu21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8D9C4CEEA;
	Mon, 23 Jun 2025 21:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714809;
	bh=dlUosOSeJGjNd9flPs+UjVMaZ/CBofuY9Py5qDh/svo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sXq3Yu21866LazTGzdNUdTHgoFr02A1oZTuk+sZ2LeK7v71L+ukVCrAh+FcSPY08S
	 I3Z2xyHUnvS17JIrbyq7dFTvaS6UP8PgI7Mm+C0lS8BAqwRVYko30GqlrDhJEawLX2
	 zuVnM0eB6KiDLb9KwFc8HfUeRxMXY9KkDjJdsf1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Hou <lizhi.hou@amd.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.12 158/414] accel/ivpu: Use firmware names from upstream repo
Date: Mon, 23 Jun 2025 15:04:55 +0200
Message-ID: <20250623130645.989583910@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -53,18 +53,18 @@ static struct {
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


