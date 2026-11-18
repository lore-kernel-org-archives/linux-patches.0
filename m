Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033108;
	b=guETG20DUKL8N7YEnkfDss7zUCfV0aP/E2S3K54v5dNyuTOd5edWylc2MwyvZXi6WlGj
	 EMwKbrwvQ4NdQLXuV1iRGutsg8szSEShOQWRux/EBLGWbYuXvgyzhT8PbeZa96L1pGMFR
	 +F+AjASzNwShXfCSNNZOkRwtleUK4AZyJ1zmyhD6/NyU3RCA/R8lS6sP/CnZK63OfHn5p
	 k0d/iTkok+3n1l9YB7XJCPQ53LgqZ3qANW9GR138Qyfpsi4XO9UxtRGHGj/6q4WHE1B1Y
	 uzKYH2RhGan2rTnIHa97szih2aGGGbxyw2Osvi4ZCdtWgKXDjr9GcY27VlH8z9zkIiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=al9M2mkl9bhDXZsRz1LcDq5yhcr6IQvz1/mkFCneInA=;
	b=ZAXRW7xyUNY7ejuDonIRGyHCzAYaS8D5FMvnQtqyHELxeeDurHdoxHuzvYN0x1qpPTuw
	 DigWg71db6DOSOJVfQUHoX/ygdL9OVNM0V+BWT+xRWKzb6/FjtHoHZLA0byJmfE3XgbBG
	 Q0vVp1aeyhIQVKDAE3NEHcQiEDWMpYMbkPu0RGlkQZVwlQgyXJZBQ7qkBOt8A8vBgewlN
	 9/m58eDq/URsuhCucpOIbaPHAtC3QEVbLU4+AkF4s1nXfQqJP4mVReZSESn46ky0T9YuW
	 OZu9W629KuVsRCzWHvxDcdIpY0RJ7BywRkKgiqiPdUlBHef8EFrGu0K70fbFxy2KtYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W5nTk4rk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B4E606A31C;
	Wed, 18 Nov 2026 20:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W5nTk4rk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664931F000C4;
	Wed, 18 Nov 2026 20:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033107;
	bh=al9M2mkl9bhDXZsRz1LcDq5yhcr6IQvz1/mkFCneInA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W5nTk4rkWVEvW63v0VMkr/9yCOf9NFTinGmNKLz91fCFQOLfj8zB0VBNyL6JnOOKC
	 gK5L6umCnay/ae/wDZvcpOR/tpcwa8/yLv0ykc+rUZopnH6Y+mg7gi1mXQ/jgFbdNW
	 Q5MXQbm5wgbwnpe4V4wsNJzWlq7GH1eeAgnyZUD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moses <p@1g4.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1608/1756] perf mmap: Preserve the consumed cursor in forward mode
Date: Wed, 18 Nov 2026 16:02:15 +0100
Message-ID: <20261118150113.884581485@linuxfoundation.org>
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

From: Paul Moses <p@1g4.org>

[ Upstream commit 1e826983ceef421d7047ed76581840b778294ad4 ]

perf_mmap__read_event() updates prev as it consumes forward-buffer
records. perf_mmap__read_done() then overwrites prev with a fresh
producer head, even when unread records remain.

perf_kvm__mmap_read_idx() stops after 25 records per mmap and calls
read_done(). If more records are pending, prev advances past them. The
next drain starts at that new position and skips the unread remainder.

An event arriving after the last empty read_event() and before
read_done() can also be skipped. read_done() does not itself update the
kernel's data_tail.

Only refresh prev for overwrite buffers, which need the current head as
the end of the next backward read. Leave the forward cursor at the
consumed position.

Fixes: 53172f9057e92c9b ("perf kvm: Switch to new perf_mmap__read_event() interface")
Signed-off-by: Paul Moses <p@1g4.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/perf/mmap.c b/tools/lib/perf/mmap.c
index c1a51d925e0e0..52b806e799a4b 100644
--- a/tools/lib/perf/mmap.c
+++ b/tools/lib/perf/mmap.c
@@ -200,7 +200,7 @@ void perf_mmap__read_done(struct perf_mmap *map)
 	/*
 	 * Check if event was unmapped due to a POLLHUP/POLLERR.
 	 */
-	if (!refcount_read(&map->refcnt))
+	if (!refcount_read(&map->refcnt) || !map->overwrite)
 		return;
 
 	map->prev = perf_mmap__read_head(map);
-- 
2.53.0



