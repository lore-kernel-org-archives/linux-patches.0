Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774763;
	b=Tg6ZNpDfNnVHC5qxahGCx/8xf/cjs3DTL+uan0iMzy4q6xhBsB/ifTJ/UKrL/KGs7ldm
	 lz4rh4vwvdQVCbkQgz6UiIfNa5spZVfMOFXxCBxj3i1wsVeILnKB9PhaTEAKd6AAPx5i/
	 lk1crw2PiPxyO1u/WazgNYBzwwr0MB9UHVzDUbatRwyuEhbwQXQYpnuiEev5pudAEftFp
	 4B0DzKbi7oAY/DchtknxKxJ5nBFSQGVHWOsgZXwAwKfFGTMWXoNRIMRBakrPha5cEMir4
	 wDEop6FbKZJZ2ADNPWN7nLwHpNjEHl8qYe7x1sg1hbvR9jLl9mPlXEhgLqqUkGZ72zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BUkiwHw1u/YKa9MgOqHaXQ0cm+IFMcZv7WnH7dirz7M=;
	b=MucJEzYHU7/+a9iykXV91MfAjyaINT+NtQ1Tmk5LF/nUH+jcv4Va3uqiqbT43A7gw+0O
	 pXHjjrlx+jyVvFvABsLOnZlY3T7X5ViFr6XCSxD+LISXRd+tMYb3KeVqFf6E5ohiQctuZ
	 f8m46adNX7QNuOyZbhcX9DVrFf0GxJ15vjtTQpTbm8jh543MRpIBnUbV7o+E3GUg3XfIV
	 XcfHWiwRQSHeZp7Xe40aFs1JJLFPBYuV4IshrJFY7Y0M+fjX6Ptd32h1AKlIpcHGd78uG
	 uAtbupgErIZaGJelk3bacVWelBpGNQ5mOGfVDpKiSLKFDKQsx7K4zgBVCUZxZSNMP7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ew80oGbF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB431606A31A;
	Fri, 23 Oct 2026 16:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ew80oGbF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320E01F01825;
	Fri, 23 Oct 2026 16:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774762;
	bh=BUkiwHw1u/YKa9MgOqHaXQ0cm+IFMcZv7WnH7dirz7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ew80oGbFSEOx4KxeWKEruY5GRLJN8BPbtaRFzhX+TEiVs1h42yp8xu327pDeTfBMQ
	 o/iht6TByPQvbC4uMUwqi/rAdTMndpibdCG+KCpEHgY66a9hZDfqITP2U6a5g+h8XM
	 +PpNNYIixmMGh/FAkTENFcofcTSO94PKtBg2/U7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Dominik Kaszewski <dominik.kaszewski@amd.com>,
	George Zhang <george.zhang@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 150/242] drm/amd/display: Fix NULL sink dereference in USB4 bandwidth functions
Date: Fri, 23 Oct 2026 18:39:52 +0200
Message-ID: <20261023163717.330117015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit 55a67aa89342545b89f469dea6f29bfb6fac6f3d upstream.

allocate_usb4_bandwidth_for_stream() and allocate_usb4_bandwidth() both
use ASSERT(stream->sink) before dereferencing stream->sink->link. ASSERT
is compiled out in production builds, so a NULL stream->sink causes a
NULL pointer dereference.

link_set_dpms_off() already guards two earlier accesses to stream->sink
with explicit NULL checks, confirming that stream->sink can legitimately
be NULL. The subsequent call to deallocate_usb4_bandwidth() had no
equivalent guard.

Replace the ASSERT() calls with proper NULL checks that return false
early, and add a matching stream->sink guard at the call site in
link_set_dpms_off() consistent with the surrounding pattern.

v2: Keep the existing ASSERT() calls for diagnostics (to report
    unexpected NULL sink), and add explicit NULL checks that return false
    before dereferencing stream->sink. Also add a matching stream->sink
    guard at the deallocation call site in link_set_dpms_off(). (Alex)

Fixes: 8fa813b7fd1e ("drm/amd/display: Remove sink usage from DPMS")
Reported-by: Dan Carpenter <error27@gmail.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Cc: Dominik Kaszewski <dominik.kaszewski@amd.com>
Cc: George Zhang <george.zhang@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Roman Li <Roman.Li@amd.com>
Cc: Ivan Lipski <ivan.lipski@amd.com>
Cc: Dan Wheeler <daniel.wheeler@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 98029a0ce61feb52c563f65349dd9b25f672e355)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -2298,9 +2298,14 @@ static bool allocate_usb4_bandwidth_for_
 {
 	ASSERT(stream->sink);
 
-	struct dc_link *link = stream->sink->link;
+	struct dc_link *link;
 	int req_bw = stream_bw;
 
+	if (!stream->sink)
+		return false;
+
+	link = stream->sink->link;
+
 	DC_LOGGER_INIT(link->ctx->logger);
 
 	if (!link->dpia_bw_alloc_config.bw_alloc_enabled)
@@ -2347,9 +2352,13 @@ static bool allocate_usb4_bandwidth(stru
 	ASSERT(stream->sink);
 
 	bool ret;
+	int bw;
+
+	if (!stream->sink)
+		return false;
 
-	int bw = dc_bandwidth_in_kbps_from_timing(&stream->timing,
-			dc_link_get_highest_encoding_format(stream->sink->link));
+	bw = dc_bandwidth_in_kbps_from_timing(&stream->timing,
+					      dc_link_get_highest_encoding_format(stream->sink->link));
 
 	ret = allocate_usb4_bandwidth_for_stream(stream, bw);
 
@@ -2410,7 +2419,8 @@ void link_set_dpms_off(struct pipe_ctx *
 	update_psp_stream_config(pipe_ctx, true);
 	dc->hwss.blank_stream(pipe_ctx);
 
-	if (pipe_ctx->link_config.dp_tunnel_settings.should_use_dp_bw_allocation)
+	if (pipe_ctx->link_config.dp_tunnel_settings.should_use_dp_bw_allocation &&
+	    stream->sink)
 		deallocate_usb4_bandwidth(stream);
 
 	if (stream->signal == SIGNAL_TYPE_DISPLAY_PORT_MST)


