Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031655;
	b=S8xgtTnJFtmnuLtJWEUNckEWRXRgxP81ffadiGF8NA/YQjxzCO4nPUm1x2q/4Zt889uO
	 Rlkpv3q+mMrCvkwbk1pIWpn/a9tWpqly5vwuyrX1WCkNwmfrMErCFMNtTfKOrur2B03yg
	 g6tpZ1kJ7lXKGeFVhheiIeVAZgPoERR2WLeOyW/ZjewgVUoJpXAUuXr9siM7mfQWVoi4m
	 9g/VE8Ohk73x5WPDPyVnXSHxPeO5NIiL9mPfN3gx5/Jtliq4YwXi5IIpNxg7FWuws52pD
	 OEeznCsIVQfkb+7y92Oe5y+poNwR/tmngwE8hCWIotF4anhjYTEZjoG+4BuRvpo6HKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Weg8oDvk3OsJIe0dczKUo83UDFzKzUfJKAGVnXLifMk=;
	b=tBQoWglEfv5B2EiTP76vgnMZ7ukUmuSzlM5SFHnAF9WDobQHcpH3hdZfUx+12jur1GEO
	 K+w7OALxjiippjI4fKyGJhAYPlPPpB1uKa64Miqf/UyC9ianKyFXXvlIrDT4WwGPRJQuf
	 dX+dvAkLUdU5H0TM/rMS6Rzg8YvqLhpFwdkxkbbQffTUK5MfZv5+NvX5LChxZ9LoOleg1
	 wsmvUqWOjhoyhee8R1SfofkZ5Ro/swDWE+faCBx84JaTsqV85henos9DB8M73/XCjGKA6
	 hEQfnV/vkh4/DSAy2wslWFsMb323sdMRssRn0vKLg4hlkQG8cawg3yBYC1OZ/sFrKhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TZxtCR/5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51662606A325;
	Wed, 18 Nov 2026 19:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TZxtCR/5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F041F000C4;
	Wed, 18 Nov 2026 19:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031655;
	bh=Weg8oDvk3OsJIe0dczKUo83UDFzKzUfJKAGVnXLifMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZxtCR/5Q8deJHcerMNuJKnvafzBEC/N67nyWjPgU0EAQWKYR54nEEEQqzjbDk3+X
	 y1j32dVNkOFa9/YO8BBHT7DCHTLOdJwS0X7a0qzRGxzVeKDHqindh8/sb69eRygZ+l
	 UuwG9SEaYsMe09Br4/z6O4D83x/bcemGJlwY9/RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1133/1756] bus: arm-cci: Drop CPU node reference in cci_ace_init_ports()
Date: Wed, 18 Nov 2026 15:54:20 +0100
Message-ID: <20261118150055.176153282@linuxfoundation.org>
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



