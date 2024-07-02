Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C4F1BE857;
	Tue,  2 Jul 2024 17:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941363; cv=none; b=Yfv3J7nLJdC0ad0cTxpPza3xrqWcXJCbLm4WiexPTnwYkgegIgDx6aHxI9G+rYOYtoWOdcmoWIObqdEf8dusWNbnvXwtxNiqvrUcKA1mMwWC98hQ+/bm7mRRgu6bEtqCYyAP5gpDs7tZhQSk7nvW9aUQhUDQcRMAfhleEICVViY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941363; c=relaxed/simple;
	bh=TvElHbeZ9olUly5cPtI85QAYNo1KFVxu52mzaHO0/Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDB8QjHnh70AQGhqKbaDidO+4pjc66fNwO9ulYDLFuPV6p/3Yq4liartVMipMIYNeRnL9iwjVTULw8tie4ONUOzCNjV0Q1J3xloaXQ9aON/CTD2fi/y0O77hPynO2b2jIBlqZvVyxz7U3Qg73S8W8nwaUgm9lsY8CKBaF7/trkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oIXooVmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oIXooVmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89783C116B1;
	Tue,  2 Jul 2024 17:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941363;
	bh=TvElHbeZ9olUly5cPtI85QAYNo1KFVxu52mzaHO0/Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oIXooVmvtZJyo+j3u887aQLfGZVBcGReVDxKY+mNnQKKoOi7AKUA55D6P8QVQta04
	 01F+g7yyOzorxECE5/AOSDLABoMJk5wdnSPPn126La8iACNCm7HEV2HgZXAfAI5ucs
	 pn+/xZkEAxbJDTB0g6mNL+mloDg6i5JIhowyNWPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/128] wifi: ieee80211: check for NULL in ieee80211_mle_size_ok()
Date: Tue,  2 Jul 2024 19:04:03 +0200
Message-ID: <20240702170227.826587738@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b7793a1a2f370c28b17d9554b58e9dc51afcfcbd ]

For simplicity, we may want to pass a NULL element, and
while we should then pass also a zero length, just be a
bit more careful here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240318184907.4d983653cb8d.Ic3ea99b60c61ac2f7d38cb9fd202a03c97a05601@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index dce105f67b4d8..160230bb1a9ce 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -4608,7 +4608,7 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, u8 len)
 	bool check_common_len = false;
 	u16 control;
 
-	if (len < fixed)
+	if (!data || len < fixed)
 		return false;
 
 	control = le16_to_cpu(mle->control);
-- 
2.43.0



