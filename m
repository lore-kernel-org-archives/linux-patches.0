Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027406;
	b=2tpFXFJFGIlqzS0SR/0e2HG7jMExmbJVHwixPoZ6usgLZmL8CCFSev/U8VPQygL+213o
	 H5jedQJWqUJ6lS4QAzUuJxQ7hDAj4hj+UC6K6oIsmofIUt26ThrENSnXuxVqkQH6cY0G+
	 1xFpKSQ6gNNCjzrrgc5yC55eeUKbdzQCp+yAZ0ylaT6khNC7roNB3aq6ZI0nYxbzZNpnA
	 jKNZrj4aj21h8HW4tn64BIeEbObRx+cBrkkf23NUpMh3a/U/rlSsziBS9LMpjqBlFN8+c
	 R/q2dFUgJXxMXPGTiDyu5LX93KiGS/7V5na4JTrkKzlYKs+3vwZ86c7LSA2WD++fu9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0wycjxFFdxwLHU01X/hZKdeZxYmWCwheIi78p/lRVR0=;
	b=dX9/ln9OLUk3wt+dfTSgH4niOjY/vRQr9OWHCcFBNx9JvBQsPbh6ZrEI3o0mRZpJQ7os
	 hcSuDhIJH7tESPfbhK05rSsVmJzG5Blf1TO8UmGXSIsbOxPyYYGVh+eey1MF6UCAF3xef
	 1Jo54K/gT/XMCwC3NQ1V9gyMSFU80deOJ5ZukgcRApt1ftWRDAa+qIPoeOSGT8jkEjc7V
	 Wso8oQvOj187e4yzqnxFFdd5cF+8j9HQ7DIjwV//tDpKerbHO3MK+f9B4a7q2Ujw/6638
	 GCAY02mH2rgBnIg3x9poGeB5jeAv25qSgANBUTGQp4SYdAEC9Cz1bd/3rA9QdcaxVWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DRSmNRs1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D94160A2600;
	Wed, 18 Nov 2026 18:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DRSmNRs1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7AD1F000C4;
	Wed, 18 Nov 2026 18:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027406;
	bh=0wycjxFFdxwLHU01X/hZKdeZxYmWCwheIi78p/lRVR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DRSmNRs1jxUERepBiByoV1EGNDNouGiJJ5l9V+o9K7hZx7JTj2ZwVJhCOKid/QH9Q
	 H/ZhmioSCuRkvJ1cCp+0vYho/1MRFnwdDMV/D0+TjxtG0ZVxDS1DEJlvXs8fBoimkW
	 dT5iIaEKRGyYA+bqo10hrJPsk+AUrejcneNR4fek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1776/2151] nios2: ksyms: Declare __mulsi3 export
Date: Wed, 18 Nov 2026 15:58:31 +0100
Message-ID: <20261118150226.524580733@linuxfoundation.org>
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

[ Upstream commit 2180d11e06fb56fd13643ae59964f144896870be ]

GCC may emit libcalls to __mulsi3(). As modpost is not aware that this
function is provided through the linked in libgcc, it fails:

ERROR: modpost: kernel/locking/test-ww_mutex.ko: symbol '__mulsi3' undefined!
ERROR: modpost: kernel/time/test_udelay.ko: symbol '__mulsi3' undefined!
ERROR: modpost: kernel/resource_kunit.ko: symbol '__mulsi3' undefined!
ERROR: modpost: fs/fuse/virtiofs.ko: symbol '__mulsi3' undefined!
etc.

Make sure modpost can see the symbol from libgcc.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610171933.J4bFOfL8-lkp@intel.com/
Fixes: 2fc8483fdcde ("nios2: Build infrastructure")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nios2/kernel/nios2_ksyms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/nios2/kernel/nios2_ksyms.c b/arch/nios2/kernel/nios2_ksyms.c
index 54f7b23df1bf5..33aa76f2eca10 100644
--- a/arch/nios2/kernel/nios2_ksyms.c
+++ b/arch/nios2/kernel/nios2_ksyms.c
@@ -39,6 +39,7 @@ DECLARE_EXPORT(__udivsi3);
 DECLARE_EXPORT(__umoddi3);
 DECLARE_EXPORT(__umodsi3);
 DECLARE_EXPORT(__muldi3);
+DECLARE_EXPORT(__mulsi3);
 DECLARE_EXPORT(__ucmpdi2);
 DECLARE_EXPORT(__lshrdi3);
 DECLARE_EXPORT(__ashldi3);
-- 
2.53.0



