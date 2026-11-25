Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621816;
	b=jkxB2qT03E/Jc1RRpfZVWlt7o1yyqdtuFpr4f1o0u4QwHoNFEyDtPRtUlsegeWNjvp8r
	 6OYgLU4g/QVbdeRwrOi9q5Ae6R+1PQPMZwZ2sR5hJF1Uo9fCDr5Xc5mhzAs0JLDn4U7Tx
	 GGB+7mNjfDVlNSCHTP/ASdJIlo3ZXzckFAIeKg4V8GiRaNOx+tIfRDtn8o0AO4/uRh1es
	 fuPadSHcjgvGdOUhfncBJcDQ1gCFskCtb+Z6iIvKEoaR7tZovykeB5JySBWNh4asqQ3Hs
	 wj1pWMnt33SAgoye1/WwydrCaLq7L8AHLGvNLOy7qtbGN8xEsLrcLLncCT5rcs1+jtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RdPejvrOOXUvvZlcAimlYr83CdhDKExUkbnvzLVOZHc=;
	b=MAxuSqzi+TyRhFp/BNNFsYak5pqfXHNpf5AxxJmBzobvqdTJnPXurqIQbbPWG7s9GSQx
	 Jde7XcfzvHbpmqxKXZdZ8cGpqi7fDKkflYwKUhIvuMF9KiISyFAjM7Z3rDaBEXD6pGyCB
	 aRpzfstw9mK++JyPKdqwmy/+pE7h1TTmoHerOny/fkYkYIibcmvVohFnqb2aGvu1hHZgl
	 qfFw8U5n1TzJ/wEza13RuUa77dxjGrOlbonzJxD8Kru0egGvnZZviBaLrEypScExO7JLb
	 rq1HJ2kG9oy9FrOsnISP9HWsMVmK4ONmXpHxb4V/i9IuZbFLmmFbdi6RQ/pWk43cu0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mxOidA63;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559EA606A691;
	Wed, 25 Nov 2026 15:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mxOidA63
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDF21F000CF;
	Wed, 25 Nov 2026 15:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621815;
	bh=RdPejvrOOXUvvZlcAimlYr83CdhDKExUkbnvzLVOZHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mxOidA63BGUS/s3MMHrca+9ClO/KVBbqM7VM1dG6yq5hEeJevOfwysNZs34eY9U5d
	 cXa0+UJy3ABeki3sHRoDbcqgO6H3AEe+pZqzYv6WBmoTHK3+cOGCqD45KutOY7u19i
	 FE92b2wtPtF2h4DoHVEmMgog0UKsBUtRaSyRigH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Ian Rogers <irogers@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	James Clark <james.clark@linaro.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 307/990] perf: Add perf_event_attr::config4
Date: Wed, 25 Nov 2026 15:27:54 +0100
Message-ID: <20261125143829.282629048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@linaro.org>

[ Upstream commit cbbfba4847b8a5299d36e002bf864b21bb83295d ]

Arm FEAT_SPE_FDS adds the ability to filter on the data source of a
packet using another 64-bits of event filtering control. As the existing
perf_event_attr::configN fields are all used up for SPE PMU, an
additional field is needed. Add a new 'config4' field.

Reviewed-by: Leo Yan <leo.yan@arm.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: James Clark <james.clark@linaro.org>
Signed-off-by: Will Deacon <will@kernel.org>
Stable-dep-of: b61c12527223 ("perf/amd/ibs: Fix kernel address leak via REGS_USER and REGS_INTR")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/perf_event.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 78a362b800277..0d0ed85ad8cb3 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -382,6 +382,7 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER6			120	/* Add: aux_sample_size */
 #define PERF_ATTR_SIZE_VER7			128	/* Add: sig_data */
 #define PERF_ATTR_SIZE_VER8			136	/* Add: config3 */
+#define PERF_ATTR_SIZE_VER9			144	/* add: config4 */
 
 /*
  * 'struct perf_event_attr' contains various attributes that define
@@ -543,6 +544,7 @@ struct perf_event_attr {
 	__u64	sig_data;
 
 	__u64	config3; /* extension of config2 */
+	__u64	config4; /* extension of config3 */
 };
 
 /*
-- 
2.53.0



