Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020664;
	b=xhcoTsUzhmmTplfUexDuAAi9YBGB4+MHAt0O+k08sxF7tQ7SN8ftZgDdIYred+X702bQ
	 4Cw4Tps2/aJpKs+E3EkRORVp/tqJwPjYkBnY46g3oq6SWES9EN6YXHJCZ6cEBxaJX8elg
	 I9gBvIuC7WGALtxqMLHH0NlFyQ1ejU8yrXjNmupQ0NMz0hCbM7afH1RbZZnc9+75YpUpM
	 5p/EKIc4enPrzDopiiHCgb+vTM5rcKp9v9MmdAu105uLZ+pHHtKy1O9YBkkDutEADrkEo
	 YLX1h85Z2zC5fQq94qRn/QRx8hpv08oJVofDMlDCfKWVSPQM62QIrYQ9pO9XEVDe+Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=soKMfF/5FJ7K5xitd5f4Fhk0XsaPodiNFRYpLTYjbGI=;
	b=n/agy0CnYw9P/rfoz6AuU4kuyRJRZZ4PQ1eCg+JOQhOiMtmIWX6kqGMUDlftoTYNtku2
	 ge3V0fRC6aafPDk79+4CPMMpMA8cbPIAz1EFKdZGFw7OPP/nrRBle5TAUZWBrNOhaOY3O
	 pGbi8++SbG6eFauqscfuCgatFEqFeoIclxCqFK1AC8fM3UoG87kSaYlcuW33+FyYvVCT6
	 ECt8fOKwTeVC1PJC2k8jZLvGFiWt52iFF2VG5Kfm1BLnV8S7Yv+WNwOIepzRKeh/FCHOW
	 w4wP6etduA6zi8tIkhSDt17E15zphcK3u8LdW+HE9r/T7V+Q4xywjobj1+AvOj/fscg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LB/dDXfg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BF560A2613;
	Wed, 18 Nov 2026 16:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LB/dDXfg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54981F000C7;
	Wed, 18 Nov 2026 16:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020664;
	bh=soKMfF/5FJ7K5xitd5f4Fhk0XsaPodiNFRYpLTYjbGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LB/dDXfgFbdmbyjThixuVpt4ExxHW5h+SmrtNgmRfIK/r26kUWhc/nib+A4iwgqfs
	 kFIVfqRak3mLJYaCzIY5tddOhOLvS9ElRBTPd4uYS7QokV4f/TcAHC3UrnOsVTY5G1
	 gxt663cAUAFcj7UFSgcWnMp6l2NaBiZQymyaSRwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2032/2651] selftests/bpf: Record only the test ICMP echo in tc8 of tc_netkit_scrub
Date: Wed, 18 Nov 2026 15:54:32 +0100
Message-ID: <20261118150359.294477768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit 17f6fc3ad257b0ad7a11f276a5c0f57e0bdf3f4a ]

tc_netkit_scrub attaches tc8 to the primary netkit device, sends an ICMP
echo with a mark and a priority through it, and checks the mark and the
priority that tc8 saw against what the scrub mode lets through.

tc8 records the mark and priority of every packet it sees, and the
device also carries what the system sends on its own once the device
is up, like IPv6 neighbor discovery or the mDNS of avahi-daemon. When
such a packet goes out after the echo, it overwrites what tc8 recorded,
and the test finds a mark and a priority of 0. Record only IPv4 ICMP
packets in tc8.

tc_netkit_scrub run 100 times on a bpf-next kernel with KASAN enabled,
x86_64 VM with 32 vCPUs and avahi-daemon running, before and after this
patch:
            before                                  after
  outcome   2 of 100 failed (mark and priority 0)   0 of 100 failed

Fixes: 716fa7dadf11 ("selftests/bpf: Extend netkit tests to validate skb meta data")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20261016-selftests-bpf-tc-netkit-scrub-v2-1-b484a7ce2a63@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/test_tc_link.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/test_tc_link.c b/tools/testing/selftests/bpf/progs/test_tc_link.c
index 630f12e51b075..2a91793674dd5 100644
--- a/tools/testing/selftests/bpf/progs/test_tc_link.c
+++ b/tools/testing/selftests/bpf/progs/test_tc_link.c
@@ -4,6 +4,8 @@
 
 #include <linux/bpf.h>
 #include <linux/if_ether.h>
+#include <linux/in.h>
+#include <linux/ip.h>
 #include <linux/stddef.h>
 #include <linux/if_packet.h>
 #include <bpf/bpf_endian.h>
@@ -119,11 +121,19 @@ SEC("tc/egress")
 int tc8(struct __sk_buff *skb)
 {
 	struct net_device *dev = BPF_CORE_READ((struct sk_buff *)skb, dev);
+	struct iphdr iph = {};
 
+	if (skb->protocol != __bpf_constant_htons(ETH_P_IP))
+		goto out;
+	if (bpf_skb_load_bytes(skb, sizeof(struct ethhdr), &iph, sizeof(iph)))
+		goto out;
+	if (iph.protocol != IPPROTO_ICMP)
+		goto out;
 	seen_tc8 = true;
 	mark = skb->mark;
 	prio = skb->priority;
 	headroom = BPF_CORE_READ(dev, needed_headroom);
 	tailroom = BPF_CORE_READ(dev, needed_tailroom);
+out:
 	return TCX_PASS;
 }
-- 
2.53.0



