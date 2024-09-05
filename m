Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FDC192D73;
	Thu,  5 Sep 2024 09:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530212; cv=none; b=MJWecW0Wnf2XDvN1DFeVF6C3j+yrpwAPsRjItpBZyafn2CT2P3TgdmCyUa/Wp/0Ig3zktV018ofiGUkMj/yXBsqbVb6hCS8cEWZgJ6G6pHMcifMzkDkKlGB4cy9rav4Mqgv1e3suI6ToxXIFftLOc6svrCvZHipyORFxJ+Baido=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530212; c=relaxed/simple;
	bh=0oTCcjni0pMR1F6YMO/FT8VTjjhC6rdJ+7SsmiNIt7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYxqz/qrkNZzq+sMakDgOP9ZJ2g9K2P95czWvzwKHm6VkoSGLS96yHHvP7zzLr5jlfiYJbM2UtQraJd0nxNu452eRx52xMSmHtoPpi3REv5SBVBQUsWTVyhpXMQIygigpbmETca9TAiSq3Ea4+Aj5diP3SjXivm0HBvRjZmwnrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=weivUI5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="weivUI5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1650FC4CEC3;
	Thu,  5 Sep 2024 09:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530211;
	bh=0oTCcjni0pMR1F6YMO/FT8VTjjhC6rdJ+7SsmiNIt7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=weivUI5D9KJ0nSGgY8jbBXpW6Nbqg9OIxt+YQDp43WBEx0vny/7pTRQZoL2VmVlXs
	 KIAuILqnYUad5Gs4Q2v26gmJKLn4EQMRvlBQ0DltjIMjjPaS/WXLz5pecr2bRhYFfV
	 IJGaLxCg9OR29XIvTVf9o7/dnrrWmMqdif+TfQ+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Zhou <tao.zhou1@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/132] drm/amdgpu: update type of buf size to u32 for eeprom functions
Date: Thu,  5 Sep 2024 11:41:15 +0200
Message-ID: <20240905093725.670170732@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Tao Zhou <tao.zhou1@amd.com>

[ Upstream commit 2aadb520bfacec12527effce3566f8df55e5d08e ]

Avoid overflow issue.

Signed-off-by: Tao Zhou <tao.zhou1@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_eeprom.c | 6 +++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_eeprom.h | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_eeprom.c
index e71768661ca8..09a34c7258e2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_eeprom.c
@@ -179,7 +179,7 @@ static int __amdgpu_eeprom_xfer(struct i2c_adapter *i2c_adap, u32 eeprom_addr,
  * Returns the number of bytes read/written; -errno on error.
  */
 static int amdgpu_eeprom_xfer(struct i2c_adapter *i2c_adap, u32 eeprom_addr,
-			      u8 *eeprom_buf, u16 buf_size, bool read)
+			      u8 *eeprom_buf, u32 buf_size, bool read)
 {
 	const struct i2c_adapter_quirks *quirks = i2c_adap->quirks;
 	u16 limit;
@@ -225,7 +225,7 @@ static int amdgpu_eeprom_xfer(struct i2c_adapter *i2c_adap, u32 eeprom_addr,
 
 int amdgpu_eeprom_read(struct i2c_adapter *i2c_adap,
 		       u32 eeprom_addr, u8 *eeprom_buf,
-		       u16 bytes)
+		       u32 bytes)
 {
 	return amdgpu_eeprom_xfer(i2c_adap, eeprom_addr, eeprom_buf, bytes,
 				  true);
@@ -233,7 +233,7 @@ int amdgpu_eeprom_read(struct i2c_adapter *i2c_adap,
 
 int amdgpu_eeprom_write(struct i2c_adapter *i2c_adap,
 			u32 eeprom_addr, u8 *eeprom_buf,
-			u16 bytes)
+			u32 bytes)
 {
 	return amdgpu_eeprom_xfer(i2c_adap, eeprom_addr, eeprom_buf, bytes,
 				  false);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_eeprom.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_eeprom.h
index 6935adb2be1f..8083b8253ef4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_eeprom.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_eeprom.h
@@ -28,10 +28,10 @@
 
 int amdgpu_eeprom_read(struct i2c_adapter *i2c_adap,
 		       u32 eeprom_addr, u8 *eeprom_buf,
-		       u16 bytes);
+		       u32 bytes);
 
 int amdgpu_eeprom_write(struct i2c_adapter *i2c_adap,
 			u32 eeprom_addr, u8 *eeprom_buf,
-			u16 bytes);
+			u32 bytes);
 
 #endif
-- 
2.43.0



