Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F1F2FF14E;
	Tue, 12 Aug 2025 17:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021540; cv=none; b=TeS886/1en85XXCAPy/K0MNL0cxExyl/X2Hm0/QDR7wivQFK0StIM2vly4JnHiviW0jgxiscBUt5DT7pAzdZc59wGqQogclJ2Bhyy9EPZSIQlZgeC67dE0v/v9R2Yfjb0vH2F4Is4JpDs4pz20xGExkE0bE6fIySPGW60e1LCJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021540; c=relaxed/simple;
	bh=qxuBUodC7vtnNSk7JxgqTQyxirqo7D7NZL918L+L4sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIG9Xsy6M1BJkxiNlyxi8Tz6Nsz/3I3MESdvgApNd4eQnIzYJtpURgZ8UCPsl3Xa3uOM1Gt1ZTBbsrdo9TuFHfiq8eB/XvLVjj5TgEmGPxqcoOWCASEZXNxxO+pam0CC662tzx5l7izKMNBuNxaMTkpa09mNW9bO28o5+zoJz4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWuEIZF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWuEIZF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7E8C113D0;
	Tue, 12 Aug 2025 17:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021540;
	bh=qxuBUodC7vtnNSk7JxgqTQyxirqo7D7NZL918L+L4sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWuEIZF7YYH6Chb+eQaX+XjYyaySt0YIK9FVv0y2xNpp/mRzKMJXsQaYm/ydLf3Rx
	 iicuBWTIQQ5Jd9ZGhGSzjhFmJRuSTdsLmWKcUYC+QLFN01CPw4Teshv3xTDs0z+Lbs
	 NDJkZauTWytmIB0oOYYyCMEEusiZF1LzSVp1Kris=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Pei <cp0613@linux.alibaba.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/262] perf tools: Remove libtraceevent in .gitignore
Date: Tue, 12 Aug 2025 19:28:59 +0200
Message-ID: <20250812172959.530397305@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Pei <cp0613@linux.alibaba.com>

[ Upstream commit af470fb532fc803c4c582d15b4bd394682a77a15 ]

The libtraceevent has been removed from the source tree, and .gitignore
needs to be updated as well.

Fixes: 4171925aa9f3f7bf ("tools lib traceevent: Remove libtraceevent")
Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250726111532.8031-1-cp0613@linux.alibaba.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/.gitignore | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index f533e76fb480..5a8617eb5419 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -45,7 +45,5 @@ libbpf/
 libperf/
 libsubcmd/
 libsymbol/
-libtraceevent/
-libtraceevent_plugins/
 fixdep
 Documentation/doc.dep
-- 
2.39.5



