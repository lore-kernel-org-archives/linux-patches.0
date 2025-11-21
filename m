Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080B2331237;
	Fri, 21 Nov 2025 13:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731486; cv=none; b=Ib/tN8J521JL4KksBEo2fpIep7oB1BBFe1Sx20CXe2DgsagqkMWngm/y1PQBgY+Z5wTYms39D2vVLTrLlhLgsDB8tOqMggYIbioAAzJ2LYsymeGvVyW5I9PSxXESI63VBF8Fd6s3MxxiE7RJLwbzqRuTlXG6ZqoBGGb+bTXZYk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731486; c=relaxed/simple;
	bh=isgJrila3uJIFWrzNT1pk2v0CbuDyQZCpMk77CPLYaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZORYQ+J9/TFoIfcB/SX6eUb0F6vdQxNdKmnwrPy9kQg9bpPd/w4Bi4riWLU90e7c2bc58/mSfC+y/S8I6ygKUp5+IL4WxqxWHREDIg6WWMISTihPX4w4GTdtF8LAegKpvXTzEP8Y2b+4qQyBkkFKx0AR2weGaXnEEI1ObAe+R2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9VRvEhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9VRvEhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B08C4CEF1;
	Fri, 21 Nov 2025 13:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731485;
	bh=isgJrila3uJIFWrzNT1pk2v0CbuDyQZCpMk77CPLYaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9VRvEhdz10Zwtenyz22e2bG337QDNfL/rALXr9Kk+eabw+dTOLQnFaaWghhf4rZZ
	 mXGe8TXucj5sh2K6+Fw4Y/ibdgznRJFkZ8T0kKvbX3rG2jmtXcYRPy461DY+ZmR1uV
	 PjYS2T4bLfxtAudy8TQuK5eXR3L+bADha/6pTGiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Gote <nitin.r.gote@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.17 223/247] drm/xe/xe3lpg: Extend Wa_15016589081 for xe3lpg
Date: Fri, 21 Nov 2025 14:12:50 +0100
Message-ID: <20251121130202.737419108@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitin Gote <nitin.r.gote@intel.com>

commit 240372edaf854c9136f5ead45f2d8cd9496a9cb3 upstream.

Wa_15016589081 applies to Xe3_LPG renderCS

Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
Link: https://patch.msgid.link/20251106100516.318863-2-nitin.r.gote@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 715974499a2199bd199fb4630501f55545342ea4)
Cc: stable@vger.kernel.org # v6.16+
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_wa.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -883,6 +883,11 @@ static const struct xe_rtp_entry_sr lrc_
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(3000, 3003), ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(COMMON_SLICE_CHICKEN4, SBE_PUSH_CONSTANT_BEHIND_FIX_ENABLE))
 	},
+	{ XE_RTP_NAME("15016589081"),
+	  XE_RTP_RULES(GRAPHICS_VERSION(3000), GRAPHICS_STEP(A0, B0),
+		       ENGINE_CLASS(RENDER)),
+	  XE_RTP_ACTIONS(SET(CHICKEN_RASTER_1, DIS_CLIP_NEGATIVE_BOUNDING_BOX))
+	},
 };
 
 static __maybe_unused const struct xe_rtp_entry oob_was[] = {


