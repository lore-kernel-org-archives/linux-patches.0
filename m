Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830872;
	b=3EChqFCC9j670j8IT73ZCp771XvMnLwopQr3RwICQc3KPhPYQKGltxBvtk+wamIcbvo8
	 iZXtRvKNPhhDN0XSz+e/guC1bmEDnxs38VtirBKS8z2YrDnBNt9T4KExJztL8oztyI/fV
	 vFWpY4m8SiFH2TO6tiL2zaS9q420No94iLSl4DJ6J1QLyEGl0guy4WhVClhFwEpgew/EL
	 IMgHM41epC5ilei3Q+zW2UhKc8LxkRdB567PFdNFVJsE7US7NfOV5BCQgbmAmEDEfz5rt
	 BGUiVwyExniIexmesSUIzj2MYySdfcAlCcIrp4Ny+NT1IxUKXKfGuZPNT5uydwB03VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=umC4JkxNm7vhTJ9I/m05TgnBULg4KZNZhJwsHuukUXM=;
	b=T8gDVGc1iDHzSTdgWIgqDJF9wa6U1RJmqUEIT+jZ+ZTjoAsNH5doF1bOYiUGdAO8CKYp
	 QiHRfrJz8nqGNJjqeQ4LeDg2/FjzGtqhmpTbZymkZ/gvCTb8tkOhVzFT0WVZPl3+OMhQE
	 SNC12EOjolYyucqIV23yCcKcnO3v+pyAL8w4M8MUMddDyUD34KHqYpcSICN5NQiVyMGzd
	 WV9pVRuYVNSBkt1KscdFuiVYkwWWv6gjd3VBWlUd923cQvuIR/nCVHWIJ/TMAvwJJE1yK
	 v47O5B6d/2CXPnztpwW1nMYXP8JYbLB9jI4WIIgImz8CzGCbaQaFUdO9cVSkFiVy7DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eo2pVOFW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FAD606E80A;
	Wed,  4 Nov 2026 22:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eo2pVOFW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6531F00919;
	Wed,  4 Nov 2026 22:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830871;
	bh=umC4JkxNm7vhTJ9I/m05TgnBULg4KZNZhJwsHuukUXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eo2pVOFWRNTp2SxqOHSjQxv+iqitMVoQRk4q0iURMKMXy4VPP7vlMKpLKkXL1gDiQ
	 oedWXR5d5FHlETyJl5RhUU3C0OC0TWFIZIleyn+qkNf7GjKTfRtmvHIUpsOp3re1DI
	 M3zGZL76NZbLQ6l+vedOM/hSQRTi3eu5GLdti31I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0372/1005] perf/x86: Unregister PMI handler on PMU init failure
Date: Wed,  4 Nov 2026 16:01:45 -0500
Message-ID: <20261104211054.507189161@linuxfoundation.org>
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

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit 91787047b1dc52b1fee68b07f79af70aae5fce47 ]

Fix an NMI handler leak in init_hw_perf_events(). When PMU
initialization fails after register_nmi_handler(), the error path
exits without calling unregister_nmi_handler(), leaving a stale
NMI_LOCAL "PMI" handler registered. Add the missing call before
clearing x86_pmu state.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Thomas Falcon <thomas.falcon@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
Link: https://patch.msgid.link/20260717080342.1879573-2-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 330c2ba41f076..2aa9270446634 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2175,7 +2175,7 @@ static int __init init_hw_perf_events(void)
 	err = cpuhp_setup_state(CPUHP_PERF_X86_PREPARE, "perf/x86:prepare",
 				x86_pmu_prepare_cpu, x86_pmu_dead_cpu);
 	if (err)
-		return err;
+		goto pmi_unregister;
 
 	err = cpuhp_setup_state(CPUHP_AP_PERF_X86_STARTING,
 				"perf/x86:starting", x86_pmu_starting_cpu,
@@ -2229,6 +2229,8 @@ static int __init init_hw_perf_events(void)
 	cpuhp_remove_state(CPUHP_AP_PERF_X86_STARTING);
 out:
 	cpuhp_remove_state(CPUHP_PERF_X86_PREPARE);
+pmi_unregister:
+	unregister_nmi_handler(NMI_LOCAL, "PMI");
 out_bad_pmu:
 	memset(&x86_pmu, 0, sizeof(x86_pmu));
 	return err;
-- 
2.53.0



