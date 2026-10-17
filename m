Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810F33CC7D8;
	Sat, 17 Oct 2026 18:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260578; cv=none; b=Hs+VqWUoq4qvtV4bmbvvxslCav56StxJ7cze2Ih8+PA7I/n3JH2r6AucgrqAJO6Trm0DWd36BxLI05cAjaWLk6/r9QIVYZSlX/330k0iwD35sWshKBf/of+Xc3Yu4KVeKeMveJBaFjV7TLnekVaCAQeegaKgIU6czcCFiZYP6q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260578; c=relaxed/simple;
	bh=QaGK3fXpD17KVB7gibRc89ACzndOjCGOrgzE19JYZTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlaXDSEyGA7gKJp11gwor0yAx0drqt7EvTzFyuWKe2iWUJ0LitWQEUbGk6JFH0VwHB2xIV7tI6hQEF5Sq8wUDbIeIojaPLWjiqAIpnthzDM51oNgLS0nxvBz/cdUaSVVodM+BLWziTTZIUjjZBV6mCY25XbjcS/MJzDdJFpJ+FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DfYbblnP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DfYbblnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6083C1F000C5;
	Sat, 17 Oct 2026 18:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260574;
	bh=MI6iUUTWhO1btSOj2X+/Le9xpdTO1G5hUtoMxiPCaJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DfYbblnPyEA2tuCJOZ5nVGfbHI2FkN2AF30foy5fte9G2LNJzjNr6GxnQ6msoIMGG
	 2+YSsw0yJtvEyikgIjcNOvWl6UHutfTGn7kI2YgWryF0m/3IuRooySSyAy6UAz/GAw
	 ScgdhiDbxvXk8LWyQAWUQA9NDcZ0T+36j3+dtfO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1539/1674] drm/amdgpu/atombios: drop empty function
Date: Sat, 17 Oct 2026 18:03:31 +0200
Message-ID: <20261017160510.616903228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit ba7f8eb7e447a8120f5bcb8e8d72964324ee5b84 ]

This was leftover from when amdgpu was forked from radeon.
The function is empty so drop it.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: a99cd231cd92 ("drm/amdgpu: Bound GPIO I2C table entry count from VBIOS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
index a14a54a734c12..31d12c1cf6aeb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -36,13 +36,6 @@
 #include "atombios_encoders.h"
 #include "bif/bif_4_1_d.h"
 
-static void amdgpu_atombios_lookup_i2c_gpio_quirks(struct amdgpu_device *adev,
-					  ATOM_GPIO_I2C_ASSIGMENT *gpio,
-					  u8 index)
-{
-
-}
-
 static struct amdgpu_i2c_bus_rec amdgpu_atombios_get_bus_rec_for_i2c_gpio(ATOM_GPIO_I2C_ASSIGMENT *gpio)
 {
 	struct amdgpu_i2c_bus_rec i2c;
@@ -108,9 +101,6 @@ struct amdgpu_i2c_bus_rec amdgpu_atombios_lookup_i2c_gpio(struct amdgpu_device *
 
 		gpio = &i2c_info->asGPIO_Info[0];
 		for (i = 0; i < num_indices; i++) {
-
-			amdgpu_atombios_lookup_i2c_gpio_quirks(adev, gpio, i);
-
 			if (gpio->sucI2cId.ucAccess == id) {
 				i2c = amdgpu_atombios_get_bus_rec_for_i2c_gpio(gpio);
 				break;
@@ -142,8 +132,6 @@ void amdgpu_atombios_i2c_init(struct amdgpu_device *adev)
 
 		gpio = &i2c_info->asGPIO_Info[0];
 		for (i = 0; i < num_indices; i++) {
-			amdgpu_atombios_lookup_i2c_gpio_quirks(adev, gpio, i);
-
 			i2c = amdgpu_atombios_get_bus_rec_for_i2c_gpio(gpio);
 
 			if (i2c.valid) {
-- 
2.53.0



