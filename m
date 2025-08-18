Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9814B346A09;
	Mon, 18 Aug 2025 13:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525472; cv=none; b=iptMSongfYVgIOjUmbUushKti7iJIiL7HGIJ3S5o3dm3u9BA97vFkynjQO6k4eks4FkEnP7BmXOvsLTD6v+Sv5fW1W7miehJAFrdDLCpKennR7XFZNYbjmI4z2btVEILiRG2Qb+OrEM5yX0FfZYbaD/OILUJJ2ZooAqIAmYlyXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525472; c=relaxed/simple;
	bh=xksyfWOY8fJ2wd93Q/0+6QChfYBkjSWmTI3q8/hA4BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBUbDcV/kniT25fwdKAKCi3wNVUjVGqJsUW3Cfh3RspFnbV2PNMIn1dIo26UA1MHv1mXKjmkEh0ELivealwBeCpv4Zp6fSq1+037S3gxLHkL/8+sbXW3ykOIgodXKdiyjOjofexgA5U8FvbMoAOer/4N3tZI3HuWJYjCxeAZi4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0zv2on4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0zv2on4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C0AC4CEEB;
	Mon, 18 Aug 2025 13:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525472;
	bh=xksyfWOY8fJ2wd93Q/0+6QChfYBkjSWmTI3q8/hA4BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0zv2on4KHdCDCE/qVU0JHxmwk51c3LUVt6Ir5x6fiAtXBOT7a261tc3GgU67eK8K
	 B3MQyD45lDFLbQ5shdSUSmUXbUTog6jVZtCCwb3ZPzUhwpuXw23fm0aYYjpbbTlmJV
	 m1nJxHmADPK/EtRldcsR/FlMS13E1Cx5CW9qroL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 242/570] wifi: cfg80211: Fix interface type validation
Date: Mon, 18 Aug 2025 14:43:49 +0200
Message-ID: <20250818124515.145057362@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 14450be2332a49445106403492a367412b8c23f4 ]

Fix a condition that verified valid values of interface types.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250709233537.7ad199ca5939.I0ac1ff74798bf59a87a57f2e18f2153c308b119b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 10248d527616..1faeb587988f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -633,7 +633,7 @@ ieee80211_get_sband_iftype_data(const struct ieee80211_supported_band *sband,
 	const struct ieee80211_sband_iftype_data *data;
 	int i;
 
-	if (WARN_ON(iftype >= NL80211_IFTYPE_MAX))
+	if (WARN_ON(iftype >= NUM_NL80211_IFTYPES))
 		return NULL;
 
 	if (iftype == NL80211_IFTYPE_AP_VLAN)
-- 
2.39.5



