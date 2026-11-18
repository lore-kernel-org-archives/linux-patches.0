Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042568;
	b=IpgrYIWSdi5r1H0Wt9mhiUyq/Nd2ayBOMqfI4P2itDL+IxkmKK4RoudIhBNqRIYyA0R3
	 NqROj4+sF3JjPI+2At/4aFALAsBVmJ7ispd4O1wuo+5gwEOMI7hq7PwBgmr1rNWJsyeo3
	 QmEdXgGxteys0ezoM4N/9i8uyJ/+wZqwPoHJZshPXcXHW45v3MZJooYYPfXB13Myk8rIZ
	 dcUCpWQy6iW26b5IFIIHLE7Thp8aFWa6HsOPk9e0iqiQgVWbCKaauxXws0Gm7nLF/RSYw
	 TpDR1DwTdake4ET/I3f1CxoGOc8VJGDNpYccfAo6wwP73Xb7Cw+EQJ808RsZ00oHSSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1nF5OQy4+bExg7rhjM5aj3XCYjTfDpJvhnAApTOn3mE=;
	b=fAf1e1cvyPGr1C4FkYzgEQ36rf6XPraELOT2BfWtuaOPuhx6TfA7ol9d9kNbi2x/SMw0
	 cDYVImb/BBtmBhadx3w45eO96Pwi0BdIK8YnJxP/E0nBNKqhUvmOpDLLx+bENN4QmXsz4
	 gG18BkEMfnYyekvsBH++gidOuEdiwRuKVKGCJ6HHC3Vod3bS5aXeYs2Qz+JB1/m/PhncP
	 WMcLJQBlRCJBBo2+BWPoF3SNVKR+3Cwoi7MkoBBQBjYQh8AbRO0bzOxBiT+ZDtMXu/Ndd
	 SM3NOaEUpSfP1e1mHHqIVWTt7ikAtsTgEFT7YiBbp5khWaZKdSKD5kjAXflvVtUmkoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xf8jCMrJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4166606A31C;
	Wed, 18 Nov 2026 22:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xf8jCMrJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C081F000C4;
	Wed, 18 Nov 2026 22:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042568;
	bh=1nF5OQy4+bExg7rhjM5aj3XCYjTfDpJvhnAApTOn3mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xf8jCMrJdZwWBVHiLvxcILyDDLhT2s0dr3j/dyzK4cg20Dyj5DjJokFeiKAC2c87v
	 xzjdX4oHBxiuJzOIyYMDgU90Nb9TX5SJxOYhntGXRoXLoogiWlg4QUpCjSGAl470J1
	 1/0O29zDKW38EGb6Nnz2M1zhQVVuWHCC4kdB7ey8=
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
Subject: [PATCH 6.6 3200/3318] perf mmap: Preserve the consumed cursor in forward mode
Date: Wed, 18 Nov 2026 16:03:42 +0100
Message-ID: <20261118150455.762126350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2184814b37dd3..b4effbc97e5a4 100644
--- a/tools/lib/perf/mmap.c
+++ b/tools/lib/perf/mmap.c
@@ -194,7 +194,7 @@ void perf_mmap__read_done(struct perf_mmap *map)
 	/*
 	 * Check if event was unmapped due to a POLLHUP/POLLERR.
 	 */
-	if (!refcount_read(&map->refcnt))
+	if (!refcount_read(&map->refcnt) || !map->overwrite)
 		return;
 
 	map->prev = perf_mmap__read_head(map);
-- 
2.53.0



