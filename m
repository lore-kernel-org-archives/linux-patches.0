Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036743;
	b=1Kk4ZZEdDsMwObDHPZhOc8K5Vc35U0exVHfxeJVZjxXTNuuCxMArEeCm7zssIBc0XM7M
	 56Juq6gWQndO/tF/F8vX4ntIXblCLjj018Sen7PkD3KSAEcH0n0FM9T2B95hzDrv2etrd
	 ggRyON9jLcFCBCL9HxDUrUZasV2SDhuY5v8Xj0w/l+bGpkEvEhinhpzDM2XXgHPoIG57k
	 /iIwXDMUmdII2hrNdHwqgMZ1aF1xjNmNbCMy3A9bptfWu9w8BAXYmduHSQ2eeQCWq6qrh
	 FOpLo255iJ4WP768dteKx4mOFVbFXW70tzWd6+aj7fxobVKYphM8LAV5sQ08YtHCrpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NS1+zfu/H00kjgDRx+ON+hK8Sm1fjk0tzjdwdhjN1EM=;
	b=XtGPsrB2nku2WhTr8phdJ6JpF70Sda76l3tWXPsNcbHElOE99UAatpUEYMrlMBr2b2Xp
	 HCL0jXo7PRNgAFs1/rzr4sN/r1h/lw0sAFVX4GHrP7byNPXU3gs3658o7FQqWvSn2c3vp
	 lY0SvChciOBqXJ+BjX7giQNNl4OHWzisE26GDYH58MompcYwaFrulOoVxUNHm/T3h3haX
	 6VbnQQec5s9n93CB1hnLi3gwqBEO7QtWXd88H/1UmGL10B0TJpLdoMEGDL8mZt3zinHHU
	 Xo4EhjS+rbnbuu76L4qJwkks4fKlHWDyqkvoo1iSnL6lQZECinjXoJBOJfYXcTBHBBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DDTZClfc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8EC606A325;
	Wed, 18 Nov 2026 21:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DDTZClfc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC4F1F000C4;
	Wed, 18 Nov 2026 21:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036743;
	bh=NS1+zfu/H00kjgDRx+ON+hK8Sm1fjk0tzjdwdhjN1EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DDTZClfcs6WBIpAubdm5QCwVsqMAzo0uda5IWV5VTIlTSRkGW3mwvDeQOxyOKFWMA
	 T7YfJ4AXfRinqsFmIzLOm+DNr3L/8xLojBA7R52Zsy1Qsl1nv6eFtNu1ZRxij/mGhF
	 eQd0GtVu8LH1lXwnDpZqpruVpLoECrz4GTZ0JU7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Luigi Lauro <luigi.lauro@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1169/3318] drm/amdgpu: require _PR3 for BOCO
Date: Wed, 18 Nov 2026 15:29:51 +0100
Message-ID: <20261118150355.191709764@linuxfoundation.org>
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
index 513fe934453dc..2cdbee6700ecd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -201,10 +201,8 @@ bool amdgpu_device_supports_boco(struct drm_device *dev)
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



