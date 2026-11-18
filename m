Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032440;
	b=faXyC5XPbR7TGwYGl7RiMmG+EHR7OYb6lxMWs9KYZ7BL7jStoWA3yOK3HOIhrzMbTmUR
	 z+kXL9cSPOmlaaR8dJdDwEMvJyZvHapNMEA76Bsp04BNRdJZJUuigkFPvpNsdpyKvY1q8
	 MKwQ25XNN83zIcSOWLIHH4vTweQYcTUoZ5A+OfX4/fmt66Vb8W0NAU9EVLUEX08qugfi7
	 uftxWw5I8DL2/X7U624dx9A+6w0mo0MTxDI5PEhZr1pNRPX6srmh1sPlrh3vEdJM/93Rx
	 cYQaQ7pYU/OW124b8gT7CmMlWJd4W8BsyWL5nUJFyCejiqMEG+hrXSc7LzYiIjekLxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=a9HDKhYpL0FECJO2S8ORqPOvrJujxQX8R44nX976vv0=;
	b=NQJqgsgbQNRTsgKWX+LUZeThBRMDnIznuYpEDbV6Xi/oHdos+t8WU9trJoNadNJDpHUS
	 G3ZUUZfwEnxVrCNJpZ6swt/wrWLnNFIb6BiytBMI0lUatpL9/buVit8gXz9ukcJxq1xiL
	 eWoSRS9inYpzVfp/s8EBairpVIGpCH8Y8+CTUTIQMh9Hzd1cahzGNQtGOd/0RhdHNhd4M
	 sY4YNwJFBZtfYp20A3h7NYqg9u+S3xM1JXDNvJ/lvNmlxTCBtOdw6rNDf+0U3G/A7HX9K
	 CXfxjsNNEWxUI2jNU+S1y04711+lK+uhq8Y1lF5Iqh0L+8RHNW4ir0/ZIcvUBxWbIeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DyETOzoB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACC0606CB29;
	Wed, 18 Nov 2026 20:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DyETOzoB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788691F000D2;
	Wed, 18 Nov 2026 20:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032440;
	bh=a9HDKhYpL0FECJO2S8ORqPOvrJujxQX8R44nX976vv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DyETOzoBw9NYUn5UPsVQe3Tram1Rgnb1uV3Lo/R9X5/nEVh4FIPqnM65G74bl+XtX
	 GbD++NVDgz53gGk+LilZ87LdZCzT/GdPnk3jPlTPdodAtXdcIQQgt216trGdgIvbZo
	 HBpHn+IFnlLYzuFz3h7XtvxkmtlMbdUdrtjlbXIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1411/1756] nios2: ksyms: Declare __mulsi3 export
Date: Wed, 18 Nov 2026 15:58:58 +0100
Message-ID: <20261118150105.382226988@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



