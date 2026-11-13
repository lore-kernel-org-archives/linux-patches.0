Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585467;
	b=OrK/qiH/3WIhyrwFK1PkiYRY/fiMtVx7A9qSDPLiA4adZbNJomHZ/+Cv3m1habBgatog
	 LuWw6tSfdwoQYuG5jHZS3XQZECl4lTQeHetx0tfhu23KdDt3vcrqVgGwu8GA9Oi9tKbdn
	 XxL3H6fKBbwoz6uPunFbtH4ijnxYtj8HbYyK8SoMz6MXTX+O8/mb2InuvLLyR4Db/kCDp
	 GzutX3nUYbGkeBVI+tNkMX7ob4lc3JlsN/bgMQ18ZYH2D2Bh9yTJdE+VZLTK4LqLSIKsr
	 VhvaJEBG105KFzwRxi/I/u+DjnRDMExT+Y7PWLaWFn3PwVyHoWLU6qq3jfxwKOmco1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gyZ7VCmtUmlpo1DLAfjnv0gzzBEmalpDFhesthQNCSA=;
	b=oARwiO/DB/QXQWMjO7gc5VmCp12KO0fveA+M45Sco+fqwDDwy4a6c2pCrKfIw5FPR+6a
	 ioEfN/e7F684tMlL8Mf44znLh5l6HuKwoiY92kvb/haJ67YA16USY7uisqDkYpobMf9Kf
	 V+lbaIuf2mwdpNvzMrU3BgBPOwkCE6GUcYCbjnxvDINyWi+ToiuRGcKYjYLmn5C/VvvYn
	 2uDJJRhy6RZEmfdt2r5VZNd62K/A4AOJUHX934q2MYjrVEBDxRVNwKpvukTbrd65dKUwY
	 1nBdnN8P9psM+4m0fe9weuQ0Nx72QAvhZnH4AaZsoi2a9t7jX0EeDpC5ePZI7r8+7ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dk8ZLmXl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D15606EB81;
	Fri, 13 Nov 2026 15:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dk8ZLmXl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75601F000C4;
	Fri, 13 Nov 2026 15:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585466;
	bh=gyZ7VCmtUmlpo1DLAfjnv0gzzBEmalpDFhesthQNCSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dk8ZLmXloCcSmhgACKXPDml1bHo/d7vH1X4nwYu0YGAmbQad4I9moXKC8W/cDEhSq
	 ABdmo/GYo4bpTPjuQb1uQIIAcyvYg6LmA21IncKa/rccS5wzaRdJKBqKNVa9kq8DBX
	 n5PSsSO7++6rxoNtXyWTXR5DRuKfMw3QTy+UX2Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 122/507] drm/i915/psr: Fix SFF and CFF CTL register bit definitions
Date: Fri, 13 Nov 2026 10:47:06 -0500
Message-ID: <20261113153758.561640263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 15b3187740291c4705b995bbf984da462e9f1e35 ]

Single full frame bit in SFF_CTL and continuous full frame bit in CFF_CTL
are bit 0. Fix the definitions accordingly.

Fixes: 3b5bf853e309 ("drm/i915/psr: Add register definitions for SFF_CTL and CFF_CTL registers")
Cc: <stable@vger.kernel.org> # v6.15+
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patch.msgid.link/20260929094434.77129-5-jouni.hogander@intel.com
(cherry picked from commit 95ca8fab5232dfb7459989d54f09501704a8d7ad)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr_regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr_regs.h b/drivers/gpu/drm/i915/display/intel_psr_regs.h
index 16a9e3af198d0..428f3da045003 100644
--- a/drivers/gpu/drm/i915/display/intel_psr_regs.h
+++ b/drivers/gpu/drm/i915/display/intel_psr_regs.h
@@ -254,12 +254,12 @@
 #define _LNL_SFF_CTL_A				0x60918
 #define _LNL_SFF_CTL_B				0x61918
 #define LNL_SFF_CTL(tran)			_MMIO_TRANS(tran, _LNL_SFF_CTL_A, _LNL_SFF_CTL_B)
-#define  LNL_SFF_CTL_SF_SINGLE_FULL_FRAME	REG_BIT(1)
+#define  LNL_SFF_CTL_SF_SINGLE_FULL_FRAME	REG_BIT(0)
 
 #define _LNL_CFF_CTL_A				0x6091c
 #define _LNL_CFF_CTL_B				0x6191c
 #define LNL_CFF_CTL(tran)			_MMIO_TRANS(tran, _LNL_CFF_CTL_A, _LNL_CFF_CTL_B)
-#define  LNL_CFF_CTL_SF_CONTINUOUS_FULL_FRAME	REG_BIT(1)
+#define  LNL_CFF_CTL_SF_CONTINUOUS_FULL_FRAME	REG_BIT(0)
 
 /* PSR2 Early transport */
 #define _PIPE_SRCSZ_ERLY_TPT_A	0x70074
-- 
2.53.0



