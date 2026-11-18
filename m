Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049630;
	b=wpZ0UJTT7gf7gy70FDjY1ngPFFlDbemL6v15mq9BYy+tT7nKz4K+C5H1nihO6DKElh2b
	 7645IFk4EmAi2j0MOXK3+XZmOAUrJZbBG7K5h68IbYCFCIqk/iVN7P6FGZg/g1kuTL9tt
	 fjscPyabY3LoFHad2CBB9Ejp+k0eoowa9E/UowYMaazBSTcaIh+9yrBveAw1WTWi/dUvl
	 oNiGOOphaciJR3wJAn4BNiqTqOOrQmIxVKBse86UXC8DPskjpTtoDPw62/ejNrCPrOF28
	 cw5WRSsQvUQwrzWaj+xWSauC71gzkrTStXe8jn5lEQzRXe2eEU8SvlQIi7fSXGjlbNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FTFjPoxQqgrwcD7zigcvHlacsddjENNIcRO8uLOSiRg=;
	b=tdXbVzvzm5nXysMvMwzUdTWW5H0FILNLC4NPd1mkXMWLfsZegEcQZHcQ3M/AGny+QaMZ
	 Bu4dEiA9Sao/5YVyxknl4R5y2MwuGCc7xM1jRCwTQa1yG+3z1h+e8ngP811As2ciMxjll
	 xFYzaPwziZqbqDoUk6PmSH5Eb/4mGir2P63hnjfCww0bSrgumdG7JflRG/XD5P044niXE
	 hfnr7/olJxWeJ/B+SclC8t78TlTP0fQqLriq8PmR+dbEgQS+ww6AsNIfgB9FBv0b13FEM
	 lNNHTLKrK3XkaWxTfR4uQEYFd0et1m1UC8b6kltVwEzzSlh9ig3m5QPwDmgvRS3z0bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K/IhpqVk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA333606A31C;
	Thu, 19 Nov 2026 00:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K/IhpqVk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8EC1F000C4;
	Thu, 19 Nov 2026 00:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049629;
	bh=FTFjPoxQqgrwcD7zigcvHlacsddjENNIcRO8uLOSiRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K/IhpqVkKmHkN0Ix2qILZcqdwr3f8moiw7PczHmv+MIbG01Iyjzr1QV4noN+9gU5c
	 r5zfu5EBQ/pfIv2q5mIew5suKSOBqfGID67wDyGeDoORzZ7NzvGWOa9ukum7RbJrg7
	 R0xVXbbzKd6ITuJY6fuNwfMfolH/Jj71wMXA70/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2421/2857] bus: arm-cci: Drop CPU node reference in cci_ace_init_ports()
Date: Wed, 18 Nov 2026 15:57:35 +0100
Message-ID: <20261118150328.725976862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



