Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0312146AA68;
	Tue, 21 Jul 2026 15:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648282; cv=none; b=WNm+H+NjnIBoFvmvG/QaIaFfsozfiL0yF9NIUxv3UqDH/Mljbl9CY5K6m8ejvPxkXjXEj6AMIS4zZrPIhEhWioJehLlPpXuLpdL5y+K2StJyrw9eLCqhyaYpdDu5OohqTK2an59JaDGQNP5MJGl60/zTFgaERtM2woQthbzvGq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648282; c=relaxed/simple;
	bh=tXHu54W0bncaWC/A2HMAzWwOthgm1CCEMq0yJW+R5Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rc1eQNHC02mVhoBy75+ZgNNe5XOvUigR+zlJB/OIxsq1o2io2UUuggxD3GomOmZXnAPal5nRrvE8rVuhDYIXDNxKuvozzc9BHyYluZRK9cgYhPNwGUmHhZnQJ+55Rf9MdZdRQsCpPQ/XtCgBpMv5D/BLicrBvyur4b5KRFiMyzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vsuv/TAb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vsuv/TAb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906A51F000E9;
	Tue, 21 Jul 2026 15:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648280;
	bh=R/l8SRMlOAjspXFOOm4YZBoJL673kJf2IIlXSbXoaAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vsuv/TAbsOBVSqx7Uf6+tZ0ApaW47r+n7azgEz9Kun+e0JuRq3uivu5wDan327Is0
	 u/SoCWk99UGzFtFtKLEnwdBBnxd72ldCbrjydNXZVmt977RtnoRep41peVpJW5Gcgl
	 6lB8CVKogwhLNt447y80uHI3qd3wNiiZrx7FWrog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kavita Kavita <kavita.kavita@oss.qualcomm.com>,
	Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0141/2077] wifi: cfg80211: restrict LMR feedback check to TB and non-TB ranging
Date: Tue, 21 Jul 2026 16:56:54 +0200
Message-ID: <20260721152556.013439940@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>

[ Upstream commit bef9d5e378f07ccdf967b929897de84a9931d1e3 ]

The lmr_feedback field is only applicable to TB and non-TB ranging.
Currently, pmsr_parse_ftm() enforces lmr_feedback for all RSTA
requests, incorrectly rejecting valid EDCA-based RSTA requests.

Fix this by limiting the lmr_feedback requirement to TB and non-TB
ranging only.

Fixes: 853800c746d3 ("wifi: nl80211/cfg80211: support operating as RSTA in PMSR FTM request")
Co-developed-by: Kavita Kavita <kavita.kavita@oss.qualcomm.com>
Signed-off-by: Kavita Kavita <kavita.kavita@oss.qualcomm.com>
Signed-off-by: Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>
Link: https://patch.msgid.link/20260420090856.2152905-2-peddolla.reddy@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/pmsr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index d6cd0de64d1f84..0ca93fd7d46f8d 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -195,7 +195,9 @@ static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
 		return -EOPNOTSUPP;
 	}
 
-	if (out->ftm.rsta && !out->ftm.lmr_feedback) {
+	if (out->ftm.rsta &&
+	    (out->ftm.non_trigger_based || out->ftm.trigger_based) &&
+	    !out->ftm.lmr_feedback) {
 		NL_SET_ERR_MSG_ATTR(info->extack,
 				    tb[NL80211_PMSR_FTM_REQ_ATTR_RSTA],
 				    "FTM: RSTA set without LMR feedback");
-- 
2.53.0



