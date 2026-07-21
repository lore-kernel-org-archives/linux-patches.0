Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267B424A078;
	Tue, 21 Jul 2026 20:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664579; cv=none; b=EWvI0hGVM+NqL3OeCxNBeOjcyYCvJZEgFp0kNpy/Se3kWywbt/e5qsNM09IU69LFqRdxEmwhyUI5HcMNyQAdSCxqCrDqsoVKxGvHwmdc+WdIpInRgPFd0XR9MPZ7pTJB5HfU0ACSWdLYStJfY1CcajWD1YP6uP0+rqONEPdesCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664579; c=relaxed/simple;
	bh=v9TzwgubxsRXy5MWqE0F2lfgp0zR0KUfAwCKykFr3d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCB4xuNfeP2jn7iLGGakqAf9u+htuOtoMMyDXi4VT7zy2jJUFIpq+/nc2bgz9lEV6L7fx61ylELKUfMru1baWfs1VM59PCrIkcWuTkX/gUAovHrYNPntHr1wHwq2aaJOahaXZofAEqhyS0LraPgkVrnX/Aoj2gabtHkgMF8AvKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLddbgn9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLddbgn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA571F000E9;
	Tue, 21 Jul 2026 20:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664577;
	bh=PiUK2ioqh2BYVrmabTp1PfcvkxlDT4JEX8xC4ka/whI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DLddbgn9Jc/bwveW0prc+TgDS0j49dIy7Nx65zOBUds18CjsvTnKEVAOzrLiHv08i
	 /uRPfVrKZlmt5X7xFcYkyXDsfJtQ56Cf11/7B0Zl65K2BcZbETvzjhSDtRC78V0mUp
	 WAG81U58FtnIyrs/8V5P9Wx6C3AK4GvXafN+R/IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Julio.Suarez@arm.com,
	Kiel.Friedt@arm.com,
	Ryan.Roberts@arm.com,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Besar Wicaksono <bwicaksono@nvidia.com>,
	John Garry <john.g.garry@oracle.com>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 6.12 1254/1276] perf arm-spe: Use old behavior when opening old SPE files
Date: Tue, 21 Jul 2026 17:28:17 +0200
Message-ID: <20260721152514.156438847@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@linaro.org>

commit ba993e5ada1ddce7a71140dc85ef65bc2cd981bc upstream.

Since the linked commit, we stopped interpreting data source if the
perf.data file doesn't have the new metadata version. This means that
perf c2c will show no samples in this case.

Keep the old behavior so old files can be opened, but also still show
the new warning that updating might improve the decoding.

Also re-write the warning to be more concise and specific to a user.

Fixes: ba5e7169e548 ("perf arm-spe: Use metadata to decide the data source feature")
Signed-off-by: James Clark <james.clark@linaro.org>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Cc: Julio.Suarez@arm.com
Cc: Kiel.Friedt@arm.com
Cc: Ryan.Roberts@arm.com
Cc: Will Deacon <will@kernel.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Besar Wicaksono <bwicaksono@nvidia.com>
Cc: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241029143734.291638-1-james.clark@linaro.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/arm-spe.c |   50 ++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -655,37 +655,35 @@ static bool arm_spe__is_common_ds_encodi
 	u64 *metadata = NULL;
 	u64 midr = 0;
 
-	/*
-	 * Metadata version 1 doesn't contain any info for MIDR.
-	 * Simply return false in this case.
-	 */
+	/* Metadata version 1 assumes all CPUs are the same (old behavior) */
 	if (spe->metadata_ver == 1) {
-		pr_warning_once("The data file contains metadata version 1, "
-				"which is absent the info for data source. "
-				"Please upgrade the tool to record data.\n");
-		return false;
-	}
-
-	/* CPU ID is -1 for per-thread mode */
-	if (speq->cpu < 0) {
-		/*
-		 * On the heterogeneous system, due to CPU ID is -1,
-		 * cannot confirm the data source packet is supported.
-		 */
-		if (!spe->is_homogeneous)
-			return false;
+		const char *cpuid;
 
-		/* In homogeneous system, simply use CPU0's metadata */
-		if (spe->metadata)
-			metadata = spe->metadata[0];
+		pr_warning_once("Old SPE metadata, re-record to improve decode accuracy\n");
+		cpuid = perf_env__cpuid(spe->session->evlist->env);
+		midr = strtol(cpuid, NULL, 16);
 	} else {
-		metadata = arm_spe__get_metadata_by_cpu(spe, speq->cpu);
-	}
+		/* CPU ID is -1 for per-thread mode */
+		if (speq->cpu < 0) {
+			/*
+			 * On the heterogeneous system, due to CPU ID is -1,
+			 * cannot confirm the data source packet is supported.
+			 */
+			if (!spe->is_homogeneous)
+				return false;
+
+			/* In homogeneous system, simply use CPU0's metadata */
+			if (spe->metadata)
+				metadata = spe->metadata[0];
+		} else {
+			metadata = arm_spe__get_metadata_by_cpu(spe, speq->cpu);
+		}
 
-	if (!metadata)
-		return false;
+		if (!metadata)
+			return false;
 
-	midr = metadata[ARM_SPE_CPU_MIDR];
+		midr = metadata[ARM_SPE_CPU_MIDR];
+	}
 
 	is_in_cpu_list = is_midr_in_range_list(midr, common_ds_encoding_cpus);
 	if (is_in_cpu_list)


