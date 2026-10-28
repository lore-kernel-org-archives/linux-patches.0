Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215902;
	b=ZrClRDUl73P4Hf7pAtp7HWs9JES17r7QUEWm4/Vtq7yMMopGRQyBe2PbDdL+aOQAFyIn
	 OTFrndR6uQnB2uQXSXUrFIJlWUurTA/NGIoRpdzGgNpmlrZfJOb9mc4HhjMeR1jD7k5Ad
	 VtXsIvhh54PecR0rJbLUcXe2+ShF0r5l3Alx9TYkpNU3b1cW7RXyjuA2uudxSx+Ge/JS/
	 K1CHCPLRNe+C4PEiOVKvju6gFbJHf147xO9oh/LYmz/Po6uhzEDLGIYTns4XfKatvT9xi
	 VyPD2PGoNhwhSbJNENE2wokhXbCjDKqyXsI6DNBC/Kfc31ISPI8PYfXtAHfeGxHh6Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ur3qGMQEv/4DZU1gonBYwEM4kXeUrLcJBK+fBzkdv6o=;
	b=qm1/F7BxVCQLfu56KV2zMsJn0toZM4+HI0QBeovEAVqjlccb3fFmXxkSsFuK7v4F9EXS
	 +ItcjCiJrD/+Qq3TtDdMcnFIHHPGhtTKHKXPa+cxzvCOigNssbwH1BOi4wcDaIN+UndS7
	 Uts+LjYuJ6MXl5zpHE0c+jYXyJ/iP0AWJyehjrSnUIDy6pUlm0siPYBScfcEL2JOEHGax
	 ispchgFEZnt+zxWJ6lIYH5R2rgmwFAVMQraNabkXc+ZnTPsNQm6Ul23puY6yFQ58P4AOh
	 ayTbT8LH5fLRoAEfZ0pgb8K2t46Bqu3wkiwTmy4yE+a8o4eSMMSVrke9i1lTtpojk3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XfeDoxUN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6B6606A329;
	Wed, 28 Oct 2026 19:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XfeDoxUN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA331F01825;
	Wed, 28 Oct 2026 19:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215901;
	bh=Ur3qGMQEv/4DZU1gonBYwEM4kXeUrLcJBK+fBzkdv6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XfeDoxUNTRHAAtvgS+bcrVzYb1GYWJDU8r4Q0yLmRM3O4QqGqgs5l5oI71NPUNP8m
	 HTwKJllH1Tb6ALhTvFZ9Gffz3Iix+r1q7gdR+o2jmC9rqASeILEkmWFlfJSSfuR6xM
	 6JPEXGQa7azxgmQlxDT+ZSfAYAqkm63JJEDXrZCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1365/1887] drm/amdgpu: Fix UVD dpb min size calculation for H264
Date: Wed, 28 Oct 2026 17:57:41 +0100
Message-ID: <20261028170530.507864519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rosca <david.rosca@amd.com>

[ Upstream commit 21a8084cd76223a13493237e04d45f5226d7cee6 ]

This should use actual number of references from the decode
message, instead of maximum derived from level.

Signed-off-by: David Rosca <david.rosca@amd.com>
Acked-by: Leo Liu <leo.liu@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 64b525edb7e7bdfcdc77883c5e413804e2396856)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c | 62 ++-----------------------
 1 file changed, 4 insertions(+), 58 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
index c144f4ed4f75c..f34199ac3e0ba 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -623,11 +623,9 @@ static int amdgpu_uvd_cs_msg_decode(struct amdgpu_device *adev, uint32_t *msg,
 	unsigned int height = msg[7];
 	unsigned int dpb_size = msg[9];
 	unsigned int pitch = msg[28];
-	unsigned int level = msg[57];
 
 	unsigned int width_in_mb = width / 16;
 	unsigned int height_in_mb = ALIGN(height / 16, 2);
-	unsigned int fs_in_mb = width_in_mb * height_in_mb;
 
 	unsigned int image_size, tmp, min_dpb_size, num_dpb_buffer;
 	unsigned int min_ctx_size = ~0;
@@ -646,35 +644,9 @@ static int amdgpu_uvd_cs_msg_decode(struct amdgpu_device *adev, uint32_t *msg,
 
 	switch (stream_type) {
 	case 0: /* H264 */
-		switch (level) {
-		case 30:
-			num_dpb_buffer = 8100 / fs_in_mb;
-			break;
-		case 31:
-			num_dpb_buffer = 18000 / fs_in_mb;
-			break;
-		case 32:
-			num_dpb_buffer = 20480 / fs_in_mb;
-			break;
-		case 41:
-			num_dpb_buffer = 32768 / fs_in_mb;
-			break;
-		case 42:
-			num_dpb_buffer = 34816 / fs_in_mb;
-			break;
-		case 50:
-			num_dpb_buffer = 110400 / fs_in_mb;
-			break;
-		case 51:
-			num_dpb_buffer = 184320 / fs_in_mb;
-			break;
-		default:
-			num_dpb_buffer = 184320 / fs_in_mb;
-			break;
-		}
-		num_dpb_buffer++;
+		num_dpb_buffer = ((msg[61] >> 16) & 0xff) + 1;
 		if (num_dpb_buffer > 17)
-			num_dpb_buffer = 17;
+			return -EINVAL;
 
 		/* reference picture buffer */
 		min_dpb_size = image_size * num_dpb_buffer;
@@ -724,35 +696,9 @@ static int amdgpu_uvd_cs_msg_decode(struct amdgpu_device *adev, uint32_t *msg,
 		break;
 
 	case 7: /* H264 Perf */
-		switch (level) {
-		case 30:
-			num_dpb_buffer = 8100 / fs_in_mb;
-			break;
-		case 31:
-			num_dpb_buffer = 18000 / fs_in_mb;
-			break;
-		case 32:
-			num_dpb_buffer = 20480 / fs_in_mb;
-			break;
-		case 41:
-			num_dpb_buffer = 32768 / fs_in_mb;
-			break;
-		case 42:
-			num_dpb_buffer = 34816 / fs_in_mb;
-			break;
-		case 50:
-			num_dpb_buffer = 110400 / fs_in_mb;
-			break;
-		case 51:
-			num_dpb_buffer = 184320 / fs_in_mb;
-			break;
-		default:
-			num_dpb_buffer = 184320 / fs_in_mb;
-			break;
-		}
-		num_dpb_buffer++;
+		num_dpb_buffer = ((msg[61] >> 16) & 0xff) + 1;
 		if (num_dpb_buffer > 17)
-			num_dpb_buffer = 17;
+			return -EINVAL;
 
 		/* reference picture buffer */
 		min_dpb_size = image_size * num_dpb_buffer;
-- 
2.53.0



