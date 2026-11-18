Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042093;
	b=TEVxLnT+UWVFGls4KE/VzTp3Cp1uXoHc/GvZtbNxKo7gIWHZin8XHgok8ZjxpBZYIfYw
	 E6wT1onpjPxHykbA51fc2UlRPcsr4UzyfTqzgU9I3GuGpmhXktW0tZhcreTBfZuZ7BxXb
	 kvRCK4XiZYENPOOEFQ7xJYVD50gKniZg0kcwqK/RxH4hLuWTeEtqGMDNl7dGGnszgsgu6
	 RGZnqGbuud5qWyRert/3TR9NE7o23AM2CQ7VDrkQACyQyTa70qjBSqY8WMO9yN8qdgtIl
	 h1/uvg/ujxkVd4GgLo7u1GuDwQF7h3D9Ci/poHDZ9kH7mbrr28taOOAi1WBo+ido1tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9W+DTT7utNSnVqC6bwr/w1JFNBOCCoPsQ5vTagR6BMY=;
	b=SGlVWIr0Qd5DBLXJr37JBUr/rooQPkG7HNNKzf1Cm/AuqjqFeXgEycDLFu55NIiFsGmw
	 +F1DqqeM26Bk7pmSh5MpXSTiFzxvfu8PhdF0AfmHCVYsu7WKwaJbbvrawvjmUAPfZTJcs
	 7ZWV73ClYnpkSx5DwtpFoVY42hUmVA24JfiDMRANmeSqYOT/hOWuWMYtVqTEUL6FDaCIA
	 9Mk0WAG8soyB5D+dN8BNrFYM9/s15H6hPhNKlN1BznApcJm/43zdblfvkjgXvchldYXTB
	 z9yw/AEfoV5/lbZPhgKl8Cxp6cciOZ7Ez2Wnp8xI24BmfLGRxqOg48OOhvh75I/ok4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v7zCR4hX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D12606A31C;
	Wed, 18 Nov 2026 22:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v7zCR4hX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A9F1F000C4;
	Wed, 18 Nov 2026 22:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042093;
	bh=9W+DTT7utNSnVqC6bwr/w1JFNBOCCoPsQ5vTagR6BMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v7zCR4hXwXwJrRVMQEGIX6+3ULTrGwBHagUub46Jg1/kU6ux4Frz2Gttb5Vw8xfV1
	 Ya+k79IDjbu1lozAnaxIbOY3t8jy2ynXxSyodxKx76bQpGeP1M4AftWo7xmXKZW3op
	 8onIA+ibzVp+k0TPtDXebFpqj9+JJbRTWr7djgK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3047/3318] nios2: ksyms: Declare __mulsi3 export
Date: Wed, 18 Nov 2026 16:01:09 +0100
Message-ID: <20261118150451.566056949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



