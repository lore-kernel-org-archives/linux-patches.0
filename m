Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211473;
	b=j/iHz0LlpjBE4E8gjBUyA84drVDkOXXh9pOo8r7TESO8wIIiBZCG/QV8Av3mg/W7weI/
	 F3yY+QcFjdqAnOdL4dIqnp7pLnnxnyohGJFO4cCz+uQEHQ5aKqfvlJcwrJEmuxjwUp+q9
	 ctlhdmEz5ffIUHO3AwWTKHJxJGYCTNXTCrB2ETYviWOYKPYJH1heocXi+5kkNps/lNSLE
	 h0YiC+KEwBzDYgDzRsPHbWlZM9AjJqK51qsvQC04rcEohpbeLU1Mnt/tdDFM/q3mOcGxL
	 psc1d7s6G8cIO/I6JgqcGJ/CpacL6RiGAsbQn8rkB2XaXcAxtHg5ZulFR9q+KlZyjCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ezNLWOKsOvCg32tb8KUfdyIMudBF0xQHdmophB7cCoY=;
	b=YX+zxtzGX4ao5STNIxSfGZr8vZ0iMSFNp6pVJbUqJ0pbaCBmhuTxuRuMGhwtjuIe5xru
	 BeQdlYqRrNpDW8aF+Bsgv5dJuySG1TM9qUcCdj7+HRhJcdy56XZnAZIy/tIp4zolVtsOR
	 FBh+cfO/If/Hap6/xIs2hVrhfnB7WQ00c4n+4YluatAP8EqREH1znoceofYkOBv895cKW
	 tJ5N3WXPIv4pgxlprE9ChBByFhtlQOQ9p6lrSlKkaS5SKp3JOtd4yeZfElHlMlIvMt9yx
	 rbH0z4fpgBthPB3qFaYGwnz6/pdE+I4t7HeyIhqocQvj1i6pz980TKpVsboGO2sGzVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LRssfEsn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D2F606A31A;
	Wed, 28 Oct 2026 18:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LRssfEsn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F381F01825;
	Wed, 28 Oct 2026 18:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211473;
	bh=ezNLWOKsOvCg32tb8KUfdyIMudBF0xQHdmophB7cCoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRssfEsnemR1OEq+WpfDC2/PnQAYKFykKK9yeNWo8HRssoQaBPFRtNrBo3zoPRZP+
	 rMXdR+05hLraaDqF5PeykZBCoEARZbqp8hqUSNe/EpiFIveqhFOGKvwA5M9l8BdXDF
	 tYBBkoGLtBDi7T4ELTWtiBSH+2yLXiLCX1rAKCYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Keri <okerixx@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 390/571] drm/dp: dont mark the AUX backlight enabled when enabling failed
Date: Wed, 28 Oct 2026 17:58:57 +0100
Message-ID: <20261028170017.268622533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Keri <okerixx@gmail.com>

[ Upstream commit 707ce102521496c67860d81221b20c56d8255f2f ]

If drm_edp_backlight_enable() fails, dp_aux_backlight_update_status()
still marks the backlight as enabled. From then on every brightness
change only updates the level and the enable is never retried, so the
panel stays dark until something blanks and unblanks the backlight.

Return the error instead, so the next update tries to enable again.

Fixes: 10f7b40e4f30 ("drm/panel: add basic DP AUX backlight support")
Signed-off-by: Oleg Keri <okerixx@gmail.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260925132558.27518-1-okerixx@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
index b8815e7f5832e..5eedbe47474eb 100644
--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -3459,7 +3459,9 @@ static int dp_aux_backlight_update_status(struct backlight_device *bd)
 
 	if (!backlight_is_blank(bd)) {
 		if (!bl->enabled) {
-			drm_edp_backlight_enable(bl->aux, &bl->info, brightness);
+			ret = drm_edp_backlight_enable(bl->aux, &bl->info, brightness);
+			if (ret)
+				return ret;
 			bl->enabled = true;
 			return 0;
 		}
-- 
2.53.0



