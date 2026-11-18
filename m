Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045755;
	b=CWnUQtbatDiAVkIo5QXpCydRZ3/LorvIxch0/mitl/iNo65R4c7AhppEyjRvvDlhJ2ak
	 A9prbjDDH1YehZ+/gzqkKjk04Po6e1O58HsqrGm56E201yElwOLYCgbgGgjubtaeruu1c
	 zrTgxy+cMzwhQpfKQXzf458BuXmyjiXSoEPgdNVuRWQcWqyCX69U3oADiUcvpVzCCSMEg
	 8dnH3ahKdRGm0iSVBu9G8geVuC9a6MJjtok/5ptW6Dd7lhX3PejPpNzbBtl0bUNqQQPEe
	 JFhX4pCFp9hunZZEO5X1SC0UnZ5RctHtHLY39dFXejIEjy6oAoegkQkiLXUrb1wrFoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1ICZi8D6V6ZnXht2KX8PAIBdHkp+Hf6bX+bkYWFLNjY=;
	b=ekr6/S2W66iq58woPVoo7tiAoEVZJagBLWKIvh9TqJEG4KkBQqdmOMvaXIQFc6bzpxC/
	 Vw981vwxzVBmbOb/zcpmBCcYiGXIPLJ/86EA/+ioNlkJIcnhMn1gPEN/TLNriYpbhCeG6
	 jz4WHkC8QzAvilZq6IWlJI7lonnfYMiHn9Q9fJcNpTHrEqLDkyKHK0OgF8GIehr2KwNp5
	 2fQs/bqhAOPAqfmn4TLxw+C6Fep1UiWHmEAunhXesqJowID2V9wJ+bCqsTNk40Eb8hc9c
	 XSVkBXHgXVp/hBG+fgnTws9P7lvpkV+H3gqsBot3zcY2GoEbcvLuxSKuqTp5vIOayCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Y1UUcWd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CD7606A32A;
	Wed, 18 Nov 2026 23:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Y1UUcWd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A5F1F000C9;
	Wed, 18 Nov 2026 23:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045755;
	bh=1ICZi8D6V6ZnXht2KX8PAIBdHkp+Hf6bX+bkYWFLNjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Y1UUcWdy8Unn4TCwW+ETcUagbFPf4WDlK7h1cNcrtJomIpbmcSYz7b4y8Qy2WSnM
	 o6FMssTeit0/nBdFSaddiihWpK5qUe+m/5Tafw91R4TYwDbnogiHPXdJgpZn/jMvCI
	 NZu0lfN4LuMzXQhRw/15C7+Q38I1U1xgzeG6wtWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1038/2857] compat: avoid double rounding in times()
Date: Wed, 18 Nov 2026 15:34:32 +0100
Message-ID: <20261118150238.969798608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 6b30c39a5e333cfb1475acf0f73de6ef954eea8a ]

do_sys_times() already converts CPU time to USER_HZ ticks.  The compat
path converts each value back to jiffies before converting it to
COMPAT_USER_HZ.  This round trip can lose precision even when the two
userspace rates match.

With HZ=250 and USER_HZ=COMPAT_USER_HZ=100, one user tick becomes two
jiffies and then zero compat ticks.  Every odd tick count loses one tick,
so any of the four tms fields can underreport CPU time by an additional 10
ms.

Return the value directly when the native and compat units match.  Keep
the existing conversion for differing rates.

Link: https://lore.kernel.org/20261020210157.52057-1-dennylin0707@gmail.com
Fixes: f06febc96ba8 ("timers: fix itimer/many thread hang")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sys.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sys.c b/kernel/sys.c
index efce340fd9724..fdca5e7f8cbd6 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1029,6 +1029,9 @@ SYSCALL_DEFINE1(times, struct tms __user *, tbuf)
 #ifdef CONFIG_COMPAT
 static compat_clock_t clock_t_to_compat_clock_t(clock_t x)
 {
+	if (USER_HZ == COMPAT_USER_HZ)
+		return x;
+
 	return compat_jiffies_to_clock_t(clock_t_to_jiffies(x));
 }
 
-- 
2.53.0



