Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024514;
	b=LqbkwjQqx/CQetoU6cyXCR41gNQxl9CdLpcEaGEd7WbJyMxAxcjDZjCk5Vemx0phH1E8
	 jZkXoH4hq9nIrQWj3KKE/YtKEzpTmwPwMUDn9vG6CmingbhmdZxLIU31XJ9vk1cIlcbV3
	 JnVfyZiYq+h15/ly/uDSBIBr7C5BsT9rIimyLgrQyPPncqCKyVpo0RK2ZjLr0uP74tL5N
	 7J81JLl+yhUXfl88lHQOm47cq7tgcKJY/BeBs1a6hr42fPLxfaz6Ew1PGdHCeCNXDvGt6
	 efwcdbps8xewnCLQlJZ+GPdyVRjADUnBkmP8YBDzBt8L+S6wwAv7CyU+FhqxTRGJAFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XdSNAV7UfZVG/tgcJ6DtXJ/L1/uNsFp3VgM/CuMDxIA=;
	b=WSy5ZN9llIShf5euNAg35Kg3vd4h/daxWI5AudEaEgov5BTRxFOjYzVx+Y32nSTyJCPh
	 4rEKYKRpH8c0M9IlpIH8nOBdM3mTiu9t6SvXc9Ikd+yga0DT0ISJGYdSmxoS7QEdfQ65A
	 I7Nw9ZfjVls8dvtIUlW6YYsQaKJt6YDNeXkNLvVXVIVMhO7hxdIM14Cl5yW3T5aGEjNN8
	 C8x6PtPW1Ay5V9P2nV+KKGFob857LuAUwcCB7xP570pwNkHbynro07yUoB9IphYTeQiHx
	 83AXfFy1ouWS4QnqlKyDN/l4XNYRFwwCThMpMrZHdJTustbRfTJ6XbsCyEmZPqtTk+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fdur6ITf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E42606A32C;
	Wed, 18 Nov 2026 17:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fdur6ITf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DE51F000C5;
	Wed, 18 Nov 2026 17:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024514;
	bh=XdSNAV7UfZVG/tgcJ6DtXJ/L1/uNsFp3VgM/CuMDxIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fdur6ITf+dk4qXoQu3LB4+8qxnjihrYfICpMb/wKFMeErFdqgsESVcriYWovRz14y
	 XKnX6t6YsVWENgiaXRfi1L+qY9M5/oWdVPAQsjm0jnvHkKLqpWArfRFV8deP1OaGLM
	 Wzw0IoP5jfbV2sBdnePN2krLJXx/wpgBnL+aCLas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0735/2151] perf pmu: Add PMU kind to simplify differentiating
Date: Wed, 18 Nov 2026 15:41:10 +0100
Message-ID: <20261118150148.810571950@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit f0feb21e0a10c50e3a154e9bdf3fbb8a38480251 ]

Rather than perf_pmu__is_xxx calls, and a notion of kind so that a
single call can be used.

Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: aa9265d5073c ("perf evlist: Don't restrict uncore events to PMU CPUs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/pmu.h | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 1ebcf0242af85..cfcaba3e2e753 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -37,6 +37,19 @@ struct perf_pmu_caps {
 	struct list_head list;
 };
 
+enum pmu_kind {
+	/* A perf event syscall PMU. */
+	PERF_PMU_KIND_PE,
+	/* A perf tool provided DRM PMU. */
+	PERF_PMU_KIND_DRM,
+	/* A perf tool provided HWMON PMU. */
+	PERF_PMU_KIND_HWMON,
+	/* Perf tool provided PMU for tool events like time. */
+	PERF_PMU_KIND_TOOL,
+	/* A testing PMU kind. */
+	PERF_PMU_KIND_FAKE
+};
+
 enum {
 	PERF_PMU_TYPE_PE_START    = 0,
 	PERF_PMU_TYPE_PE_END      = 0xFFFDFFFF,
@@ -306,4 +319,25 @@ void perf_pmu__delete(struct perf_pmu *pmu);
 const char *perf_pmu__name_from_config(struct perf_pmu *pmu, u64 config);
 bool perf_pmu__is_fake(const struct perf_pmu *pmu);
 
+static inline enum pmu_kind perf_pmu__kind(const struct perf_pmu *pmu)
+{
+	__u32 type;
+
+	if (!pmu)
+		return PERF_PMU_KIND_PE;
+
+	type = pmu->type;
+	if (type <= PERF_PMU_TYPE_PE_END)
+		return PERF_PMU_KIND_PE;
+	if (type <= PERF_PMU_TYPE_DRM_END)
+		return PERF_PMU_KIND_DRM;
+	if (type <= PERF_PMU_TYPE_DRM_END)
+		return PERF_PMU_KIND_DRM;
+	if (type <= PERF_PMU_TYPE_HWMON_END)
+		return PERF_PMU_KIND_HWMON;
+	if (type == PERF_PMU_TYPE_TOOL)
+		return PERF_PMU_KIND_TOOL;
+	return PERF_PMU_KIND_FAKE;
+}
+
 #endif /* __PMU_H */
-- 
2.53.0



