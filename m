Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062473;
	b=hTo5Ecdl4NWuPSjNAqXQ+S8/b5hveP2KucicyVRRKc+Bdni97gO5PXYztxG0a110j9SE
	 x9XmdgR2SbZElA6M3OEj0ft3N5ebRPMhJ40As17XU2IsfPVmaKD+9BPcAMCGLsxvt4gEu
	 luFqbiCJlZ0qVGGFEQwK0L8jriHcp6avIfF3lzY/WTbuq99t2Z9MxXyJxjeQZoijwE2Qv
	 lrI+icHdyn18aCLYEkZtR26HE9EzD5eLNHXMQJqOBfuX5g6nGYrpU8O0aCLMUE3JqiPT2
	 aMDUCmn4+FUhmkL3TClcufTDM8oJ8YWC6v43MK+O1U/BpSaBA2yC65x5mwnef8dC2vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7JbBTY8nBIDP0PODc5MpiqkJsb3pST3a59Ig55xYRpQ=;
	b=lX7CUgaE6ygWPsMIgD1Y0w5XOcBnqFwdmRyBSNl3u3TW9eHnGtH3uMxncYaNY47SHnJl
	 4GfO6kUPIu6J76vbMTleY1XheohQw2sAWNadMZoYYGqPpnXCRSwzZop4O4dflXCrgjvzo
	 wN9A2nlGY01hH9SdYnNrNb9kEwppeYOqFahHjWhYE19og5gJ9+mHCW4jDBWxhUKVkyRcY
	 GMlelKr8r+wXkaGKR8tx2OCC3sOpSEJq3FasIILTWmnxo1itlLYGDRK86zRtDbHocIbyx
	 g5Zyf2IgK2ftJ8U7RUmydlbz1Avhz2qHPTiko5zZhjiZ4ahYcgWxHOCZNvyVI+vlAzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=auhSE3J2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11816606D808;
	Sat,  7 Nov 2026 14:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=auhSE3J2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9B11F0089F;
	Sat,  7 Nov 2026 14:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062472;
	bh=7JbBTY8nBIDP0PODc5MpiqkJsb3pST3a59Ig55xYRpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=auhSE3J2cwO708iGz2sngQdQfeOBwj1YyJ7O6rf6oir+LSAq0pZOpDT5UKiB21lTP
	 aFJdTPj8wS9No3KVGt0A132vHPfV7Zvt2b4CsSWaIf5yWfbxPBYIzikU8LVTV99XcA
	 vx1ow8l+M/1R45q9OTflDrPhNbdOC8YTBLnaZ7Gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Luigi Lauro <luigi.lauro@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1377/1536] drm/amdgpu: require _PR3 for BOCO
Date: Sat,  7 Nov 2026 08:56:33 -0500
Message-ID: <20261107135036.513439014@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f022f8cc97306..a8f8bb342884f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -349,10 +349,8 @@ bool amdgpu_device_supports_boco(struct drm_device *dev)
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



