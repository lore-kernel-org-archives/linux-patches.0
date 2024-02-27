Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CA713B29B;
	Tue, 27 Feb 2024 13:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041907; cv=none; b=N7C6X+y8Dfsua9c58uoh8RDg9fHb9Y4WhiElDz6oykmZdbFUERMqIDu+lgW1cxqFkEwIi/rZjaOxOkCvUNyM+zoHFGbRoXL5m2UqTi1Cg65zJDVlAU+v2mY7rfCST9PaMxZyFP1qbpwVmwREc4YscaYOKu/I0Vtz6CEMSIGr5Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041907; c=relaxed/simple;
	bh=UuzSS+dV3SQUjzt4f1g7j4YMsuaPWssr2ZMt7LMsRVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlQq7A1EIU9rAiVq74WkDx6R9iPZ6GMH/dgxTlLbYXFim8ykkcALX0IwmsmUJhHhqyEn4MV+XvTWJ5OfdYfnOQQKmP/LY5AStiXDOpldweQr6W9A7UyPn9a3nlbfbj+Sl2DoXv9+2Z27+w6GSFFd3djdoRfiEe2SjFw9tQ6Khew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dfyy+oQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dfyy+oQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5244C433F1;
	Tue, 27 Feb 2024 13:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041907;
	bh=UuzSS+dV3SQUjzt4f1g7j4YMsuaPWssr2ZMt7LMsRVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dfyy+oQi7hfYFQnlfd9OOSwdGBPIk91pUzCCyFjmdnyH6UbKqkY4U3CGpj3QD8d2a
	 +LVxeKBiC//Ydo/lL1/knqTnPU0OAaNah0gHqGHY4RU+qGDr+zI+5WII4IZZ3ZEXjd
	 9rCB9gOch+kgzvfwEvwb5Qd2XlNo3p+iZeK//D2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/299] wifi: mac80211: adding missing drv_mgd_complete_tx() call
Date: Tue, 27 Feb 2024 14:23:24 +0100
Message-ID: <20240227131628.898372651@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit c042600c17d8c490279f0ae2baee29475fe8047d ]

There's a call to drv_mgd_prepare_tx() and so there should
be one to drv_mgd_complete_tx(), but on this path it's not.
Add it.

Link: https://msgid.link/20240131164824.2f0922a514e1.I5aac89b93bcead88c374187d70cad0599d29d2c8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d9e716f38b0e9..c6044ab4e7fc1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7800,6 +7800,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 		ieee80211_report_disconnect(sdata, frame_buf,
 					    sizeof(frame_buf), true,
 					    req->reason_code, false);
+		drv_mgd_complete_tx(sdata->local, sdata, &info);
 		return 0;
 	}
 
-- 
2.43.0



