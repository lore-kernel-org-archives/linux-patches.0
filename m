Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018053;
	b=3pdotenczkO0BIpcQbjkAaPWyvRbn8En4Wvjn8SSnjmtQBg29f98jnEDwVAm+WrkdwLo
	 aBT7d6iaxX2c/TFx/Cx9JA5NGftGMu2X5cEdi+SI5Uhssax37gVHC+6zA2yU/VIYJHV2G
	 kWr4LqHBs9kQCIQDM2k/yYgpV4kpKmasxEUIdtVEvTrCE+gbGGEGezTTDq0gVBLNt48ug
	 WbmXkHjwRlrlRwYqeDQAKWJAW668ExS9mOd3FofruGCkY96hjz38otrlZxtEUotb8d4jj
	 /CZdomaaHTjVHPDL+nXV4xDTW8EAbTPIhgtW+tvFOVITXqe9lMDUtw8hoPALKN6gBLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pti2Tn38dVlVzEzK98ntmRzI9y8rflxormuud93L/HQ=;
	b=YsY6A3T2X7tQWduV60/rdsBR3IsIZivjOs/r+qX+/O6qgBuyLlBXBZ4C8AGEfLP6Jwbc
	 oaT51L3IKDqsXSqA6omODzwhz+JGPUminKNuAkykIHtOVfXQyrikwoqLr/7KA9rzqnL4t
	 VSB0JA7atjp6N4uk/h+swzbYTkvZ5jAWrNJahqDrDXpulla0vnQj38QCbbftczNM3pyrR
	 QZhY0zKe9kzADwUIjCP57nEY/qpSdb/I5cysFBvs6BUjmbowSwFs3eh+N/8UQZwC9dipK
	 40q5TCb+oCqi6B2Oqr05sn3EqmuElr/KnFPqzUhBz2WCRtgxXHn9Hv/w0EpuHYDD+CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eDk/nRVP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C904606A31C;
	Wed, 18 Nov 2026 16:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eDk/nRVP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9E71F000C4;
	Wed, 18 Nov 2026 16:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018053;
	bh=Pti2Tn38dVlVzEzK98ntmRzI9y8rflxormuud93L/HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eDk/nRVPijoTFJr1RCewgTkeYfAoVVD0bOCzL3SQejsqEIM/j+xfostmysbVtfO4K
	 p5Ag6SlpGJa0YSuodsJDeNwKWFy2+tCMA9qhiqsPbKttRj8dGcRLgQL9pWDqv1Bbpg
	 R9FSJ4YHNXFI5XIzk/+GfLFJ+H/JLg9xxfvyvxE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1104/2651] serial: 8250_mid: Add missing module namespace import for SERIAL_8250
Date: Wed, 18 Nov 2026 15:39:04 +0100
Message-ID: <20261118150327.739982933@linuxfoundation.org>
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



