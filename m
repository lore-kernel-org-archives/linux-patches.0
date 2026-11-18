Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035218;
	b=jQiukR5fXW73tfoCQY+SQGjqTSWBeokp6RjoMjRi0JbACEN+nhWgA6NYcQu9ZXJzZzDo
	 WDKhtP4x+qBRDLPcty9l5vQP8IoDv+4SN7W14IPynuEBd/NfXwBomWjGNPc4N7h6Trf0G
	 Ch5Wl41Wr6fX8BcqCNg+j8ApDONLq9U3dCfM2ehPc1U/o4ZcYqYcvACEFK3VJkIMGW10O
	 P1xqfWJLrdFiDMidkI9DsirKO1WqXBPuZ36DRdbZ4LtCO+JhkZHeANFxyJZ+Etlqf9V6K
	 oNHcW7WYhq0D3F9m8U1MxCUKIm9rX8n5IavMKF7LlPLI+4ZMY7nI8vooyOK/eMEw2XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sDH2lwdOABRwlSI6xINtpf8OzgGzvAo2eKcSAzE3AkQ=;
	b=FEExZAXBFGGTWQvCCbe8GfNqXqWNJ7O2E/esYeh0b7fgV/KmTGjQZMNYScWNt8w1a0Vl
	 sXERprbFPVY3zKjE1UQywqVaUsZSJEQSTlyWNQ+qnExZNyRRRLSlrmPBNzD0pUnC9Z5NH
	 qbR7Z3kArHTk7R6Tlo3Mi/rhR4vnKtybl2ccezkXi3HczXlr49mUWnFjSqtnhF+UKrB+B
	 6+syXc+fwluklkq2vgqZWrchfTdG+GA0MBs3BjXZWG2+C+nB7tElVO/MvleKm2stc2Am5
	 6G6TeXFitE9+U3OxkQzQ8633E8rr7k3J+KGrVSdJHmcFel4FROfeKngGr8Ftqm9dQUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A++Hlb7a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A3960A2603;
	Wed, 18 Nov 2026 20:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A++Hlb7a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD3C1F000C9;
	Wed, 18 Nov 2026 20:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035218;
	bh=sDH2lwdOABRwlSI6xINtpf8OzgGzvAo2eKcSAzE3AkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A++Hlb7a2+jXREH7tSL3onORWd0EhprABtIVwd4xRIpL2bDU7/XPmasJHgDTvX7ar
	 2NwEsrlYduIpyoeg0tj5Z6UPzwuxheCWUzsbL1nw64Y5cx/Y851kq1/gKSanqcTYs8
	 BBJ8R8a5KEVvg3hjuqKaD63wYLExGlVWfYz6n5KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.6 0597/3318] s390/cpum_cf: Check session mask before cpu offline
Date: Wed, 18 Nov 2026 15:20:19 +0100
Message-ID: <20261118150335.572909490@linuxfoundation.org>
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


