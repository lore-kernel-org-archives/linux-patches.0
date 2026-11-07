Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061532;
	b=Lqi7NMp55/dWPDQZji+OBGb7Ou0Huy0RWNI7sIYjjURZYnXBfZNWOO+Q3uAvojN5zIwv
	 2Co8V7dYog2fofybWCyKMtx/U4dL5sO9WOUR1VNVezeHUa64Dy3SZSXdhAS7eGGJVOKEQ
	 0rHbqO4sa2Tz1iTFhQvd4mwd3MOfCG41j4QYMpyAiRWgZo5/XoXdRQky5VRE2PYOkDNZv
	 3+RJhuhZhqiQobNCsxfKZMRv654eVvkTZrrZlL7m1erNPsCDwSJIh8y80J+TyBICrmRXS
	 pvQAT3EF7H9I9QzxL6U4rtufSNYkXyzGqNAhvJ7YIMnRqC/W42Doqmq8efVJo8tQgSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UdeDaA9Bqj1Nb0f2JeF87WnRr/ev7kyPFoYjgxseKME=;
	b=wAsmBEpi7wckFyi9v68B0Bu1z0Elfc/+kBWJjfZWlWMaP8IVp1dHYiGfz9EUeFp646k7
	 i6i9hWlwekh2AD4CeDk/IWjAn3X7MN9nYzcXF35e8vGJT8/1gMOTPUsndKs7EbXMG126q
	 cuCIZvedJf+BEWkNMPJVXwiLvJDEMR2c8305j0wyHeQeh1umldJjMLoysUv3yukoUlWiz
	 DG/3kK7aq/UUJRY5CBY6czn2ukQvrryj7IsOK8R6wd9CEP0/38QZIURSxF+HRNRurO1cB
	 fiLxyAar2/iSXILmqpw9Bg7TOSegaHAXrWiEzKZ8YbiDqAD+/DHUqjWOXjUgFwstsFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v3Jg5259;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE151606A330;
	Sat,  7 Nov 2026 14:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v3Jg5259
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975D21F0089F;
	Sat,  7 Nov 2026 14:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061531;
	bh=UdeDaA9Bqj1Nb0f2JeF87WnRr/ev7kyPFoYjgxseKME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v3Jg5259rsVHJVuo4nHABSeNOYyPzaHJ0pZuaWsgmKxGyIaTPbdsDQVHKOJxup6mN
	 hL5vegI8CxuTXtOExpPKcztFWOLgsd3EYA/wk2BxQad8+gMK098QA/eAG6BWMRtg6J
	 SfBGnuc/l/eWXgnjbquFewOiaByWMBpQt3CsZnvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 0617/1536] s390/cpum_cf: Check session mask before cpu offline
Date: Sat,  7 Nov 2026 08:43:53 -0500
Message-ID: <20261107135014.865372618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
@@ -1803,6 +1803,9 @@ static int cfset_offline_cpu(unsigned in
 
 	if (!list_empty(&cfset_session.head)) {
 		list_for_each_entry(rp, &cfset_session.head, node) {
+			if (!cpumask_test_cpu(cpu, &rp->mask))
+				continue;
+
 			p.sets = rp->ctrset;
 			cfset_ioctl_off(&p);
 			cpumask_clear_cpu(cpu, &rp->mask);


