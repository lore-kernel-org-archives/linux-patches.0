Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021043;
	b=AXMoEs4LhFd2tII+Cy/RpWKJ8p6wQdD7GXScetbiwiV5bfBY+Nqm8rGkbgRBy1407v8T
	 7MI7Ur+vCQABIyGFUamYYe9JtiHZs0cDDVqgBUc9y/bDCr3EisOYfmy9wmZ83f/yfMhqu
	 3PqOZqs7SfjmmeOvwwaoMCGYSLlyT1GXi7rNPY0KT6LQBx85vkkEAb1RWrI7QVLzrN1JV
	 uzySzMOFJs505ojWhVW0npJMEJBpQwtmW3KS48Wd39AmUtrIBd272qdK8i+D/L0U/xte1
	 pFj7PF3M4g71ZyQ1dVIAdxnZrNGZxUwcWY8woWSkYJpenFMTlYVrUQ2eAi3WBmfKjRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NfHbplu1CLqY89tz0juJOG8PNKXShPSCcTp6zTLRR98=;
	b=XqGT9Zjez465jlhRcRrOWUOuEMG9WB6YwmBrnstv3w9fIEm6qJq068y1/b7FoPPPNreN
	 pU1B4msJaSOY7wbA2HoPujSk7KGO9+44bl4auUEnWj4U+XuYSWtJSspTCVNtj2lPPLRx4
	 c3TdA77xMCrVyHH0O8h9HJ6B8KcDFTQo42dKLbog+a8mezIEyyfZQcVq0DE9O2pXm8OT/
	 VT/ZF821XPQh2Tw8peJ69p8m77kfZ3m/0Q14Mts7NQ36xQ+/8VG92+UpVWBvXBOMY/p9E
	 EKimGERsrJSKshRnsW2+uzRs6LFeFs4b1SR8R5zOrWezFBqf269EiHn499r2wZRSAWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m6ROtMWT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E45606A31C;
	Wed, 18 Nov 2026 16:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m6ROtMWT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5171F000C4;
	Wed, 18 Nov 2026 16:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021043;
	bh=NfHbplu1CLqY89tz0juJOG8PNKXShPSCcTp6zTLRR98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m6ROtMWTr3teR1A8vmIghBmswk2LxGRPPvQfp3v8MjS7m1hA0pWfqONgiZ/F7N4m/
	 Tm97fITCJ9piGJe6wGNc/21DTY7MZ6QBpvkA1fw1XL1FrXPkvF9JDruxsfLdjHNxQm
	 gZspGWw35ZOrCDyhiUZqINIIRmjppqTMXW+M7nTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2167/2651] nios2: ksyms: Declare __mulsi3 export
Date: Wed, 18 Nov 2026 15:56:47 +0100
Message-ID: <20261118150403.832704893@linuxfoundation.org>
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
index c40aa39e86587..e8710a269b398 100644
--- a/arch/nios2/kernel/nios2_ksyms.c
+++ b/arch/nios2/kernel/nios2_ksyms.c
@@ -38,6 +38,7 @@ DECLARE_EXPORT(__udivsi3);
 DECLARE_EXPORT(__umoddi3);
 DECLARE_EXPORT(__umodsi3);
 DECLARE_EXPORT(__muldi3);
+DECLARE_EXPORT(__mulsi3);
 DECLARE_EXPORT(__ucmpdi2);
 DECLARE_EXPORT(__lshrdi3);
 DECLARE_EXPORT(__ashldi3);
-- 
2.53.0



