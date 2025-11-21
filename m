Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A111F09B3;
	Fri, 21 Nov 2025 13:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731575; cv=none; b=BeF975wNdhS2tfYQuP++7iS3b5SXMee2NNnI12vhiCZIuf4SDR2LoWdJnbr2gEhw/ayC6lrAVhycTS1BK4nlewRBDIKyTPYR0Xx4CPI2LCsPqv0we533P90KVI+OWFvxvOfVEPFVWaxYNKTjOZcBNRubIokhUhomN2iCqVNIQn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731575; c=relaxed/simple;
	bh=Ij+RZncpriJJZhOX5SJY6UjQYdw2dZRz7kMkycz6FAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t38Q/XUmZeWaRUz0r+2uMRgpOxhm8Fa48nI9MCQ2GK7SpfiZlzm7TJEBs/WjIOWAROck29gxYYA0sWaS6HL2c4JzOO8WsZbOTGMyauv/OX83tuLTWDLYKIK8Mhs8sbvIN7cK1NpUAsExfXeImmpmA+24NqaP57v/RvGqQMk7HB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWAjvdr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWAjvdr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A562CC4CEF1;
	Fri, 21 Nov 2025 13:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731575;
	bh=Ij+RZncpriJJZhOX5SJY6UjQYdw2dZRz7kMkycz6FAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWAjvdr08XvUbgoDKjABNqdRm4N6pN2ELuMvMxa+NxrsQu6NO4xa+87ApgXS1pyuQ
	 IWdTV9T3q0BpdzBRNqTea+JHq75ZYVNSvRyqIuWoh7vvQUP40qHHROyWSO6tGDKiO+
	 hIce1TpRiQb4KPyqnYPu0ZpP1awbHBLchVDItf4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.17 224/247] drm/xe/xe3: Extend wa_14023061436
Date: Fri, 21 Nov 2025 14:12:51 +0100
Message-ID: <20251121130202.773632377@linuxfoundation.org>
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

From: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>

commit fa3376319b83ba8b7fd55f2c1a268dcbf9d6eedc upstream.

Extend wa_14023061436 to Graphics Versions 30.03, 30.04
and 30.05.

Signed-off-by: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patch.msgid.link/20251030154626.3124565-1-tilak.tirumalesh.tangudu@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 0dd656d06f50ae4cedf160634cf13fd9e0944cf7)
Cc: stable@vger.kernel.org # v6.17+
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_wa.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -653,6 +653,8 @@ static const struct xe_rtp_entry_sr engi
 	},
 	{ XE_RTP_NAME("14023061436"),
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(3000, 3001),
+		       FUNC(xe_rtp_match_first_render_or_compute), OR,
+		       GRAPHICS_VERSION_RANGE(3003, 3005),
 		       FUNC(xe_rtp_match_first_render_or_compute)),
 	  XE_RTP_ACTIONS(SET(TDL_CHICKEN, QID_WAIT_FOR_THREAD_NOT_RUN_DISABLE))
 	},


