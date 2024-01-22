Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB834E1D8;
	Tue, 23 Jan 2024 00:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969981; cv=none; b=sv4xxjpR2DgQj1CBfH6WET6v3mus9PRK0MaNa1tBiWQ8k9UvBnQ5ZIrmSNx0fDINIviGEG/YXTjyL9WdsYeYx3fou0wPoQWp8ikjvC9YoD107OnG2L84K8iB9P616C7zp/+feepdylJPbQN6fo7wov97bEql13lnjE8rg0yFlZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969981; c=relaxed/simple;
	bh=yLyYkGN8sEePcyCol5mDtsQG2UKdRej704excK1j8cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DwyCbuAzms5YMebxlcLJoOd3qm9T43jmO5hJWc+5LHposemzb3Vp8gku6LZZFx4LyhIb/l4FugEBP4jFJTGsgOWuqzvm6Qq0rv71E2xFaJo2n/OYLHfL0Tyv6bRCyW9tb1QaBzqNBM6JBTFR2jUGJKaQbOQtTJ/kx+070OW7kdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WXHlKfLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WXHlKfLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9241C433C7;
	Tue, 23 Jan 2024 00:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969981;
	bh=yLyYkGN8sEePcyCol5mDtsQG2UKdRej704excK1j8cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WXHlKfLPhv0YOjUs3CMql/NiHvCToTblYuQ+W1XU7Yp3FHymxh2PzVffL/zWLMx1f
	 hV5Ta3fRhbsA1J1rezry8LvwQFaWn01gA2XDlhflulFBgOE/kKzPSXj6DZ9nGbd2/F
	 BM1DY9qFEfMO69qYMQSXR7971+A+To5pNshLia8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@kernel.com>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kajol Jain <kjain@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 549/641] perf vendor events: Remove UTF-8 characters from cmn.json
Date: Mon, 22 Jan 2024 15:57:33 -0800
Message-ID: <20240122235835.320977353@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jing Zhang <renyu.zj@linux.alibaba.com>

[ Upstream commit 457caadce7ab71a54ee2d4f032ee4a55b4a28776 ]

cmn.json contains UTF-8 characters in brief description which
could break the perf build on some distros.

Fix this issue by removing the UTF-8 characters from cmn.json.

without this fix:

  $find tools/perf/pmu-events/ -name "*.json" | xargs file -i | grep -v us-ascii
  tools/perf/pmu-events/arch/arm64/arm/cmn/sys/cmn.json:                   application/json; charset=utf-8

with it:

  $ file -i tools/perf/pmu-events/arch/arm64/arm/cmn/sys/cmn.json
  tools/perf/pmu-events/arch/arm64/arm/cmn/sys/cmn.json: text/plain; charset=us-ascii

Fixes: 0b4de7bdf46c5215 ("perf jevents: Add support for Arm CMN PMU aliasing")
Reported-by: Arnaldo Carvalho de Melo <acme@kernel.com>
Signed-off-by: Jing Zhang <renyu.zj@linux.alibaba.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jing Zhang <renyu.zj@linux.alibaba.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Link: https://lore.kernel.org/r/1703138593-50486-1-git-send-email-renyu.zj@linux.alibaba.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/arch/arm64/arm/cmn/sys/cmn.json | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/pmu-events/arch/arm64/arm/cmn/sys/cmn.json b/tools/perf/pmu-events/arch/arm64/arm/cmn/sys/cmn.json
index 428605c37d10..5ec157c39f0d 100644
--- a/tools/perf/pmu-events/arch/arm64/arm/cmn/sys/cmn.json
+++ b/tools/perf/pmu-events/arch/arm64/arm/cmn/sys/cmn.json
@@ -107,7 +107,7 @@
 		"EventName": "hnf_qos_hh_retry",
 		"EventidCode": "0xe",
 		"NodeType": "0x5",
-		"BriefDescription": "Counts number of times a HighHigh priority request is protocolretried at the HN‑F.",
+		"BriefDescription": "Counts number of times a HighHigh priority request is protocolretried at the HN-F.",
 		"Unit": "arm_cmn",
 		"Compat": "(434|436|43c|43a).*"
 	},
-- 
2.43.0



