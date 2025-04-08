Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D5E267F57;
	Tue,  8 Apr 2025 12:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114826; cv=none; b=BlV5B/zWkNwawda9dnvzPvXn3fYgy3DdNdJvCg4BCE4Iz0+xBYbE6Nf3qy0BiEo+dZNZfKerywAXkIk1PDs0AunKiJ4jjqpAygpYg2fgnujwopVFLcIL6/cOQD6/o5QgBf2vg1CPLR4NUff7N0PXxyEuiwCxSsV2fdxofZE1hrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114826; c=relaxed/simple;
	bh=YJxLmvq/sH6HBWcqo4Fm6FCAcGtqBgh3Rqdm9IQA8u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLx9r5M6BxfhI1sOo7/dj+I2AURPV0c6vDmD8Iw0HbOtvaOaTJjgVLoL2IE8vQ8pXQNePmVm8EMi3FQbEvrf6gBGOQU4hfNKfoB3awD/IpODILeBqxpqy5CwkcpITwpKlYwCOy91ss5tJnXVZwRhOT7mn/bS/oQhTflt1hECKWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEe07etY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEe07etY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B15C4CEE7;
	Tue,  8 Apr 2025 12:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114826;
	bh=YJxLmvq/sH6HBWcqo4Fm6FCAcGtqBgh3Rqdm9IQA8u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEe07etYw1/mK6mXr2MbPWVEvVd8SvegNN1KavoFDJ3BvFelz9Oydlr5VejzJz+Zs
	 cM9Z2XyS2hBsY+CNkfj0KfH2T8txNSiPAiY2IvL1Bjk8j3x13mGimEQ/GYRxRxJVBe
	 LQxlFkB2lzOLNB7+Fv1/i2brC4L2aMTX8CUtMjGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 212/499] perf report: Switch data file correctly in TUI
Date: Tue,  8 Apr 2025 12:47:04 +0200
Message-ID: <20250408104856.495410043@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 43c2b6139b188d8a756130147f7efd5ddf99f88d ]

The 's' key is to switch to a new data file and load the data in the
same window.  The switch_data_file() will show a popup menu to select
which data file user wants and update the 'input_name' global variable.

But in the cmd_report(), it didn't update the data.path using the new
'input_name' and keep usng the old file.  This is fairly an old bug and
I assume people don't use this feature much. :)

Link: https://lore.kernel.org/r/20250211060745.294289-1-namhyung@kernel.org
Closes: https://lore.kernel.org/linux-perf-users/89e678bc-f0af-4929-a8a6-a2666f1294a4@linaro.org
Fixes: f5fc14124c5cefdd ("perf tools: Add data object to handle perf data file")
Reported-by: James Clark <james.clark@linaro.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-report.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a5672749f7819..a35f754f05a12 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1555,12 +1555,12 @@ int cmd_report(int argc, const char **argv)
 			input_name = "perf.data";
 	}
 
+repeat:
 	data.path  = input_name;
 	data.force = symbol_conf.force;
 
 	symbol_conf.skip_empty = report.skip_empty;
 
-repeat:
 	perf_tool__init(&report.tool, ordered_events);
 	report.tool.sample		 = process_sample_event;
 	report.tool.mmap		 = perf_event__process_mmap;
-- 
2.39.5



