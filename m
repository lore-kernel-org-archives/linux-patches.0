Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027123;
	b=hS0xjBpB7bhXbLZQsF2TTxBBwJjMvfaByBGjucuwgAO3VZG81PTG7zcefAcTJDNUpFOg
	 VYgqaX3VDdmIqN6+Yky13lbHH2ZXVtPxvF0BVLFspFCJKfyedUwrEgAvAco/ubuhogtk7
	 Satf63qtAVx/cJYl41KJO/FKouh5cDbw+CgT7HmOse1977eC7wa9ahOq/s8KlFc1DSRHD
	 c7Uy6hpg2HEj5LuBS7JXlaggSmVwIJPNPi8YAq20N4RWZ66BKvX8ywFHdWtX8F2ObcmfX
	 5uf2nxMbEE10N74rCWdqdR4V3SdyY7fePuPIKSNg2TITgzn8A/BMb6CAXpLXYmAT1TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F8aaTPuWScQsHH/C4WqQYgdkkAeKoCA+nI5VVjlitOk=;
	b=DjYCKMvatIHE1Nuj7c2Q0B3ZpkRShy4WTaZATbiSpy++tHWTQYzmpT86ky7M/wsfChjr
	 AXRaE+aM/g7Izi4vqYz+I6OBVeszI97zqGE9nVnEhPw7lbIw3taCPiLMamB7w7irF4Hi1
	 N+WwM6c4u1ef2E7SaMhooQu234RGTRVdLOARsx4ipdcyqjnt72B6nxVwmj5zFi+1u871l
	 +gHSv0yFwS7gbGnC+sl0KxhEBJ6Kd4fjPCMOfH39KvlfdDCUo5fwJOHk2mgmUdpNbEyEF
	 qkqsA2z+L5qHYOVl7laBaXNfr+u0oeB0ILxt7J5Lb+AlJ8VzGH1LW2H9N43RAiI47AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hXKwsUC/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B951F606A320;
	Wed, 18 Nov 2026 18:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hXKwsUC/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161FE1F000C4;
	Wed, 18 Nov 2026 18:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027123;
	bh=F8aaTPuWScQsHH/C4WqQYgdkkAeKoCA+nI5VVjlitOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXKwsUC/DGIUqj3O3t/x+FC+47vvrNFexsz+VRTmV6imxCMyksSgx8PVY+sELAuco
	 uBHH+xaK/7rM9DvTSv1HLL/Fm9CbSk1hiTdIIDJWRSIowWHt7xO0/XRcbGTHdG9zxM
	 ioKJKw3g9mVE21y5u6SKUPU3FJD5aqrmA+qChjIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1677/2151] selftests/bpf: Expect at least one kprobe miss in missed/perf_kprobe
Date: Wed, 18 Nov 2026 15:56:52 +0100
Message-ID: <20261118150222.918709046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit 34d527e513c9a3f3a00f1ddf03fe06f493da14d0 ]

missed_kprobe attaches test1 to bpf_fentry_test1 and test2 to
bpf_kfunc_common_test, which test1 calls. test_missed_perf_kprobe()
expects the kprobe of test2 to miss exactly one run, the one test1
triggers, since kprobes don't nest.

The test is not serial, and the kprobe on bpf_fentry_test1 is global.
Any other test that does bpf_prog_test_run() on a fentry/fexit program
calls bpf_fentry_test1() and thereby fires test1, which calls
bpf_kfunc_common_test() from kprobe context. The kprobe of test2 then
counts an extra miss, and the test reads 2 instead of 1.

Expect at least one miss, as missed_kprobe_recursion does since commit
08a7078feacf ("selftests/bpf: Improve missed_kprobe_recursion test
robustness").

Fixes: 01e4ae474e39 ("selftests/bpf: Add test for missed counts of perf event link kprobe")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20261009-selftests-bpf-missed-perf-kprobe-v1-1-c9d0f75f6f99@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/missed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/missed.c b/tools/testing/selftests/bpf/prog_tests/missed.c
index 0b8f1aa5a3e74..b5fb0267e944a 100644
--- a/tools/testing/selftests/bpf/prog_tests/missed.c
+++ b/tools/testing/selftests/bpf/prog_tests/missed.c
@@ -36,7 +36,7 @@ static void test_missed_perf_kprobe(void)
 
 	ASSERT_EQ(info.type, BPF_LINK_TYPE_PERF_EVENT, "info.type");
 	ASSERT_EQ(info.perf_event.type, BPF_PERF_EVENT_KPROBE, "info.perf_event.type");
-	ASSERT_EQ(info.perf_event.kprobe.missed, 1, "info.perf_event.kprobe.missed");
+	ASSERT_GE(info.perf_event.kprobe.missed, 1, "info.perf_event.kprobe.missed");
 
 cleanup:
 	missed_kprobe__destroy(skel);
-- 
2.53.0



