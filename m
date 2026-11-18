Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033619;
	b=Ju74+7Emo75X/RenUO3ai/3Gs6rKihYzNNnkRPrvxbqDiJNyIfWxk0/irLF455DGN4E1
	 YFQ8AWjozOpJNL6ahczUr1Dvi0+DOOnDq6repAeezbfyV/ltu1vUzcAimEJo9fc7bMP+s
	 H1rD/Vj0jGewtHK1vJmrNTVI0V0LEGH7i2DHSNU35fg8gajadRljdBbu3dVFBCLaW29mq
	 qw47TAmM5EsX4U9M19ua9KrhdbE9aV9Va/kSI6a2y2quW8+3v39n1/PgeQKpvZoRdTu0R
	 cErJ+zqIM+H0cdnW74tBzEkGvtJshBwb9YQ19j+ykM9UOclXtQk8mtfp/6p5yQNCfjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YsK5KUosX9qd0hotXMrM9527ff2aana81uJ4BwMrMIQ=;
	b=FNypIx1b2w+CYTbCsy4X3f22wA33KpT/xEjwaB/Ny3MV77InGaVDqdDiLQu9ZntVxz9w
	 i9YTn+EoGS/17CYLGjFHVBrsBsPM+b/qAC+HJeck0iZvDkAVqnseYqkHjHiLnI7L8JgcQ
	 T4vQxoeleFc7LPxRC5bjLuQLRjcBU7Nu+5spkH60irKnPpOOIC9hjSsu7zatvVR230l5a
	 4DWc1bz4qP0RIWhowc1XiYOQf6VzZJiL8ldmb8LDoiAhVSy/jOTBoOdRl6O2Uvag9Nu5/
	 RHX33/Y+TMI0AUVqV5TI/5rYQfKeP0ztqDVgmNuGmTI3okljimCbjINijijF1ScH9Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z3Y3uAv1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCF8606A325;
	Wed, 18 Nov 2026 20:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z3Y3uAv1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4C71F000C4;
	Wed, 18 Nov 2026 20:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033619;
	bh=YsK5KUosX9qd0hotXMrM9527ff2aana81uJ4BwMrMIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z3Y3uAv1sKzjpdgrt180HUl501sQyYZ/p3AeenXbemiWbTv/wFoDJ40RYZD+2BfiI
	 bAdgvPle1ZHysbqAstVTV0A+YUeahsZicURIoyMAIEQsw/DDmPVzgHovPonx94+UwD
	 SJ7tACFTrXe/Q/pe+QXP0dWWG5ksiw6gx/6OBvF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0080/3318] drm/amdgpu/atomfirmware: WARN() rather than BUG()
Date: Wed, 18 Nov 2026 15:11:42 +0100
Message-ID: <20261118150316.485391046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit d7c595044965c826e6f3ce30590d3ec4399cd633 ]

There's no need to crash the kernel for this case.  Just
return an error.

Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
index 6521d06c7e4e7..2b65c7bbb57c8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
@@ -763,8 +763,6 @@ int amdgpu_atomfirmware_get_clock_info(struct amdgpu_device *adev)
 				   (crev != 6)) {
 				spll->reference_freq = le32_to_cpu(gfx_info->v22.rlc_gpu_timer_refclk);
 				ret = 0;
-			} else {
-				BUG();
 			}
 		}
 	}
-- 
2.53.0



