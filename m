Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026323;
	b=sRtlKCe9uG7EVNbkRNMuwHVGTvgX/rOWvJMkiD1hQxg2xXsklZ7BhSTDoAZ8cJiEr2qi
	 c5k5Ufj8Iz+Cf5+5A0YaEZUjRA9udBOedBPUbZwezy3XVwRcNYKN5/OKgk5IwKrjfhMdZ
	 nelVmdNNsVAzIIw9znmsrER8Y0pSw+G+eDXpQHNgZFyZI9NFPoY5pYqkZcftcK+B+Z12g
	 D8WtxwS3CSyRSBxnuY35uCbXhSpkbz0MRRBzEJX1zZcDRXMZNAGRWlKqghCSeRbi4WlGK
	 QGrh2wusbyefZf1V7XmHBHsFOw2Js/wYQRpR/A9lbT50l1rAZ/OXac88qfuzBpoyqBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=k79CssyYx/FnE1YviAhuUuaaoJyEiTFFJCyDNiHq8tU=;
	b=S4TAwXzL/Ypis04M5uzPvxb2YzO0YgGO1S4gXWCvMP97+6kaDqzY8ugVd/XR2G4XM+j2
	 l0FypHdOojdDT1pp88a7fI6V9DaNTvU4vtBc6LxQR5k0BbX4JvmS96mRP1CJyvn2anSmW
	 lPwBJuj/FnB57/VwzIQtPfydIxJXmlqlmtOFrjvQKXghnypqa7wf8pFl00SR/gOFXIhQn
	 K7IyGkp8PiM1g6AaAyLaXKpZY16fYonICrZbRxVgL6Z2qGOvUDqp3ZLVtVfN82HT0r8QW
	 vOlrUq/wHznUCxwLNXj5UEJOEtp2OZUPzy6JxkwWzcLQHTM9zW9QzvkeGadeKQHVlaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l6lYwh6v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC1D606A325;
	Wed, 18 Nov 2026 18:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l6lYwh6v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9461F000C4;
	Wed, 18 Nov 2026 18:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026323;
	bh=k79CssyYx/FnE1YviAhuUuaaoJyEiTFFJCyDNiHq8tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6lYwh6vrM8vs9sETgTx1sBer9/SzlXmq4yTCoeT+1DZPnmPPanZxkK5qY6CCK4MX
	 Rf4xffIsSKJpPc2wRwreZahtW/0eF5d1N6N7n7OZsU774yU7lZWkAAQsL881TYI8Tp
	 zKiYoDCZ+ET2v9mL33Wyzt4vhM3HNSe9iuFrPerc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	SJ Park <sj@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1377/2151] selftests/cgroup: ignore memory.reclaim -EAGAIN for zswap writeback test
Date: Wed, 18 Nov 2026 15:51:52 +0100
Message-ID: <20261118150212.177343099@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Yoo (Meta) <harry@kernel.org>

[ Upstream commit adbb0adb434d55bd02b18c8de6356f954a077c79 ]

The zswap_writeback_enabled test fails when a write to memory.reclaim
returns -EAGAIN, which means less than the requested amount was reclaimed.
attempt_writeback() propagates the -EAGAIN to the caller, and the test
case is marked as failed even when zswap writeback did happen.

This heavily depends on the performance of the backing swap device.
Reclaim does not wait for writeback (on cgroup v2), does not count pages
that are under writeback as reclaimed, and memory.reclaim gives up after
MAX_RECLAIM_RETRIES passes without making progress.  On a slow device
where reclaim does not make any progress before writeback completes, a
write to memory.reclaim fails.

On a VM with zswap enabled, where IO delay was injected via dm-delay, the
success rate of the zswap writeback test drops dramatically once the delay
reaches 11 ms: 7% failures at 10 ms and 79% failures at 11 ms, n = 100.

When zswap writeback is enabled, ignore -EAGAIN from memory.reclaim and
determine pass/fail based on the zswpwb counter because that is what
zswap_writeback_enabled actually wants to test.

With this change, the test reliably passes even on a slow swap device
(tested up to 1000 ms delay).  This makes the test resilient against the
performance of the swap device.

Link: https://lore.kernel.org/20260914-test-zswap-wb-ignore-eagain-v1-1-6fb715c22cd8@kernel.org
Fixes: 158863e5d7cc ("selftests: cgroup: add tests to verify the zswap writeback path")
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Assisted-by: LLM
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_zswap.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 086a085fa6d0f..36d466cf7fcf6 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -322,7 +322,16 @@ static int attempt_writeback(const char *cgroup, void *arg)
 	 * it can't writeback to swap.
 	 */
 	ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
-	if (!wb_enabled)
+
+	/*
+	 * When writeback is enabled, memory.reclaim may still fail to reclaim
+	 * the requested amount of memory due to a slow swap device.
+	 * Ignore -EAGAIN here. The caller determines pass/fail based on the
+	 * zswap writeback counter.
+	 */
+	if (wb_enabled && ret == -EAGAIN)
+		ret = 0;
+	else if (!wb_enabled)
 		ret = (ret == -EAGAIN) ? 0 : -1;
 
 out:
-- 
2.53.0



