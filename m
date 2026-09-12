Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8EA235358;
	Sat, 12 Sep 2026 07:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199646; cv=none; b=pIECAOGMdUZWwNbrHSX8infmj+/ZuHQ/sWgVQbTfdLD9VBlHJ9ocqb6lxfl05ZLhJcDuMDR+8twKauNcLs40T5ztAxfF0FBMmQ0LAsX5H5Sf0O/keMy9x940BZyvyQYpzjUGFQENQpw9fR0gytxDG1VYrHurOV6AQD6tM8kuYok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199646; c=relaxed/simple;
	bh=4aeCb6kdzGt/uKE7yL39vOWxgq5XVyv2tTsVElZTJJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5EtoSvMWvl7Itdq5Ql5zlmoYXMnoswatAnN/OYy1yVA7sHrjy/GpLtc8bGK/l0TDGCgmOCVsNvi6I7WXca+i3VoKSHDv/dNfbKNzWYP9dOP5TcVJrZHiwN6AbrrBUk2MC02mJtJ4kGpYb+4kYk2FwVFSXgqxz5d5KyEGcGcdgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UsLroQ9z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UsLroQ9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD5E1F000FF;
	Sat, 12 Sep 2026 07:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199645;
	bh=taoTe5AoRSCE7BjYlSz3VsuYTQc3kBDrgEI/HPAzQb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UsLroQ9zK6H5Jan/v3Zue8rxF9bskESzpT28nPouBg54JPS3w4LOkPKOmznjkQq8K
	 zpC4xmEH8X6TsmRKdBiaqFA+ViCmb8b2e0hsC8g+Rhd9eL291spq8hqib1AwkBafhc
	 ddVALSTPh6IkedirmHk8UL7axfh4Zt8mBlqQrv7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliot Courtney <ecourtney@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0626/1815] gpu: nova-core: correct RISC-V HALTED field
Date: Sat, 12 Sep 2026 08:39:36 +0200
Message-ID: <20260912065703.574483159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliot Courtney <ecourtney@nvidia.com>

[ Upstream commit 5557c238eb0f97169edda1d0776207e3d61f4f16 ]

This uses the incorrect value, so update it.

Fixes: bb58d1aee608 ("gpu: nova-core: falcon: Add support to check if RISC-V is active")
Signed-off-by: Eliot Courtney <ecourtney@nvidia.com>
Link: https://patch.msgid.link/20260703-blackwell-fixes-v2-9-8e3d8bc32bb9@nvidia.com
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/regs.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/nova-core/regs.rs b/drivers/gpu/nova-core/regs.rs
index 0f49c1ab83ad4..a1af4a8bd2365 100644
--- a/drivers/gpu/nova-core/regs.rs
+++ b/drivers/gpu/nova-core/regs.rs
@@ -570,7 +570,7 @@ register! {
     /// GA102 and later.
     pub(crate) NV_PRISCV_RISCV_CPUCTL(u32) @ PFalcon2Base + 0x00000388 {
         7:7     active_stat => bool;
-        0:0     halted => bool;
+        4:4     halted => bool;
     }
 
     /// GA102 and later.
-- 
2.53.0



