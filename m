Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030135;
	b=rVsBbpc3enhj7IwKds45tzwO09ZjmXL4XZac33zH5spFMj84yiPnqQSXda+KIr6dmvEG
	 HyC7p9QifB7RXd8Er/15LEFRz2JQRK0xLJ4o83KjL39JbDbA3mUKnp/uLK9X32tR/isJt
	 7TJY9yqGq9uWSUgL07+11DyGOEFwTn6btTx6o8ac6f7jpJcFL04zlCPO42vpTCyNySNXP
	 SbZ0Gzc8BfKMqym/lFoyUiX7AgiXMcxjwsEHogG6u15b/BU9BjND+99IKX324GBEzMqC7
	 M7gsvvvXbP7nyL9vefp0092TBoA8fHFORf6pwjgdz6Bwgvdy92K/WTQJos/U8ylKVFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UQcnC+1nywoQuLystw8AstTNNOxe8MaAu+RHQAiiUpo=;
	b=UVsvdiYhlfiT8lrsCMi2KWYo5We82dzbShI4/L8B/yOISAwNCDyKgNy2dld72apIKrRv
	 OOwr+6NJtXge4Jnp2I15rxCIGnmJMJGy3Mk/pKqo26L0CFoAteiqsI7ujlqC68NV4i5n4
	 mjV/SLAQNAgknZjJ4I1DhqMuwkVfwKPkYdcRPRIYqCqzomlArUdHxXorm0zC5s2wtyI5y
	 PupboE/zYQhDUGYcENn5UYp7FWlenQ0tiKBeyKamnMJa7/trxQKJ+rNTwiJRlKVlvQynq
	 Wx7yugdBecKiwgr2eqrfLhYrGW/JX/BgWcXxQysyEZggOSDA/O3q4T+Isj1eRNgj8RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SIXSxqSY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4626074EB3;
	Wed, 18 Nov 2026 19:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SIXSxqSY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691271F000C4;
	Wed, 18 Nov 2026 19:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030134;
	bh=UQcnC+1nywoQuLystw8AstTNNOxe8MaAu+RHQAiiUpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SIXSxqSYAq4HJjwwt4mJznqDmk/jRHveL1WXOADpMbevhUDIZJBl9bOvSCBlA1zVN
	 ezTuLHbHiqC+GX6Yin9gu5nvpun66jH7O7xqW09YGFTrC+X4m85ESZUNCubjaPX4n4
	 ls+g71sHq3N9m3Wtd0Nq7ySnnvX5IZ0lhewZizt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Leo Yan <leo.yan@linux.dev>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0560/1756] perf mem: Fix size tracking for mem_lvls in perf_script__meminfo_scnprintf()
Date: Wed, 18 Nov 2026 15:44:47 +0100
Message-ID: <20261118150031.383140617@linuxfoundation.org>
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

From: Thomas Falcon <thomas.falcon@intel.com>

[ Upstream commit 06d5ce78e4fea2cf0738da903aa248a81101c155 ]

When printing memory info in perf script, the entire size of the
buffer is passed to perf_mem__lvl_scnprintf() instead of the remaining
size. Pass the remaining buffer size instead.

This issue was detected by sashiko during an internal code review.

Fixes: fdefc3750e847a91 ("perf mem: Print memory operation type")
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Leo Yan <leo.yan@linux.dev>
Assisted-by: Sashiko:gemini-3.1-pro-preview
Signed-off-by: Thomas Falcon <thomas.falcon@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/mem-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/mem-events.c b/tools/perf/util/mem-events.c
index 9c4adfb45f62b..ad93fdf5a1565 100644
--- a/tools/perf/util/mem-events.c
+++ b/tools/perf/util/mem-events.c
@@ -591,7 +591,7 @@ int perf_script__meminfo_scnprintf(char *out, size_t sz, const struct mem_info *
 	i += scnprintf(out, sz, "|OP ");
 	i += perf_mem__op_scnprintf(out + i, sz - i, mem_info);
 	i += scnprintf(out + i, sz - i, "|LVL ");
-	i += perf_mem__lvl_scnprintf(out + i, sz, mem_info);
+	i += perf_mem__lvl_scnprintf(out + i, sz - i, mem_info);
 	i += scnprintf(out + i, sz - i, "|SNP ");
 	i += perf_mem__snp_scnprintf(out + i, sz - i, mem_info);
 	i += scnprintf(out + i, sz - i, "|TLB ");
-- 
2.53.0



