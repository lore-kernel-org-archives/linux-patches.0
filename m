Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026628;
	b=Qj0ftIf3NfNiI2eMjnf2sYT59weK2orNPPoaXXyKOzi/933HYVgiQlqQP2+QMmviPg43
	 tzomOCNh6EG0rvZRaUA6ev0IgjBaHYzjYuKJMfTIRKYn2FPcAGYW4uOe9hFW38b192pLW
	 dShoPV5N+FqSDavl/18eeHra8f0pCbSMrs9Csh/v9gNEKS4e+Nome4veLGSBdQGi9HXEw
	 sEHjrnV5PeowfGpBONM+4n9XGUCPIhyZXdHWXDVu2hcsUw1OtK85p4+QVK41YDpSvGRTw
	 WYjQTSdlqM7fv2KaxnX8A/puQhjSX7/L6zws7VgjBgm1ygmXcegd4UGu8D/BaZlTBKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h6DtUUZ6MDj5TbDKQf1YIz541RgVmu3UyNIrx83fwPI=;
	b=EAailHzpE2RW0zai9JOadytJT8izUdY8IH9d9kJOT5uyV8pxq2eSELk4ImMPNLHDq8Sp
	 ilX5AmMQXuhcoSr87ePqF2ZeVBgy+64bDZ4er8PTONEKrmBEScNlw9rnfjzfMcyetjcyr
	 4fPQChuBDjQyY1HLHqvbvK1LoROf/QZ+5PnjGWPtaDXT4/w3YLdR7Pvqb1qOL/B9eQ+4/
	 +Pl7//VMofa4KXu0r7tzTSIEXm1T9eOAD5aspX7FIIEJZfEWIDvKwndIwumuIDUv51eKZ
	 ceDtSdRmeSNELAEtkCSc+KaXCM8tgToAk2qwCwFBFQMN2FYQjC0Brfi3kUqDdrIrJoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0WEwingP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647BC606A320;
	Wed, 18 Nov 2026 18:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0WEwingP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31911F000C4;
	Wed, 18 Nov 2026 18:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026628;
	bh=h6DtUUZ6MDj5TbDKQf1YIz541RgVmu3UyNIrx83fwPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0WEwingPf2wphun+bAKEe4Fxg2BxrFXPV7YIrxfmf9SzrA7jGsK20iIaN0EY+dozc
	 MaWvkBifnSDQUYf9VSVSTKF3cBkfG11zyZLFtFz03eVTo6Wtbj1VFAtV1oF46svT8Y
	 dxmfbKh1B/wmU7n0tTPZhXuYI6jgVvB1F38m8Cf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1501/2151] serial: ma35d1: Do not force-enable an unselected console
Date: Wed, 18 Nov 2026 15:53:56 +0100
Message-ID: <20261118150216.548434782@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0809655f43959..3be30fb055131 100644
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



