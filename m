Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059680;
	b=4TkEivzJoZY/Jq+x26NuW0Gf/6MzV5HUTZeg9fPnuIwyXUFl7Waeletqc/9Wyy81z8rl
	 IzTAg7krHDaufCwMKT2d4DT1D2bhFII8QCFsNozzIwpWC5D28HKnOls5Xj4j8eYnPLOLf
	 8EzxSgEDMPwpZv1xvSwdRsw9q4XhTEpmlCnjhqHI+dohm7jbQeH8aXzdSYPao27M9dJkb
	 44LHK8vD9zb4R3xQ1Y4OXyZqyiHobjZv4fBy9/8Z+oNTEx2nSW9TNf8W2GOgxp3lO9KyN
	 eRwxHPb8dycOY0zGpUBUhk/iq1aTwyV3GwGcALyz/Bk2tFYdzrGpmdd8qm3MoAq8Jtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0wveX49ckt5/7AEwcAUGuQL1HZ27+hSa5rxIW3MRUvw=;
	b=ShsyNmZL+pxobBVo2sHC1pc7vpisl7zCdaYJh6Epox9QXWV7izBnkg8q+SFb4G6KeK8Q
	 J0J3Bli7u3yXrSxnP+a5OyJDwi1gxgU3svw1+BapJEsD29Dj4g3PsK25szkIP7n2yTz1s
	 kWGrXWoIHKsbDH4FJZOslP4wkQzsJAHa01xOQ8bx/5vu/4wbPvQdT7MNJ02cgJkytVG1x
	 pEl1O30FWGXVFznxQHpMNy6RiqZyRMAGVJCfXTtyTBaf+ymHN4da6Y8UTLMtVEOnmnade
	 1szWDXwYNRtZbl1X7suiZU34fTlq3gouwm3RF9QxKLn2bF5zPBawAPcbSIvNjib4NRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QFw7sCak;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C412E606A32A;
	Thu, 19 Nov 2026 03:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QFw7sCak
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256051F000C4;
	Thu, 19 Nov 2026 03:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059680;
	bh=0wveX49ckt5/7AEwcAUGuQL1HZ27+hSa5rxIW3MRUvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFw7sCakTlFtR9wCv3YqBcH8fGrBG6h2tL+JAyBxtQq+Tm8l+SaP78DmADD7f2H/r
	 8Huw0QlDT7tfQ9Rpl1KytItDa01hbmQ1UQ9hufZR0d5YuWa/Mt7/sMqT0nO/eN+3It
	 0hfZfxONsz4fzj8ZsdTflGCBMbEZE/twCQeNv62A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Luigi Lauro <luigi.lauro@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0926/1848] drm/amd/display: take a runtime PM reference only when a CRTC turns on
Date: Wed, 18 Nov 2026 15:49:24 +0100
Message-ID: <20261118145955.552823415@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luigi Lauro <luigi.lauro@gmail.com>

[ Upstream commit b456f591f925fbd6b33770d0eec1b51c2f9d41c1 ]

amdgpu_dm_commit_streams() takes a runtime PM reference for every
active CRTC that needs a modeset and has a new stream, but
amdgpu_dm_atomic_commit_tail() drops one only for each CRTC that goes
from active to inactive. A modeset of a CRTC that is already active (a
mode change, or anything else that needs a full modeset) therefore
leaks one reference. Once that has happened, the usage count no longer
returns to zero with every CRTC off, and the device cannot runtime
suspend again until reboot. The two also disagree the other way when a
CRTC turns on without a stream ("Failed to create new stream"): no
reference is taken, but one is dropped when it turns off.

Take the reference in the loop that counts the disabled CRTCs, on the
mirror condition: when the CRTC goes from inactive to active, which is
what the commit that added it intended ("every time we enable a
previously disabled CRTC"). Each active CRTC then holds exactly one
reference.

Tested on an RX 9070 XT (Navi 48) over OCuLink, with the change
backported to 7.2.9: an unplugged connector forced on, then mode A on a
CRTC, mode B on the same active CRTC, and the CRTC off, three rounds in
a row. The usage count rose by 3 with the stock module, by 0 with this
patch, and by 3 again after reloading the stock module.

Fixes: 97028037a38a ("drm/amdgpu: Grab/put runtime PM references in atomic_commit_tail()")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/5951
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luigi Lauro <luigi.lauro@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 59ef9a435499777b8e1c4e0eff52f813c64fb920)
Cc: stable@vger.kernel.org
[ sashal: adapted the patch to the separate PM-accounting loop in amdgpu_dm_atomic_commit_tail() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 3b37aca3781e4..43ad2fa2bafdb 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7825,8 +7825,6 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 			if (dm_old_crtc_state->stream)
 				remove_stream(adev, acrtc, dm_old_crtc_state->stream);
 
-			pm_runtime_get_noresume(dev->dev);
-
 			acrtc->enabled = true;
 			acrtc->hw_mode = new_crtc_state->mode;
 			crtc->hwmode = new_crtc_state->mode;
@@ -7979,10 +7977,15 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 		mutex_unlock(&dm->dc_lock);
 	}
 
-	/* Count number of newly disabled CRTCs for dropping PM refs later. */
 	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state,
 				      new_crtc_state, i) {
-		if (old_crtc_state->active && !new_crtc_state->active)
+		/*
+		 * One runtime PM reference per active CRTC: take it when the
+		 * CRTC turns on, count it when it turns off for dropping later.
+		 */
+		if (!old_crtc_state->active && new_crtc_state->active)
+			pm_runtime_get_noresume(dev->dev);
+		else if (old_crtc_state->active && !new_crtc_state->active)
 			crtc_disable_count++;
 
 		dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
-- 
2.53.0



