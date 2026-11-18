Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019675;
	b=qnelYYkSvcz6SFZojF3VN+MsWZukBpWw0KXspkK+qJlB1T00pSjqk34eCT9SUwrZm/Uv
	 Tb8M9FSFz2kdD160lc6e+2rsT0h1r0DiIlp7F9yGLAzxbDcaA+D+lasYfHWgSt0xnuy5J
	 VpjY3Rp+HS88USv7BsxuUWEkc9iTTcyjUfb5NGLkH9PgouemxRHBQcANoDVY8F2d2aOOa
	 /6nHHXzM3novRjN5ZbWG99TOqXuWvCnyaqmJ55SvkipsJr0yaueMx2s1+LhEuXsX/Wwig
	 Xw2J62CgTFcXsKIU4ImXVQf6ea8gDWvATLUdoNtIrk8DN+mPAzSYGnhpkaiHTpeRkXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Pdoem6n7Dg1X4mRjBaPHD+gh3tX7KAYGYKx6Kp4bKuQ=;
	b=n9wAbEL7CP7FjHC4dCP97ydmcHCUBZqcYqQz7YWijJJT41yXQNo4Rs1qSYbn9Kv39R1g
	 dCJiBUh3QUgW6K/BLfoD+e2crnGamrW5K8s7ep9Rc7jtAb8jDVyukB08/W10uFmVrHDiu
	 s+B+oaL7psJQ50/Buvc68Qs9i3hZ/VESEBlWlOHF7hF2DGfJpGanL8NyEu66TT013SOFM
	 vvfM35r3mwXFHpaOKsc5BJAGL0+4SQ6yrauPqc4eXifo0zY+choJ2JomzGhaBlZ6dq80x
	 JzIuVitNBTE7VCd+X8tQrpcCqVh4Vf2gKtbt4B6wBRB42oLtM1tLsDTdmYPpZRDI5Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vodY+8/N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EA1606A320;
	Wed, 18 Nov 2026 16:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vodY+8/N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C14F1F000C4;
	Wed, 18 Nov 2026 16:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019674;
	bh=Pdoem6n7Dg1X4mRjBaPHD+gh3tX7KAYGYKx6Kp4bKuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vodY+8/NC/4jy4sK33c2E8dShuiliwKhocHH8bl72/r9eUknP2b5b2/5mVb4bO6qt
	 mFsU+SzuPDnOrtYMWdE9pVyHgTri4m8PMsgIm6BxUQygC9xk6CivCy4g6Kbjq0CBMA
	 gl5N43A53X7F4SMyUvjfIAw1ENrKcVPdAHGKLadI=
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
Subject: [PATCH 7.3 1680/2651] selftests/cgroup: ignore memory.reclaim -EAGAIN for zswap writeback test
Date: Wed, 18 Nov 2026 15:48:40 +0100
Message-ID: <20261118150348.166939347@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 4e943e3d90adf..5c4f785e81e46 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -346,7 +346,16 @@ static int attempt_writeback(const char *cgroup, void *arg)
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



