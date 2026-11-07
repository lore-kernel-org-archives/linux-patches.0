Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064010;
	b=Cq9S2s+oCunMtbOUpitpzEx5/Xwr/HhFRx6C/xmZ55vtZdw2oThdEqxWL58F7uTahzAC
	 508SW4sd4VaIK3JolnTtsDfGAa/GQw1rsyMzIS9blvWrN3PjQznKR7Rd4yTFUREekgD8z
	 rBwxXaCU70EjQe7msdssh5aahkkI4U+6CHoPeMMtZS1II5cLAkoYW38Du3mIXe3kWWvAS
	 CLtyqy3RMdiOCp/HCtjQGQ8AzqynIeioIzw4s+S0mNQm8d+yhnQOkqlQvigRXUj7bGqHv
	 Om0ehc1qjJ4IuPBrfWRDxaP9GnaMHSj1GoUKOgQUI6siKM7uuxljTPYFGmMaUkz7Xtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hyPUJZiYgd8haj8K0qZ+Ru8bZnSuGgXwl5kwV+c+5U8=;
	b=mPlGCzVutey2DVC/me+yDKLdB6cc58nfB0hGeVeL4ykifxE4+oQFyxTGGpj3b2X1yV/c
	 sttTS0Cb/QXIwCHlLOEqDWO20qwz8NnJDHucwpAIeWosSQ6t6BYoIrNu+5kmnM53crgC/
	 hErLTNAjvQWq6XDfJm5xVho9LeJVdxdDeWgHK20/vVeUTscEclGM0/GSL95UlGllplcaS
	 CuNNp9IojT5ht9v1xaVnioi8OSEWGBu1flnNSxpnEmev1cRExmqzkVSY3/JV1Iv/MH4sG
	 EXubNuIwFrW/Pp604qYj16GdcqK5tNCjeoOxvcgNxT0l8uQoPWbbkA/3NUpHuK7OukQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MKI+/RxB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FEF606A9C0;
	Sat,  7 Nov 2026 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MKI+/RxB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AF91F0089F;
	Sat,  7 Nov 2026 15:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064010;
	bh=hyPUJZiYgd8haj8K0qZ+Ru8bZnSuGgXwl5kwV+c+5U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MKI+/RxB1H3FdcF7RM72qsp7CYXBju1T08+6qNeJr/qVBQRroMKVaJCFWmuNDUNzk
	 92JQ3yOlz0rZuVqupovANS9ArypgLxEb9Ay3pDeIN8MP4FvtWuxz+UbEBF94bJdzGy
	 RYwtBhTTWEFvCxLY9FE8ZBYU22zFuPf399gwfnOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0189/1257] drm/panic: Do not use un-escaped URL as format string
Date: Sat,  7 Nov 2026 08:41:25 -0500
Message-ID: <20261107134944.677561210@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic.c b/drivers/gpu/drm/drm_panic.c
index e576c4791861d..ba21df4be3380 100644
--- a/drivers/gpu/drm/drm_panic.c
+++ b/drivers/gpu/drm/drm_panic.c
@@ -658,7 +658,8 @@ static int drm_panic_get_qr_code_url(u8 **qr_image)
 	char *kmsg;
 	int max_qr_data_size, url_len;
 
-	url_len = snprintf(url, sizeof(url), CONFIG_DRM_PANIC_SCREEN_QR_CODE_URL "?a=%s&v=%s&z=",
+	url_len = snprintf(url, sizeof(url), "%s?a=%s&v=%s&z=",
+			   CONFIG_DRM_PANIC_SCREEN_QR_CODE_URL,
 			   utsname()->machine, utsname()->release);
 
 	max_qr_data_size = drm_panic_qr_max_data_size(panic_qr_version, url_len);
-- 
2.53.0



