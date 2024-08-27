Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037B138DC7;
	Tue, 27 Aug 2024 14:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770013; cv=none; b=Tvo++cOSaGiJErRnkC2fGeOyyOPsvon6csIFFj2V/es9lD7wSWI7qovyRGT6rwlLPYO7zdJMyCfGFO/Jr6yZYqWzGMyeISNEfRJryLpvV7hZiX1hI2qsbOsmzVeQVJgX9T8HpSonGcGS1h65IiXHS9RRedJJMbhGTF+1kEw/KHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770013; c=relaxed/simple;
	bh=9HfUdQB6o993RiWH3a79V45LOVnry8BhhCvjacL8gQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YPWb8tzPdx6YdfGU1giSwmgLYDAghqkRX5l0EchnnkprxdXaz2pG5jtmMsyDsttToJqHBi4KYz5zW3jZ3L///J1Mjfnr+44QOjFs/keyAjHNbvn5ORmj3BTQnlGVe722u5ZSB/I3gBIsNqy/Ogk2f4G9GhAzq2SO/wDrB3MxZdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=foQZRtt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="foQZRtt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78988C6106D;
	Tue, 27 Aug 2024 14:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770012;
	bh=9HfUdQB6o993RiWH3a79V45LOVnry8BhhCvjacL8gQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=foQZRtt2WduE5YozBWkT1e8hC/2kgiZFHdu9yC3axdVym00Otl12ntYPuWXL1OaQ+
	 i9b8gi0iZqv2HhGbwQKmkMpQ44zUH/oty9WVl/KMVbXRz5kTmnBxk4iy9VxD4mJqUg
	 gCpOg2apAEsY4dPo8JKSxVDkSkIwLZNUtCESOgBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/341] drm/amd/amdgpu/imu_v11_0: Increase buffer size to ensure all possible values can be stored
Date: Tue, 27 Aug 2024 16:35:15 +0200
Message-ID: <20240827143846.605665287@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit a728342ae4ec2a7fdab0038b11427579424f133e ]

Fixes the following W=1 kernel build warning(s):

 drivers/gpu/drm/amd/amdgpu/imu_v11_0.c: In function ‘imu_v11_0_init_microcode’:
 drivers/gpu/drm/amd/amdgpu/imu_v11_0.c:52:54: warning: ‘_imu.bin’ directive output may be truncated writing 8 bytes into a region of size between 4 and 33 [-Wformat-truncation=]
 drivers/gpu/drm/amd/amdgpu/imu_v11_0.c:52:9: note: ‘snprintf’ output between 16 and 45 bytes into a destination of size 40

Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/imu_v11_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/imu_v11_0.c b/drivers/gpu/drm/amd/amdgpu/imu_v11_0.c
index 4ab90c7852c3e..ca123ff553477 100644
--- a/drivers/gpu/drm/amd/amdgpu/imu_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/imu_v11_0.c
@@ -39,7 +39,7 @@ MODULE_FIRMWARE("amdgpu/gc_11_0_4_imu.bin");
 
 static int imu_v11_0_init_microcode(struct amdgpu_device *adev)
 {
-	char fw_name[40];
+	char fw_name[45];
 	char ucode_prefix[30];
 	int err;
 	const struct imu_firmware_header_v1_0 *imu_hdr;
-- 
2.43.0



