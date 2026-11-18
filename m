Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027886;
	b=qahNkncDd0GcvGRaDot358RmpuzsFqpaZoDgzWZZE1tRhiTXMJT9h44TGtiYLIjA3GLe
	 WwSVnWJLtjDs3hW5Df5WfYwm4wym4Lqx4Uan0Eoutk1X0Z/g5h0G/3lMMGa4yFimPVzmD
	 lPtyG8nR8LXY+Yw8Af9uyek4VHNvy/XRQNEaKmobREkglAiDYRlOCO0i1nvQVXfd0EDJT
	 0GEUijRXn7IV+pRBN8ZVSxIbiiRvBDoeqRbkNX83XNE1OiAcQTUisV7P75ODZnrhOttaE
	 MJqr4n4mth8i/fmnVDnzCST8JbkAnh4v8Fzu2YzGwekecf70IX+iOvNt8ZMmi71x7ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=za6wICvvhbNdYQIHwdVUf6OogULfiKyhre19SwUMBKQ=;
	b=48nxskXsAwRtp48XbDAK4dPN40st+YDGa1Dj7yz3d/B/bTnfNyq1FJTofxzTyDxfQolY
	 fssmCgk24J3/TbjKHO+Y060uVVWRy9OUhyVjawnQrLEiveRjnTfEbwU08wIuAkhdIzP7O
	 19BZn2/SH3tkikbGpkYrSzSUm+FtyfVGYMR6BKIp4Mjp/zZYKOWOCXvogdxXfU7XTSQLg
	 j0pt2wp1WpEbeQBPl1BLgm1duxcVpXZSoSQhdChPtpY4gxRb6KMTJ7FBUgP946V8leNlC
	 H1HHNn5KBFOniMbqYvBVhMVpSR+SJlukxv5/hoosuGqwM2kRoaU94Z3j1W4tQLVSZuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YeWB398T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A392B606A31C;
	Wed, 18 Nov 2026 18:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YeWB398T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0152C1F000C4;
	Wed, 18 Nov 2026 18:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027886;
	bh=za6wICvvhbNdYQIHwdVUf6OogULfiKyhre19SwUMBKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YeWB398TnPdttBPLVDRxSRNWqGb+LaUgg3FYkqvmGcOeO2YIZdrx/4kar0MZpZtzG
	 9zsNlVCMO6RAMXeNTfMwFUJBeefiOetdLRTQV8gzvVg65OYCohVUpNNP5oQ2OqwDXu
	 cblI1Lv4ZYjbM80QZrWm6RSCr6J8a7Ipon86C6XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1947/2151] vdso/gettimeofday: Correct the read of tz_minuteswest and tz_dsttime
Date: Wed, 18 Nov 2026 16:01:22 +0100
Message-ID: <20261118150232.691760995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit cbd0f65b48f52d308c457b0fd5201324abadb501 ]

When these fields got moved from 'struct vdso_time_data' to the new
'struct vdso_clock', this access was forgotten.

'vd' is not an array, but a pointer to a single structure. The code
works by accident in its current form as CS_HRES_COARSE is 0.

Replace the incorrect array access with a regular pointer dereference.

Fixes: 886653e36639 ("vdso: Rework struct vdso_time_data and introduce struct vdso_clock")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Nam Cao <namcao@linutronix.de>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Link: https://patch.msgid.link/20260902-vdso-tz-v1-1-4d37a6b85ff9@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/vdso/gettimeofday.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/vdso/gettimeofday.c b/lib/vdso/gettimeofday.c
index 95df0153f05ab..f18083f64d10b 100644
--- a/lib/vdso/gettimeofday.c
+++ b/lib/vdso/gettimeofday.c
@@ -380,8 +380,8 @@ __cvdso_gettimeofday_data(const struct vdso_time_data *vd,
 		    vc->clock_mode == VDSO_CLOCKMODE_TIMENS)
 			vd = __arch_get_vdso_u_timens_data(vd);
 
-		tz->tz_minuteswest = vd[CS_HRES_COARSE].tz_minuteswest;
-		tz->tz_dsttime = vd[CS_HRES_COARSE].tz_dsttime;
+		tz->tz_minuteswest = vd->tz_minuteswest;
+		tz->tz_dsttime = vd->tz_dsttime;
 	}
 
 	return 0;
-- 
2.53.0



