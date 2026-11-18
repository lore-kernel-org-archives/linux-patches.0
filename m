Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058580;
	b=ugdhOXmhC570CeoP+THKS1WWLy+G3CRM40fcEicHwpIsA57iRtYPvtalzbgTYmQvnp8y
	 mpC0JneUccnEMoU0Rvuhs5LX75gj+PYX0yNnSF84RPJZblzi9GBBMnjIBosCpUATr1s20
	 fYJgAPisyRCqeZvwm4xdZo+2sgOncq3o4hvsWJJdVrXvOObVgysLsU7oj9Ans0XY3UBb0
	 wzLXoNkdy+2GIx1pDUtvtNaqfIWNm/yHTPjUK3hK1HAD2O1BYBg3bYsXZkDRfr4tkpDWt
	 nFDeKUov1bWQoq87JyUgzsdFubT10ghknUjOg8nehnYHxr0pYsRdeIaVYCmDdn9zkLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YHHBT5P+xw0A1iAFMU6ApLANpfSvw5TAyBYqWzXrVL4=;
	b=x+WQAofMAzhX9b10HkoNAWSzmyHYZAp0wXbVZ22AqkN8C/ESz927eglmGjR5qx7NnuxU
	 TRCO63GwqD9b7CpJD64Sy1djA4nvs8raEtqkHF99/G3dy4V/143YHq43kmNi9940caR2U
	 1wI2v9yfr5i9cKKodcpDe40wf70L5HPp26Z0+r4+pOGVYg2MQIIZaktSYLqRIWvZ0441U
	 OOyO9BiqpsbeDoKQfOe+ayJZN8zz0XjFu7jBxEvREQZeAuPw/yYP1+d8v+xVvSY6wkbhq
	 xEz6hRWcDUMDHSD3JibBvGdHDyWPaYMIqsy8ZCpOg434JmXyHqlO1LA5Y0PhECtY2VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OwW8GPOX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB82606A320;
	Thu, 19 Nov 2026 03:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OwW8GPOX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859C51F000C4;
	Thu, 19 Nov 2026 03:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058580;
	bh=YHHBT5P+xw0A1iAFMU6ApLANpfSvw5TAyBYqWzXrVL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OwW8GPOXvOZShCXW/zeYYn6XjqazT56f9eZtmliKIUAn2SUZPXm1WntYrmC21F3kq
	 T9G1NJ2eFfcICtHYukQ1aG2gtQH1c7b8R+EkSO6eJtQ/QzqVHBzfntNCiBHMIddAqd
	 NfIIedH9s7SkcwVYWW2DY6lLla62roamyl4WKytg=
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
Subject: [PATCH 5.10 0529/1848] ipv6: defrag: orphan skb before queuing
Date: Wed, 18 Nov 2026 15:42:47 +0100
Message-ID: <20261118145937.077174728@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



