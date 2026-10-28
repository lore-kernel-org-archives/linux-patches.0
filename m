Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213394;
	b=vEA8pEL+/dhWVr6P5nBFk4Liui7IaMa0ZpYXEZR9HmaNrn9gLsGRzSt8JXNCHXAJarBx
	 ynPjhi9/bep1ZuewDmcJQXjj02QludFNvgfvZwmUy26KwrByOYHrCG59jhc/L/uZX15hm
	 +Y5gtFjI/zyYpODwED0BNyj/s/7aEetGrNJR3V3/BJssuTv2WXrskj3qEq/dEKE89Tui9
	 kWMf0f5sw5xsVrLhgGNuBDl9IKdY8CLXXXPuYkmTh1RBwa0kH8QbdlJCK4LTiQ/6Dnmiz
	 V5qvSYn0s/RpKX9DRBJrl0rrTe0vyZaP4Ba5PgA2yqSHaQamJgnSRz16gZj38WUj8fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aCL1BiTvvSa9b+VGsI0YvXaowhOYGCX0aHcxr3I+xOE=;
	b=wwAz8Y19YkOrxygZk/XfRmPsPfdbv7GzvnwLAqXuJdTZS+lwfQga151k082k+CkaJ+Tw
	 xJwXNHG1MxPYomJiZ25gZMJ+2XFaLsEdG9x9cxOWo/Sp0T6fO7qoOYFqXioRYZHueNXoH
	 2WpnAo/pvoHGclh9/FTv5WCnEB7ZcvdFxJhHo4+oCsw+yRM9jsjRyC0GaNODHwIVmvGKn
	 ll7/5sS23Bw3axEIwXGzg0vKfHCvQgu/ZY+fql7GQMTq40gg8KmCt1gA95KbqAq3xzh3k
	 XoNjjM8hRN1QNx78o8jeHY7w4/YjEizJ/CTJ3nhNarCY88ER0KKrwA4bJgOCw587vwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QF2RAFXA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1EC606A31A;
	Wed, 28 Oct 2026 18:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QF2RAFXA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD501F01828;
	Wed, 28 Oct 2026 18:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213393;
	bh=aCL1BiTvvSa9b+VGsI0YvXaowhOYGCX0aHcxr3I+xOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QF2RAFXA+b0DnU/DX2agZKpvakweINjHBvnSHEpQyRX7vCNa8E9+7adBwevPn7djl
	 YuctsN25SCRdRPRhw+sF3gjzE9zfcELyrybZ285ARDStXHBVB4ETrDZQU8PWofafaE
	 O9W3M4XoqsCTNy881Vdv0QYBG5xdIwNypq9G7IbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Keri <okerixx@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0483/1887] drm/dp: dont mark the AUX backlight enabled when enabling failed
Date: Wed, 28 Oct 2026 17:42:59 +0100
Message-ID: <20261028170510.252699431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
 drivers/gpu/drm/display/drm_dp_helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/display/drm_dp_helper.c b/drivers/gpu/drm/display/drm_dp_helper.c
index 14dcaca0d8c14..74fd93180f700 100644
--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -3843,7 +3843,9 @@ static int dp_aux_backlight_update_status(struct backlight_device *bd)
 
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



