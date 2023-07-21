Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C97920F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90418C433C9;
	Fri, 21 Jul 2023 19:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967175;
	bh=O05TXVz/qaAcc9mYw41t3d6J5r+H7xk0MN9KLJfmuR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mc492mlVRcxUv/aMux0zaMszIRq9X/nlAP6z5nRYYR5Q8aCMJt7KJVbh3qr5lqHpb
	 VR8Fw4A28zZCamc+Xjkc2wr77xiVLnqadiZLs6bU+DLkgRvLEGBZi2PHkq/KPgRq5O
	 4SfwIsIpg7+BXr8299H61LTDuDCQrEqHIg0h3KmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Aaron Liu <aaron.liu@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 070/223] drm/amdgpu/sdma4: set align mask to 255
Date: Fri, 21 Jul 2023 18:05:23 +0200
Message-ID: <20230721160523.850115903@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

commit e5df16d9428f5c6d2d0b1eff244d6c330ba9ef3a upstream.

The wptr needs to be incremented at at least 64 dword intervals,
use 256 to align with windows.  This should fix potential hangs
with unaligned updates.

Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e5df16d9428f5c6d2d0b1eff244d6c330ba9ef3a)
The path `drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c` doesn't exist in
6.1.y, only modify the file that does exist.
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -2330,7 +2330,7 @@ const struct amd_ip_funcs sdma_v4_0_ip_f
 
 static const struct amdgpu_ring_funcs sdma_v4_0_ring_funcs = {
 	.type = AMDGPU_RING_TYPE_SDMA,
-	.align_mask = 0xf,
+	.align_mask = 0xff,
 	.nop = SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP),
 	.support_64bit_ptrs = true,
 	.secure_submission_supported = true,
@@ -2400,7 +2400,7 @@ static const struct amdgpu_ring_funcs sd
 
 static const struct amdgpu_ring_funcs sdma_v4_0_page_ring_funcs = {
 	.type = AMDGPU_RING_TYPE_SDMA,
-	.align_mask = 0xf,
+	.align_mask = 0xff,
 	.nop = SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP),
 	.support_64bit_ptrs = true,
 	.secure_submission_supported = true,


