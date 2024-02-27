Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE51D13B78E;
	Tue, 27 Feb 2024 14:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043431; cv=none; b=bDWg68G+xjk31ZBpEPQHn/K2PdMcXBNSg+rpH/RfC9C2Rr2tkP/K+/QVjcbLIuASxp7TpLP1jNxw4PgOFpjiWSgnAW59wu2BD9i4kXthIwXVeGLnLbTxCYklT4IdWIrvnttaH83aQdXP4JIRfzeQiYiuxt7SmapeEoYs0i79AIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043431; c=relaxed/simple;
	bh=w2plbAPO1+Fq/JGzrfRzMLCnPPZ++03Kyy3wDmVSihg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZr5kiypzRCa+U8TFjI/bp3KcqsFF48w+oSJDr9h3wqmj2v9NBv2WZSzX8PTu/r8cRA0JqoR6sUvOMENTWvslnhtoa+NuvOcBhuP3SmQHCbWmoyDGQkV4tKLs6w2bnhn/8jFJMaTEWXOQbRCftbHYfi5TnVDUQMQ6UDjUPY4ycs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IkMYVFmA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IkMYVFmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E61CC433C7;
	Tue, 27 Feb 2024 14:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043431;
	bh=w2plbAPO1+Fq/JGzrfRzMLCnPPZ++03Kyy3wDmVSihg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IkMYVFmAEgo0hIELeA6js6Rpmf3TaxqP18s1wEl9VKAlndcMfpvlQ8UrvDNuv+JRK
	 BIaKdkWPsyGOi0/bU6RR8nBCMF3LqGLo2zr6+bt6WgPW6mIbP2AEQzs/juJN76OwFC
	 1tBn7JJ3j5YI01tW94lxe7vTsmApNQi0fDXx50u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/195] wifi: mac80211: adding missing drv_mgd_complete_tx() call
Date: Tue, 27 Feb 2024 14:25:28 +0100
Message-ID: <20240227131612.714313779@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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
index c6f0da028a2a4..f25dc6931a5b1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7294,6 +7294,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 		ieee80211_report_disconnect(sdata, frame_buf,
 					    sizeof(frame_buf), true,
 					    req->reason_code, false);
+		drv_mgd_complete_tx(sdata->local, sdata, &info);
 		return 0;
 	}
 
-- 
2.43.0



