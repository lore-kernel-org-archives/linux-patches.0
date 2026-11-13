Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591364;
	b=iB1wKUaajpjP3PIIqyp+UjHtID5URvXGPFdTZOa5RCnWOYPmKKK3twJ8/tpJrOTg5+ln
	 aZK6yETYppYrqYv0u+xoXV7SW9Kg6hvGkdkAHQ9RurZuwdWLGqt1AERStlPNUsPOJqpLH
	 5Pd3sjevx2nwA961Io80PuHFOoqQKHo1fWRchVJI6O6m9HRZiL1Y64AOZrdCWpQvyzIez
	 t4j8COdY0jSyHbVQR8FQnd1Q8HVUIVrS62tU8I/wxI+sBnAD++MZt1yc8yfU77Ixu3Pac
	 x62jrbogYZ2017tNktM9sQLldT6e3PjT6S4Rub/werak44fzjeG3flx1DUCBUaE3mSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y9kMPT4lvc1oVPatZtF5GWtCXYDTVG/bwcV3P2pMqPk=;
	b=EKfePtCRWwmSQF8Y2qFVJ5Ce3h5/pRg6rAtLMD9dcefSqoo92xRsQIrvjvM/s7+iVddB
	 5Ej02vRt2+lE7yI/jDXORNydgyVGAOlcWOvqd/6KVMjcQQ2wFUNLQEbrTjwgGYRQj2MoT
	 Z+guZXdw7YChcXWzJ2m0VJCWfOYo0wHrSHeKOa2/qCxC8If74EufiD6oLSWOndyaQFyLF
	 dd+/2GNtGgvJJTnmoS1cCWBIuR2IqLMxXI5CrGtKhtYCbYShp6oawCi01qNh/Gtv8DFeC
	 uSNaKX/zibTQKlxVVV195r93jIPVLB+zgRJpXx1EOCTGPLbWaRw7bauWogcW65N6lig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VeYeKSxl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD81606B22B;
	Fri, 13 Nov 2026 17:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VeYeKSxl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9949A1F000C4;
	Fri, 13 Nov 2026 17:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591363;
	bh=y9kMPT4lvc1oVPatZtF5GWtCXYDTVG/bwcV3P2pMqPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VeYeKSxlj+DENCpVU49tTb7+Ru0ZX9DeDqxN20RZPOnfxuxpxgZstlFS93cAQW0DV
	 /+2CThI5ZWNqr7WKgDnWAEXEL4H8qyWA58f5EX2BfD4Lepj90fISeJIBGg/HgsohSs
	 z7li0IWvPWk+9s6FGRKsB6N1ZxB9Zq9wm3j+3xW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 466/670] drm/panic: Do not use un-escaped URL as format string
Date: Fri, 13 Nov 2026 10:50:30 -0500
Message-ID: <20261113153827.740392404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 6596aae25585b183ebd528206bde6f12efaf8db1 ]

Replace the direct use of DRM_PANIC_SCREEN_QR_CODE_URL in snprintf()
with a %s conversion specifier. Avoids a possible vulnerabilty from
a crafted URL string.

As the attacker needs to control the kernel at the Kconfig level, the
potential for an exploit is likely low.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.12+
Link: https://patch.msgid.link/20260911124540.279841-2-tzimmermann@suse.de
[ sashal: Retained the zl= URL parameter instead of z= to match the older QR encoding. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic.c b/drivers/gpu/drm/drm_panic.c
index 06f0aa1cb4f74..f4662f88e2173 100644
--- a/drivers/gpu/drm/drm_panic.c
+++ b/drivers/gpu/drm/drm_panic.c
@@ -507,7 +507,8 @@ static int drm_panic_get_qr_code_url(u8 **qr_image)
 	char *kmsg;
 	int max_qr_data_size, url_len;
 
-	url_len = snprintf(url, sizeof(url), CONFIG_DRM_PANIC_SCREEN_QR_CODE_URL "?a=%s&v=%s&zl=",
+	url_len = snprintf(url, sizeof(url), "%s?a=%s&v=%s&zl=",
+			   CONFIG_DRM_PANIC_SCREEN_QR_CODE_URL,
 			   utsname()->machine, utsname()->release);
 
 	max_qr_data_size = drm_panic_qr_max_data_size(panic_qr_version, url_len);
-- 
2.53.0



