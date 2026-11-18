Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032216;
	b=tfrU9fcdatyK4BQfxD1ZygJUebNTSVnhaFA1GhtuyYW/uSirRVYZPoB90KDOFEPp/s+I
	 5HMabXjpd4y0z7jOztxaq41I/f4ZqoSJ0KxV/yVxzFFusABkJ585NM0ew3WytouAti1eX
	 X4cW5RDMPEYyYSQNeYy/QYp287aBvOFuWhXFXFdNTrjZXFMKKtLcLGyv2EJPPC9vvS+/W
	 CYyrp3W4HPqegwClZ+OsF8MKnG84H63Dk9XGnJ6QWQ13pPedjIak8u1ULwPg+joH2bXbw
	 7i8yXQFlhSSu3pCcQp1xA1XJfS7ZkC+N1DLpheI8Ehg0WHM3ardbahsRh7ZAVdiM2kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VQRZEqpAZmiwle/hQF0ZR2jQHmrBIRZ7/FlWRh2LGBk=;
	b=KjwE1+060HiDmkPVMOCXkuYFloxGoaYWlADrUPtaq473zajhzfl3gF5WJWg2iEha48hG
	 u7mfJxtYHAsqkO94AmYHShxiz8SqAywjhrRlGIkrE/P5pSvlIkTEB+fVtJCtDGEFImNG/
	 Hs2PzFI8G2qR+9CBVo1JgSJYVsQZE3TEe4oON/3ZnNFlj3UJIBqLV0T/biwMPpxNzx93v
	 cyxcxLc0YK4nUsufGgvamrjpLQiXdSlWqrOcw6u3yVX2hUmkGvjEUA4eZ3StPN+qYqTPf
	 9ecgrbFhE5thKGpeDM3cHX3UWkCTj3B/GpeyOzXe/hLS9lu1AslK4Xkwo6GSnuVXMUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Tpakkgq/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF61E606A320;
	Wed, 18 Nov 2026 20:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tpakkgq/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E571F000C4;
	Wed, 18 Nov 2026 20:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032215;
	bh=VQRZEqpAZmiwle/hQF0ZR2jQHmrBIRZ7/FlWRh2LGBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tpakkgq/mqEOiQMa0KF0KK9NO3ELPP00ng7S0QsrJrljJ00joedfGZndkqiKry3iG
	 kj4HSP/SYWDofs1wpj9jZOBOb2oE2FkbwDmIuTGSrMb+Zio23HbUoACP4SNnTpGVsF
	 Ktz3jwA2cP7abZxsUJHWqiYY52xVVCzrV1V1AtLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1334/1756] selftests/bpf: Expect at least one kprobe miss in missed/perf_kprobe
Date: Wed, 18 Nov 2026 15:57:41 +0100
Message-ID: <20261118150102.480706030@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 03dfae9ab014e..a990034fcdf18 100644
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



