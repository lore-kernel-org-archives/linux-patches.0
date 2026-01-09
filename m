Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F75133D511;
	Fri,  9 Jan 2026 12:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962479; cv=none; b=VA4UtQJBF2Ags/41F3dSP6Ws1aq5BF8hqDVZlNbGhNhZDhOIDhlpLE1uwNd7UrVKrLyNVtyqvODsiqfW/uU3jGv8mNZuZMdkPTEEnrBNiRsVO1bXIPxS+cfY5evdDsLJ7zwUtQe7u+ojIEfdk/4jIvCqymnPGHlQDhVpRpV7NR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962479; c=relaxed/simple;
	bh=rycpJ0GW5usSkrCp71t5EO8Co6hvOSujCBHdssEfYBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFcZlP6UdwFM4iV70TyZN+6S8CGoeXe1nmpZy+pHmOiprFHCRVEceFYbf74Ai/c4ZIeHEJmdMEUbxRfMQAkhaoaN3XXTfXdbC+lG197xeNJGlX+08l7zpyCJtSPcDGW07L0P/vf1VNDe94mjmALQszhwZkKicpsYGCMjGMQ14/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYLAUzvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYLAUzvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9142C4AF09;
	Fri,  9 Jan 2026 12:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962479;
	bh=rycpJ0GW5usSkrCp71t5EO8Co6hvOSujCBHdssEfYBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYLAUzvk+kPKRtAHNA7P26pbFIqKAjumcXP1JUPU+gtMrd1WG0MXNAdQTpDLbqF1p
	 haHqX2da6V8MEwRV2Snqjj87rnVokJxF8h3SPxpzy9+m89N9Mb0UmueEMJw+GIbrt0
	 ouz8OHgrLD8x/NPN1GyiZUskRWsSwwnb7b5Ynsb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 378/634] drm/amd/display: Use GFP_ATOMIC in dc_create_plane_state()
Date: Fri,  9 Jan 2026 12:40:56 +0100
Message-ID: <20260109112131.753047822@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 3c41114dcdabb7b25f5bc33273c6db9c7af7f4a7 upstream.

This can get called from an atomic context.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4470
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8acdad9344cc7b4e7bc01f0dfea80093eb3768db)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_surface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_surface.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_surface.c
@@ -104,7 +104,7 @@ void enable_surface_flip_reporting(struc
 struct dc_plane_state *dc_create_plane_state(struct dc *dc)
 {
 	struct dc_plane_state *plane_state = kvzalloc(sizeof(*plane_state),
-							GFP_KERNEL);
+							GFP_ATOMIC);
 
 	if (NULL == plane_state)
 		return NULL;


