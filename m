Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044139;
	b=YhTV+PiKIDHeAPSNFkhw4X6FgmtCMwt0JIfEpJ6NLJd6ScmQyhZjK7MbFd59eUKDiJVy
	 llFutVeXkgg7cF5n75c3vToIYDTkgzGaTkjsNAxJWCdJwkXO/g3sqGybfXkSPqLtjfyp2
	 iEOp8b8NLOoDUiPu6VBwu6mHqQmJXoSwOBUcMMQCw/TxSDGJP6G1dziXpiI9LYoK6GXNq
	 X4j754j+3UMXjXc2STa7BSQ6hmHStpL7n4nXQoRm/EahvfXrnkfwbD6FHG/xY7POGvxLZ
	 peN24rrBXWY0YyluUKT2M8Co4WO/kwdd+6cLw+yifPmIqlHN4I7+pt0YlGqBCpBRXfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Thd7qOfN7AXET4diXzdBYa45Il7Trj++W/vsBTGUFVA=;
	b=z1gPgQhRP9NOdWUOcBKdp6M3EP3PQf25OeyFMlu6chBUp6FwEI3sgoO3PNu1AXc5C5UT
	 iO7NbA4T++87jGiyhy8coI9B3QxadhtpIwdoBmGKlThg+EJQ3rETUVgpF7IPQEAnYxw7i
	 jwVkz9GMBUy9CABQK9WnLMIi2A0CoM2gZMpcknTOFi08y40sVLq4uguVFPGxrkK9MwV5n
	 vYuBGv14qtp5WgBDWN+iWOZh+s7Q/jr9fNgwt2HW/C38ZvHhGU0zdhC6diUg36flwSb+u
	 p2jVfX0qppF4iGBKg0DyCyUvJ0lqeLG69VhGd347C0ahq8uVF89DZe7k4WZPxbH5T2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qpwEdRCj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939FA606A320;
	Wed, 18 Nov 2026 23:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qpwEdRCj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B658D1F000C4;
	Wed, 18 Nov 2026 23:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044139;
	bh=Thd7qOfN7AXET4diXzdBYa45Il7Trj++W/vsBTGUFVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qpwEdRCjcyN1w6ATaPKPBvcSiQn3MemAQ1W7+wu/zMFpVEs8qEyIbHX+ODgXZOnZS
	 hCz1ovNjvuLDjPEtZKtbLMsrZumO0hpFwY28m6OLWOuMZtgDDJ0D9YxUNKwnQ8WF/j
	 ouWq0ZzcrEZ/AkmHD8Q1xp8oIaocqq/6EiCf51i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0459/2857] drm/amd/display: Fix dc stream excess put in dm_update_crtc_state()
Date: Wed, 18 Nov 2026 15:24:53 +0100
Message-ID: <20261118150217.947282174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit c5fd4eaad50d620c7e09ac2082b2fb55ee54170e ]

In dm_update_crtc_state(), when a modeset is required the newly created
stream is stored in dm_new_crtc_state->stream and an extra reference is
taken with dc_stream_retain().  The reference returned by
create_validate_stream_for_sink() is released as an extra reference at
the skip_modeset label, leaving the stream owned by the new CRTC state.

If amdgpu_dm_check_crtc_color_mgmt() fails afterwards, the code jumps
to the fail label which releases new_stream again.  Since the extra
reference was already released at skip_modeset, this drops the
reference owned by dm_new_crtc_state->stream and the stream is
released while the atomic state still points to it, leading to a
premature free of the dc stream.

Set new_stream to NULL after releasing the extra reference at the
skip_modeset label so that a later goto fail cannot release the
reference owned by the new CRTC state.

Fixes: 7cd4b70091a5 ("drm/amd/display: Rework CRTC color management")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 102a47065a62dc8f6bbbb47cf082a2934282eb08)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 2aec7ddd5a725..561cfbc591f93 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9302,8 +9302,10 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 
 skip_modeset:
 	/* Release extra reference */
-	if (new_stream)
+	if (new_stream) {
 		dc_stream_release(new_stream);
+		new_stream = NULL;
+	}
 	new_stream = NULL;
 
 	/*
-- 
2.53.0



