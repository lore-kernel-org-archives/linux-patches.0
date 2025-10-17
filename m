Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA869330B17;
	Fri, 17 Oct 2025 15:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716258; cv=none; b=DEc2O9eJn6yxycHP6Kaph3uDCW+govR2qHHoULWn1axdONW7sw2ytu62y7a5UxCplDMiQw//b3aHsTYnhBk2tnVi2YGwS0jc9fhODpyJyinDv90E5zvA9OC08xSSnVRWkNA3brXFWMQgqm2j4ijQg3uzx9lEZ+8gf2rcIVuSGhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716258; c=relaxed/simple;
	bh=bjR/jZ5eEeoXbqkr8TsncxGQ/O/HMlqfQ8LXSbv3H24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rqq/NeB0gg4vQXmlQ1IhWZW2+2Qt1v00niAlZIRHg9jMwrAj506jBd+jZflOeajJACve55zOjlWl1tnXC5Ds/1JYyWOhWcaPVaFWM+yMbYclJe00MBgM0Z5lH01Yl+5Rupkuhd0vgWv7ga+YkLdQD9sSboTWKuNoJ0ohJUWALZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H40V3ORS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H40V3ORS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3D5C4CEE7;
	Fri, 17 Oct 2025 15:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716258;
	bh=bjR/jZ5eEeoXbqkr8TsncxGQ/O/HMlqfQ8LXSbv3H24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H40V3ORSkabuix5Pf4Cl1gs6hYMPT5mEjGWDT+fCXQfRa6JmAU2x9JZQw4yJB9ynV
	 Zsb+oKeMSmAcp/wqGI0geBPRqT4fDrxGrXbHCikXNC5WmhTcfpR94JQhhB12RFmbhQ
	 IpmLPcnqhnw55AqusxQ75wCOqYr3DwI+C8s09IUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@linaro.org>,
	German Gomez <german.gomez@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@redhat.com>,
	John Garry <john.garry@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/276] perf arm-spe: Save context ID in record
Date: Fri, 17 Oct 2025 16:53:41 +0200
Message-ID: <20251017145147.153470153@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: German Gomez <german.gomez@arm.com>

[ Upstream commit 169de64f5dc22d9984d45c1f119fb644fa16d64a ]

This patch is to save context ID in record, this will be used to set TID
for samples.

Reviewed-by: Leo Yan <leo.yan@linaro.org>
Signed-off-by: German Gomez <german.gomez@arm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Link: https://lore.kernel.org/r/20211111133625.193568-4-german.gomez@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 039fd0634a06 ("perf arm_spe: Correct setting remote access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/arm-spe-decoder/arm-spe-decoder.c | 2 ++
 tools/perf/util/arm-spe-decoder/arm-spe-decoder.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/tools/perf/util/arm-spe-decoder/arm-spe-decoder.c b/tools/perf/util/arm-spe-decoder/arm-spe-decoder.c
index 32fe41835fa68..3fc528c9270c2 100644
--- a/tools/perf/util/arm-spe-decoder/arm-spe-decoder.c
+++ b/tools/perf/util/arm-spe-decoder/arm-spe-decoder.c
@@ -151,6 +151,7 @@ static int arm_spe_read_record(struct arm_spe_decoder *decoder)
 	u64 payload, ip;
 
 	memset(&decoder->record, 0x0, sizeof(decoder->record));
+	decoder->record.context_id = (u64)-1;
 
 	while (1) {
 		err = arm_spe_get_next_packet(decoder);
@@ -180,6 +181,7 @@ static int arm_spe_read_record(struct arm_spe_decoder *decoder)
 		case ARM_SPE_COUNTER:
 			break;
 		case ARM_SPE_CONTEXT:
+			decoder->record.context_id = payload;
 			break;
 		case ARM_SPE_OP_TYPE:
 			if (idx == SPE_OP_PKT_HDR_CLASS_LD_ST_ATOMIC) {
diff --git a/tools/perf/util/arm-spe-decoder/arm-spe-decoder.h b/tools/perf/util/arm-spe-decoder/arm-spe-decoder.h
index 59bdb73096741..46a8556a9e956 100644
--- a/tools/perf/util/arm-spe-decoder/arm-spe-decoder.h
+++ b/tools/perf/util/arm-spe-decoder/arm-spe-decoder.h
@@ -38,6 +38,7 @@ struct arm_spe_record {
 	u64 timestamp;
 	u64 virt_addr;
 	u64 phys_addr;
+	u64 context_id;
 };
 
 struct arm_spe_insn;
-- 
2.51.0



