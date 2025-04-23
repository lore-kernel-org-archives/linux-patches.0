Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4939527FD49;
	Wed, 23 Apr 2025 15:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422567; cv=none; b=fC1FRjd94O26B9y8wIfbYmvDr4riRV2L/k8RAKptgEwzI/Hy746uUw7yoD27ZdJWw9/c8W34Dx0p9NnPN1ilsw3Vv4ToZkHe7nZfPamI7M487jzGNau2zeKb7wj+hSWFOCzkZ4T4aU5LysRBn1thZgrlqswfCm/ogWY39sxwWzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422567; c=relaxed/simple;
	bh=3uLRkz4lYgYofM/A9VatQ7U2vAk2CmUYgOx1drD32vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ExqfQUMU+ihW6hn7cDKc5fHyNygBq0qGV6JHxc4sR+4vVDbFvux6CfIApHV4+OvQGTWjaJ/AUb5QvB7w5WWNt11Yn/U3MwNW9zQ/MVyjL/6+zzRn8QY2S18o+ZvrbB1eqtDmcYBGvqgTb1Q+mobWkTpP312G4jzQktPdA7Lm7wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zWo34LOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zWo34LOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE995C4CEE2;
	Wed, 23 Apr 2025 15:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422567;
	bh=3uLRkz4lYgYofM/A9VatQ7U2vAk2CmUYgOx1drD32vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zWo34LOzeINKsZP6ORz9OqL4yEtmtc/Jke9FLqjrqe1nQM1iIOu9Wob/UwQMvg/if
	 +V5ZdCEqAw5tgkvNphroGyWxIogwFevkHzTo9FQiZenNjokbUEcIFvtA7SzngBuvBv
	 6YvIYEQp7vxs0++Rbz6MByjTJOmOagPnl5ZbtQJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 391/393] MIPS: ds1287: Match ds1287_set_base_clock() function types
Date: Wed, 23 Apr 2025 16:44:47 +0200
Message-ID: <20250423142659.463531883@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

commit a759109b234385b74d2f5f4c86b5f59b3201ec12 upstream.

Synchronize the declaration of ds1287_set_base_clock() between
cevt-ds1287.c and ds1287.h.

Fix follow error with gcc-14 when -Werror:

arch/mips/kernel/cevt-ds1287.c:21:5: error: conflicting types for ‘ds1287_set_base_clock’; have ‘int(unsigned int)’
   21 | int ds1287_set_base_clock(unsigned int hz)
      |     ^~~~~~~~~~~~~~~~~~~~~
In file included from arch/mips/kernel/cevt-ds1287.c:13:
./arch/mips/include/asm/ds1287.h:11:13: note: previous declaration of ‘ds1287_set_base_clock’ with type ‘void(unsigned int)’
   11 | extern void ds1287_set_base_clock(unsigned int clock);
      |             ^~~~~~~~~~~~~~~~~~~~~
make[7]: *** [scripts/Makefile.build:207: arch/mips/kernel/cevt-ds1287.o] Error 1
make[6]: *** [scripts/Makefile.build:465: arch/mips/kernel] Error 2
make[6]: *** Waiting for unfinished jobs....

Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/ds1287.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/include/asm/ds1287.h
+++ b/arch/mips/include/asm/ds1287.h
@@ -8,7 +8,7 @@
 #define __ASM_DS1287_H
 
 extern int ds1287_timer_state(void);
-extern void ds1287_set_base_clock(unsigned int clock);
+extern int ds1287_set_base_clock(unsigned int hz);
 extern int ds1287_clockevent_init(int irq);
 
 #endif


