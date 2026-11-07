Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060945;
	b=K3q03Q6iHmlcpCcFaBT8vroxu2KERHUtOnQ+LS0j2IcLmpMUX41UKXSaI2QqR83I10xN
	 jfFpZESVpSQbPDW7sFzV/sY1kCCz3CvfafqnomLAiT8vW7rW/QjzCbIlr8QMYGoG/VNUg
	 F+PPqd3iIFsAsV4z7C02EMn0ccHrV+hnScLqYveDlX4eux3okncCpwycyOY0ckxAsKfsU
	 7wQjDcQf9HKhLjX7h3Ui3GQ5arVXqmM5TakEhDfblAi9Ggc4CEXStEIOphSH4SdAH9YK5
	 ri35F/iSEi/bHOfrYPHYqNafHo4uQRGOHAVTOlsQazyC18/HxvDPYp3zQl/hfzNjkWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YQAVHtgv+nQMAYq+s8cv+iu3rB6bCQ38bgsfJQeJXsg=;
	b=pIpLMizsjY3fzMSvc7ULU3vmGW7OiChQLHXVe6NZSAm2pKfpSvre+/1EtpY6lcIeV3bV
	 gkp1WqrbzFnB5wIIKP+xI3dPAwjQT7W6SBhqsz9C2mx8lLHCnPXR6QV9py1cPAuIdOvfB
	 9YNKXi0ZYnI4qeb5VRQZvOutFzrYyKQIVEsu4wQZIWNxdxoP0X9RznVb0DJsapSUJRvHg
	 fo2QeNjRAmAaCsL1twYKlhrP2F2OsBb+gjSyw9xj+v6YuNR2SfVkuOrUfexZcUMeU3Ntl
	 asRA1ddI4A1RGhT7Y095uVH/m8VBzo8weVgP5sLRVOvhobSbh6aFl+9TjZNFRLRdo8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G5NPQyTJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D650606D807;
	Sat,  7 Nov 2026 14:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G5NPQyTJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A0A1F0089F;
	Sat,  7 Nov 2026 14:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060945;
	bh=YQAVHtgv+nQMAYq+s8cv+iu3rB6bCQ38bgsfJQeJXsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G5NPQyTJATC3FW9OzkGynmasZ8x487O/uPn2fXJUJPQcBOxBQEpnnyqqIek1/cbZm
	 C41W0BJFPvKDLNNm5T9WkwwII+FRUCbGmS+bDtqg97TXCK2ZeHbKsIzivzfsWPlED7
	 imlID6PAn3jXaih7tc8ROZm7KCOocxpJN5tf6PA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0307/1536] perf/x86: Unregister PMI handler on PMU init failure
Date: Sat,  7 Nov 2026 08:38:43 -0500
Message-ID: <20261107135006.342584206@linuxfoundation.org>
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
index 80482229b2900..98b4014ff94a9 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2142,7 +2142,7 @@ static int __init init_hw_perf_events(void)
 	err = cpuhp_setup_state(CPUHP_PERF_X86_PREPARE, "perf/x86:prepare",
 				x86_pmu_prepare_cpu, x86_pmu_dead_cpu);
 	if (err)
-		return err;
+		goto pmi_unregister;
 
 	err = cpuhp_setup_state(CPUHP_AP_PERF_X86_STARTING,
 				"perf/x86:starting", x86_pmu_starting_cpu,
@@ -2196,6 +2196,8 @@ static int __init init_hw_perf_events(void)
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



