Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFE951C2D;
	Mon, 11 Dec 2023 18:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eAPDy6z8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08965C433C7;
	Mon, 11 Dec 2023 18:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320716;
	bh=x95pNcdoAJovTlHvGl2r3RAd+M1YWGOGLaETl7gn8xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eAPDy6z82WAN2inF4N4Qa+HYHnnhh6+0FnzKMZ0WOjA30nZtnrUKRmvO66DAvztcH
	 5OOQmRxeKNlt2zrUKkSCqQeV4NJxDtHx95lNpO2YKrnANHF+ER5WA/OCCBke/GhosV
	 NhOpyzLHV7VmGOKzthmPjR+HB+IZM+DJeWJLVyEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/194] drm/amdgpu: Add I2C EEPROM support on smu v13_0_6
Date: Mon, 11 Dec 2023 19:22:34 +0100
Message-ID: <20231211182043.966534781@linuxfoundation.org>
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

[ Upstream commit b81fde0dfe402e864ef1ac506eba756c89f1ad32 ]

Support I2C EEPROM on smu v13_0_6.

v2: Move IP_VERSION(13, 0, 6) ahead of IP_VERSION(13, 0, 10).

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: e0409021e34a ("drm/amdgpu: Update EEPROM I2C address for smu v13_0_0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index c2827edb9d3d9..47406456e2707 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -112,6 +112,7 @@ static bool __is_ras_eeprom_supported(struct amdgpu_device *adev)
 	case IP_VERSION(11, 0, 7): /* Sienna cichlid */
 	case IP_VERSION(13, 0, 0):
 	case IP_VERSION(13, 0, 2): /* Aldebaran */
+	case IP_VERSION(13, 0, 6):
 	case IP_VERSION(13, 0, 10):
 		return true;
 	default:
@@ -166,6 +167,7 @@ static bool __get_eeprom_i2c_addr(struct amdgpu_device *adev,
 			control->i2c_address = EEPROM_I2C_MADDR_0;
 		return true;
 	case IP_VERSION(13, 0, 0):
+	case IP_VERSION(13, 0, 6):
 	case IP_VERSION(13, 0, 10):
 		control->i2c_address = EEPROM_I2C_MADDR_4;
 		return true;
-- 
2.42.0



