Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044364;
	b=aCUVb7NfSnoFz6zBwGQEHRCZ3bMJ8wluwH+VZB9QKcdoKmXhhAQmhiFQejPmQ6kCMmQK
	 Y1JUHwDjqOieVUUKTTn77a+9XgFhnO+nGkICZW6m2Sa68OpKJMSalEDoiQ9ux71Bu5YeI
	 /94+HMD5KfUhv/q2PhFETqcJUoFA+gecamuxEj2nDLFFWYcjdjCibmcYIW2vn99lhAY+h
	 ebCgvqYZPABhTpSNd/xwynunLz9H0QdNSkTQ3wajqQQXIWj4sOAruFeF1OOf+xwCL+P2L
	 k5DuutpIWUtXTqYNnh0jZnn76oXbS56+ecTubV621XusWsabJ5/Dp17yJmITfDVZ5ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vdsk+HLUU4Dk3Tr/IGaK/f1yUTy0e+KOwRW1p9wcG/M=;
	b=CVLhQqRQ0Qy9n9ZnG9H6LrUyTAIsR592cLE5ER+17D8Owfi/IIgvvLC38oJcN2Rlnhac
	 FC/ZbzYhmQFDZLAjM8OC8yHzBeHVzRR7CpxM/ZFZVCC3r4OeXfhMwglf9PqejsuET05cD
	 lCt2QMFUJrtSixbHPu9tnb0I3t6idiFJFu3a7LixRJoyr5KUhvsilrdS45/zQpGJGOLnW
	 FEmdCPnFo3R8qQVEatH5G+BjXK5ViyEXGGDZ71D03eZsIMMnFdF6tDVAnWDQEQ1pPYBPa
	 UHeB1mSdePioCi2LD8WeIyFKSaNRo8WogahkHHTj7nFahmUDtn5cNy+egirE6ii0nLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Spzearwj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D578606A31C;
	Wed, 18 Nov 2026 23:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Spzearwj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E111D1F000C4;
	Wed, 18 Nov 2026 23:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044364;
	bh=Vdsk+HLUU4Dk3Tr/IGaK/f1yUTy0e+KOwRW1p9wcG/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SpzearwjVVTujdnugZHbSA6LN6BkpKJxbzpUF0Q1+NeiZudniTzdWaw/PRwoz0Sx1
	 SU2ISfBmEvO2mdRSdBVzdvGQVjckf6BKjMY7yAuZpwP+k8UGC75mRoo1qNRk5k7L9U
	 ilh0fnF4Py5k3OfCQpyZHH7qLdl1NhOzYtfqve0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.1 0541/2857] s390/cpum_cf: Check session mask before cpu offline
Date: Wed, 18 Nov 2026 15:26:15 +0100
Message-ID: <20261118150220.966490070@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1561,6 +1561,9 @@ static int cfset_offline_cpu(unsigned in
 	mutex_lock(&cfset_ctrset_mutex);
 	if (!list_empty(&cfset_session.head)) {
 		list_for_each_entry(rp, &cfset_session.head, node) {
+			if (!cpumask_test_cpu(cpu, &rp->mask))
+				continue;
+
 			p.sets = rp->ctrset;
 			cfset_ioctl_off(&p);
 			cpumask_clear_cpu(cpu, &rp->mask);


