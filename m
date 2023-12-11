Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8C851C2D;
	Mon, 11 Dec 2023 18:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+VuI2tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AFEC433C7;
	Mon, 11 Dec 2023 18:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320692;
	bh=SQRBGoDlY4Vh1pBkYilD01QpOtHTuGZZ9RR9okf52G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+VuI2tbx3CI3CbWb0o5SY8OOW+YtnusG6RmKmu2aWD6HzzIItO5aQ8fKXKlM5046
	 IW3moCxVmck9LqTWPIfeIHbsNs4CHztb0zp2/HxiwQqqg+sgQrlfo7T1B5LPq9TmPs
	 s9sOuQ+4xWZag6R1apUarzNsEo3Rbpo+2wwZDYQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/194] drm/amdgpu: Update ras eeprom support for smu v13_0_0 and v13_0_10
Date: Mon, 11 Dec 2023 19:22:26 +0100
Message-ID: <20231211182043.606951026@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Candice Li <candice.li@amd.com>

[ Upstream commit bc22f8ec464af9e14263c3ed6a1c2be86618c804 ]

Enable RAS EEPROM support for smu v13_0_0 and v13_0_10.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: e0409021e34a ("drm/amdgpu: Update EEPROM I2C address for smu v13_0_0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index 84c241b9a2a13..7dc39154822c5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -90,6 +90,16 @@
 
 static bool __is_ras_eeprom_supported(struct amdgpu_device *adev)
 {
+	if (adev->asic_type == CHIP_IP_DISCOVERY) {
+		switch (adev->ip_versions[MP1_HWIP][0]) {
+		case IP_VERSION(13, 0, 0):
+		case IP_VERSION(13, 0, 10):
+			return true;
+		default:
+			return false;
+		}
+	}
+
 	return  adev->asic_type == CHIP_VEGA20 ||
 		adev->asic_type == CHIP_ARCTURUS ||
 		adev->asic_type == CHIP_SIENNA_CICHLID ||
-- 
2.42.0



