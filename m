Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050325;
	b=HchzrETMZvQUTiurGdTH7VYJO/1kJEUOq71MmAh15dB90bfxP6b0PK6SZ6BgIlF0ph/B
	 dew4Q5GwJsp+lyo3aqJRHJZ298Xrqa3E5Ipb8w3yskNO4cYy88R5cmQiRmnq9VB3ubn1O
	 eeM+hJqWushhxMcQ+0BXPM49QLY/qQ5LJvCF9da4kx+7nVmAl1NObjP/e6mKR1FjO2Tf6
	 NGl4erF4gPcD1TUMQyVNAne4pTqm63WVEgyC7GdG1YNDy9NmqmYhsgp95L4wgFAL+j5rL
	 1Lmprmmrjs0/XytMLNK+twCf7Ph5+ffmGz1ATCfhUrQZKf8chbQdg+ILdRNgYpeZBtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=u2IxfjYiqqyeLtDZXcEOIS+CMAchI9XpNCFjI7ZKsdQ=;
	b=DlSFQ8oHEgEW2Knu1bloYVgNWgIbzoPRiz1X9KGGp4oK8XyGZCis0/Ndkv1RH0FJQ4/N
	 RIHPdKg/UB+90N3IqfGBTIDknYuHiwqAZGptywDQfXNAW3V1IVPKmlVsD+qvdkVO21MN4
	 97qrVkUz/FVdAY4zDPc11V8lkZezcTAt2eNpwmtAIRTIMmVMUjZrHzxn27mFSeeNKvSba
	 b6QfxmKAnj71+CXpESdlmz7GhlWjj/t3qELegwv9b/FqOGePO1LtA2Tqup6MX6IE19iUg
	 b7u+5bK7Y2esNmIVVAZEBs5PUU+GHcJWfkyeykMn0bhmIG5DasHZgU7/JJWqlEL0+9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J3Mr8/eP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A673C606A331;
	Thu, 19 Nov 2026 01:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J3Mr8/eP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0354F1F000C6;
	Thu, 19 Nov 2026 01:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050325;
	bh=u2IxfjYiqqyeLtDZXcEOIS+CMAchI9XpNCFjI7ZKsdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J3Mr8/ePvlY4sVHB70O7NsAy1AEDz31VgFiUI0IOP0Qx1nRTIN0pQkL75c8ryYi1q
	 kq2dKAIhT/axRhFi4IBmYZLJx45iid6ux4/L9ezPWobKE5vnm3AEk3oamIxBYl3+Jd
	 n92JoXkjX9FeB/dawgNdKtRblNImwF6fKqtfTNzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2627/2857] nios2: ksyms: Declare __mulsi3 export
Date: Wed, 18 Nov 2026 16:01:01 +0100
Message-ID: <20261118150336.174750076@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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



