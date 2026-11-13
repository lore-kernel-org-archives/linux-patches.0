Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585476;
	b=HxQRlNN+0S+7ztN1tXjqzi7zBJ9/J3IGjK7Tkw08wOF3VyAmX0AHPGmROIWYmd649h/X
	 u4lVe79XmXfOPaydYjVaDk0ahI18RUANmX3YmlGJ+znrzYU49Ta5JKRlqQFetb/ww+ahs
	 CyT9mI5YTnIk2/GMaj+5D2mtIGBvY0FrAfSb5jBHxmPbr+b/whLeQQLYtNCQXacTLqH0f
	 wC94hNTACRE3ggWrKUjKL6GAfNc96uc9SXjlbiIet4BoLARmBlpylARU5fh2RbgPN2v0j
	 E0hB0oIeWxv6zuEvQ8N1MmgRq6B+7ULsg9gJRHhw0qYuZEfw4xbo/f+liHaWcLFce6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zx5cdQJnxuXUGCjfZyyxYdPGNEJVMEr6Ds7pFkPRNiw=;
	b=4iE4nY5ubgbvpJ9G0ROp69Lr1BOpgLwY4KKnnrAsDiEubs5JQUq7sBs3195Xbacy7TjP
	 R60Wa6Ov4SMl+Z4f98GAmHqrziODGBzYEyEyNyKpQbjFHjOwTEXFrK66MOTF/j3my8seR
	 p6FjdgCKXfSMKnmW6G7ONwiYdyxyk10IymauEQSxz/tbuppERF5YUT7/PyXriJdIYMJny
	 10V+KrCAddueia3FWPyGrr/2VHJ3Q6SVJRgsTu4EsqUednDoRwCtullXg+Uo2ShNrZNcM
	 Wyx0BpZfTNkZnY3KF/6ZPOkzGNcobfnvFEWKiqfMWEOKQc/7nqMXXhzNf1SURjV7bmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S9g6zbGH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0CF606EB94;
	Fri, 13 Nov 2026 15:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S9g6zbGH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9591F000C4;
	Fri, 13 Nov 2026 15:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585476;
	bh=zx5cdQJnxuXUGCjfZyyxYdPGNEJVMEr6Ds7pFkPRNiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9g6zbGHbcSMOFWTMp4/tKi58G2uVUxeWx03yE3VPk+IFZARZpy4wzdPLBsuHTpIA
	 HtzEAEIzGtlC5bUH/LYFFi1xEEQTSv9ktKaYNocXcve1lWLigmXoCu3DnfBzCB2x2c
	 uQqzptzXG5r3e8QRFhqZLUaR3eMGnLt9cGUcolhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 128/507] drm/i915/display: Allow port sync on PTL
Date: Fri, 13 Nov 2026 10:47:12 -0500
Message-ID: <20261113153758.789477237@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>

[ Upstream commit 285300ef89aacbe902ba29c91625975f51345217 ]

Some dual-SST tiled displays exhibit visual corruption on PTL, with
one tile's image vertically shifted or wrapped by a random amount
that changes on every hotplug.

PTL supports port sync, so allow it to be used to avoid these
display issues.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/8991
Fixes: 05cffc074938 ("drm/i915/display: Implement Wa_16024710867")
Cc: stable@vger.kernel.org
Signed-off-by: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20261012040402.3332398-1-mitulkumar.ajitkumar.golani@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 7b308d9d496dd3bbe2fdd09d4e9d32499f2a1a0b)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_ddi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 02a53c9848e13..8de6e13cf2dde 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -4594,7 +4594,7 @@ intel_ddi_port_sync_transcoders(const struct intel_crtc_state *ref_crtc_state,
 	 * From, xe3lpd onwards we have defeatured this with reference to
 	 * Wa_16024710867
 	 */
-	if (!IS_DISPLAY_VER(display, 9, 20))
+	if (!IS_DISPLAY_VER(display, 9, 30))
 		return 0;
 
 	if (!intel_crtc_has_type(ref_crtc_state, INTEL_OUTPUT_DP))
-- 
2.53.0



