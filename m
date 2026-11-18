Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045644;
	b=HwkLZRVS3OtzhIEsr6lL5Dg9hoFtckxX9xnrDXQKS5EuH9A7QM6eZ8NEGuNGjgG5yqWl
	 CqxhyqSRdtcnFNIQ5gvcQbJtWcl/akJIAkYZ/G7KJjCsgWezUsnfZ0BRPiz0hBJLC5dZU
	 fgG3orscSO8PcDQpchKb1Hsm3M04Ven9WVFmcCMpYhE8L9cQLiuAPq+4DBf0MSrHibQyr
	 /p/D5GI64rj6Ml7LaT1oappEiZsnaCxN5mEagNAZmhVJMn/E+pLQTDFrOjJEeSIm9RsUr
	 uueZxBtpnYuC2igiHZk2dLlhoPIa7eIu1gRMkX8ITOLpkQoW9UqW+/ZBDd1GTPq4C1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RGVMN/u2/VxYWB4WpVix0QZ6HiS3bheH6e23RY7RuWs=;
	b=fbJX7gQQIiewI4KZCLypM269rpa6d6/HefCLolGSGUkfBoHTBV4Ta1SVEFsm8Cd6XUsQ
	 yLcX73jsL77sHWK3FviuLbR9oz6TdI/GtilreSxSuK/b2JQwjPqSh2jjUXjiGKNL6fHP2
	 a/0ILFlRRyknl7yaRcV9Wve3H//WstrrUm9Ccw+D5H9SFJBTiCjeTDvT5G/yoTTpZ+4Pt
	 m+nBrTwDoD8A4PDWd3U9hM/GAZWyDka3sBhr/zj5fTwN2CyHNDGeGe+gAOW0EOXjr1HjF
	 Nsc6AJj7J5GrCkL82AqvTl5B67zPVEUIVjgGJ4UeNQzo+106Rqs83STh83K3ustZxBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iFvyh+tE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB3A606A333;
	Wed, 18 Nov 2026 23:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iFvyh+tE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C641F000C9;
	Wed, 18 Nov 2026 23:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045644;
	bh=RGVMN/u2/VxYWB4WpVix0QZ6HiS3bheH6e23RY7RuWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iFvyh+tEFKH5DQle5Ty8+x9U99gTPDe3+JGlaUXAVPDGE9fjm3S3bVTktS/Gihi4H
	 mzE5aFdkXYV3KuXhVpVaXksVHLz5lcsLN0L+FDkKhHc1nW97NBpWq4PLc4oLPLOH3W
	 zBDgofkU1fMyhSTlr5KT/YSbU3HfbYv+rQyxdT08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Luigi Lauro <luigi.lauro@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0998/2857] drm/amdgpu: require _PR3 for BOCO
Date: Wed, 18 Nov 2026 15:33:52 +0100
Message-ID: <20261118150237.535637082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Luigi Lauro <luigi.lauro@gmail.com>

[ Upstream commit 28f3d169f162ca7e803c5a1f7e1bb55bdc915d1c ]

amdgpu_device_supports_boco() returns true for an AMD_IS_PX device on a
system with a hybrid ATPX method even when the device has no ACPI power
resource (_PR3). On an APU mini PC with a discrete GPU attached over
OCuLink, the iGPU's ATPX method reports hybrid graphics, the dGPU is
flagged AMD_IS_PX, and runtime PM in auto mode picks BOCO:

  amdgpu: ATPX Hybrid Graphics
  amdgpu 0000:c6:00.0: Using BOCO for runtime pm

In BOCO mode the driver leaves powering the device off to the PCI core,
which can only do it through _PR3 on the upstream bridge. No device on
this dGPU's path has _PR3, so when it runtime suspends the card stays
powered, with its fans at about 700 rpm.

Require has_pr3 for BOCO, as the function's description ("dGPU with ACPI
power resources") says. The same card then picks BACO, which powers it
down:

  amdgpu 0000:c6:00.0: Using BACO for runtime pm

This only changes systems with a hybrid ATPX method and no _PR3 on the
dGPU's upstream bridge, where BOCO cannot cut the power today. Tested on
one such system only, an RX 9070 XT (Navi 48) over OCuLink with a Ryzen
AI 9 HX 470, with the change backported to 7.2.9: the stock module logs
"Using BOCO", the patched one "Using BACO"; BACO runtime suspend powers
the card off and it resumes cleanly. Not tested on a hybrid laptop or a
Thunderbolt eGPU.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/5980
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luigi Lauro <luigi.lauro@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1a039805354a44aab7abb2a6e685212d48b17a5e)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 81eb14997d923..8bd9ecb88c94a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -263,10 +263,8 @@ bool amdgpu_device_supports_boco(struct drm_device *dev)
 {
 	struct amdgpu_device *adev = drm_to_adev(dev);
 
-	if (adev->has_pr3 ||
-	    ((adev->flags & AMD_IS_PX) && amdgpu_is_atpx_hybrid()))
-		return true;
-	return false;
+	/* BOCO needs a platform power resource (_PR3) to cut the power */
+	return adev->has_pr3;
 }
 
 /**
-- 
2.53.0



