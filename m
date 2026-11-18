Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060291;
	b=XLQgsn+RDpJuhIZI3sqQrD6bEGJfDxhM7NWtXKJFCIXNwjd9IEfqZKcdBFFJPCTizOv4
	 2O+Hce2325O/Hq8dd6G+upjSdCFdONnyzuKQJL6nuRqXBIyuK+AcvmG2NzPU27w3twooM
	 u6EuPYNjUYfBYlpLCToCrugHsLIKxZHM9/phyaIh58aVSXiFswFSQpA1xwl4b6UOzgaz9
	 PggV2C6Rw0z8SZpDpJghOb8jB7xiXLPPTwcJZy9AfWSkurM1unZ3xYsJDzs9BH7ddLEFd
	 b0NoOUNk1rxiqVodxxRyI+A9PbdcaWuSSHRzlbh1xZLJ6bBkjFmcjgenxH/hAMFxlcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CV8YNkPRQUHRB8+AkpEbu81n/px8jbrj6cYk/rqmSNk=;
	b=XHUCc3F9u5YZGHo2/27P3zmUWo8LgWZ2MTFmJY82UVOLgIMoJneK7FGWJrHmqBmUM8BO
	 zdUon2mBGWvVO9s/C1gphncxwGNb1wI4VvxUe+/ZIJYUdBW6HbDullnNT/ShTEDxp7sI1
	 NTPWkxsb4yJBNFi4rcpQdUV7OS03mf2ZMYykRkDLykIcyWFgHeV8VP3CAT8e3i33C7V7W
	 O1QJoR1tYKppnCWaeOWGXALMviTaeNn8CQOFAnZW0nFKLVf0pIpePXPlx9+eIZIVfzyCo
	 VDPLftokVDitABT/3mP347bKL8qYY7Z+mn6vshkMDWiuZ0+/W3eMJQBQA2fi+lx/9qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J0bZEAX3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC01606A32A;
	Thu, 19 Nov 2026 03:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J0bZEAX3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CB61F000C5;
	Thu, 19 Nov 2026 03:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060290;
	bh=CV8YNkPRQUHRB8+AkpEbu81n/px8jbrj6cYk/rqmSNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J0bZEAX3SMq2qvqXczh7Fq/pahbxouDvd8C+9sH2fAaTUy5+JXR04aVlUh1h5h32Z
	 z+UpgPtbURh/bflVU7gHCCGgwvczPE7kTBRC31nxPLgFcH5/LRxBKGAx318/5vPswe
	 zioQmt5J+Of0T+NYKws/7AXpuJJ2OuqM2EySgYgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1145/1848] perf jitdump: Validate sym string NUL-termination in code load
Date: Wed, 18 Nov 2026 15:53:03 +0100
Message-ID: <20261118150007.656918973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 98bfe1142ccbaa5ffdca5dcdddd26f238ad33585 ]

jit_repipe_code_load() computes sym = (void *)jr + sizeof(jr->load) and
passes it to jit_emit_elf() which calls strlen(sym) via jit_write_elf().
If code_size equals total_size - sizeof(jr->load), the sym pointer
aliases the code blob with no NUL terminator, and strlen() scans past
the buffer into adjacent heap memory.

Add a memchr() check to verify the symbol name is NUL-terminated within
the region between the load header and the code blob before use.

Fixes: 598b7c6919c7bbcc ("perf jit: add source line info support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 2a14161702449..e23ba5866ffce 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -494,6 +494,13 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 
 	sym   = (void *)((unsigned long)jr + sizeof(jr->load));
 	code  = (unsigned long)jr + jr->load.p.total_size - csize;
+
+	/* sym string lives between the load header and the code blob */
+	if (!memchr(sym, '\0', code - (unsigned long)sym)) {
+		pr_warning("jitdump: unterminated symbol name in code_load record\n");
+		return -1;
+	}
+
 	count = jr->load.code_index;
 	idr_size = jd->machine->id_hdr_size;
 
-- 
2.53.0



