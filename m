Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017764;
	b=vmeHhFxCzdYDoO3n3ZEQ6iSwnctTQ2x4x2dpsjOWjUu3I8nlA1oC5XVQwYK1+PAThWZq
	 gSbtuYkRrxJETZgq2VJnHVA66drqkR7rkD3t2+D33mMCbgCK7P1W4KqFKnfPwPlvHeEYS
	 XjtEh2ll5Um7uZ4h99YSmnX0dzTOIUIM4EgaLnfe0pCY/tFJGubxBcBRmMWXH5YeZsXp9
	 QVFGZpe/i+NXeu4/XWwUDlkZ6gNPBt4GiIUv3SI47S0pJjdMTFxsYIPVtHpgR3xzoSACr
	 wJKawulTx808Ds7AhqKmz80AIcvKP+PYPFJBEzLO5FR6JbALbuyvwr4A9lRjwqA5Efw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mH6C7iQ9N5LsDo1FTdHgNFgVdHz2+S3z4juc3B1ohhc=;
	b=EuaSwGlulqvwaVpT90WGVrVBnlqha98Aa0q2ghzIYsZz1QiQ0ailskvNWZy2AeZcQufK
	 5PU5tXrYAJHRRdHogqtthuu64SpBl+rbEu1k0gtTkzKf8n2PdXp6j5jt2ecQz0xvYWwjD
	 9hJjKjXaqxt6griG2blvypWd++ChGsAlbV3P2Y9x1AKZ0GirmLT9Z31QM4WFafdBp743d
	 dYXt8BpiAiaWa3hJu0zHCwjZeFOKbkAO28cEKsTz7kN2YJkOBKKf5lqAZztk9YOX8fObx
	 YU62cs/njzfa9QwXEQd1JjQ/h3NVSJQzsNB7Aaam5UAbhvHuAC6PZaMb1O+b1NWme2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2NVZ2egL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0DA606A331;
	Wed, 18 Nov 2026 16:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2NVZ2egL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172B11F000C5;
	Wed, 18 Nov 2026 16:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017763;
	bh=mH6C7iQ9N5LsDo1FTdHgNFgVdHz2+S3z4juc3B1ohhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2NVZ2egLVuteRovEsaApIlIiyFL+Ce+w6PgNZR1Edb2+iY2QARMVKrO/zaODMvwyI
	 xHNrTJDRY1b12JxtACUdzIU+1RPpM0LdFJNn0rG3UPrZyNd3meXNfgG+yqRjEC3nQj
	 6kRIeyuZBsQH/D7a7y+dM2RVs1PkcmqnlC62/nGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0960/2651] perf test: Record kcore for the CoreSight callchain test
Date: Wed, 18 Nov 2026 15:36:40 +0100
Message-ID: <20261118150322.462305961@linuxfoundation.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 5dd1a045e576323a10d0c7ca6dbc0f0b81ed9b5c ]

The CoreSight callchain test traces both userspace and kernel execution
and checks the callchain across a syscall.

Add --kcore to perf record to save the running kernel image alongside
the trace data so perf script can use it to decode the kernel trace.
If kcore is not available, the test will be skipped.

Add a Fixes tag so the change can be backported to stable kernels and
improve the test reliability.

Fixes: ca0e19074bd6afcb ("perf test: Add Arm CoreSight callchain test")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/coresight/callchain.sh | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/coresight/callchain.sh b/tools/perf/tests/shell/coresight/callchain.sh
index 13cca7dc11184..43ad90bc30345 100755
--- a/tools/perf/tests/shell/coresight/callchain.sh
+++ b/tools/perf/tests/shell/coresight/callchain.sh
@@ -30,6 +30,11 @@ skip_if_system_is_not_ready()
 		return 2
 	}
 
+	[ -e /proc/kcore ] || {
+		echo "[Skip] /proc/kcore is not available" >&2
+		return 2
+	}
+
 	return 0
 }
 
@@ -43,7 +48,7 @@ record_trace()
 
 	mkfifo "$cf" "$af"
 
-	perf record -o "$data" -e cs_etm// --per-thread -D -1 --control fifo:"$cf","$af" -- \
+	perf record --kcore -o "$data" -e cs_etm// --per-thread -D -1 --control fifo:"$cf","$af" -- \
 		perf test --record-ctl fifo:"$cf","$af" -w callchain >/dev/null 2>&1 &&
 
 	# It is safe to use 'i3i' with a three-instruction interval, since the
-- 
2.53.0



