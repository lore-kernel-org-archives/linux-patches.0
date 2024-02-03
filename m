Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95DF171C1;
	Sat,  3 Feb 2024 04:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933909; cv=none; b=jBD4v0Vga9D4B7YRYNIKeu+6MJ8vhxEx0tNNPXRVXzct+WoEOIoA6+oIQew4guRABCs6QIFXhPlG8DcmWFYN6fd4zX0+oWmqZm3sNVkHtGp8evIew5cctAWi8G7zwiRJ6XKCZnGjhzYOJS501tKeJZHdC5QHlNYWJkyxjdAfF0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933909; c=relaxed/simple;
	bh=yW8XMJekV5BVBNWc0CM0VLYRgk0QpwrdULTDP079RFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WSAUYbWHTKmh73HZyPK+Od8O+CLhZ6dssPxTlWAeaEIY/yFDXuxUnAKsd4xWMqKK/WqYm0eWC5LWdP9BWESK1NkxUz8KCHRBazFI1eZ9bxbxV6Lew+SMC5Jk6iM+EjzS7JCpEGFNeMFDm+tuAui8CGW0Zgdqt3/71zJpPRcgSqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSg5F55m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSg5F55m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15BCC433C7;
	Sat,  3 Feb 2024 04:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933908;
	bh=yW8XMJekV5BVBNWc0CM0VLYRgk0QpwrdULTDP079RFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSg5F55mvNrw4ewoFHssopnZuxGSRxz1f91M0uTVua569jRydHGZ8n2LfJKqFoaoL
	 bJjnnLTxXMqfL2mrH2KtzVQmQ5uaVnPguIA9R2PXM6YjETmb2s2IFMsLWVTuEiYcSB
	 +oIdE6RUgQkm/OlQryz5OjPByCqQWAnJYaIVyvGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 232/353] drm/amdgpu: Fix *fw from request_firmware() not released in amdgpu_ucode_request()
Date: Fri,  2 Feb 2024 20:05:50 -0800
Message-ID: <20240203035411.010032373@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 13a1851f923d9a7a78a477497295c2dfd16ad4a4 ]

Fixes the below:
drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c:1404 amdgpu_ucode_request() warn: '*fw' from request_firmware() not released on lines: 1404.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Lijo Lazar <lijo.lazar@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c
index b14127429f30..0efb2568cb65 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c
@@ -1397,9 +1397,13 @@ int amdgpu_ucode_request(struct amdgpu_device *adev, const struct firmware **fw,
 
 	if (err)
 		return -ENODEV;
+
 	err = amdgpu_ucode_validate(*fw);
-	if (err)
+	if (err) {
 		dev_dbg(adev->dev, "\"%s\" failed to validate\n", fw_name);
+		release_firmware(*fw);
+		*fw = NULL;
+	}
 
 	return err;
 }
-- 
2.43.0



