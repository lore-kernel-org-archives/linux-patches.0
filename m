Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F703BA2C
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97AFC433C9;
	Sun, 16 Jul 2023 20:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539425;
	bh=OgFBWw028N26/+R9mpJ9uQ4667GLAsngEfcD/8JkCi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxuwUZghIhLU6Nqi0XTtMtiPBNBydEKKpL9K8P4Z/IxmAVYHb0VGYpbbUKevWbJWv
	 r7pS1Y0bCA8WHaU81vvtJjvaq6P6RWRlKcsTEhu1jCb3suTGIQvlGe6srSEua6iWAe
	 im0Z5n6bW6I/5yXnV7a1vkynFo5za2zziI0Txjls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Aaron Liu <aaron.liu@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 791/800] drm/amdgpu/sdma4: set align mask to 255
Date: Sun, 16 Jul 2023 21:50:44 +0200
Message-ID: <20230716195007.523192253@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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

commit e5df16d9428f5c6d2d0b1eff244d6c330ba9ef3a upstream

The wptr needs to be incremented at at least 64 dword intervals,
use 256 to align with windows.  This should fix potential hangs
with unaligned updates.

Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c   |    4 ++--
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -2306,7 +2306,7 @@ const struct amd_ip_funcs sdma_v4_0_ip_f
 
 static const struct amdgpu_ring_funcs sdma_v4_0_ring_funcs = {
 	.type = AMDGPU_RING_TYPE_SDMA,
-	.align_mask = 0xf,
+	.align_mask = 0xff,
 	.nop = SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP),
 	.support_64bit_ptrs = true,
 	.secure_submission_supported = true,
@@ -2338,7 +2338,7 @@ static const struct amdgpu_ring_funcs sd
 
 static const struct amdgpu_ring_funcs sdma_v4_0_page_ring_funcs = {
 	.type = AMDGPU_RING_TYPE_SDMA,
-	.align_mask = 0xf,
+	.align_mask = 0xff,
 	.nop = SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP),
 	.support_64bit_ptrs = true,
 	.secure_submission_supported = true,
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
@@ -1740,7 +1740,7 @@ const struct amd_ip_funcs sdma_v4_4_2_ip
 
 static const struct amdgpu_ring_funcs sdma_v4_4_2_ring_funcs = {
 	.type = AMDGPU_RING_TYPE_SDMA,
-	.align_mask = 0xf,
+	.align_mask = 0xff,
 	.nop = SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP),
 	.support_64bit_ptrs = true,
 	.get_rptr = sdma_v4_4_2_ring_get_rptr,
@@ -1771,7 +1771,7 @@ static const struct amdgpu_ring_funcs sd
 
 static const struct amdgpu_ring_funcs sdma_v4_4_2_page_ring_funcs = {
 	.type = AMDGPU_RING_TYPE_SDMA,
-	.align_mask = 0xf,
+	.align_mask = 0xff,
 	.nop = SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP),
 	.support_64bit_ptrs = true,
 	.get_rptr = sdma_v4_4_2_ring_get_rptr,


