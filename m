Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022084;
	b=waS0Z1MeCsINHQ56ah/kFL9BnykktifsVqITo/vm9bDci2J4/k5iMmDdPsuw0JZZirQ/
	 fhkXlCUrSQlK5wi1iChoNQf3shqOQl7eqwpxIHveWUdyj3F9FvkjZeuf6v6QqMAlG3Sby
	 RDEXjkWvWEuvvtQ6/5UD0Hcyhg4f0BGJl+i5DEx+ZIsxWhTo29G5IwUFuciz7geqhbG8/
	 8MV1/82xfwy0gzKi29fLOcRBM6ocev/KzHnPVHerlDRnaKq3KncYCrM7YZ1Bcfpx+U1g0
	 4Tc7KZ18CpwnKYxgUnIqLV1r1DUhu5uNX5oTrf3S9R+ijX42btv0FK0EXJ09d7KFDMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ouPTUszjfBuwgZbU73PYRXliwype0jmp2SMVfYDUdDw=;
	b=imGXb5NJS0r52pSLWgg+bDw19YIEiLkHVBUN77Wbuk1W0dzHdJMVQ8YBdSlQVasvE63w
	 eUJBdWF/X+lhLdCzUrc07lbPv6y/rff2UczaCSx3+EYb2sw9X+VM5cJthaHTbCA5ZdRbP
	 XVs/5KU3oWDVEMqL+N4QwdAzC1cgOsc9B/kgjLCRR9C+2DguNYDGzKXsjizgk2bh6cHCz
	 4GAl9mq4AQWP/ObQJHXHF0/ANIjJNjFkr98cv69xXoA+wf5rZup8DZFgVK07ym4nDJdat
	 IMBX4SJzspawak/hjVIW8b+6nKZHvLWQ60iqkxwEw96Uo6LpkyruehdzX0vwm/hz4ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aCLy0HuW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16B4606A320;
	Wed, 18 Nov 2026 17:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aCLy0HuW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B5E1F000C4;
	Wed, 18 Nov 2026 17:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022084;
	bh=ouPTUszjfBuwgZbU73PYRXliwype0jmp2SMVfYDUdDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCLy0HuWQOdDW7JfTIqF5cQKjiI/wDOeLcMNqVjv719f9USE1h0TzSjFKKeZgqMXb
	 GxAkuPPTQhzOT/XClP7XrSMPboWoNol0nSsVzDecwBa8wLrftIw7c50DV5Lbf9BI8c
	 KWFoTTTMl+ymP3GRw9TEj1T6YhybaqmRSvLTxqJU=
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
Subject: [PATCH 7.3 2496/2651] perf mmap: Preserve the consumed cursor in forward mode
Date: Wed, 18 Nov 2026 16:02:16 +0100
Message-ID: <20261118150414.682779647@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ec124eb0ec0ab..ab3adf1d8baf9 100644
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



