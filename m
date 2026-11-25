Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622511;
	b=lcxq34AWfL2oJoRmOQ62UHm0cW4Edv/5m0l0IbbqL6pkpnBVpJvW6Pq4x1EHixipS+//
	 owGJYQxfPasJtMtyle1sQ2XNVYdgAx9/ojyl4UbPNKJp3FcZHaeUaphlNjG1mztCqTayM
	 aWAsOf9D8l3xreGQtMLNQPRdGeRU7NEhlWB0F8HpVfaEKjBp8sveIboDEYo47y1UIykUs
	 nFiOj+1AI92d/y9bF7eqI04PPUoCyD6w5xsYCLAERhwpTVK1wKEv5FR8ByZH8LsHf7B1i
	 4N34TERg0uiboW8ba+Ta2mprTK0nGWWzXBRaMz2fdzVmVjEjL1YS+kywZyd+tfkC7oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8+mY4F69dH0v+37rNKOFkOYeLFklWj14x5tzvzgV/0A=;
	b=AozLLRA/gDVQhK5rMk0E1XbC/93VP3WWOrBEdNDfKW9jjYg304clUm3YSj1paeEs8VDh
	 ud2O44s972CPx5f6c57uothZukYBZMeM1rS+eAB3YdG8wXkMRaw5qN9zFw3sLJoHI2FTY
	 RUG9ZoFR/qbSU478yk1AhRXGBdEiC2n5HbE7S/NXIg+ISIBwJfpB0hnN6HL98EVOxIu5A
	 5t4MIycRJ5W/NRH42c9acSeoDSvUKRGREZ5I4JKgQrT4ywPCS2mUcTJPGR9iZFTMaQ2fq
	 JI1ewuTlvo+s1RGxrVAqHKDpQqa13Ydt3k2jnvHkci7Z62OJ9GD16cWYUH7HkwJgLPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1uRzLctG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FF9606A321;
	Wed, 25 Nov 2026 16:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1uRzLctG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A851F000CA;
	Wed, 25 Nov 2026 16:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622511;
	bh=8+mY4F69dH0v+37rNKOFkOYeLFklWj14x5tzvzgV/0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1uRzLctGlv9s1TMNWBxD9VYg5DnhBYWqHLHPorz+SNMP52dGaIVgjuRyqXXFkkjhO
	 exRLXOza74qKtU6F2BylxzGWT2whDMIGKDMGnPPHRI41w5GXnI1uwN4vO+yGiUQ+k4
	 YeWJGgdFhtP0Bf/cdgVn8C0kFGAsnnePVQIVzD2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 562/990] serial: 8250_mid: Add missing module namespace import for SERIAL_8250
Date: Wed, 25 Nov 2026 15:32:09 +0100
Message-ID: <20261125143835.262872571@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 789f52f83305032ecfaaf7efae9a8ba75815c01b ]

After commit 1c305d5f1daa ("serial: 8250_mid: wait for LSR tx empty
before setting termios"), modpost errors (or warning with
CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS=y):

  ERROR: modpost: drivers/tty/serial/8250/8250_mid.ko: module uses symbol 'serial8250_wait_for_xmitr' from namespace 'SERIAL_8250', but does not import it.

Add the missing module namespace import to clear up the error/warning.

Fixes: 1c305d5f1daa ("serial: 8250_mid: wait for LSR tx empty before setting termios")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Link: https://patch.msgid.link/20260927-tty-8250_mid-ns-import-v1-1-84d0482e1c5d@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_mid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/8250/8250_mid.c b/drivers/tty/serial/8250/8250_mid.c
index c02ecb96e8b6f..47f820fcd1a45 100644
--- a/drivers/tty/serial/8250/8250_mid.c
+++ b/drivers/tty/serial/8250/8250_mid.c
@@ -415,3 +415,4 @@ module_pci_driver(mid8250_pci_driver);
 MODULE_AUTHOR("Intel Corporation");
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Intel MID UART driver");
+MODULE_IMPORT_NS("SERIAL_8250");
-- 
2.53.0



