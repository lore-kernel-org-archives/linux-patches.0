Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831403;
	b=BRva+XulfGiufB7KxOdv5+6JPRevLYnCmqawIRZdOZRIvmtgQG6DAvLs2kJq6ghzwVaC
	 w9qw7HIOFT3oRxDePQRkLNle7DRkPBkH42yMzYnbUl7/SkdQUlFs0BZJrqOMOp6LQwPqS
	 +t9ONwIGPOvqqmmH+TS6ukckAJOcJ+8WVJ1vvDoYjIX/zDruxB6f3og4BMnOsdMYcXzJ3
	 1HV4PVIRBvbkc8219YE3baHHHD1lEVHr9LXUb17S0tY7cNDtSk+Y9+9wNXYlPv4BqUMMN
	 5AZdJkV9IOND+o5cSZfnGGRKC1scD32AW3tD3Q7xDYpc4XDSmQiNRNbHVz12jpwRiGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xx2UpNkngObTyM/BHCLQhkCO/3b3QiSaeqP01kslcts=;
	b=CzaP5YNkVuxGfdMsR++H2oV+wIFV1eKKfMF+xsynDXt5zUGFwNqr1ii679nrGAYtYHqg
	 IXNXbo2RaLNtFS/aCeCD3J79xWugAkwyeD4sZsvHmRCsK52SJyMBMQRg0CaOc9l+2DFwr
	 JMwVFBVxvZV33tSkMB/L/jly9KWPVR5LVIeS4059kr+gyf1FWwjXvN7lbEv+dcdyWTCPR
	 kzXWoQSR8o+3BSFA0MfFlEhznZhFOgtNg6Xjz5wu15roZKvzwvwmVfMY8n1E5au5F4RgD
	 AEt4ng/GIPfW2S1slpsrFHMPXwlvFmUAPD6Vivjb4U1IKQ8lbayoolIFVqGsth9j3GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CsD646rU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B37606AB10;
	Wed,  4 Nov 2026 22:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CsD646rU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADD61F00919;
	Wed,  4 Nov 2026 22:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831402;
	bh=xx2UpNkngObTyM/BHCLQhkCO/3b3QiSaeqP01kslcts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CsD646rUmIyvW8L84hSzufTek9pmMTNscykmNQxxbh8svYmhihJolOmzritZy44zL
	 7SP5jEs49WT23G65i/n86hZFwgXsclTmcxS6RkCbRXpM5svXQxsnouvSTVP1z4vwo0
	 00jM/7d7QRr/6hk3CFhdz6N+Pmj2H3+I46mplG4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.18 0684/1005] s390/cpum_cf: Check session mask before cpu offline
Date: Wed,  4 Nov 2026 16:06:57 -0500
Message-ID: <20261104211102.784444488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

commit 99a95985dfc85eecad97f0991a2401d2fcef294c upstream.

cfset_offline_cpu() stops counter sets for every active session without
checking whether the outgoing cpu belongs to the session mask.

For example, run an hwctr session on cpu0 and a cpu bound perf event on
cpu1:

lshwc -l 9999 -i 5 0:b
perf stat -C 1 -e cpum_cf/CPU_CYCLES/ sleep 120
chcpu -d 1
chcpu -e 1

Although the hwctr session does not include cpu1, cfset_offline_cpu()
decrements its counter set reference count. The subsequent perf teardown
decrements it again, causing it to underflow.

The perf event keeps the percpu state alive across hotplug. When cpu1
comes online, the hwctr session is started there and the reference count
moves from -1 to 0. Stopping the hwctr session then decrements it to -1
again, so the zero triggered counter set disable path is skipped.

Check the session mask before stopping counter sets on the outgoing cpu.
This prevents the unmatched decrement and the resulting reference count
underflow.

Fixes: a029a4eab39e ("s390/cpumf: Allow concurrent access for CPU Measurement Counter Facility")
Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/perf_cpum_cf.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -1800,6 +1800,9 @@ static int cfset_offline_cpu(unsigned in
 
 	if (!list_empty(&cfset_session.head)) {
 		list_for_each_entry(rp, &cfset_session.head, node) {
+			if (!cpumask_test_cpu(cpu, &rp->mask))
+				continue;
+
 			p.sets = rp->ctrset;
 			cfset_ioctl_off(&p);
 			cpumask_clear_cpu(cpu, &rp->mask);


