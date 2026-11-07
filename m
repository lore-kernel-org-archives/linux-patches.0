Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062874;
	b=ZsZIUSXS6UigjaDzgrbPVsFG8Ed8KHrnQzwT99q2NpsvgOJ65QRZClrjwN7PWMc1gbi5
	 AcqtWaZZM99MZ+5ARWjX+CTsItu5BBcEBYk1WnvzPNMwFJBHeZPZyHlbfwSjzkCeUSSTW
	 IG6laIl9AyziIP41fGmB47uSPrN57RVaSEWlJyz80+IykZFGrkZqBAZoHtWfPQ5kIdOkT
	 3+QuV610fepTk9nJ6Rxauh8XxEPhV7citIdzMxnmf958gfn9QJNsC8ROLLqxLOAKbbng3
	 jV9gn++J97zo97MR83B601k2Im6D9YbTwSWTm5pnF3X/2N/VrbysuefjSrgIuLSiRCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PzaVDxtBmX30QuVM/XjfjrGm28JfWHUWOCKfiAqgJyA=;
	b=CDv/Gl8wNY8tUEW9Tte6r7r/LlhH38aug360YqFnnqlfaFNWIKR5kiZp/6NoGC2LC5Wb
	 A2ZLg6Eo913rc8oloxaC1Lx74iqDiAn3zjnR5t845w7tRZtcRnc7iD2tTyLLo6BVBGchP
	 zS7mu+yA3sNFDsT3ira6M/LYwEMzDpOn7XJPTZumOZ9Zo7GOLK+lQ2Ahk7dXyaoE45aXb
	 orlu0I27Mc5mY8y5fhe2vV+HsBOupIje7FSb2uqmNvatN/7sMmE+DHmvP21KroSM227Wy
	 duru6n4HQEIo4Gd1hY9TQzj+nNzIkBUC5I7ZRSUlUoTcWgPpF0mfqHoDAbHtKbbq2cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FKZtLoBZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEEF606A333;
	Sat,  7 Nov 2026 14:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FKZtLoBZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0531F0089F;
	Sat,  7 Nov 2026 14:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062874;
	bh=PzaVDxtBmX30QuVM/XjfjrGm28JfWHUWOCKfiAqgJyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FKZtLoBZOkA+aIDRuhNH1GCdubkcUEItI8PAUAll5Clcx8NU78jqncV05+7Sxd+c0
	 +WBvqMSHhW5UCA2a1yiAmVBbLSLUff/zqFpf+xt6MFcDCECcjYSPZefBQ7X3XpLgVd
	 o3GpNVYjuJDx5VzIHf0J3Vqm55MIgA80TvGYT5QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 157/869] drm/panic: Test address from kmap op for NULL
Date: Sat,  7 Nov 2026 08:47:19 -0500
Message-ID: <20261107134857.625432553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b95d869257a84..9c4ac2febc931 100644
--- a/drivers/gpu/drm/drm_panic.c
+++ b/drivers/gpu/drm/drm_panic.c
@@ -184,6 +184,8 @@ static void drm_panic_write_pixel24_xpage(void *vaddr, struct page *next_page,
 	u8 *p = vaddr + offset;
 
 	vaddr2 = kmap_local_page_try_from_panic(next_page);
+	if (!vaddr2)
+		return;
 
 	*p++ = color & 0xff;
 	color >>= 8;
-- 
2.53.0



