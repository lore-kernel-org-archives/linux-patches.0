Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063495;
	b=bUH2v/K2PfRU0HKScw4U7+fnV3BYWhL4XjcBJzG4bssEkWxXcWcF/ZBgTM4LYAv5PKss
	 WhQ6olrV7KSA6OJWtXXCz9vm8cpzXHY7cpvWV+UZ+gtumS+DWfVwXAxQBPHAlxvDMc3H/
	 ExHvY4FV5Y020Yfe+MlS1xPWRk2vQSPEUakbauyQjiYw7+MJOj7BDRFLNekway2I5TOih
	 jNtgRMmqVMbgPHHGyiPnd9q0NyV4kl8CwRX99xhlJHhEu9bW098/hWlEXJC7xte3ZMM4a
	 3JC8PWjWZaFWDQgIQtPcinPh5XHuriJ9XV4hy6B2gbKcphIufPQ4+lbpRqqR2Fa9lyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qv+zamMpVziSFuipxv5Fg/t4mCIFUqRupyGVp3UHVPw=;
	b=YYjUpXP6h2OnNKTwX4mh+m5pxcLBxz5kWmTIn+u3EqqYBw1k1Dv3SNNBcP9TPu1hptMa
	 0yvnXotZpmuTKNGL9x1gUrgUCXS1jo3dw3W+fTn1PeVOUknk+xOZAN9eJB8WFmEC0doiZ
	 6rXBI3hc9kIAnjbslfA2v4GtmA5N8uBKDUsZn0Hzr/lOjK8bKBh1RDd1xqdoblhsvJEoJ
	 ZG+ZmrFPcALxtT8eTYEnsTXkibAOZ/AlOZjriT5QH4twWLqTsU6+qBeXuK/RdOk64AnHq
	 9OpUDibFNE9RdzIeqfp0T/rxMltnLJGTRlELL2lpo9Xt3F8fpUTK8p1TCfRsTxspvNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aBYqxNpn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C25E606A339;
	Sat,  7 Nov 2026 14:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aBYqxNpn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD811F008A1;
	Sat,  7 Nov 2026 14:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063495;
	bh=Qv+zamMpVziSFuipxv5Fg/t4mCIFUqRupyGVp3UHVPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aBYqxNpnt5X8i1QY0DO/7lgYWAJOIj5O2CqFJKKMaJYUPWHMzYoZU0xM0HRqAx7JM
	 6wMrtLuVIwVtJByIkx80PhvrciFxh7k/OnNeHPbPqxrq6Bb//g+eZXkyJjS3gGmqi9
	 /geAO8tP6A3bqlW7bncnStrX0I2URM9NpdUkMIjw=
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
Subject: [PATCH 6.18 603/869] ipv6: defrag: orphan skb before queuing
Date: Sat,  7 Nov 2026 08:54:45 -0500
Message-ID: <20261107134913.536429068@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 25ec8001898df..c10a8a9d607e8 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -227,6 +227,7 @@ static int ip6_frag_queue(struct net *net,
 	}
 
 	skb_dst_drop(skb);
+	skb_orphan(skb);
 	return -EINPROGRESS;
 
 insert_error:
-- 
2.53.0



