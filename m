Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FE31CFEB3;
	Wed,  2 Oct 2024 14:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879218; cv=none; b=M7NCkF9V/VAqdz72eKcMcIgvu+0Dl9rp4QgMkWTynPDdPz3FfGHQdCMGdmtzvjG1f6D+5SucyomB15NsUWQHrtkU0PDPqslOXk4n7fQ6gWKloAd7Xu+QzX3AS9/K2HlMmN+sUIyTyp7yYtfbASsyM4kDLXBgzOJsihZtM72fg74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879218; c=relaxed/simple;
	bh=jeSjJVPKA3YC1qySXKmxDbebALpl4DZDhgAsWU5E+3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPecpJUUMjOZ4QYpKwsvAWv+tafrnhOAfM2hAdzJv31GjBTGLt+qfTNdIVJ2POYB6I7BmT1aYXm4ga/28BENE4htSn/0Ai4qy0VY4UHRegBUC66LhkJl9WKBw2dGLX3+ornPhJRCqcHCfmi92RsYGDWyjsojrlwBsLMSpT67s9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kO7pfjv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kO7pfjv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A16C4CEC2;
	Wed,  2 Oct 2024 14:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879218;
	bh=jeSjJVPKA3YC1qySXKmxDbebALpl4DZDhgAsWU5E+3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kO7pfjv9w07YiXkh2lR8xERC7iNrSkCBcQu5HQlEQXUq7cDJzdxHLvjpwemSRRhWB
	 CxLfvHaiUgeDyZRQHxqv0ts79HCn2XEMzdV4tSS23ahIuPx9QXOxDuPN5tWYvMiDCX
	 Mp+nuJgql5ExSZMFfQ30JWdrA304E2IPMlNsJx0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/538] wifi: iwlwifi: mvm: increase the time between ranging measurements
Date: Wed,  2 Oct 2024 14:54:25 +0200
Message-ID: <20241002125753.051862889@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index 243eccc68cb05..f7bec6f3d7584 100644
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



