Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056133;
	b=001Io11CighvxPWsrEDHtswUJiQQkPV4cLhG4523P+VYFQPp/PnRMV8N2iBRlLBillac
	 7TnViW69bVgRJbEPYk44j9GnKP93k7nTpSddbTVB9zupJSZcPQKCmGdfl3n8Kz6EBGP93
	 u7N8Bc1LmeC2vo8BmrTTMQysUO1iwJW0lAl10wQ/bu6++olNiBP+diMief9sZWvkjZ+wL
	 4/AswRClzctp4e7i2OLM/vzuA8to1h88GJehME9E/FF0zXioUVKCucnwVR/xI7qAvuHsW
	 UtpxpGjdSUSeettBc+/qPDTdhM5ooXDYk7GPZ4V8FNJd/ugzZpzts1FQH3HWvwRdIXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=61gx4EOGanLYi+7ZkwRAJAsWnBJbpXTzETuPynp14vk=;
	b=2I5WCFv8UzoYGsF+/k+bn+CX8YzyVUWTZ1ILbOLQSs5mjckWx3/dlHludEhAi03EPHXX
	 IuwVuYzz1lLSAa4X2Qu19anWcLZ+ltREL1C4pksT37D45c6L1N6eMhRlrIVV0BI38rwiQ
	 cd//8ncOXAKgshL81hMtjuu+JLvrok5G7M8CpSoJI7/BdD28us1zZ7Cf1bo/Sp5ZzDPB6
	 /iS59ZfcN9Vutv2si8EG8L2GbrR/Lc6RKM+VPvkD6fwI0JfNs6TapABoKbHPpdm9R0SMD
	 tgK1/KjLE/VCEBYU7NDaiwxnSPfPhIQNja/4Gk+pDgC55HkCe8qRMOVfGn+00G1woDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ixjYJgB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A02606A32C;
	Thu, 19 Nov 2026 02:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ixjYJgB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5BB1F000C9;
	Thu, 19 Nov 2026 02:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056132;
	bh=61gx4EOGanLYi+7ZkwRAJAsWnBJbpXTzETuPynp14vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ixjYJgBY2T8SEDF7aoG9G4yAbmLDXpTiH7S5aw5vwCWtARXwXlCm8AZkKQLtRjp+
	 NA9H7LZ8ZBIXkB1DuaVb8TYrSxO40SGQLfDv9/Eos9V4LDAvGjjQAzehurvNglbLfs
	 Op4PAi0jCRWv+A9Au0H/CbHLxbrXfuAmsGm5W1rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1879/2214] bus: arm-cci: Drop CPU node reference in cci_ace_init_ports()
Date: Wed, 18 Nov 2026 15:59:15 +0100
Message-ID: <20261118150126.427734734@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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



