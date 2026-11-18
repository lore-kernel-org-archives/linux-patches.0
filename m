Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056616;
	b=goNoa15MwaAnwrZH7Czf3K/9/ozKiiDPMuCfV6ZkIIjXfpfapLXAQIf5060WjLfQYOKH
	 +vHF6V5asHKOCnvE6Y+qs7q2vt3MWSnhrlhQxhaLMdPkU8uRBSUro7OlUoaITCpi97AaB
	 LgMlu7xiT/Fr6qZ313Jewn4EIVkFp2LiiR2vIHcIatoZihEMO6fecECc+6K36AEOj/Q4f
	 dgAhkkJr2XmUu4Z5UDWGZrp4TcTnT21CDZAFdy24k4hiBkouXnhTmVhn9iAOWEQCgq9mX
	 9w5m8jtc47xelZ6yQbtqwCV2u0YL1WLLgGS+J1YZ1n8mHjbVYDKh6mqrFnvDWq7cCfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=K2OmNi3sDZVhWkc3rL0kKvuGvF4MbCdFOwJxZIpmwb0=;
	b=Wb9XXDQLDtF+DpQHo2OrkNdkwO23peCjZgU5N6JJWlL1/YUjcpxHedL30jJti3K9QbVl
	 d0F3dKSvvISsrKMLZwnBEdrL1CgaOYXoQrLGJcNSBuop3A6ryKTJOhNLa9BO/iTovjmbI
	 TsSmchEbaqWwK+CPfSMSSoLdKwqnKfPmr8H2DWDmnCTeX7sRcE34CR+2+uAsVzvoBLxBI
	 PANaziqXOGczlH5ywkDFQHZR46l6ai0KjrgVA7VRQJgrNZAFTHx3v+WU892jm70ZIgypX
	 oYzksehQU6XWaGhBt9wffW7Y8i/5vhDlOJFcQ5589VNfNzoz6NJOmkj9nncrPFk3cNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e7AXsuQh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE46606A31C;
	Thu, 19 Nov 2026 02:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e7AXsuQh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403E31F000C4;
	Thu, 19 Nov 2026 02:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056616;
	bh=K2OmNi3sDZVhWkc3rL0kKvuGvF4MbCdFOwJxZIpmwb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7AXsuQhzljiRL286cIOEbJRe1NOV8jY91c5ykddaskIA6I2jxU7ayXljSRBtSGFd
	 TSVUs9C2r9dR2dXyt15a0z19z71IU5t/Ehmcuf14cbdDn0v3t8Eh+VR3RNMoCUYYGl
	 wadqXsmrd1onpdv34iQHC0dWZA/CZ2gqgRIbTt4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2052/2214] nios2: ksyms: Declare __mulsi3 export
Date: Wed, 18 Nov 2026 16:02:08 +0100
Message-ID: <20261118150132.784872029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



