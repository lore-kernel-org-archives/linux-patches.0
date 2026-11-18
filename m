Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022870;
	b=qu8e7MADjWHqgZi8eXShXgVVKB89RySPHqIZwllPBKB/vmpfQ9cm4QCQj3SmTGorSTQc
	 /rTRPHRq9eztOptUlorDp3Sa7ZVsmFBIVIcOmsgV5J20jcXbfDbBVeKUIAExNaOhZS+KS
	 6FJVv+V/ADXEMX9CLpfPuvkwYWlZxjuIYgdaGZRS/yBi9r8Fdj0gxMdNKNtqbzycFI9iG
	 u5aeTXpOEEIQbqq7GnWJPNnnkTnsFCqh3AvQMdtcKVP3dGK/wocxrskdFHSXSvNDR62p4
	 rM5fQYFsqqZhvC4W8a3QzuKcXzFgx97XLFQ3eT+JbAdTsyrhH3aIImtPEKfnT9v8ARA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jpxypCy13igPLHbgjL5bb+Tvot9bEhmCTglsAPuvcwk=;
	b=rfoA1VIvr4pZRpu1sU6CYmT1QpwVg6DTC14d0RtCwFvZAvP2y3klG5Rsu5DdCrK8bACJ
	 na5f1E5EHeSb9PUfgk2r7DH0dGjtdeWCiSlgLulg0YaTPQcVsErhxyBIOAiqaOnk5w+86
	 1nDe8s9+q/ASPC3yoUb+7Oe4HN2dZ1xneWCamiIbE1qnWb0l0C30W6NblFKhyIg3AACgz
	 2Rmh+i88JQiCq48ChuQpQ/f4jJmREwh8R5LpjS8GnqTX91r8dgFEUvNOcFuNpaSmN0rDV
	 sWT1Phg8jBCoszGSOfcgd5Nygm3gYRxVa4+lSMMdXrTtQZYKn3Lo3z/i4QeYUj6hSOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eD+OtvOH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E01606B5ED;
	Wed, 18 Nov 2026 17:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eD+OtvOH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AD81F000C4;
	Wed, 18 Nov 2026 17:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022870;
	bh=jpxypCy13igPLHbgjL5bb+Tvot9bEhmCTglsAPuvcwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eD+OtvOHqDBT9V+qyfvzj62OOHv5/weE9fDb4PoySkITleM5mXC2sK6RR4dVZ9blk
	 N+am5/fJI+oaNp4KydEIAkya6G8XRCtRcjFQkjMpqe7f1LcgEupFQFGNpi+fuRyKDm
	 hyFzu96IEoH0aaskhpoR1etuRH/8/V78nNDNxFr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0166/2151] perf jitdump: Free event in jit_repipe_code_move()
Date: Wed, 18 Nov 2026 15:31:41 +0100
Message-ID: <20261118150127.794164852@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 7fc5851aac606b9e4143f6857710cc5f346770c5 ]

jit_repipe_code_move() allocates a perf_event with calloc but never
frees it — the 'out' label exits with only perf_sample__exit().

The sibling function jit_repipe_code_load() correctly calls
free(event) at its out label.  Add the same free(event) to
jit_repipe_code_move().

Fixes: 9b07e27f88b9 ("perf inject: Add jitdump mmap injection support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 8694f29d3b652..5f4af5d890ac6 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -682,6 +682,7 @@ static int jit_repipe_code_move(struct jit_buf_desc *jd, union jr_entry *jr)
 		build_id__mark_dso_hit(tool, event, &sample, NULL, jd->machine);
 out:
 	perf_sample__exit(&sample);
+	free(event);
 	return ret;
 }
 
-- 
2.53.0



