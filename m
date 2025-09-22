Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16440170A37;
	Mon, 22 Sep 2025 19:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569492; cv=none; b=kBLnyOnPwx/BP7ny0rmYu/mWXjjL0qi3Ssussh8D2Sk4UtqCfj1FavnZz1zv4zLYjGxHwugYgeBWsTrQMzsk678jaaLBtVMOGsG0rie9Q7PjziFVwI1duDDbc+hEEBVQ638HwlZRSe8JrZ/04yTtNyJtKpWa9QOfQpDH/2HCq7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569492; c=relaxed/simple;
	bh=l0s5xIBbTJ73bIUfatbepbNzvcXkwNkZYObnAoqPbAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMUrjv1x721k0guKXNRekCnc5pJAQkeCPQ37cAP9jiynoxTCXgIxQRozQtP+y5iAZ562OJcgwK0VLKhXL1QzgfsJd368ZOrrC69j3w59u4200DMtD5b/KXOkPU/XcgFYcWH37m/tHZ8xR9Hyfw1tCIzF9dhva6z2QyCNMX4Sf1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qn8W2VSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qn8W2VSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350BBC4CEF0;
	Mon, 22 Sep 2025 19:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569491;
	bh=l0s5xIBbTJ73bIUfatbepbNzvcXkwNkZYObnAoqPbAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qn8W2VSEsd8eoVXV0Q7WNxQRFKlPBPHOXay21ifg10MCGhkxSrzdq2lU6MDJjM1xE
	 GbNZsazqoX7dDo/SN1AhlXcAkVCKEdOdJfJB7re81EXQsUmp1otrSVDLAql0P5buMH
	 +FuuziskQIPDbkGrTQMoNjfbwxVEZNlzDj2VP5No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Yuanhong <liaoyuanhong@vivo.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 03/61] wifi: mac80211: fix incorrect type for ret
Date: Mon, 22 Sep 2025 21:28:56 +0200
Message-ID: <20250922192403.635465267@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liao Yuanhong <liaoyuanhong@vivo.com>

[ Upstream commit a33b375ab5b3a9897a0ab76be8258d9f6b748628 ]

The variable ret is declared as a u32 type, but it is assigned a value
of -EOPNOTSUPP. Since unsigned types cannot correctly represent negative
values, the type of ret should be changed to int.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
Link: https://patch.msgid.link/20250825022911.139377-1-liaoyuanhong@vivo.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/driver-ops.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index e685c12757f4b..1f961944ecc98 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1216,7 +1216,7 @@ drv_get_ftm_responder_stats(struct ieee80211_local *local,
 			    struct ieee80211_sub_if_data *sdata,
 			    struct cfg80211_ftm_responder_stats *ftm_stats)
 {
-	u32 ret = -EOPNOTSUPP;
+	int ret = -EOPNOTSUPP;
 
 	if (local->ops->get_ftm_responder_stats)
 		ret = local->ops->get_ftm_responder_stats(&local->hw,
-- 
2.51.0



