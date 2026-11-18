Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036663;
	b=YSkAeJGuJT2caYLzueLfvXz/p/km1E3itRJw9m0eodQZOkEVGUuXwNacwXqrb6tDhMNu
	 XEHaGINLUWr2OOa5wQ3O2VHSetYQ3B6uKnnd1agl6EKUZodeTVuk03Nais/2DxpPk+DQo
	 JV8gCoH1ee4+Ye0f7eNPxmKhANLVnenazg7JV10GrcWcfvF5F7e8yB7qIbY/M5PO/qn39
	 6DRCEm7KIcts2UjOq1Fs0/Hv7hmxyMtjTgj2ZHeQMCN/NLUm70sFw29QqKMrBEtVnbyHa
	 qbHpYNCPPQsOY9bO/j/rZu12e9l5TeeGlgc3TvylqvOyLXgi7u4wAcfQioaimib3GcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E9RiaStsBx1xcckYc7pC0I/jLPsVmdYWW1VkVk/sAUc=;
	b=c1FLv5PkwaUFGzBhA2R1vNr8nWHGIu3gPBnUjv8kjc+uVMjOTrabbHbW+akkviX0pkRl
	 7L1PaJ/1OshEESSWVvgnzza0PJWHf5UjNc/h4lo4rkwrh59mP3t0It9pUtI8QvsFzORsz
	 yqQmr0EjInUo6i668t9oGa7UXQ7vxjvGrIzOX+xida1KpGqjSFMV7NbOG5GudYBXlPIWU
	 wi+Y/VxVUhigtYzDiaBh9J6oMHphIgpEZuJ7VWhKNRwMylBltutvp+ngyY5YfYjubFW+q
	 OwUWhkWQd8shLtP8FPuWmItkGlJk2NsiN/YO8CtfxjDT2spV+R+9WpRjj7noYLdUIdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NqcmHNxo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBE9606A335;
	Wed, 18 Nov 2026 21:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NqcmHNxo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8311F000CA;
	Wed, 18 Nov 2026 21:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036663;
	bh=E9RiaStsBx1xcckYc7pC0I/jLPsVmdYWW1VkVk/sAUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NqcmHNxoYL5XM1eShSlA3oHxifiXcywqCdjTzpCukA6bZpFdu61pXtPvtvneugaYJ
	 xPKOlNbKoXOBzs7G7q/n8//D6FNG8RcPZCe49Wyr9xXe3yuF0OsJCltvOJ5Q85zjSn
	 rH+tRCpawTi8MBYEtcGaSJnn8cGTk1gJjdPmRUAc=
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
Subject: [PATCH 6.6 1139/3318] ipv6: defrag: orphan skb before queuing
Date: Wed, 18 Nov 2026 15:29:21 +0100
Message-ID: <20261118150354.230043061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a429620d06ed6..05dbf8144805c 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -227,6 +227,7 @@ static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
 	}
 
 	skb_dst_drop(skb);
+	skb_orphan(skb);
 	return -EINPROGRESS;
 
 insert_error:
-- 
2.53.0



