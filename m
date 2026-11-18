Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026527;
	b=03cBLH+lBsEVfojOQ8FZlcesj1bykBv6mGy4F5xWh/tMRHVGXxYG8LPz3iL+AQN+8eSb
	 1lNDdtYz3RpjAEqlVvD1kynMRWtXolc1vc6NL29Wt9/76dJKtxfXm0KUvs/i5Vgjn0cH2
	 T7k3iRo42lW3vGAZuDwjZav9HCC69adtGpwb4rwVMuPJeomi1yoDcFkoq18qZ99yMH+GZ
	 BMP/msHh/HdBpRTCZQ/zEaw6eKSYJbwec1bVy5uRbYOQL7iCVDIh1SDlI/bcklZ06a9Yx
	 wudf1JR9/zCBzJJsP9OMMGk89GSD0uvLziXaFZqL1rcnl9EeArbey/sCJ3bS37Kr7hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5QicVRaAipwIkw05e6EYdhLov/BKgKxbOQcYLdVrK5o=;
	b=gKuXKv67oW4xK0QOu3/XQw4Qkgui7cziNpZIIgQvt22IGfT0K/+vUWaBzL0zUFat6gVf
	 irulI7P2g+LGYWTVDy9xy+4VARLdjcS9YUgkhJu9qpCaS6yr97JwIJ7IX0J1F5fQBl0E+
	 kSU2hGt3JfphWEwt8rjMUjWhr8XVmIZqmgthdolvU+Cgd0J/RwYbWkFxcgahTUD3pbj/O
	 xNje/HEaG4FHeaD7Do1IgJA/3tXdQsQrLv3AuxWGT5ajLviRPXEjyhlPFfTJFXtsZMjTR
	 GcgmYc4MR5J9E8D3ElPS01ZIqK1iQLISspIouaFeXd0gxaYwz2HTUJf0+c1DVIJPExw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJvvfVSp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35136606A320;
	Wed, 18 Nov 2026 18:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJvvfVSp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884EB1F000C4;
	Wed, 18 Nov 2026 18:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026527;
	bh=5QicVRaAipwIkw05e6EYdhLov/BKgKxbOQcYLdVrK5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJvvfVSpEd5aCEn6JBUGMspMi8l+KaOrGPHN25QsHInBqshQ2MiKS2nMke5ZwG2cR
	 CQpY3uegm/fW4ktrWWXHjdNGJfjAWQVLDyW7RmRFVixofc5DngMXOPgZMlSoEBTaK8
	 TW+yd4m5oFcjP3dYNJ7Pf8KHVkE8gOUJPMPZ9h34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1425/2151] bus: arm-cci: Drop CPU node reference in cci_ace_init_ports()
Date: Wed, 18 Nov 2026 15:52:40 +0100
Message-ID: <20261118150213.862519752@linuxfoundation.org>
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



