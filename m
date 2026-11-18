Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021839;
	b=jqsvn6EeO3uDc7wS5fGC/22Z4RMsaExL8XfERW8L0t9VwH3KY5ZdKjPLHTxF8D6Gtf9y
	 5s1ahk/L+Xp9ObSXLKZINKMT198dDnVuT3NKe2JQBi/19jaRKwu1+oXNFga6Qs7ogdD9l
	 qYW3AItI2PBehFDOob1ufB3REzZIbZdauc/lGUJkgkOHXueZ0TTYsCunHGNxi9mCJCPWA
	 wnFwk5HLh208X1UYGSEYA5Ms2DPq4UQlMxC8uiAQ/tmt/6DSRb+9XPbViG3vUsTuF2/B3
	 TX2gIjUXJodPx/WmTKO18mZkXVMc16DC6WDNKx13aWjUHIrLi8XcEKmPpzjwoIn2BfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=giw+9vykF8QXBIjEXIuLxdnhz7VAdDS0yrxOsTsh3Ao=;
	b=Wz0bzkB1Zka9rp45TQzPrgJAuwInXLryCm2085BWFWlh83geHTNfjILzwucWbNgEBCp4
	 WDkQXwzdPma//aj6/9InJpP9pjsCZ3Hj8mmakWYjRmBQjKu3felcKc/sHMgeKDAvl+GV0
	 9BM6sINWHZAVEj0P+k2xn7Sd5PPYoCIS2DmY+wM8Vf5SJtnC4vi7tKGijdngaGetwIotP
	 Ou0YSCFvfZdtqBnG4gysFMCCF4uHUKrHPc2GA7xJtadoaNRjvjHVSBgxS1RV6pwk/r50y
	 QZReCt9M70E83bWY7boifN9mI4kY0GVadxKQuOV3VwjLG6eJCuteRH8MK7ukRn7TRwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LEKdF201;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF73E606A31C;
	Wed, 18 Nov 2026 17:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LEKdF201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD551F000C4;
	Wed, 18 Nov 2026 17:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021838;
	bh=giw+9vykF8QXBIjEXIuLxdnhz7VAdDS0yrxOsTsh3Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LEKdF201Shw/GFEg5jljo15FwqOroEYsJRoTYu10A/fkGg/vblyl93GaI2dt0fgdh
	 GhBPMkqAm5uzUP23O0S14K4tVp0hY1+Vrz/YsHkh6+4kowp9/DmHp3GR5IU516Oc5j
	 XAvO7tDJNwsu2W4NWHo6G/JIMvrDfDO0M218Eu4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2408/2651] vdso/gettimeofday: Correct the read of tz_minuteswest and tz_dsttime
Date: Wed, 18 Nov 2026 16:00:48 +0100
Message-ID: <20261118150412.010321877@linuxfoundation.org>
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
index f7a591aba59f1..6e9b03051beec 100644
--- a/lib/vdso/gettimeofday.c
+++ b/lib/vdso/gettimeofday.c
@@ -374,8 +374,8 @@ __cvdso_gettimeofday_data(const struct vdso_time_data *vd,
 		if (vdso_is_timens_clock(vc))
 			vd = vdso_timens_data(vd);
 
-		tz->tz_minuteswest = vd[CS_HRES_COARSE].tz_minuteswest;
-		tz->tz_dsttime = vd[CS_HRES_COARSE].tz_dsttime;
+		tz->tz_minuteswest = vd->tz_minuteswest;
+		tz->tz_dsttime = vd->tz_dsttime;
 	}
 
 	return 0;
-- 
2.53.0



