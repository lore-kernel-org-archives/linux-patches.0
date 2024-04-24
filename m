Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D5416D9BD;
	Wed, 24 Apr 2024 18:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982771; cv=none; b=idhIPy7V4k5qhg7YElCemKQo8e0o7BOyx/Ykme3H1xDjs98kVfox4ZSqOlmpUniNtlL0BXBXROHS9o2wy+W4DUU0eiVMPOgLaUZBvAFNwwd/v+WF1ZK2jb3PrVMXNy3gcfX1fPpEobWXB5lvA1rX/yl5NzWaRSSS/6x5bm+yGy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982771; c=relaxed/simple;
	bh=30OvYjSJuD34vtY83bLWHG2lOubZjPNjxBpPZF5csZQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=EYfpS2MWiZVLqqdBRnf7Gg1IJtNm3IiThpiplLzWsN5yvU2uuh/1bKcnT6wJVc1g3fdmeURgjRX5qT6zsxTGDtm+goqqAmL9Ot0BC22G1WoUN2N3Iw5vHAhVvTSyWJBsXYDVG8Np351MuyfA8onxvxID3hIRq9zQso0b1Gn1nbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CCynUCQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CCynUCQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C72C113CD;
	Wed, 24 Apr 2024 18:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713982770;
	bh=30OvYjSJuD34vtY83bLWHG2lOubZjPNjxBpPZF5csZQ=;
	h=From:Subject:Date:To:Cc:From;
	b=CCynUCQrk/isnXaumy6k68iQuGWn7yV0on+rsBTrba18OPD2EL1NnTk16g60IKxCi
	 7TqzKwia9Q0DD3CLFwqkpPyQNU5DXpTqmyaCr9fRmWU1qtP0SqmKoncMAvRiKzsHjr
	 BMTuyuFASUGaJYjgZGVrgJKdjlPS+MZOmJTEj6velIz6NyEUKA7eL68RgTqLtjN/Lb
	 aVL0K1xGiTa9c2OROeKFy0TYlQbLVmpkMWUbFdmPemSLtP5cK5eugluyDPR0Vhx2ce
	 3X0nAVibV6g/z+oeW07vg/q0YFjKMzHKgnqGW7jZHndWCzLdY+C1LSKc1ZnOWtaZpM
	 KVAAZhh3pimxg==
From: Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 0/2] drm/amd/display: Use frame_warn_flag consistently in
 dml2 Makefile
Date: Wed, 24 Apr 2024 11:19:25 -0700
Message-Id: <20240424-amdgpu-dml2-fix-frame-larger-than-dcn401-v1-0-5659f8fa8816@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC1NKWYC/x2N0QrCMAxFf2Xk2UBbIoq/Ij6ENamBtY5UhzD27
 xYfD9xzzw5d3KTDbdrBZbNurzYgniaYn9yKoOXBkEKiQImQay7rB3NdEqp9UZ2r4MJexPE9FMx
 zoxCRrqoXiXqOwjDuVpex/6fuj+P4AcsXRaV6AAAA
To: harry.wentland@amd.com, sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com, 
 alexander.deucher@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com
Cc: aurabindo.pillai@amd.com, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=743; i=nathan@kernel.org;
 h=from:subject:message-id; bh=30OvYjSJuD34vtY83bLWHG2lOubZjPNjxBpPZF5csZQ=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGmavoaWzh3W7YLNW6/mH1JrOOHp2f4lemnp8ZPSfx9P9
 53ZJafXUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACbyJo+R4frC2pxwzw/2G4Rn
 XYkpvbih82JJ/LHFYY/fnYowLayxe8bI8MhTv/gHZz7D6f1VrQciG5PWlguvMhGL6OP75LLr1B0
 PLgA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Hi all,

This series resolves a couple instances of -Wframe-larger-than from
the new display code that appear with newer versions of clang along
without another inconsistency I noticed while fixing this, which have
been accounted for with the $(frame_warn_flag) variable.

---
Nathan Chancellor (2):
      drm/amd/display: Add frame_warn_flag to dml2_core_shared.o
      drm/amd/display: Fix CFLAGS for dml2_core_dcn4_calcs.o

 drivers/gpu/drm/amd/display/dc/dml2/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)
---
base-commit: d60dc4dd72412d5d9566fdf391e4202b05f88912
change-id: 20240424-amdgpu-dml2-fix-frame-larger-than-dcn401-48ff7e1f51ea

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

