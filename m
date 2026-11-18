Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020135;
	b=3a49fyn0BU2cKxtu8un/4sMkmcl19K86QadoIYH4Fveg76C6TdRsyCwpAMWXBcBQsplC
	 Or5pJPwFJTcOIqNAVEr/56fWkdMrPGL6RtmC1bpPDeR8xgOWs2s0iZmF074qJtxvW4/+q
	 BNNRLHjxOxz8utTPlU46TkuM0OdLUFSiMumNJ29vdI0Wsdi/zbX3+bABE9Kpbf93L5epp
	 5SMlz4PtBLSDBeLOiwsi/6clNvQgssGgmJA9LSC20FMl9vueWoCL9rEJUDlzSDOLUvXa6
	 tceIns3tkZXzC1DIkjBRH+O1oS2k51ywXZ/30pMIgAeodxTMLsUow9t3D/MYZTXUvfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A/lCUMbxq8+zmvOxJBaCjRivq3dq2NuAzD0iL4B6uXc=;
	b=J+TWfk5CJyTJbqfL+5ysIeDFZ8ohkr92p10JUY9shJ7/NZomNnRo4OUIjTxqmPHdPf8C
	 MTl+pYX/kz1ZzBrIEj97g+1mAYn07llQlzcO/rS+vh1qEaRYGRtgpnkl4fzUuSjEOyajz
	 0PgL8IrDxHk+lDLYsDLCZavqcirK/q+jbYOa6+g3coudnDFtszNBsnApkIUqYFedU52mA
	 cRCZ51l3wlQ9vOv9Lqz7WngbgEaIGWdPOZcZxk+4UtHcJMGxsZjbCDPgQSYhpUWiCg5Rw
	 ZH60pwbdSCcFc/D89u5SAX57JtGTYlrzjC3U8tsM/izKnt8Vi0EGoY+leFdN1jMr3aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cf42pUK5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760ED606A320;
	Wed, 18 Nov 2026 16:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cf42pUK5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7C21F000C5;
	Wed, 18 Nov 2026 16:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020135;
	bh=A/lCUMbxq8+zmvOxJBaCjRivq3dq2NuAzD0iL4B6uXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cf42pUK5tUG0sFT7RAz5RVIMHuT/rDzDiR6V2imjrw5TpveV2vIZsJEs67CnsCYT0
	 DDYRFDg7B29xrcV1YD4KcFbjzaytejPl8qTUOiZDzd3zRYgZAxezJAkyYsa2YjMYzb
	 hL/Bj9L3Y+89RlJ+RDQ7ZmyqlbpyrFatoM+PFxNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1845/2651] serial: ma35d1: Do not force-enable an unselected console
Date: Wed, 18 Nov 2026 15:51:25 +0100
Message-ID: <20261118150353.480583575@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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



