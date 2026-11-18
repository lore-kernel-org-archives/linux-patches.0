Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041666;
	b=3ewzbHBwy5w7P+qCnT0OcHO3+yGj3zZwhKFBQ8rDlVRK3xT0A/kxFiMMEWweBZS6YbXB
	 GhKfbEPQ+U7ZJ+BxMY98kO57/3Kk+ZGytHEkfayxYWPpNd1VHMm0Et7bgEnhW5wrsQwLM
	 F5KNZUSWMInqOOxvm4eTi+4giWoRysk1NLsgK4ro4cpmMdVyXVNYlXGQ6RoWJ/MPFvGY8
	 uBr1U9K3GZjXsiEIuYo37sdVWxQ05qjpFWbZc1dW+Mrl660YpDaX9SYSPu0RcY5bOuSvb
	 ur6/CsZ/ljkLre4klmzZ5hsEfs0XlNpBiRs5C31nf7adE82vG/aARtEIcKWm/kSTcNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x+RrjSzstIPb0qXJfaaQ6tGQFVVjVcPmRu//HPp3/Wk=;
	b=UJAw1URNrRXl0/Y0WGhk3A3DyqfJEH40qHV2jMp65jS6WQfE4WJWIBvmjPg7bDW4p33T
	 j/jadrX2C/f9jbAAOwMZiqm9ml0au3vBgOgAX5+kuD6C1qNundt45x90aNBGsUj/N6l+B
	 ojfxSgp+8E1mXWGQ4nrr0L7h6djELROJjkeNSsoksYvaTyEm4eJzGNDV/hxv8IrYQlscY
	 kH8XmxEh/NfQPHiPzk4AlWAL/FSL1OTvOIFT9OOMi8gPtI6msPD7ZI3DUl29kp6NhhYGX
	 ATwkm+BOSCZeD96SWhZ38OJfaFk6HIM2G5jUo63/4wMUqNWRvCyi21ZD5ZdjGorEuDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRAn+Qv3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B99606A31C;
	Wed, 18 Nov 2026 22:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRAn+Qv3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EE91F000C4;
	Wed, 18 Nov 2026 22:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041666;
	bh=x+RrjSzstIPb0qXJfaaQ6tGQFVVjVcPmRu//HPp3/Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uRAn+Qv31JRid+la0NmSSRH8iHcTkUSq3YyQ0TfOL71AAMh6XbcZLMnzQdcb23R/X
	 Fua5Q2EB21M+s9sZzeav2SzTnRyHR4OO4A8fDKVzsTA8SKUPhg41yzCr+dwrIINRUW
	 PoQ0nhHe/hw+eRNFcSVC1wBpe+Z4QZ/yFzJYi2l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2853/3318] serial: ma35d1: Do not force-enable an unselected console
Date: Wed, 18 Nov 2026 15:57:55 +0100
Message-ID: <20261118150446.192515603@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 171bb8a67cc1af7c88a65961adfb028430e0b783 ]

When another console is selected and there is no matching ttyNVT console
argument, the core accepts the MA35D1 console without calling its setup
function because it has CON_ENABLED set before registration.  Its index
remains -1 and printk repeatedly reports an invalid port, flooding the
console and preventing boot.

Let the console core enable it after successful setup.

Fixes: 930cbf92db01 ("tty: serial: Add Nuvoton ma35d1 serial driver support")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20261012055340.16719-1-kmehltretter@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/ma35d1_serial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/ma35d1_serial.c b/drivers/tty/serial/ma35d1_serial.c
index 225feb5868e85..7618e5f156fea 100644
--- a/drivers/tty/serial/ma35d1_serial.c
+++ b/drivers/tty/serial/ma35d1_serial.c
@@ -639,7 +639,7 @@ static struct console ma35d1serial_console = {
 	.write   = ma35d1serial_console_write,
 	.device  = uart_console_device,
 	.setup   = ma35d1serial_console_setup,
-	.flags   = CON_PRINTBUFFER | CON_ENABLED,
+	.flags   = CON_PRINTBUFFER,
 	.index   = -1,
 	.data    = &ma35d1serial_reg,
 };
-- 
2.53.0



