Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F44F51C2D;
	Mon, 11 Dec 2023 18:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+6p1CUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8E7C433C7;
	Mon, 11 Dec 2023 18:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320708;
	bh=bhjIyzy3dpeqO0KQall741RG4N5YCzW61Fm3dnicsR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+6p1CUOLemEPVRyOPZR0pk0CGPAq9sNTJZFGPzysmUsCuZrHTzUzDgE4s8eo180O
	 F/WN8+h30+HEXTony35A4Unj+/4BAZaAJdhpFiDZWXkKHyhveZGzf0M6R1/h17I7G7
	 JnjtJbZ5bw6XHYk3k4QqIbiD/5/qFdWjkSc3sn0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <Alexander.Deucher@amd.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 161/194] drm/amdgpu: Remove second moot switch to set EEPROM I2C address
Date: Mon, 11 Dec 2023 19:22:31 +0100
Message-ID: <20231211182043.836829858@linuxfoundation.org>
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

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit 1bb745d7596d2b368fd9afb90473f3581495e39d ]

Remove second switch since it already has its own function and case in the
first switch. This also avoids requalifying the EEPROM I2C address for VEGA20,
SIENNA CICHLID, and ALDEBARAN, as those have been set by the first switch and
shouldn't match SMU v13.0.x.

Cc: Candice Li <candice.li@amd.com>
Cc: Kent Russell <kent.russell@amd.com>
Cc: Alex Deucher <Alexander.Deucher@amd.com>
Fixes: 158225294683 ("drm/amdgpu: Add EEPROM I2C address for smu v13_0_0")
Fixes: c9bdc6c3cf39 ("drm/amdgpu: Add EEPROM I2C address support for ip discovery")
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Alex Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: e0409021e34a ("drm/amdgpu: Update EEPROM I2C address for smu v13_0_0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index 2d9f3f4cd79e9..b908d575b5a98 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -205,15 +205,6 @@ static bool __get_eeprom_i2c_addr(struct amdgpu_device *adev,
 		return false;
 	}
 
-	switch (adev->ip_versions[MP1_HWIP][0]) {
-	case IP_VERSION(13, 0, 0):
-		control->i2c_address = EEPROM_I2C_MADDR_4;
-		break;
-
-	default:
-		break;
-	}
-
 	return true;
 }
 
-- 
2.42.0



