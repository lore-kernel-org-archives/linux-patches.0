Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207505;
	b=uS9ODtKMlcT49JuE8ASETxnPok2Jhvgu3t5ojtOvMyGjPOkEByAcSPHxGkofHux9qxUj
	 1DsepTgnhRyrUx0awcI6h0N3Alsloc8Cvwc9aVw9iI8s9GbdZUfld4I8cAaZf46D0F49n
	 o3TxOdM7jqCf1eo5tdBM5GSZakamuIN7mwigA4Tx3C4jn6GHszCMYlS2nwklwrAsuN3+i
	 aEqQHYk/JmE+Tern2trVi7M6u7JJRb0hskdgWaPvXOL3VG8eKCA1I8gPbILrWDZNR6HKt
	 7eWcFGWHtllp+xOlZle3hI81kQmEAM/Fqrx+lbXdNAf1PundLTrhJrY3JTKHXNJte4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ydmkOs6B9KEW4WLtK6QfU428SKZ68NdjQzMLhjrSuh8=;
	b=xwu6p3LAcsqo6G+z9/NR2kpiIpXPDMx4i7hDTkVl9Ki8rY0gcBv/9T4HSdxtUM1bym88
	 Ba44ndgq/itnz2LfOvDG5qt+TNdxVRfYwuUmbpr0/nn+QHAhsAtKij2aVzoSBwLUeElAR
	 4anmZvR3Cxc+xXr0ZesOfGPpVthCpq5J3xOUfW2dKpP7qSx1UOCJ71kR3zCoM8y4FBRuw
	 mOhYMztW0spTFqUg6TE4C0/KVka16xHjzxMTM/QJiwFELWwDrIQqqu2x2iAe2xAxBlWbk
	 AA3PHmUSgf7jFvdZnMT0jb9Jl1RKLjbQ8xOYzEloW4MOHUFvM9JlfS5Gf/3DrH/d6HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CprlNXT+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458D9606A31C;
	Wed, 28 Oct 2026 17:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CprlNXT+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9794C1F01825;
	Wed, 28 Oct 2026 17:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207505;
	bh=ydmkOs6B9KEW4WLtK6QfU428SKZ68NdjQzMLhjrSuh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CprlNXT+kP3Ce+qW3pUVJ+fwHVWnlh+p2ATdFotTkMOVf5uwZUFQKsRfukfr5WPxd
	 EAp+CoNiAWOStYHudzs4YtjLHy9vPWJRrzzyN+E9TTC0R1C2OGec3B6EC0Dk2ipKMI
	 qssjR26lTxbi2ORDRyNRKA3V6PDiwVLK/oIP8TIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/247] rose: dont warn on stray CALL_ACCEPTED/CLEAR_CONFIRMATION in state 3
Date: Wed, 28 Oct 2026 17:56:52 +0100
Message-ID: <20261028165947.578843684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

rose_state3_machine() logs "ROSE: unknown %02X in state 3" at
KERN_WARNING for any frame type it does not handle during data
transfer. Two of them reach that default arm routinely on real AX.25
links and alarm sysops watching the console, even though they are
harmless:

  - CALL_ACCEPTED (0x0F): a late or duplicated Call Accepted that
    arrives after the socket has already moved to STATE_3, typically a
    retransmission on a slow link.

  - CLEAR_CONFIRMATION (0x17): crossed clearing, or a clear confirmation
    left over from a previous incarnation of a reused logical channel.

In both cases the frame is simply dropped: no state change, no
teardown, nothing freed. Only the noise is a problem.

Drop these two frame types silently. Keep reporting any other,
genuinely unexpected frame type, but through net_warn_ratelimited() so
a misbehaving peer cannot flood the kernel log.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit 8649e4074ca29a6a8ef0076c2892ebc980b7153f)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_in.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/rose/rose_in.c b/net/rose/rose_in.c
index 666153a3dd8f7..69b2af24e85a6 100644
--- a/net/rose/rose_in.c
+++ b/net/rose/rose_in.c
@@ -202,7 +202,18 @@ static int rose_state3_machine(struct sock *sk, struct sk_buff *skb, int framety
 		break;
 
 	default:
-		printk(KERN_WARNING "ROSE: unknown %02X in state 3\n", frametype);
+		/*
+		 * CALL_ACCEPTED (0x0F) and CLEAR_CONFIRMATION (0x17) may show
+		 * up in state 3 as a late or duplicated Call Accepted, or as
+		 * crossed clearing / a reused logical channel on a slow AX.25
+		 * link. These are harmless protocol races, so drop them
+		 * silently. Any other frame type is genuinely unexpected and
+		 * is still reported, rate limited to avoid flooding the log.
+		 */
+		if (frametype != ROSE_CALL_ACCEPTED &&
+		    frametype != ROSE_CLEAR_CONFIRMATION)
+			net_warn_ratelimited("ROSE: unknown %02X in state 3\n",
+					     frametype);
 		break;
 	}
 
-- 
2.53.0



