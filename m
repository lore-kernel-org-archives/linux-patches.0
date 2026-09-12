Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211C837AA97;
	Sat, 12 Sep 2026 09:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204411; cv=none; b=R9exgqByqiAeDc5kpxq6JxRKRp9QPTD+visKTsJ8OYvy7pAtavZeYwf1qrGhIVRr6sjNuLoWMSRe6dJkybZgdZnE5hSFopJSh9D9GqCcjIMRw0fH9wrjbYoICJWkEcMSbJfHQNu0Pqi8LfCbyvCO0rHvsayoFXXKrwy3BywSsvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204411; c=relaxed/simple;
	bh=5MyvaSxcuB+xcq434ckMChfzQiMfiRDP+ifecozrqBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnDnEPLy/URA2e8pMmoqjEsB2uxBju2AYQ1+uMLdbxo06CGOjCJJjFbMY5AQT7Duv0pfcbx5XS2WjEUIhjvp/3ReMwQKes9muO62Fy4cZGJrzvXkqx8kuJSXG+af2Ra7/7fgBt0bSmWJrieYAJx37p3hQl6/CUKOuREcXzVGDzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhpuD183; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhpuD183"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C6D1F000FF;
	Sat, 12 Sep 2026 09:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204410;
	bh=lzRkc7eJK6WWkL3TxymHv02pomJ+f4HzChL/eDTZWEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhpuD183ccljgWrjkwyav20uKkK2MFBZGiwm8S3SMI1yeVKTazHIimhpV3t0s0i7X
	 0al3Cu07nojFfG2pG1gdPVGxW5W1Q/xj7QhqekhKaeFedE6XSt/wcZKM8BZ5Mzpz9a
	 fDsKPDuwdskiN+X8x+QL28DUTwiY0nWXjorx4/AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Besar Wicaksono <bwicaksono@nvidia.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1600/1815] perf vendor events arm64: Fix Tegra410 Olympus event 0x0197
Date: Sat, 12 Sep 2026 08:55:50 +0200
Message-ID: <20260912065726.552039986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Besar Wicaksono <bwicaksono@nvidia.com>

[ Upstream commit 9453bc6a69ef43755f1c28d5688cacdd69fa16bd ]

The name and description for NVIDIA Tegra410 Olympus implementation-defined
event 0x0197 incorrectly indicate a TXREQ limit between one quarter and
one half. Correct them to describe a TXREQ limit below one half.

Fixes: 86ff690f45cc ("perf vendor events arm64: Add Tegra410 Olympus PMU events")
Signed-off-by: Besar Wicaksono <bwicaksono@nvidia.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/arch/arm64/nvidia/t410/misc.json | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/pmu-events/arch/arm64/nvidia/t410/misc.json b/tools/perf/pmu-events/arch/arm64/nvidia/t410/misc.json
index 8ff87d844e521..e1b45cc33b180 100644
--- a/tools/perf/pmu-events/arch/arm64/nvidia/t410/misc.json
+++ b/tools/perf/pmu-events/arch/arm64/nvidia/t410/misc.json
@@ -316,8 +316,8 @@
     },
     {
         "EventCode": "0x0197",
-        "EventName": "TXREQ_LIMIT_1QUARTER_CYCLES",
-        "PublicDescription": "Number of cycles in which the dynamic TXREQ limit is between 1/4 of the L2_TQ_SIZE and 1/2 of the L2_TQ_SIZE."
+        "EventName": "TXREQ_LIMIT_BELOW_HALF_CYCLES",
+        "PublicDescription": "Number of cycles in which the dynamic TXREQ limit is between 0 and 1/2 of the L2_TQ_SIZE."
     },
     {
         "EventCode": "0x019d",
@@ -517,7 +517,7 @@
     {
         "EventCode": "0x01cc",
         "EventName": "TXREQ_LIMIT_COUNT_CYCLES",
-        "PublicDescription": "This event increments by the dynamic TXREQ value, in each cycle.\nThis is a companion event of TXREQ_LIMIT_MAX_CYCLES, TXREQ_LIMIT_3QUARTER_CYCLES, TXREQ_LIMIT_HALF_CYCLES, and TXREQ_LIMIT_1QUARTER_CYCLES."
+        "PublicDescription": "This event increments by the dynamic TXREQ value, in each cycle.\nThis is a companion event of TXREQ_LIMIT_MAX_CYCLES, TXREQ_LIMIT_3QUARTER_CYCLES, TXREQ_LIMIT_HALF_CYCLES, and TXREQ_LIMIT_BELOW_HALF_CYCLES."
     },
     {
         "EventCode": "0x01ce",
-- 
2.53.0



