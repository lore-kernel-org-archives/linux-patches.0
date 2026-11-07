Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064012;
	b=kwa5mIPsw44evYThvPOWmdbEhqzjT80/jvjofwwqUWP3ub534BELBBnrKJZmMGkv8j+H
	 ceXsSl3Mu4dV0x8JAxNGZzUq/RaieKMBtfZfI061pfVAleY6gzAEPY+2PodFarkDGXgfW
	 qwEoKwFIcwXxK4CKVIjqXF//QM+cbyrU7KNiiPbgq7ONKwCKN26b9TLKsSTOuu1NrLXn6
	 RxgF1jIpADdnynsr5BJBQLtDtiJ0fOwy0Cl0gsFhIAW5pGAplxA/pvndSXeqf9MZIWwr9
	 fgMJmYWR/r9ZOhWH8xI2GKgzeQRHTxmZYqMKKwY/byeOAkUE0JIlABRWie6eqU0dU/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=01NRPBj8mtUges7Wc3KS2LFmopn1+/ZzR1I9ZO0jMKQ=;
	b=IifqERFBuIWqBeNxBey1g3g/2OL79fZ8NiLhOlHczUIlqZ83a5Dp26/Ao2tCgCMMdSJn
	 CxbIN1fPeyCxM3waQ9iOdJWRa54/Ej6BE5SZCp0E4Q/vXgBubOd3un8uU27NOqL+MFS93
	 0qPJHtvM8MJwoCQCcc6uBpahJpo/n5HGsz2IYlZ9/YM2e9+MiywLHVWa+XsxwrEeWG1+h
	 +r3cymCb0VIb7ZLoUfCHDH4PCgSKDaK7T8TlW244gXJkEhhLu5FiYJaTaKwQ4Qp9NcHeM
	 HOqSnrL3p7IpOqnjBu5xeA45LbIMIlY+/C8Dy2dQ/5IpD9Da6A8Eke8oPXoBbf9L7dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jX7Gu1e1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7A7606A9C0;
	Sat,  7 Nov 2026 15:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jX7Gu1e1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA151F0089F;
	Sat,  7 Nov 2026 15:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064011;
	bh=01NRPBj8mtUges7Wc3KS2LFmopn1+/ZzR1I9ZO0jMKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jX7Gu1e1+Vb89M5hdD9Q18YdgP1XBkeGYxsalWRw7CZ9hW3WyyjX9YvOxdmQSznlQ
	 V1dfs08A4sxPVrRkReZJ+b/jB2Vu3RwrJju/1tG7gJwPu4vgNCXUjENbwjUrw1PQ42
	 4DEf1XQhx6ZGpBOglMQCiTY8d/Ow84kNuPowwPww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0190/1257] drm/panic: Test address from kmap op for NULL
Date: Sat,  7 Nov 2026 08:41:26 -0500
Message-ID: <20261107134944.705597912@linuxfoundation.org>
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

[ Upstream commit 6a6304ec3ceee879e3a2545b217eb11c8b7870e5 ]

Do nothing if kmap_local_page_try_from_panic() returns NULL. This is
not likely to hapen, as the previous page from the same memory area
has been mapped successfully.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 23437509a694 ("drm/panic: Fix 24bit pixel crossing page boundaries")
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.18+
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patch.msgid.link/20260911124540.279841-3-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/drm_panic.c b/drivers/gpu/drm/drm_panic.c
index ba21df4be3380..d28ce8878e055 100644
--- a/drivers/gpu/drm/drm_panic.c
+++ b/drivers/gpu/drm/drm_panic.c
@@ -178,6 +178,8 @@ static void drm_panic_write_pixel24_xpage(void *vaddr, struct page *next_page,
 	u8 *p = vaddr + offset;
 
 	vaddr2 = kmap_local_page_try_from_panic(next_page);
+	if (!vaddr2)
+		return;
 
 	*p++ = color & 0xff;
 	color >>= 8;
-- 
2.53.0



