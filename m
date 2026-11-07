Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065134;
	b=YsN/FE8dBaDjVeJqOu7oCOsr9KfDAQUfW+5deHwoB9rFEWfvR5e8vRXbUymIYKWbUeNq
	 ADCvvLPCmaKp1LYV1ijcYPoihPU2jiS6HWYFzCnMZXr65MP8o58E5UJ9c0wbT/4on98Bm
	 BOXqbW4oUR+uRW5LVsUtFw32yl9eRXFgG0abLQrevIBtKZE7ALaZ/xSuuLujTjG1Dqt5o
	 nDeNEssNwGKMMDuTi4JjcZOHuytMR0KDLdGSvLXuL+I07SgMc11X12gK/8GC+HhO4pXtI
	 7qo3p+8H+XKYyl7LbdzrkeSrKRLl3oRGv1UIqcN57DxJVd5lTt6cPcsYRXNl+g/PsJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IsR3Vego0OFeOIYz7jHLqnz4ZpUD3l54toh2opF5eU0=;
	b=NaU23CPI/ygx3LfUdxthz4S8Ix29nuxHiJKDCD0j+GEOv/W7XB4WCOiiS479HqkXNptk
	 IHCzoQTbq9RvJdfvfaEfFFb9HrxD49Eg2n16l7+9R1BfNwG+dlNg6fclB8UNYsKnqL44X
	 HJpjQ+lgWO28iWfatEgXRXRlKV/cy16Kbp4DAC0wQTa99QKI+8KCxmVqFl37fOzDw9N9+
	 Z3pYC3bMkkapVkrIN+s4BHo558K2eVMn4m8E7w9lrE1A+GHlRiCX6kVIfl+8ZeB43HXMc
	 cxl9FMmQ87natMZWyDyyHAW8myp3/MMCba8vRYxaev49eNjrov+rcDoUaF06JlSA+Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NpKtFA8O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE0D606A332;
	Sat,  7 Nov 2026 15:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NpKtFA8O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260671F0089F;
	Sat,  7 Nov 2026 15:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065133;
	bh=IsR3Vego0OFeOIYz7jHLqnz4ZpUD3l54toh2opF5eU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NpKtFA8OsiD/ZHBB9qdl4igUoWosZlJ3PccP3bBvFjWn9isCOpfBZWlkgz/4HnXxr
	 45X/fAgLqaUJbyDoVdr1bjlgbxq13Z//tGHg7dnj241TqH0xrFyvirOHpl0gIT4IAO
	 O3tO2jzNr/fCO3xJEim74lmpctEqxqKFdPguPM74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Luigi Lauro <luigi.lauro@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0953/1257] drm/amdgpu: require _PR3 for BOCO
Date: Sat,  7 Nov 2026 08:54:09 -0500
Message-ID: <20261107135005.665922669@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 9269e780feb73..9128b60891c80 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -583,10 +583,8 @@ bool amdgpu_device_supports_boco(struct amdgpu_device *adev)
 	if (!IS_ENABLED(CONFIG_HOTPLUG_PCI_PCIE))
 		return false;
 
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



