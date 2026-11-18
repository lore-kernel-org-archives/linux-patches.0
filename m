Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028844;
	b=k/JAVR+NaY4Ix9jme1hWOoPlTSpyKlLxS3CSlAUEYKxDGjPuyaQIzIDLvaBpnpTyT5gM
	 jjTrDtNJm0A8y6eFEr85qktbTfIb4uF0A3pt5iSYufeYvR0/rma/rP4pJPJc4o314lF2G
	 gG5NqlIzMsw/cE/nBPZWkd4RLIlb3XemCHZeYk4J53dCsc6MzbkhSCkAHWIyYSMDNBbDS
	 s8k5+CAi8yYPjhg1WOx5XKvk6WHdyOuCusGzp3DeZ3YebhNjtd1E/so/lJpgF0KBBxzUZ
	 Y+rs9FIL7gweQYWOZDLHAp0u3Ba/L52lSWnhx7f9Z2l37NnEsbYJTEel3YTkjYAdFiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lj8hsBTLVTb7HceVrVpAqHuMLjWr6+I7kUiBt4DVk6E=;
	b=bO+WgYSma/Cd5uHApl9P9NDKVRNLYJUVv/JiQIJu1aoq1DvsHnW8wCKXjk5BcAD6LniL
	 6Qey1LbuuZ1DetNZqMUGD3eZvO45nj6qzll9mQ4SGjuGPrgYKzpZPDToz227J7YaHl3Eq
	 bP+EtSeEzbkvH3S+w1phKWuvYWc83FKbFwtVVT/wgp6QijJPCB55liTzRTNVyo/0A1D90
	 4zIHLYu/2dX+0E6moDf8956cTmGs4E5NrRoU7q6pc2JlWF0lMx+xVyQHy5PTjwh2mOTgO
	 O1yG1FHXEI+0t3YbRRjveGjOBsEFU7AkwLLy2JOElfKhlLtLTzaIWF+uM8X8w+j63cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=azHFn5fQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869FB606A33E;
	Wed, 18 Nov 2026 19:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=azHFn5fQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6D01F000CA;
	Wed, 18 Nov 2026 19:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028844;
	bh=lj8hsBTLVTb7HceVrVpAqHuMLjWr6+I7kUiBt4DVk6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=azHFn5fQznKS5+7uX341uotsy3Wsx6qUVbCOjknG8j3+BzzHKRupAS5PNMdDbG2R1
	 OYTAKPU+TpuHm/nLkwCmv/KEkCvKOn/wU54Z8eE1t1qCUkEbH84n/jzxrps3magWGK
	 47odwC3jiecVqPpMrJVfh3MXJFtrhVR3TI5L8pYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0112/1756] rose: give loopback answers LCIs that calls cannot be given
Date: Wed, 18 Nov 2026 15:37:19 +0100
Message-ID: <20261118150012.658703850@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

A call to an address of the node itself goes through the loopback
neighbour, and both ends of it use that neighbour. rose_loopback_timer()
gives the answering end LCI 51 - i for a call on LCI i, so that each
end finds the other. The 51 comes from ROSE_DEFAULT_MAXVC, but the
number of circuits is the maximum_virtual_circuits sysctl, which goes
up to 254, and rose_new_lci() hands out LCIs from 1 up to that value
on the loopback neighbour as on any other.

With more than 50 circuits allowed, the call on LCI 51 is answered on
LCI 0 and the next ones on LCIs that wrap around to huge values: the
answer is never matched to its call. Below that, LCI 51 - i is never
checked to be free, and only the way rose_new_lci() walks the LCIs
keeps it from being one that a call already uses.

Answer on LCI 4096 - i instead, at the top of the 12-bit LCI range, as
was nearly done before commit 1f731b63752d ("rose_loopback_timer sets
VC number <= ROSE_DEFAULT_MAXVC"): 0xFFF - i. That commit moved the
answers below 51 so that /proc/net/rose would not show an LCI above
the number of circuits; it prints the LCI on three hex digits, which
any LCI up to 0xFFF fits. 4096 - i is still its own inverse, so each
end finds the other as before, and rose_new_lci() never gives out an
LCI above 254.

Fixes: 1f731b63752d ("rose_loopback_timer sets VC number <= ROSE_DEFAULT_MAXVC")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit aeddd6cb7ca6e8019ac73c8c0d40e5d9dcbc5c6f)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_loopback.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
index 6c5c35030e67b..efd4a719ab2ca 100644
--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -101,7 +101,12 @@ static void rose_loopback_timer(struct timer_list *unused)
 			continue;
 		}
 		dest      = (rose_address *)(skb->data + ROSE_CALL_REQ_DEST_ADDR_OFF);
-		lci_o     = ROSE_DEFAULT_MAXVC + 1 - lci_i;
+		/*
+		 * The call and its answer use the same neighbour: give the
+		 * answer the LCI at the other end of the 12-bit range, which
+		 * rose_new_lci() never hands out, and get back from it.
+		 */
+		lci_o     = 0xFFF + 1 - lci_i;
 
 		skb_reset_transport_header(skb);
 
-- 
2.53.0



