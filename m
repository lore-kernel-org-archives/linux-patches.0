Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031091;
	b=SY4PUDl1F1wg2c5S1QsBCQHtiuU8u0sbbRkr+EWBSdVnXMocYB9laOZmQrZEqZYRHF4s
	 qgXaxtb4meoDN6OgQC8to5bdzgTazXpbxaVt2C+BgeLO7jtm/z8y5/l4cmJJDQZyM9Vuh
	 QvqqwlmZlVwT3mOnjqiDh623xcZ0peLlXUMBJDESJltQsYlddUE75j7qiV0yfPZYBR3jp
	 BYhIMho2ZqDhUO/fyzcShS6WoP38gvziPb6gfe97GWDznkljVL99B4H53WJ/Ovnh9ZDaP
	 6ANamW3jjJ2tNnWjd3L4/aPyZuurNNRvPjDgdwfhtNCXNkyRcwDz6yNJ5uAFh8OxhTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FgrMa4bAHrp/AWam6tIu+BIqJqprElc+oij8C/o5t8U=;
	b=GKL5ClRywZ+Hsr3ETFTPN/qLFajkjJOtT8tpyub3StISvzXxfklCY5vduoE4AnC2E5P+
	 GEfvgD4TYT245wxKRtNOj0yt8nETZo1iFBqAboa9ha+ov0tK9Uco9PP9/9KQJBH/5kvY/
	 zgYzgEqn0JiySilg7KhmV4J5yhJzgaDh1sPiwFqx6KoBf9OsSAwbCCzkwRpqlGRp/qgf3
	 FNs0vGl0jwgzwFcmYS0+3HrZMv2ASidfxea2muu6b7vbDt7PMB/biqNI3Qcl6z4eIYFQL
	 Cw52uYgY9+r8eS8VOlNvqIQT63qC1X1ZZYp7BIiiCx6oQgrKmljYNzeGNzs2oar5Cgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=isMHNSwd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E732E606A31C;
	Wed, 18 Nov 2026 19:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=isMHNSwd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBA71F000C4;
	Wed, 18 Nov 2026 19:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031090;
	bh=FgrMa4bAHrp/AWam6tIu+BIqJqprElc+oij8C/o5t8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=isMHNSwdAEtZWbOwGW42XS41/SLPbKk5BvbCPt/ydRLs3U3e95WDX5mQpF+ilWTi9
	 +tWHCXDLW+9uFwuOwv5WtFJmx0ITlsjOSkYqE4jri/6Sh+9LB1prxO6mUavi6ZOVJd
	 G6OrqxQ0G9Oh8AxksjiPyntgV8XDy5+mb4FSIGaI=
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
Subject: [PATCH 6.12 0936/1756] selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in test_no_kmem_bypass
Date: Wed, 18 Nov 2026 15:51:03 +0100
Message-ID: <20261118150047.234193772@linuxfoundation.org>
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
index aa25806169639..2c4b28724c637 100644
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



