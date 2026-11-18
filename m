Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052753;
	b=A3lQESyUsKlVXZKzf9BeH35B7dyztRmMv8s4MT2odkq1HWpqzYWSlGBpC7T8a3PC3tcM
	 2hB44JXz6SDIP4LSPzUUoMxnnrOEX/ogHY8C8xv3De15HPSmpOPE1Fddngcoko6zkl3O5
	 xFEzZk5JzOw1AyaMY0g1pPcwNFALqRvvlBF9D99ft3Lr14ozt1SB0nxJtXVUvCGm0dVqg
	 CYqFNPtLUnxlzQyFvLwZ29wwUlPnc3uKwfdnYFYDqfHo88IQ1AQwztsJs62nTaiD2w3SC
	 q68lMaE/9TnqCC6Sd2zFfqb6syLAs6UnckNishXXWE8dCy+5ON+XVQTtXHcrqPZKXSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lT7gLlp+8WuH9NOvNEpk/ApUdjkHXI/XROwk+E+UL8g=;
	b=fkFhhVrCIiW/LRRO023+YpNVQhsgAdx0CIAHqwa6Yoi+q+aIwq2zZR8kMoW7+ZsyYQ7B
	 yDcpIbZX6OtcPuDuWyHpbx8vtshA8fn0zPzrjl5/xzXAV29C1j9QTf9rssmviKbkKt4Gh
	 O1d816mqQSuExo8a+/QWl7TZeA+xECbny5eGByJN9l1bqUK/o40ik48CbEJx5qhWina+S
	 Yz6NDsEJGyp8yzXfJ3CDqkAY8+7BKbVyEgj4/CgyThKn6RFeDuwyZ3d+2cmDB0vOQV3eS
	 8YtqvUoLa2/HnQWQfwEu0huTQD1NMxV6mxlk8HWqyWf53dIGQxsz2f89uN4yGpjRHbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qCbPza6J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F93606A325;
	Thu, 19 Nov 2026 01:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qCbPza6J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526C51F000C4;
	Thu, 19 Nov 2026 01:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052752;
	bh=lT7gLlp+8WuH9NOvNEpk/ApUdjkHXI/XROwk+E+UL8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qCbPza6JQ8Wy0Ez47kiYPNlsaJixd34J4bR13RNMtl0PItGt4X8XQCYYhOaB5rWN5
	 2bHeRnp/grk1EIGfvabQlkQY5tTCTFB9BkJshM/rd2lYo1HWWMuqjwetj4qHqawqt0
	 FTFQydrZ5wgX4zFj3HhdjqN1nsruWWaG4c0XkBIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Luigi Lauro <luigi.lauro@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0674/2214] drm/amdgpu: require _PR3 for BOCO
Date: Wed, 18 Nov 2026 15:39:10 +0100
Message-ID: <20261118150038.771283640@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d94d02844c64b..5f9fa4a7caa69 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -255,10 +255,8 @@ bool amdgpu_device_supports_boco(struct drm_device *dev)
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



