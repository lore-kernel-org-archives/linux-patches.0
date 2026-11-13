Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590104;
	b=sY3jT+uqgU0zPJn30/7Npr7oEMjdX4VK9EgLtUJvQ8FJVw0y+En3SOms2GRzZY73CnTU
	 I7FcTYAGEKA0CJdSeBeIBlkvz+gBdAW0YpY3oS9VgawQcHPrFxxDgo+dEb/1QKZqIrA5L
	 l1A0fOekZ0avmDVpLtyxCItGsnox9lMzsZrHpCrrwprAtxo4/IbMnmqCWsBdjCX2QFc8n
	 aOtu9/a/t0zXRFnxxH6RtbZ5YdwVOIgDhWq4DZkgd1QAbEAiVCXn1XMKUfCOoEEKsRqM8
	 /Vhhf4c7DvhD4tmLzkUYaYJXy9fTARPhhgqZC/b7LG4RuNun0t5Jb/b88AYclhUXnkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RhrHNYwynZykTgqwhzMwROI167+ZYQW1qAhY9hXhpzU=;
	b=l3Dwi54IcuESp3OSEXI9UhtLxAzjj0UUYz517GQyHsdpxIBN+VK14zkh05WUlM+CjKCC
	 9MjNX9COe+9DF5KkodT5mvTYrmSXkee9azyaLP9pefmwNQBBYQkt2Hs9fRF9+M58zTHCt
	 K4W/ngn1WyqLxmFD8EzpzzBdfL4hBZHqhRiWgJ+2r3NKNBfE+iww+T3BCNNMxnB+t1IT4
	 rWbikS7qNngXoqEaUwWtFHD5qAC7hlOrbhCO9UANJYhiJeETrFkbANKQX7alumf0zK8e0
	 sTO6wYzRxFxDmAzPMnC5EQHHSCN+1Pj1tq7PyF/urswaSjs/2rwjnag05V8givXmaEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NutNBsbB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2B360A383C;
	Fri, 13 Nov 2026 17:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NutNBsbB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250891F000C9;
	Fri, 13 Nov 2026 17:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590104;
	bh=RhrHNYwynZykTgqwhzMwROI167+ZYQW1qAhY9hXhpzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NutNBsbB+csdr5nhYhdd1zVHapIXEwiQn5GG0N1lxA7d2m+7ERu/7c+QS77h2BqjE
	 jXhyqOqN9fKLV1BkIhCU/xRKASsl5e0XyXbbwxZyZqP75KmFMXWJe3nDV+h4CRnAuh
	 Ba/Gn1YN22ynr+Y9WhuXjiPqSO3zexcNJ8Mh58AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 127/686] netrom: dont convert the maximum number of tries to jiffies
Date: Fri, 13 Nov 2026 10:44:20 -0500
Message-ID: <20261113153825.124040176@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

nr_create() sets the number of transport retries of a new socket with

	nr->n2 = msecs_to_jiffies(sysctl_netrom_transport_maximum_tries);

but transport_maximum_tries is a count, not a time in milliseconds. The
result depends on HZ: with the default of 3 tries, n2 is 3 with HZ=1000
but 1 with HZ=250 or HZ=100, below the minimum of 2 that the sysctl
itself enforces. Sockets accepted on a listener copy its n2, so every
NET/ROM circuit of such a kernel gives up after a single retry.

Seen on our nodes in /proc/net/nr: n2 is 01 on the Raspberry Pi kernels
(HZ=250 and HZ=100) and 03 on the x86 ones (HZ=1000), all with
transport_maximum_tries set to 3.

Use the count as is. The other transport values are times and keep
their conversion.

Fixes: 4d8937d0b113 ("[NETROM]: Eleminate HZ from NET/ROM kernel interfaces")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 16eb00a80bb05640ba628529fd258e4ddb100ecb)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/af_netrom.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 6de086082f71b..e3daae77e43e5 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -459,8 +459,7 @@ static int nr_create(struct net *net, struct socket *sock, int protocol,
 		msecs_to_jiffies(READ_ONCE(sysctl_netrom_transport_timeout));
 	nr->t2     =
 		msecs_to_jiffies(READ_ONCE(sysctl_netrom_transport_acknowledge_delay));
-	nr->n2     =
-		msecs_to_jiffies(READ_ONCE(sysctl_netrom_transport_maximum_tries));
+	nr->n2     = READ_ONCE(sysctl_netrom_transport_maximum_tries);
 	nr->t4     =
 		msecs_to_jiffies(READ_ONCE(sysctl_netrom_transport_busy_delay));
 	nr->idle   =
-- 
2.53.0



