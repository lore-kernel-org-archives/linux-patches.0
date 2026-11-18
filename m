Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033610;
	b=gmxUcgXeRXv126MUksmpEyHt2nWxTLWENWLBschXKP1xucoddkkyWub5VysI5qmOHFC0
	 GTFV4iVsnCebsokxM6iGjVAvjjupZQxoMDpEOCJQPHgPBuWKp15Ex4mt1imkpfq8ps0l9
	 Xnt/6dzCSyO61NtGBgiUGQP7kGMBJ1FYHAkRW3rnGXoe7y+8eU4ZdJUf+wIRPLVxDGW/3
	 AySszeAx6RQYFrPNLzdVMhQeJPw/7B7PXnPIOoELDrNbdnSWkmtk5+zDbfYUzXoRaz9+d
	 cp1CGG+JuNvuRwtJC8syl0hmuUz05jAeXMJXX4NzmOtKBf5p81z2x2p4dvXdej4jZBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=odvc8/6MMHeYaq86pGXu6m8Na2TWcBMZUsyLnUmg7fs=;
	b=FhjdrScmfoX6VOwxc5140rWR1KBkdAgf7JGZJXMdinhRGUBTe7Ir7Te3eBvyxIF2J1nJ
	 J1dcIdSPFgRyD6yfXdjHhHd+swiABaXuGv8GLoTJ7ItuuKtWt0M7nVz7Qq2WLARLxRmEr
	 vVpmZUVSkQ7fbx6UO/VU6q+rqUzDrq07o71tl0I8Z/8II1BWQuya80rRlpRYDu8NOnwGa
	 n0lAf+J04zPfxozy0RKQtXPNjTjp0BROkUWd2pil7KN2MiErRusrpUOrYMVkMkWfxwwac
	 ij84/v7og/2Nv6BppF/4dcVSJcKQkN+BC2c41NU+WJWZYzVwpFJ1pqZ55NnayiT/+kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y0zuUfH8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D559F606A32F;
	Wed, 18 Nov 2026 20:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y0zuUfH8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381891F000C6;
	Wed, 18 Nov 2026 20:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033610;
	bh=odvc8/6MMHeYaq86pGXu6m8Na2TWcBMZUsyLnUmg7fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y0zuUfH8p2eolG3sEYTje3UTcdkBYqHFkHeIF6WAwzY4j88q0wj5TLOzalJCqVKYb
	 A3iiD0IHOF6rOUvweHOHBsrSbBPYroALtqtKJ0k9Hc8KNfECvyEaIyqxKGCQGhSZME
	 SsAcXD7qlLoqb6vEmwELt8D9eHrtD0lZKCKHnP3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YiPeng Chai <YiPeng.Chai@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0024/3318] drm/amdgpu: add bounds check to prevent array overflow
Date: Wed, 18 Nov 2026 15:10:46 +0100
Message-ID: <20261118150314.471083033@linuxfoundation.org>
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

From: YiPeng Chai <YiPeng.Chai@amd.com>

[ Upstream commit db15c49a17b8fab9ada38f3a548e5353d7d6b1a8 ]

Add bounds check to prevent array overflow.

v2:
  Add warning messages.

Signed-off-by: YiPeng Chai <YiPeng.Chai@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 65a5edcb12ba4..bcf7f8ded7006 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -3134,6 +3134,13 @@ static void amdgpu_register_bad_pages_mca_notifier(struct amdgpu_device *adev)
 	 * Use this list instead of mgpu_info to find the amdgpu
 	 * device on which the UMC error was reported.
 	 */
+	if (mce_adev_list.num_gpu >= MAX_GPU_INSTANCE) {
+		dev_warn_ratelimited(adev->dev,
+			"mce_adev_list full, skip notifier registration (max=%d)\n",
+			MAX_GPU_INSTANCE);
+		return;
+	}
+
 	mce_adev_list.devs[mce_adev_list.num_gpu++] = adev;
 
 	/*
-- 
2.53.0



