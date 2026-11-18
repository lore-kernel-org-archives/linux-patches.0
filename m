Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025710;
	b=hZUYosDLSC4No2uV8wU5V33rdPVwbX478xlUej1JCRwwJxWsQNjEb9Jju3wjO2tMTn7H
	 SrEDdy2pO7AzidZDnytUfNsZ+qLUGd1Cq7M4GaiRVeOEoC8SBCGhj0M7dgjVNr1BbkW3n
	 EGYqeeLYoo4Pte9p5fmu7sM/EMSDJEISFGk/pIZDJ1NaABsJO5hR8R+lhH70qKTkxiH4P
	 zQVwaU6k46tbJwlNghlRARvuQte/kTNKcSJCz7RxTnxbVu/Tt519TgD84eOAN4JLLUCQH
	 9eWj8W2tmYip7WmwGxsJjiipsZJHL7rJfO3dmt07brHhUfzBM3sUy/sbJa31Uo+bJyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=91BGo8gRGgdYSYezaZQQcpjPtZNv6qTaGRre0+aN064=;
	b=QlovxOdz1m4k2l5OdsnhNjXV1n1QuYHDgPFTpc1Pp2K+Abtj166frj4NoRhtWhpTEJZq
	 tk8Ecyz8JlUG2A+orucn8hEvvnwrpKTtZ91580J0WjZG37tjk7pe+9zPNGdF5cavL4iHU
	 0+sKiLNT3YaVxIX0jkbkksZ44u08JEmy/pkpEZy2baRGqnXEkBYRHO5Zx094m6eihNXlG
	 dMHmmL1SOLFZ9v06DQVy5ywPmKeVwXpJMAyaDdnTze64vvWFrJFw5UthH0CRVbW7SCvka
	 MtMGCyS7pTkJvrHQVmUboV+qJTh7dTHuMOwn4xw4xRYMqA+WQesxvBrSjhUWsaXfPyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s0UidDe9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A10606A32A;
	Wed, 18 Nov 2026 18:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s0UidDe9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB681F000C4;
	Wed, 18 Nov 2026 18:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025710;
	bh=91BGo8gRGgdYSYezaZQQcpjPtZNv6qTaGRre0+aN064=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s0UidDe9RAnfxsHzsczdkTgME2sgPO+x4N6qyFEglbRvZeSrWtQqkswlX3HmwmfDX
	 VxVSAYnm4VV0PjsfWO4SiZQ5EfuAcvjurvGKBs7RX90mfY/odMo/qCvs7fPWlnVAwb
	 +QRzWsHV49keZTpnEwhqtlb5GsD/LqnLqARjXKIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilson Felipe Pereira <wfelipe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1175/2151] selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in test_no_kmem_bypass
Date: Wed, 18 Nov 2026 15:48:30 +0100
Message-ID: <20261118150204.930506996@linuxfoundation.org>
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

From: Wilson Felipe Pereira <wfelipe@google.com>

[ Upstream commit 0567c7eaefd7ea1b26d76c46964f9a1d92120d7d ]

In test_no_kmem_bypass(), delta (stored_pages * page_size - zswapped) is
checked against stored_pages * page_size / 4 to verify that the pages
pushed to zswap belong to the test memory cgroup.

Due to slight stat update timing differences, delta can evaluate to a
small negative number (e.g.  -5MB out of 1GB).  Because delta is declared
as a signed int and stored_pages is an unsigned size_t, C's usual
arithmetic conversions implicitly promote a negative delta to a large
unsigned 64-bit integer, causing `delta < stored_pages * page_size / 4` to
falsely evaluate to 0 and fail the test.

Fix this by declaring zswapped and delta as signed long long and comparing
against a signed threshold, ensuring negative deltas correctly evaluate to
true.

Link: https://lore.kernel.org/20260828033741.2184560-3-wfelipe@google.com
Fixes: a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem bypass test")
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Koutný <mkoutny@suse.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_zswap.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 76667ba1b421a..086a085fa6d0f 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -567,11 +567,14 @@ static int test_no_kmem_bypass(const char *root)
 			break;
 		/* If memory was pushed to zswap, verify it belongs to memcg */
 		if (stored_pages > stored_pages_threshold) {
-			int zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
-			int delta = stored_pages * page_size - zswapped;
-			int result_ok = delta < stored_pages * page_size / 4;
-
-			ret = result_ok ? KSFT_PASS : KSFT_FAIL;
+			long zswapped = cg_read_key_long(
+				test_group, "memory.stat", "zswapped ");
+			long long delta =
+				(long long)stored_pages * page_size - zswapped;
+			long long max_delta =
+				(long long)stored_pages * page_size / 4;
+
+			ret = (delta < max_delta) ? KSFT_PASS : KSFT_FAIL;
 			break;
 		}
 	}
-- 
2.53.0



