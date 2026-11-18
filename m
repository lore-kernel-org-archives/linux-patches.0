Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031527;
	b=zUGOzGf3W6fInYOQ4CTwqrw4Bi7qwMJF3oE247QAatgVya/uteQYjVnJCiC6zchO4s48
	 f6QemoQpFUPosZ3i26h7Bruran31TiOgExVw5zjdmgpCFiRwsS5hXE+FRPjLOjLFlw1b1
	 5TW6plU88jdfhQIHCq5hTt98t/qg3DPkPqTID1x97+ZMDuqvJjHlc6KrRaql0FfbtnVBV
	 BQB4drj4T4ddPPRtegSFBWI8cL2wvK96BzjKM19IDC76AkUEeWct4Q7ZiolzIlyX8dKyt
	 hM9o3cypH8Lt8shQbQI/6MQ8rWCsQTIPAaAcxbNthMDohwaEZAzweheIJB6K9UT92Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DtCv7iF+gh1qw2zd+a2CxTK/obMQhaOyEwODxNSk8Zk=;
	b=TxpKIE3J1iwjYWyNpbw8eSf7+xCZIRqV8LsPsjYJH0rC3lfnWMv3KBOtGynpl/FDiQki
	 0Cxo8kn+df05L2TY13kJUhSMdImDrJWvrHZTrlSD7x+LQglpgLcxQlMZoK9ItaDtRg1Ku
	 Mt3JDY5CetbvJSQkErEiLYiqPpIgp5eRYR5/RvyOcl1SbGAxow/PiEud3JryKqKYNvYJf
	 4zWQf8tbcDXowohTmrNv8xhHh16sCVS0Z33zKbCyWCD5T4QzJhEHFvg1UDEP+ig9Zkf5a
	 7H78C4tpUXDsyCk1K8RfJ1uuCKNTmFCuwFvyNco+1tbJqCiHw6L19UN9XJhBp7ZumIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AlNYe4q6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BDE606A325;
	Wed, 18 Nov 2026 19:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AlNYe4q6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567A31F000C4;
	Wed, 18 Nov 2026 19:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031526;
	bh=DtCv7iF+gh1qw2zd+a2CxTK/obMQhaOyEwODxNSk8Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AlNYe4q6gNZzpplupp1ZcaYIeAsm1Q6+8KULdiUYDbSgW+3IV5YDChs76IqDHC/JA
	 yfWj+bDDyap6X0DQ6alchsCW1yxOu7a9mfrAJjyxj3ADF0K/f5VUrFGgvzbG8jAO7/
	 GLRCmuX4PV0hiqGPf1Uj2CP5VtZf5XoUiJQCXiZo=
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
Subject: [PATCH 6.12 1089/1756] selftests/cgroup: ignore memory.reclaim -EAGAIN for zswap writeback test
Date: Wed, 18 Nov 2026 15:53:36 +0100
Message-ID: <20261118150053.536527913@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2c4b28724c637..36d2c48605e48 100644
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



