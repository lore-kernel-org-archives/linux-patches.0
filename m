Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C281CFEB0;
	Wed,  2 Oct 2024 13:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875270; cv=none; b=gNVKtKODAnMd7g4MWzunbXTqYpOpmYJG0oT/XxPJZ+fM4XA45W3c8sAvyEDIhrviLmxrx5AwOTSMDvgNUTgj0DhyI64UUuz1vSHju3qXB1DfW145yZtrOqy5CiiSnHvId2m6F4nR4EEAVyw0KOanNJOXTtqBCnSrSDhS8f8Vock=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875270; c=relaxed/simple;
	bh=z5IidawbhCo3u+G8fSDHByr51yANxCn2aOICNR2CXTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdIiI/mIBjii9y2J724O6pKYkoHfU2Oagez97IBlPvbe/GAlcgQnXHUfEbSwyrPuARrSRkoKsFODJUBfuouom9C90aWD0F8zGkcbnvtAtm+RJs+CvpjvtBN2HLLOzKOL7u11JXHWJ6PcDfII6+nawhGUWG0MuAU8PUp+vSpBlTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYX08/tO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYX08/tO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325F1C4CEC5;
	Wed,  2 Oct 2024 13:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875269;
	bh=z5IidawbhCo3u+G8fSDHByr51yANxCn2aOICNR2CXTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYX08/tOSZqsitOiONWp5mWzBnldoPbmOct/fq8lqc1Q+/M+x/AII/zu9B5hXLIhk
	 HAH8J/zv7WGMgovT2/LLrwEizVJGFnu7jsD5MDTgcdHclwdSZREo8NW7s1ysTmC+9r
	 yKYje5bcJH/ZhGzvsya+CS2CaBVSyhkzOGZ8UOgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 045/695] wifi: mac80211_hwsim: correct MODULE_PARM_DESC of multi_radio
Date: Wed,  2 Oct 2024 14:50:43 +0200
Message-ID: <20241002125824.287912725@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit 7c24c5bdf489c8f3a9c701a950126da871ebdaca ]

Correct the name field in multi_radio's MODULE_PARM_DESC.

Fixes: d2601e34a102 ("wifi: mac80211_hwsim: add support for multi-radio wiphy")
Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
Link: https://patch.msgid.link/20240712074938.26437-1-kevin_yang@realtek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virtual/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index d86e6ff4523db..5fe9e4e261429 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -71,7 +71,7 @@ MODULE_PARM_DESC(mlo, "Support MLO");
 
 static bool multi_radio;
 module_param(multi_radio, bool, 0444);
-MODULE_PARM_DESC(mlo, "Support Multiple Radios per wiphy");
+MODULE_PARM_DESC(multi_radio, "Support Multiple Radios per wiphy");
 
 /**
  * enum hwsim_regtest - the type of regulatory tests we offer
-- 
2.43.0



