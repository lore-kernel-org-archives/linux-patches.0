Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03821EA91;
	Tue, 27 May 2025 16:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364545; cv=none; b=NfdJeMa4im4OHARf6dEnB4W7fk/+DR4suNffIRz/j0t5vore38epnWYjZUS6CiDNZ42VkxkRpEgHF7waqiuHENLoidxEBOU6+fuaq4KXVzht3uUKlolNtQYVsmUqVSzea9xzr6hHsvgxrfxC8K0z+m8XXbu8mzyuxvTQKE0TUvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364545; c=relaxed/simple;
	bh=FyzLew4tnQg+r7/OioV5MvSrs854eiIAN1ikyQezshw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3NHcatvK2XCJnomCNRF9E/qVUfco3UFO7QZbaX+pJ3hMuhfjU61WVPZYTxZa76+FYS+5s7CKWkeI1KVW9pYq2KjlDrxjfKw1EuOC4Psid3oa3cyIwUvAcF6ZpAesXTGnibTuCJ4h8fbguO2/jCPTfUhpab7Ov4gEuu7qM4wgiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7Bw31tr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7Bw31tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACB1C4CEEB;
	Tue, 27 May 2025 16:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364545;
	bh=FyzLew4tnQg+r7/OioV5MvSrs854eiIAN1ikyQezshw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7Bw31trOaT+3I+y/pWgHgSz4mMabHz/xUfrpe8iG+jB/65SitM8gf0PEZcsgfUnv
	 /zJvACG+Am3SvWfWP2+9S28eYWY1sDQrls89vcyNnr/zjpLx4MlgiTQn3i1sXEHIDU
	 hufF5umDd2YSlDZm9WmVcAM9JP1y8NaUwSv4WOxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Flora Cui <flora.cui@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/626] drm/amdgpu/discovery: check ip_discovery fw file available
Date: Tue, 27 May 2025 18:19:44 +0200
Message-ID: <20250527162448.741907475@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Flora Cui <flora.cui@amd.com>

[ Upstream commit 017fbb6690c2245b1b4ef39b66c79d2990fe63dd ]

Signed-off-by: Flora Cui <flora.cui@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 31 ++++++++++---------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index ca8091fd3a24f..018240a2ab96a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -111,8 +111,7 @@
 #include "amdgpu_isp.h"
 #endif
 
-#define FIRMWARE_IP_DISCOVERY "amdgpu/ip_discovery.bin"
-MODULE_FIRMWARE(FIRMWARE_IP_DISCOVERY);
+MODULE_FIRMWARE("amdgpu/ip_discovery.bin");
 
 #define mmIP_DISCOVERY_VERSION  0x16A00
 #define mmRCC_CONFIG_MEMSIZE	0xde3
@@ -295,21 +294,13 @@ static int amdgpu_discovery_read_binary_from_mem(struct amdgpu_device *adev,
 	return ret;
 }
 
-static int amdgpu_discovery_read_binary_from_file(struct amdgpu_device *adev, uint8_t *binary)
+static int amdgpu_discovery_read_binary_from_file(struct amdgpu_device *adev,
+							uint8_t *binary,
+							const char *fw_name)
 {
 	const struct firmware *fw;
-	const char *fw_name;
 	int r;
 
-	switch (amdgpu_discovery) {
-	case 2:
-		fw_name = FIRMWARE_IP_DISCOVERY;
-		break;
-	default:
-		dev_warn(adev->dev, "amdgpu_discovery is not set properly\n");
-		return -EINVAL;
-	}
-
 	r = request_firmware(&fw, fw_name, adev->dev);
 	if (r) {
 		dev_err(adev->dev, "can't load firmware \"%s\"\n",
@@ -402,10 +393,19 @@ static int amdgpu_discovery_verify_npsinfo(struct amdgpu_device *adev,
 	return 0;
 }
 
+static const char *amdgpu_discovery_get_fw_name(struct amdgpu_device *adev)
+{
+	if (amdgpu_discovery == 2)
+		return "amdgpu/ip_discovery.bin";
+
+	return NULL;
+}
+
 static int amdgpu_discovery_init(struct amdgpu_device *adev)
 {
 	struct table_info *info;
 	struct binary_header *bhdr;
+	const char *fw_name;
 	uint16_t offset;
 	uint16_t size;
 	uint16_t checksum;
@@ -417,9 +417,10 @@ static int amdgpu_discovery_init(struct amdgpu_device *adev)
 		return -ENOMEM;
 
 	/* Read from file if it is the preferred option */
-	if (amdgpu_discovery == 2) {
+	fw_name = amdgpu_discovery_get_fw_name(adev);
+	if (fw_name != NULL) {
 		dev_info(adev->dev, "use ip discovery information from file");
-		r = amdgpu_discovery_read_binary_from_file(adev, adev->mman.discovery_bin);
+		r = amdgpu_discovery_read_binary_from_file(adev, adev->mman.discovery_bin, fw_name);
 
 		if (r) {
 			dev_err(adev->dev, "failed to read ip discovery binary from file\n");
-- 
2.39.5



