Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052688;
	b=2HugoKC27ALG828rMecbpSpf6ShODm7ygRKntp6KF+E/Blk/eM7LFh1NBgffTzLjbkuZ
	 9tP/cSe/ur6cNKJZ+Yjde5jl5J5miXF1RBF7oAKPwGWmMvA5EKKAZSM3OIvmM9ZEiggRC
	 jTXgpeEtg7LvZiCDWYcHN2FtVNKkCzoiC3Fe83CT2s09fq1za1eAX101D7yvygkkNxjQ9
	 PUeKhTCxc+aRf4YWOxfFg10i/tC+AOz4cOrcziLR2g6In1gu4kXliVBa/qRWcvF5zm8S1
	 S3t1f/AvbXILglPBDPcBqjj6smGVzJqg2wJ9Bg0FfSzUIlGZb0zN3Uoa6/bbdHoJKpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6I5SK4lbuT4ygddlUgeyRgtlKrc9Bpg3oxJ9zJDDIk4=;
	b=R1Jla0chxYOJ+gsAN1lpyBeKmF2E8HjTN54GNEcnznJBrgOmknxe54tj+5i+8B/dAmzi
	 q+sE0dNe5fFtktoOq6A+w4+TdSSsBYMDpRP/Pf/EISccJESUmZISR2KFRixGiP8CHw+gC
	 CeMq+fKVmKksNrEeGToqncN/mSdXL8DeWx38umwLM1of9lZT3b7kz3GGkMc5F3Gaz/gHv
	 61aPtV8FYzs7d0damD68Otz9Vsj/vLEWx+Z94aXQ2PKif62fWzBri1w/9NzZHoTqnNppV
	 nPIyOT2jA9A2IFb4c7NOqfK9spbmqisuXIBTIkEgkFAlHwJ6g7CMmkv+qH9QOOowaWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="M/mxi2CH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CC7606A31C;
	Thu, 19 Nov 2026 01:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M/mxi2CH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07651F000C6;
	Thu, 19 Nov 2026 01:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052688;
	bh=6I5SK4lbuT4ygddlUgeyRgtlKrc9Bpg3oxJ9zJDDIk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M/mxi2CHIbYUVi3a3U+nYhWWkQd5NRQTinucMDm9yYI2dpYF4mVMC2VmtHYEiD/Ej
	 pFp1z8xT1cYtbsm5k1azS+U3o3bw4lzhhmK0i/uu0R6PHJ3Q0f5yo4kxdqMXpuHi3C
	 L35Zpi7nH6TAirr26i19RXwdHjGUjEzOKGnrr480=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Eric Dumazet <edumazet@kernel.org>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Zixuan Chai <petalzu987@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0653/2214] ipv6: defrag: orphan skb before queuing
Date: Wed, 18 Nov 2026 15:38:49 +0100
Message-ID: <20261118150037.649714760@linuxfoundation.org>
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

From: Zixuan Chai <petalzu987@gmail.com>

[ Upstream commit 5dfa91a5ec53cfbf907a1fca095ac3ac7a4e94c9 ]

IPv4 and nf_conntrack fragment queues orphan skbs before returning
-EINPROGRESS, but ip6_frag_queue() leaves the socket association intact.

Commit 18685451fc4e ("inet: inet_defrag: prevent sk release while still in
use") moved skb_orphan() into ip_frag_queue() and nf_ct_frag6_queue(), but
missed ip6_frag_queue().

Without orphaning, inet_frag_reasm_finish() clears fp->sk on frag_list
skbs but leaves fp->destructor set to sock_pfree. Freeing the reassembled
skb then calls sock_pfree() with a NULL socket. A socket using
SOCK_RCU_FREE may also be released while its fragment is queued, leaving a
stale socket pointer; this is a second consequence of the same missing
orphan.

Orphan the skb before returning -EINPROGRESS so the queued fragment no
longer retains the socket association or destructor.

Fixes: cf7fbe660f2d ("bpf: Add socket assign support")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Zixuan Chai <petalzu987@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Link: https://patch.msgid.link/5c396b7011168cd98b9812df4d6bbd00a96048e7.1791008591.git.petalzu987@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/reassembly.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 6993675171556..c74cfca91dc4b 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -221,6 +221,7 @@ static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
 	}
 
 	skb_dst_drop(skb);
+	skb_orphan(skb);
 	return -EINPROGRESS;
 
 insert_error:
-- 
2.53.0



