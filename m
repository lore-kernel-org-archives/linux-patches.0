Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041546;
	b=OKyS67lfLMNw/ICs1MISCnJUjLkUzmtYPYyd3j5SC22MqbWZ7hz17DhCNSh9KMuqliyu
	 NzMtgqpjLe48Es6wdCvjqgieZMOhyZRQr4GstBmuboBHCowxOjIlbMu2AwC3FX5VCL/oP
	 rXfyhXDp8C9u+YXA31PKlsg6u2jrE4N2v9AYit8h8OrA+Xpl05eokd4OcwOC0UUUnFYWm
	 Lr0xnTA2vKaa8r9QYDtbyKs4pUnA1ZMGw4WiTxxrboylh45SlvllyFz73YybBBAT7Gkp7
	 7vgY/MpzIi+kPFwcq6BZvVyeWySRjE7PaBlbfPdfyIv07Gmpw5Z138eeDEoENiVzOqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w1/iukNKK5xvcQAPBgyf/XrzpoS4IBY2sSLt52cfuOM=;
	b=cHtThebf64AbwjEmuOz4RMoMPh6tKt1+85n9m5CEoeCjBnVE5hGBoSRNGGHjcRub5T5H
	 KRwmNjwMP5u0I3zZuq9FU0oqR3BEeBhb1KKvNI9VKFSPwo5bHu0T6Bkiel/2KAb4mp0/7
	 8oJ/AS5LknLsoGiZvaBitAFgizt3engrbvHpFwHD6Kc/LthYllo8NHMOWqSdViXaacMg6
	 OR6KE2FzSnlAtxX5H3IcqIQ/keC3HxTifu/TDtOyXZ8JD3p2JV1mxzeLvep5ca+JJFers
	 4Okhps+4w9yNJZdgi6TsCFxZ0nPquCXdntMbPZ65q44SxoaYoND59DM2K1HbI+wiFBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IJJQmWj3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49919606A32F;
	Wed, 18 Nov 2026 22:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IJJQmWj3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9461F000C4;
	Wed, 18 Nov 2026 22:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041546;
	bh=w1/iukNKK5xvcQAPBgyf/XrzpoS4IBY2sSLt52cfuOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IJJQmWj3ux7r+dproYRFFrkiVBApJUysRlQQ9Rj3uuwNPYeyy4evsW80xDS0LbS8A
	 Bi5ekjPK3dBJVDRH3qmLSCtkyWPDxwotdRUsnrTsk3TuFSV5lStS8XMEnHblu7rIaC
	 KbjaaNK8opQTxW00TE4pKBUwwjkgm9rlTH8EW2Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2801/3318] bus: arm-cci: Drop CPU node reference in cci_ace_init_ports()
Date: Wed, 18 Nov 2026 15:57:03 +0100
Message-ID: <20261118150444.706770688@linuxfoundation.org>
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

From: Yuho Choi <oss.patchbox@gmail.com>

[ Upstream commit 41d6c0fcd4d75bf78c304c6660d60fcf757885ce ]

cci_ace_init_ports() looks up each possible CPU's node with
of_get_cpu_node(), which returns the node with its reference count
raised, but never releases it: neither when the CPU has no ACE port nor
after the port has been recorded.  Before the commit below the loop used
for_each_child_of_node(), which manages the references itself.

The node is only needed for the port lookup, so drop the reference right
after __cci_ace_get_port().

Fixes: 78b4d6e0fd26 ("drivers/bus: arm-cci: avoid parsing DT for cpu device nodes")
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
Link: https://lore.kernel.org/r/20260923163536.596107-1-oss.patchbox@gmail.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/arm-cci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
index b8184a9035837..ab9b49451f8f2 100644
--- a/drivers/bus/arm-cci.c
+++ b/drivers/bus/arm-cci.c
@@ -199,6 +199,7 @@ static void cci_ace_init_ports(void)
 			continue;
 
 		port = __cci_ace_get_port(cpun, ACE_PORT);
+		of_node_put(cpun);
 		if (port < 0)
 			continue;
 
-- 
2.53.0



