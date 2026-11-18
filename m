Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057115;
	b=HhqiIT8wqvkXs3dNv8uMB6xrKWuNeAPoThRuqnyWyjPxav4IblMWkbH0OZ6YZS2tLfTh
	 5jLLU3vrxHjiK4leuwph5PA9FNDz4pEQEp7WXZB8OmzYVKNEaGhO+g/bYodyXtfAead0Q
	 QVl2gnmsEEmi3TGuV22jekyPIXPkqJttdtZoyaBDmIOEYen4zdhCMhZbgJwnaHPg2wpj6
	 MhE0RpgjIRL7L6b0ihV87D1pkrp/HEpl573gYIYGX4VYkFEbk7XimHPHoP+zXkaJ4cQEx
	 JpsyKlA2LfcffAz9k4+LKZ8ahyV8x2c8OIeMlCNVOXNdmsyUNdtdpAxlOyHzhAPfV6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lJ3koeHLn8ewomLWrhserjS+7X1SjCNDG565My/4f60=;
	b=Zi11sgXUSl6EepptzcoeSncML4RS6dSiRc84fxvBhg4mzn92Bu896qn6SqH3HrJBuN2n
	 b5XDbJ/PVbJ+rRyVM+ZElhsTBuFyPmocQ0l/ovqKiEBqtUmMUc203hqCKdOfIDkbiVqU4
	 tF3EMYPHfqX3iO/WChZ0c9lOpd5Y9uSmsEgpcm7yJ0oBDfRGsCPqX5t4LamyB/jO2PdDE
	 LVfedyqEL4P2Oys5Q6t+OcePAKgSicC1Z30PxRcn0KdH6U88pShI+OwuP62mNp9h0U4dx
	 ib633uMR1VpsJ5uq/X8cqxqHzY/jFoZ/l0VG6jIZrhEjM04iGO6w6OAGZiQF0x4LYCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2uE9hIgV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6951A606A31C;
	Thu, 19 Nov 2026 02:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2uE9hIgV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5CB1F000C4;
	Thu, 19 Nov 2026 02:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057115;
	bh=lJ3koeHLn8ewomLWrhserjS+7X1SjCNDG565My/4f60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2uE9hIgVX8TKZtS/QJvuDSMNyksf8tK3+u1lAcuYstdIpsEUGxd5vwSQFkiJjEiUV
	 qbv1yJjUTauGOCmSfPxK1wX88xU+4Y4Sk1m9TSpMUOvPbJTss8nvX4x8uV1t7S+Bd7
	 jJ0FCw33L1Szb+da7Z/pX97ijZGvehm/mDt+Uq2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 0018/1848] drm/amdgpu/jpeg: set no_user_fence for JPEG v2.0 ring
Date: Wed, 18 Nov 2026 15:34:16 +0100
Message-ID: <20261118145911.880545485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

commit e5f612dc91650561fe2b5b76dd6d2898ec9ad480 upstream.

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: 6ac27241106b ("drm/amdgpu: add JPEG v2.0 function supports")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 96179da0c6b059eb31706a0abe8dd6381c533143)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
@@ -774,6 +774,7 @@ static const struct amd_ip_funcs jpeg_v2
 static const struct amdgpu_ring_funcs jpeg_v2_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.vmhub = AMDGPU_MMHUB_0,
 	.get_rptr = jpeg_v2_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v2_0_dec_ring_get_wptr,


