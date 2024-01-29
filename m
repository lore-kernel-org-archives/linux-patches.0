Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E8376043;
	Mon, 29 Jan 2024 17:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548623; cv=none; b=iZ9fBZtA3t0UxLWBk0if+5FGAe1G6WXLNH02OHFgTRilggZe2uPmoWPtBN47cPmTH9NV81ZuqCQA1sQU9AnxWQijD3ZwNPVRo1xaXx3ylUppe2FzldIikPCeVu5kt+e/JR/H0ZxLFESv+R/E7zTl/dzPf/akuBFh05b9gtcq/Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548623; c=relaxed/simple;
	bh=YGYTjUjs3lANfHAI2Jjo/4DDpeVF5sONeWhM8ksO3es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OLbyKhtv55xNiGcjDolXahaEsYEceyx1urSdrrgj7zWyTyTP0NbJJ8Lxoaj7ckiaty/dP7yKm5vh1n580PPY+0aHrrw26uuf+mVDomHdpGkq1OBH9LhQxAb40LvblFiu0BskYRW0+XOv3Kvz2dj12HA1kAsRYeRPMAvJPwl7Reg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9nEVoi/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9nEVoi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C19FC43390;
	Mon, 29 Jan 2024 17:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548623;
	bh=YGYTjUjs3lANfHAI2Jjo/4DDpeVF5sONeWhM8ksO3es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9nEVoi/kdf6LP3wcL/QpY87jSouRtkI9XkQdDa+4L1BRGoUvxG6cKZucjNuspt1g
	 Ti/mrR/hD9Ffj9IyIzZcuE3EbgQJlkWblVkNLbRCmaO9bDeRh4WRoJ/ueU8wKVo489
	 St6JrVCFNTJsbU/OqaxiYkiSgMeGJ3/p66F5M30M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Kahola <mika.kahola@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 293/331] drm/i915/lnl: Remove watchdog timers for PSR
Date: Mon, 29 Jan 2024 09:05:57 -0800
Message-ID: <20240129170023.435920858@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Kahola <mika.kahola@intel.com>

[ Upstream commit a2cd15c2411624a7a97bad60d98d7e0a1e5002a6 ]

Watchdog timers for Lunarlake HW were removed for PSR/PSR2
The patch removes the use of these timers from the driver code.

BSpec: 69895

v2: Reword commit message (Ville)
    Drop HPD mask from LNL (Ville)
    Revise masking logic (Jouni)
v3: Revise commit message (Ville)
    Revert HPD mask removal as irrelevant for this patch (Ville)

Signed-off-by: Mika Kahola <mika.kahola@intel.com>
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231010095233.590613-1-mika.kahola@intel.com
Stable-dep-of: f9f031dd21a7 ("drm/i915/psr: Only allow PSR in LPSP mode on HSW non-ULT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 97d5eef10130..848ac483259b 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -674,7 +674,9 @@ static void hsw_activate_psr1(struct intel_dp *intel_dp)
 
 	val |= EDP_PSR_IDLE_FRAMES(psr_compute_idle_frames(intel_dp));
 
-	val |= EDP_PSR_MAX_SLEEP_TIME(max_sleep_time);
+	if (DISPLAY_VER(dev_priv) < 20)
+		val |= EDP_PSR_MAX_SLEEP_TIME(max_sleep_time);
+
 	if (IS_HASWELL(dev_priv))
 		val |= EDP_PSR_MIN_LINK_ENTRY_TIME_8_LINES;
 
@@ -1399,8 +1401,10 @@ static void intel_psr_enable_source(struct intel_dp *intel_dp,
 	 */
 	mask = EDP_PSR_DEBUG_MASK_MEMUP |
 	       EDP_PSR_DEBUG_MASK_HPD |
-	       EDP_PSR_DEBUG_MASK_LPSP |
-	       EDP_PSR_DEBUG_MASK_MAX_SLEEP;
+	       EDP_PSR_DEBUG_MASK_LPSP;
+
+	if (DISPLAY_VER(dev_priv) < 20)
+		mask |= EDP_PSR_DEBUG_MASK_MAX_SLEEP;
 
 	/*
 	 * No separate pipe reg write mask on hsw/bdw, so have to unmask all
-- 
2.43.0



