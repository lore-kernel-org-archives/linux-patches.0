Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061925;
	b=XtF1KpUgr3qrkr1WFyjr6QWc/naJRczIoYA2GSwXff8hSZR1A5A0GGTsQ0pXnilBAY1w
	 6ZiOVp3bhn32NH1ZKtgxFBvpdDdmamuaUuBDhGEtgs7N8mGStidTWK1QgqJEEFcFFLh+0
	 trGXNMLncWA+Gri53z1MFw0+2gO6yQ11Zx5+y/wqtc4nA7Qf+LupZJo/GNP5JrJbTA4Q8
	 nzEXV1sO6lB2i38m0JQ2xSJ96hjKFEEOk6tVINFexPqBhN+k2pUsTLsmeoKjqeXiCHGKT
	 rUjGc1q8n4Gc2ia0M+q/sXWwDHFvfY56YdNJsR5PxUaUbZTaRRU2HOQ/6c3BMQIjSlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=sJTbckUUAR+8o72o0qWDIux2LsFm3/XYirnXiwUewuI=;
	b=oi04km3nxSte76kyW88aF55Ohsq6r6FrDf3DKu2P3gVZqkZ/1xxOwtylV8z3IrsY2gr5
	 4u/cf7Z1h0LTE2lKWxT/iZzngknH3xfs0zlSl4qDUI/4W/T4WNLWSvHKh9r6JQ/gql44O
	 p0Is7qp5JfLY3ajJH0wXCbisflnwsTtPvfB5LWxzyMrbyDUy+Ust2W85B53iyumGTRbYg
	 IqMVPotExdJVwxQbh5XGcTF4a4gAp3rlYeteY/k59gajpP9kSnif8/lbMU34K0th8IKRw
	 t8YDkcT6V9HByCGSrcErm1ZYyAr+Ayx089TwHefC+mDIZR8z3u0IWX3g1otdQ31Yc9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XczvQ7Qn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A615E606A320;
	Thu, 19 Nov 2026 04:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XczvQ7Qn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B551F000C4;
	Thu, 19 Nov 2026 04:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061925;
	bh=sJTbckUUAR+8o72o0qWDIux2LsFm3/XYirnXiwUewuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XczvQ7QnTEG8mnI61zHvsTKvkVodnl9YJZn/T0i6XjnYrmTc3toxIsbCsGcVPjtS2
	 WbKHAhBQssMgcnmMKyFpR0+YljLU7NpcdDJlzQUNYMi7GwgEtx6fpx2hRV2cyeMUy0
	 KOjmtb09StnHIBXx1oMPF1Y8Yo+T7/HK+IDOmc4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1725/1848] nios2: ksyms: Declare __mulsi3 export
Date: Wed, 18 Nov 2026 16:02:43 +0100
Message-ID: <20261118150031.830711126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



