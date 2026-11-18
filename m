Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031897;
	b=3ld5k1llF9deZRegWkm/TERSUNerHFy7qEWuTRn3lyHTLH5KVI9Mnp+yHGSYYxCV4t2G
	 lGW9x0D9RrV0IWtGCNr2Yym1Bz3dwPMQWxWXiXIS1e+vN66feXVuwUN0wFE1RJfJ31s+G
	 0FTKjMVWXOmzwwVBVImeZYijVNO/M6D/SIP2RrkNEjRHc47nQgxIF6dR+bt8NaonYDfVm
	 es7MmKbgylICAYXlRZVMzIdIAUAU7BJHkAsIcaqPjzoE9O+ZhYGxVXnBMOiowRcLmSBVM
	 oHfBhd5EK82ZjIKN2z3QIb6cqaAc3L/RpoB3Py8NzGK50PmVormlondnkAs9ewd7MAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xP6uylH/sXJx0RQq9oWPjvr+kcCN4bMRLWdVO1ha3G8=;
	b=Id+whwnL4MDwr7odpBmkp2JfYHcAulPoxmcVgNtrE46O3knw5N393hCv8FSqnOqHLHGf
	 zcCxpNqvDuCyqyvOaup954URAiQPdUvxrGGDUUXooL5pJ507sPB4Tt3EUHyGC5yVAc0Ls
	 Gxi6H9+hkd3l0jLo314tZejOMgT/+xz/YZAg8l2nnEfF94ryMA9fZIZAusE+AAtfIyYyj
	 +I6Mwzr4Po5o7a5svinUh5zI+XayH0rrBQANgC7uEbXwDOB8cmMDzTLne5gfD8ZVGxTp3
	 VRNxkScRmokdu2Eg2GW3W7TsLvqt1LaP7v5O8krNDhOlzU7LaGSl2euQwCVGAy3aDvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NupzhKyK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25704606A32A;
	Wed, 18 Nov 2026 19:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NupzhKyK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793301F000C4;
	Wed, 18 Nov 2026 19:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031897;
	bh=xP6uylH/sXJx0RQq9oWPjvr+kcCN4bMRLWdVO1ha3G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NupzhKyKviy76og7PPeox1mXWV4JTYHHek2bcggSxjzoQEi5YsQ3erAbmnzaauAU4
	 MHAZ4b9GYM/SLOJQXbrcOr5WqAl82hqQtdDdeg92mCLZq5YswcY+PEyeCNS8EjEvkc
	 LKGLJBPgtH3/4eu65WgKGmxWXang4AQPH3sqQGYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1193/1756] serial: ma35d1: Do not force-enable an unselected console
Date: Wed, 18 Nov 2026 15:55:20 +0100
Message-ID: <20261118150057.363733613@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f3e349ddf29cb..288115e3cd12b 100644
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



