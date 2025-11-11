Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AFD3081CD;
	Tue, 11 Nov 2025 01:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825566; cv=none; b=B7T1uIGcbLBlAaVvlku/SCWHGfoKQAFUePOGCi8YRsANEBXXdX06MKromfv3miEbp03Ioprd9X5CM0o7a3N+N8X0xkunyjFcWeITVrdhzNHJKQsqNrfIryXfROL7QDTCaUo4q1shxSx65XMKv6ccMhwvdlSe4c0sy8T6KpGRCT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825566; c=relaxed/simple;
	bh=IlZ/wUW6qedHS68arpkeMRJR/KC7r9S/e7y80S3Lz/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pSy72FIt/Gx4vYlCyWLql6L3oY8F20r9nob88T7pqpKRFocMe/IH77trZltB/bCbOitH1gemuEtsoYCub3qqBVpiynn3kHWylU7GGpHTnonoTBZghkHD85NPvSsi5b0Ykynti347hUCEaphv9tfX8FIEq0cb2roqYPmLxuVGs1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPdewllW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPdewllW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89ADC113D0;
	Tue, 11 Nov 2025 01:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825566;
	bh=IlZ/wUW6qedHS68arpkeMRJR/KC7r9S/e7y80S3Lz/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPdewllWDit5QTe15N69VT1+1h+F3oHawx42qjn5xscPbviKWcUDvdW7HwBEiL5e3
	 rxcigh+4CjM8TS7YcOBgTJaaK2MwmWjgFlxX3MZ+o5N5VecR9bUHEY8MZUmS3GZ+Ru
	 xfO2UfaMaYm2qRxlCldPECE7ySlveBlwBLmmdZrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.17 848/849] drm/amd/display: Fix black screen with HDMI outputs
Date: Tue, 11 Nov 2025 09:46:58 +0900
Message-ID: <20251111004556.920246756@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

commit fdc93beeadc2439e5e85d056a8fe681dcced09da upstream.

[Why & How]
This fixes the black screen issue on certain APUs with HDMI,
accompanied by the following messages:

amdgpu 0000:c4:00.0: amdgpu: [drm] Failed to setup vendor info
                     frame on connector DP-1: -22
amdgpu 0000:c4:00.0: [drm] Cannot find any crtc or sizes [drm]
                     Cannot find any crtc or sizes

Fixes: 489f0f600ce2 ("drm/amd/display: Fix DVI-D/HDMI adapters")
Suggested-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 678c901443a6d2e909e3b51331a20f9d8f84ce82)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_detection.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/dc/link/link_detection.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_detection.c
@@ -1141,6 +1141,7 @@ static bool detect_link_and_local_sink(s
 		    !sink->edid_caps.edid_hdmi)
 			sink->sink_signal = SIGNAL_TYPE_DVI_SINGLE_LINK;
 		else if (dc_is_dvi_signal(sink->sink_signal) &&
+			 dc_is_dvi_signal(link->connector_signal) &&
 			 aud_support->hdmi_audio_native &&
 			 sink->edid_caps.edid_hdmi)
 			sink->sink_signal = SIGNAL_TYPE_HDMI_TYPE_A;


