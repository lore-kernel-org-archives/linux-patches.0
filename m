Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623853;
	b=Xb+P052bJovl57bfDTn9sMlu99jI+7ceWqONTKmaE8NCax4y6xOKX98ikZTEkwQ5Oaai
	 KmAau3A4J/UWE76H45p7ZmRndMpZhd5pK4+QK7AKffOtMKRxR/hmyqqAzs4vHsXMYqIJ5
	 kxb0IXMRKQqj2gRWaaJox2wgKt9P9AG53DYSi2Jux6Hz0W62HuI2MHYAXCZbjbnUK1kM5
	 d6O9N8Gp1qbPBooxgEcz4qDEaD6TsyqrfbMSdcN1w2yoHrh5D6yT0tTns7ga/qADcttU2
	 NkG/LL+oNHbuCOk0n/+sQ2eIahuFFKRBLm/Qv5Rwzv+kwZhf8e678LL/IiwEKIS3ANA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ErXkUksoaC2TX7MBxDQI79MoTAuYMoT6PTJrrX6N49M=;
	b=sLT6Aq1CgYBKsc2QZoX/kcwg3CcnfkJsD179i0JxgnVbCRxcbMzYM8SSu/P4Z/tbdVFy
	 r/jV3E3mhNcfFBMuHgJiiKj1T3Ja7RPWrb81ll9k6o6nyxzxGdEZm7+O4Dvh1I401exh7
	 Q1yHW+NZ+8wWWfzGW1WiQspxVXIvhNMbFfcjEWfE9A90igMaAU03mzvRYPEHc+vnNV5ls
	 FUPmpbE0LKqR8gyX78HbHTXHYvqfSu3z+Y+3+PT2QZ/MT/etrPRdwz/ZGJ8J9jk+gJr8K
	 LMfEe0UO3HY912+HwhaKJnbGMgQvCx5plHfl1IjbIrw/NXOa/2ghjXVaWJNKza8U8hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LWfcQa/G";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842F3606A323;
	Wed, 25 Nov 2026 16:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LWfcQa/G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D427A1F000C6;
	Wed, 25 Nov 2026 16:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623853;
	bh=ErXkUksoaC2TX7MBxDQI79MoTAuYMoT6PTJrrX6N49M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LWfcQa/G7Z6WhD/DWUOL1u9GF4VykNKxXTYXjAqcCM1riDFEUfV9hGk77+xlXbdR0
	 +efnoN9u6M8yjvcpL0/hAO1RumA1uKf17PNDxomEgcHPvjNRQBEGlNABvqmbfsz9Wl
	 Fk0/AH3siajh4NITvwGnfCucW2De6wmJ1W493U0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH 6.18 980/990] perf: Fix null pointer access in is_include_guest_event()
Date: Wed, 25 Nov 2026 15:39:07 +0100
Message-ID: <20261125143844.936328027@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

commit 88aed0422f39b22406f35f1e758cea25e7bbcfb5 upstream.

A typical module unload occurring event when there is an active perf
connection leads to freeing of the pmu pointer. The call log is something
like:
 ..
 __pmu_detach_event
 pmu_detach_event
 pmu_detach_events
 perf_pmu_unregister
 ..

__pmu_detach_event() sets event->pmu to null. When the perf connection
finally is closed, the following stack trace is observed:

 Oops: general protection fault, kernel NULL pointer dereference
 ...
 RIP: 0010:_free_event+0x3e/0x370
 ...
 Call Trace:
 ...
 perf_event_release_kernel+0x260/0x2d0
 perf_release+0x12/0x20

A call to mediated_pmu_unaccount_event() inside _free_event() is the root
cause of this crash. Adding a check inside is_include_guest_event() ensures
we don't accidentally access a null pmu ptr. In addition to this, we will
now call mediated_pmu_unaccount_event() before clearing the pmu ptr so that
nr_include_guest_events counts are maintained correctly.

Fixes: eff95e170275 ("perf: Add APIs to create/release mediated guest vPMUs")
Assisted-by: Claude:Claude-Sonnet-5
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20260904181625.1394082-1-vinay.belgaumkar@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6229,6 +6229,9 @@ static DEFINE_MUTEX(perf_mediated_pmu_mu
 /* !exclude_guest event of PMU with PERF_PMU_CAP_MEDIATED_VPMU */
 static inline bool is_include_guest_event(struct perf_event *event)
 {
+	if (!event->pmu)
+		return false;
+
 	if ((event->pmu->capabilities & PERF_PMU_CAP_MEDIATED_VPMU) &&
 	    !event->attr.exclude_guest)
 		return true;
@@ -12789,6 +12792,7 @@ static void __pmu_detach_event(struct pm
 	exclusive_event_destroy(event);
 	module_put(pmu->module);
 
+	mediated_pmu_unaccount_event(event);
 	event->pmu = NULL; /* force fault instead of UAF */
 }
 


