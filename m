Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016298;
	b=SSCkNzGcghwyevl8jHzC6dfVZ4/gWfxx4xe22gLMOwGVumqtYeNiH5/5w/L6h70JT3yR
	 EuQYNJZbBKQgpInfQCXHrKWXM05Hg0fM0jfsQizuFmKE65mg1R2SqqFEunW60/cBOI1pf
	 AfHildU7Q2vSnFvI8tQMUfZxgQVQYjtqiLv4wYgf+W9Z5QAdoT4/xMb5Lfh4gZ+OdbR2J
	 0H0MxAAQ0sg3LQHaL0cfKDvjDBKCKdCbwSdt++/ieGTc+vn52LQi4aUEPB07VyqY20DMx
	 O8NGSyJMKclXB80gmWEvBCB212pcWBMmwKwMzShFK80OVKKBwLoGus5EYge+yQt69mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=io6IlTdewX0d5XYp/8RRErPo2VXk3YEnE9k+au3zDhY=;
	b=cMDVPI3nYuGYdzRfUNvBnQ0bK5sR/ibGIXgY3Dzikt+lnrj8cfCCPnT7BlQG7o81w30c
	 m6V9GZrjLh2nbb95cHnhM6yQ7tg6O3DIv5OEMpxy+OzlJ7KBMSMhTfY9giLgKVNV2wPj3
	 HcM3qYZkZNi7+J6ht29MFRO98n4OIfFy7MCMxxO+ZOR7qKr1Ec35tGY5FKZsLIpvXUUuh
	 yOVQArOgsqyAbdZzKLDaI/fvgviFfbN1PlmE8HrdOOL+NvgYkls6XCbc3UbkJERgww0O8
	 iRlAT0pIpd8L3xuKrzTOLcagmTPqG1WO1kbUy9JWSaWhZB6PPnh2LKoEl19gtquMLMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IlFvLN6S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5215560A260F;
	Wed, 18 Nov 2026 15:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IlFvLN6S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E02C1F000C9;
	Wed, 18 Nov 2026 15:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016297;
	bh=io6IlTdewX0d5XYp/8RRErPo2VXk3YEnE9k+au3zDhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IlFvLN6SLQZXSIli8t/7rBg8HbdinDRZccjuEA4WcNZN5C44BaVUG/3s+Q2mYMmNB
	 6sCpWDCh9vVf45Wftq541h7PgK9CoMDcRiUxxObW3KeBmfBtJgkWJI+cg6nqlQE3cT
	 jtuPzefM0LJb87Io6ITxfE+KenfOOYsQll1eFD4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0480/2651] drm/tests: hdmi: fix infoframes tests
Date: Wed, 18 Nov 2026 15:28:40 +0100
Message-ID: <20261118150305.060811975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Mika Penttilä <mpenttil@redhat.com>

[ Upstream commit d5c34a384305e05a2d463dd2094e0ec449643bd4 ]

drm_atomic_commit() calls drm_atomic_check_only() internally. Calling
drm_atomic_check_only() explicitly before the commit leaves the state
marked as checked and triggers drm_WARN_ON(state->checked) when the
commit checks the state again.

Remove the redundant explicit checks.

Fixes: 7436a87db99d ("drm/tests: hdmi: check the infoframes behaviour")
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
Link: https://patch.msgid.link/20260914040723.2593700-1-mpenttil@redhat.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/tests/drm_hdmi_state_helper_test.c    | 54 -------------------
 1 file changed, 54 deletions(-)

diff --git a/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c b/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
index 353a261d42dac..f8ae1a0bd5c01 100644
--- a/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
+++ b/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
@@ -2929,15 +2929,6 @@ static void drm_test_check_infoframes(struct kunit *test)
 
 	old_hdmi_update_failures = priv->hdmi_update_failures;
 
-	ret = drm_atomic_check_only(state);
-	if (ret == -EDEADLK) {
-		drm_atomic_commit_clear(state);
-		ret = drm_modeset_backoff(&ctx);
-		if (!ret)
-			goto retry_crtc_state;
-	}
-	KUNIT_ASSERT_EQ(test, ret, 0);
-
 	ret = drm_atomic_commit(state);
 	if (ret == -EDEADLK) {
 		drm_atomic_commit_clear(state);
@@ -3034,15 +3025,6 @@ static void drm_test_check_reject_avi_infoframe(struct kunit *test)
 
 	old_hdmi_update_failures = priv->hdmi_update_failures;
 
-	ret = drm_atomic_check_only(state);
-	if (ret == -EDEADLK) {
-		drm_atomic_commit_clear(state);
-		ret = drm_modeset_backoff(&ctx);
-		if (!ret)
-			goto retry_crtc_state;
-	}
-	KUNIT_ASSERT_EQ(test, ret, 0);
-
 	ret = drm_atomic_commit(state);
 	if (ret == -EDEADLK) {
 		drm_atomic_commit_clear(state);
@@ -3153,15 +3135,6 @@ static void drm_test_check_reject_hdr_infoframe_bpc_8(struct kunit *test)
 
 	old_hdmi_update_failures = priv->hdmi_update_failures;
 
-	ret = drm_atomic_check_only(state);
-	if (ret == -EDEADLK) {
-		drm_atomic_commit_clear(state);
-		ret = drm_modeset_backoff(&ctx);
-		if (!ret)
-			goto retry_conn_state;
-	}
-	KUNIT_ASSERT_EQ(test, ret, 0);
-
 	ret = drm_atomic_commit(state);
 	if (ret == -EDEADLK) {
 		drm_atomic_commit_clear(state);
@@ -3276,15 +3249,6 @@ static void drm_test_check_reject_hdr_infoframe_bpc_10(struct kunit *test)
 
 	old_hdmi_update_failures = priv->hdmi_update_failures;
 
-	ret = drm_atomic_check_only(state);
-	if (ret == -EDEADLK) {
-		drm_atomic_commit_clear(state);
-		ret = drm_modeset_backoff(&ctx);
-		if (!ret)
-			goto retry_conn_state;
-	}
-	KUNIT_ASSERT_EQ(test, ret, 0);
-
 	ret = drm_atomic_commit(state);
 	if (ret == -EDEADLK) {
 		drm_atomic_commit_clear(state);
@@ -3387,15 +3351,6 @@ static void drm_test_check_reject_audio_infoframe(struct kunit *test)
 
 	old_hdmi_update_failures = priv->hdmi_update_failures;
 
-	ret = drm_atomic_check_only(state);
-	if (ret == -EDEADLK) {
-		drm_atomic_commit_clear(state);
-		ret = drm_modeset_backoff(&ctx);
-		if (!ret)
-			goto retry_crtc_state;
-	}
-	KUNIT_ASSERT_EQ(test, ret, 0);
-
 	ret = drm_atomic_commit(state);
 	if (ret == -EDEADLK) {
 		drm_atomic_commit_clear(state);
@@ -3438,15 +3393,6 @@ static void drm_test_check_reject_audio_infoframe(struct kunit *test)
 
 	old_hdmi_update_failures = priv->hdmi_update_failures;
 
-	ret = drm_atomic_check_only(state);
-	if (ret == -EDEADLK) {
-		drm_atomic_commit_clear(state);
-		ret = drm_modeset_backoff(&ctx);
-		if (!ret)
-			goto retry_crtc_state_2;
-	}
-	KUNIT_ASSERT_EQ(test, ret, 0);
-
 	ret = drm_atomic_commit(state);
 	if (ret == -EDEADLK) {
 		drm_atomic_commit_clear(state);
-- 
2.53.0



