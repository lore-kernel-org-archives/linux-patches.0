Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050896;
	b=N+12rgvyB7uJEpOUsLXG3sVr3GjZ1njJ1aLcaIdLadwgfND+u3/SHAaq7LlA6u5SvLfO
	 H0RSzGrdosmTqTJuKN+Dz0O2GKmP2/xxQljeFNHwuJFctQ64USHr+YEzXynLNNIkp8O82
	 Uc1X3v8mHKOyqkOeAt1C3JoL/R9kPPB2RwIfOUX0m9RdRGUqsIgIeb0uKlnyFtz4kdSGW
	 k7ewGWnR7YgeeIWiyczLnH8oKM86mFM34xTiW55nAjIok3qlAcDx1DR3qxZb0G3evCJIn
	 qdHzqnue2f6l1hw/XtoSMrwBemd6C3pgxlQHhf1MoXxE3xZ24rQuVMcWMrN3/NntpMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=eN9Q54Ix1Vr686QknII4Im82uAYHfOKeg4QC+HwZNGE=;
	b=y4Tqn3WsjLoZfAbymIy2EU8VLmPP6t7EJJjETsm/ZGdIykpoGYMMaN43DBzwRqEhFVnN
	 /5V+pm6rK9d2WqTKlXwrxnwHyr4tdHgG69Zvcwizvs/MWpNV+P6BhT6terrcQeAavWpwZ
	 RJaW4zb32v3VoMaS/3xzy96gs6voiE+/kJjtVwjmbQ/XBZAUtFCLnB9U2vH14/57j2CHj
	 l4cVW/iUGpVcj/RaMwN179MVGy/qZgXLRRghq6aGu//2BvsQi+egD6BiFLXdp8VWa8mwV
	 wbbtUixjvxbQgnupzOT4ST5SKHlSFkrg5Xrqf2aqu0aC3nJd3mmX5GipXLVmCwHibyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x6RqwcMe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6B0606A31C;
	Thu, 19 Nov 2026 01:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x6RqwcMe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F991F000C4;
	Thu, 19 Nov 2026 01:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050895;
	bh=eN9Q54Ix1Vr686QknII4Im82uAYHfOKeg4QC+HwZNGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x6RqwcMeHATZHz9nXavqj3alrs3nCMtB6M/BGXlFsgwRXfhbpUCJnYDoiUHjA/gD2
	 WCYyaU9Tc3ryS1NTZ/DVmM/bH/Jh2HdHakoAbRMdqjNc3iMLfli/9opLvnG5BPfj+c
	 UPFD8Asb5a1Lxzkiar/htrkkLVmuGZ106c5pomrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.15 0017/2214] drm/amdgpu/jpeg: set no_user_fence for JPEG v3.0 ring
Date: Wed, 18 Nov 2026 15:28:13 +0100
Message-ID: <20261118150010.832827491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

commit a2baf12eec41f246689e6a3f8619af1200031576 upstream.

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: dfd57dbf44dd ("drm/amdgpu: add JPEG3.0 support for Sienna_Cichlid")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d7d774f100efb5089c86a1fb8c5bf47c63fc9ef)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
@@ -554,6 +554,7 @@ static const struct amd_ip_funcs jpeg_v3
 static const struct amdgpu_ring_funcs jpeg_v3_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.vmhub = AMDGPU_MMHUB_0,
 	.get_rptr = jpeg_v3_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v3_0_dec_ring_get_wptr,


