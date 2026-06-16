Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BA644DB6D;
	Tue, 16 Jun 2026 16:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625789; cv=none; b=CMWE34HwGGEb7uW9Y8DqIWXxpQ6jkSWUM9D4mNBR0E1BpWA14cPRIgOEqxME/555AFjMQO7ncIfxxRYcKJwUd/4iBMVgnWLK8+L/spWqdjTVWPCszZGnS8I7RdxX9MJS1Rohm2Wpafh6Ffi8Zl+4yMcT4AB+/ymvYHIIE3Ip0/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625789; c=relaxed/simple;
	bh=AIfPuUfrrz0E/iSL0E7tmd4j0c1FM2d5zWDpKkKKHQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZDjQp7kwVLdkxqQFyWsq09K6iIcM+Spiya/vtpkL11YBnlCrKc36iKPqJlAeBtJtM/YxA8CI1eFMXlXjY3kMF/tBXpDEQteH1a0rP0E4pSz0ZcjwWHCfO3sHinfSNCVtdMYuvsD85VMMlIPqKLg2j3O6VoW2j+MGyknaqSNgf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=viG5SQkd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="viG5SQkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9E41F000E9;
	Tue, 16 Jun 2026 16:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625788;
	bh=kjr9ur1lYIdjDOlQ5meoCQJdMCYBg6et8mbP4rwcaqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=viG5SQkdEOslgamgFH34Poi/N3bDvkI8O3qGpAxTpER5yWSgFNjhWioRQK3J14lrm
	 kppaf6NTm2h6bHzDVppJyE9SHXDmPWT2nneaamm6rjy3nnvwxyeLhOrcLBqYRFEFl0
	 BaC3YYgyuavpGXmcsgln4uUG/lDwMF+AuIcL0/+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 206/325] wifi: nl80211: reject oversized EMA RNR lists
Date: Tue, 16 Jun 2026 20:30:02 +0530
Message-ID: <20260616145108.310926026@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuqi Xu <xuyuqiabc@gmail.com>

commit 4cd92957e8f8cc4ebfe8a5d4203c14c592fde6b1 upstream.

nl80211_parse_rnr_elems() stores the parsed element count in a
u8-backed cfg80211_rnr_elems::cnt field and uses that count to size
the flexible array allocation.

Reject nested NL80211_ATTR_EMA_RNR_ELEMS input once the count reaches
255, before incrementing it again. This keeps the parser aligned with
the data structure it fills and matches the existing bound check used
by nl80211_parse_mbssid_elems().

Fixes: dbbb27e183b1 ("cfg80211: support RNR for EMA AP")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Link: https://patch.msgid.link/20260529152542.1412734-1-n05ec@lzu.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/nl80211.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6079,6 +6079,9 @@ nl80211_parse_rnr_elems(struct wiphy *wi
 		if (ret)
 			return ERR_PTR(ret);
 
+		if (num_elems >= 255)
+			return ERR_PTR(-EINVAL);
+
 		num_elems++;
 	}
 


