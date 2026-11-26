Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704224;
	b=1CfWlwiUV7YW2AOiTFCKZNMVOYY8hioe1Xa5ExsFTguJisVdxlknOfqg8bnt/gTNYMOT
	 nkTHaVNsLcK1Gmms5MpKVnl9EBRAs/xOgFg8OXdg0nWN24iYzx3jOegPJ5vP2YaSJBde8
	 VJvshOEOPoqfUU2hLR/EScT6WNF9WddXw5unVx54v+MhBI0bnRmNh7x1OxbX1yVog8IoH
	 y0Eu+dj4W79LV4kuHR+0m2XOKQIvxmBf+ETIAURUswYX8XmriuIwaQBtSVtT7E3TP2fL3
	 FoZqlChzrNUo5eBg/V9noZrpTIBjKVPM6eI+4ytWborKDNoGK8z6Jd048kZO2OMz/4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x+IpiRHrpdr/wOsSxuM8kXnOnGjLx/jPEACU6IZw7yI=;
	b=Ox5j9hOUVWO/IGzUT2uMNw++SvGCo4u8vukXG8fOCoWV3GwiU6QDh6QlzccwwdmS+Gi1
	 0CxEE2Z/uWvt2OBjphCpuJr2sc2AQjL1CkfHaMJw1FmjFmwY2dFSuL0lRRghCqjG97BcL
	 R+1pMbqlo/Gi6yTw+WkIiN/yxOecL4PTDYXcRgkLa2KJoizgb4QCEVTZke0QSWEeW0pJY
	 PqlCC/9qVoqJ1q4LPqewutFT294e+HEHArQMHbiLZjFBH5MkoI590ISBqOP/+FhHal4jI
	 I+RpLBeN+ai5KoNxK0rPSbXmc5grwbqVcNIRTMiUZSUEgi4ooBYSF8GBjs8Eh/4F/4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nvr+CCgZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D4F606A31C;
	Thu, 26 Nov 2026 14:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nvr+CCgZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1941F000C4;
	Thu, 26 Nov 2026 14:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704224;
	bh=x+IpiRHrpdr/wOsSxuM8kXnOnGjLx/jPEACU6IZw7yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nvr+CCgZV0NwH3g71Q7FlF6ys7GZ3IRsFcfRmqg1T7arQmJ9gfqJHKui4M408aPjf
	 vWSRu02WzrwVvqY701Z9Io476VQb9NytEv0ffuYPBNf9rk3gqmyangt2inN075eTiM
	 R/Eb8oKlkB9VPkbeK70sw4Fia8o4cokV6882Ccfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/265] drm/amdgpu: Check cs flags.
Date: Thu, 26 Nov 2026 15:35:38 +0100
Message-ID: <20261126143605.659260992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

[ Upstream commit f5ea64f9fcd921bc4e2307a262e19450b8a58524 ]

Had no validation before. libdrm_amdgpu memsets this, even
for the raw/raw2 functions.

We have a lot of functions touching the ioctl struct, no
strong opinion on where this is placed, but I thought
early would be good.

Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Reviewed-by: Faith Ekstrand <faith.ekstrand@collabora.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d01e15e76358f60ef6734462d2b6d9972b9dfbc)
Cc: stable@vger.kernel.org
[ sashal: Moved flags validation from amdgpu_cs_pass1() to amdgpu_cs_parser_init() to match the existing parser structure. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 6286eadc084aa..23d5775201c09 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -114,6 +114,9 @@ static int amdgpu_cs_parser_init(struct amdgpu_cs_parser *p, union drm_amdgpu_cs
 	if (cs->in.num_chunks == 0)
 		return -EINVAL;
 
+	if (cs->in.flags)
+		return -EINVAL;
+
 	chunk_array = kmalloc_array(cs->in.num_chunks, sizeof(uint64_t), GFP_KERNEL);
 	if (!chunk_array)
 		return -ENOMEM;
-- 
2.53.0



