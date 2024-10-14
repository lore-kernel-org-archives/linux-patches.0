Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD221AC8A2;
	Mon, 14 Oct 2024 14:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917409; cv=none; b=dLyVPeeo2zemcnEZaGA8ZUyd83xgtvrRJO1EiQNugxsRbMyVv1vvZVEu2KPKthc0F6BfzH0CYI7O4Gd9T1JMIwIRiq4ng+K3VuBeSkBOb63I3ie7Y+o2fH0qGnU9Ab41olNpIsu+v4Qw2zFTDV5Q+/lmq3RhDHn1zy5zrN4XC/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917409; c=relaxed/simple;
	bh=BSZjXo4nusqpQuC3nfLaVme0ZRLCASYtgSRqgC+AgpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBHZNv13xkKiV7dVDSrfKtecfr3F56tBQ2QPwuYrOordZyITMEq++0KR1vSuOlDyOl105IGP9iGCktfEk7l8L6uZXVSxKlcqPRiEFDJl/B4DZL+znWfW4MQbw+HNwI+0BYOwy9Ii9Po32EWkZLK5OuDsE2xk9WPNXlDjBkWvjXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2ZUM1uV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2ZUM1uV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25EFAC4CEC3;
	Mon, 14 Oct 2024 14:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917408;
	bh=BSZjXo4nusqpQuC3nfLaVme0ZRLCASYtgSRqgC+AgpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2ZUM1uVjqqeHGKemBq9WTjrMIoBwZEupjekiG3mDaqs3Nrk43PfWonUcyVysDPKo
	 lxR1KltpnugeuFZ5BysHUO/Opc7fRG8BxZM2g/qYjvXlcBrEofL5/pBVZl/3agqNy9
	 yjjmhnGlaTENnln6t7twMqEzJIOxyQB6iTRgfpTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/798] wifi: iwlwifi: mvm: increase the time between ranging measurements
Date: Mon, 14 Oct 2024 16:09:33 +0200
Message-ID: <20241014141218.705770991@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 3a7ee94559dfd640604d0265739e86dec73b64e8 ]

The algo running in fw may take a little longer than 5 milliseconds,
(e.g. measurement on 80MHz while associated). Increase the minimum
time between measurements to 7 milliseconds.

Fixes: 830aa3e7d1ca ("iwlwifi: mvm: add support for range request command version 13")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240729201718.d3f3c26e00d9.I09e951290e8a3d73f147b88166fd9a678d1d69ed@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
index c604f9f39b248..685649b48c570 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
@@ -103,7 +103,7 @@
 #define IWL_MVM_FTM_INITIATOR_SECURE_LTF	false
 #define IWL_MVM_FTM_RESP_NDP_SUPPORT		true
 #define IWL_MVM_FTM_RESP_LMR_FEEDBACK_SUPPORT	true
-#define IWL_MVM_FTM_NON_TB_MIN_TIME_BETWEEN_MSR	5
+#define IWL_MVM_FTM_NON_TB_MIN_TIME_BETWEEN_MSR	7
 #define IWL_MVM_FTM_NON_TB_MAX_TIME_BETWEEN_MSR	1000
 #define IWL_MVM_D3_DEBUG			false
 #define IWL_MVM_USE_TWT				true
-- 
2.43.0



