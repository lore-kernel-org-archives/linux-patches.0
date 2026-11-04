Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829506;
	b=wUUzhS6ZPwzWQoSDs2c0C1eB45ZLuATWmuAjgNUHzxD/IoTgGayPi8AY36ZvOfRjf1Bz
	 MVUMQeWjKaLQEPcoRgqsoojAoZ3wEZ3JfZrtQ2dOxsiY15CwHuFDkQ/fB90EkhK/c+aZj
	 5cn5N3zyjseNACcV9j757U9kKcgNRaLrImn1GcNcpSBeUfu2xSzXxZoUjoWSPhIJaH5fh
	 uV+uptxsYQ2Ml+C7oHrW5f4DQ9bjAir4UB6vTTyepmtWgHaYgxi34zHDkpwqA6pJNRgeB
	 nENnwPk5l/WgpUgItttR2pAkMVBd2YyqPuePxIdpHQlB4mXXyWNGnq6akMox8TTygDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lkBp+SWG+h9Aaw812yo5h5WDZ0JujfXSIXKxp0zCZbM=;
	b=FfYmHX91PWV6zCW+20rNuWlVgvZfAtHKhAwY/P9H+FvHdIDZW9r8/eWCHIRaCr2KTTp1
	 isqUh7QKAc8AOVDUwloN3e/OovQSAVDQrkQW3qVoxfU22ww0OS1jcvtslLwtm8FCWgHIL
	 bHSHdA5PiHGfleVgE3FmLcFo+YJE1q7tUgukacvDNGuAYldYzCsPHoPJJzmdVJlnYgLRN
	 1hC77VzripGVRCdjzZzPfW5lQQ7qiroNFWGkN2aKESmIDLFGdmpjx1jQDdWnFcDYPCWBi
	 aoY91GRGCxOTK3wW2XQpcTaCB/a9Pt+It260tt2AqNzYJPj3LX8ZEl35y5x90yRw6Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MI0qDwL+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D194606A87C;
	Wed,  4 Nov 2026 21:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MI0qDwL+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2351F000C1;
	Wed,  4 Nov 2026 21:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829506;
	bh=lkBp+SWG+h9Aaw812yo5h5WDZ0JujfXSIXKxp0zCZbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MI0qDwL+2FphIY8XN2HpUJE0p+3ABdMC9Fe5vWdns3p7I1QpnkqecShOqqsHOCYfh
	 yjDi8fWIPgQDtHJ6oJlUyYdv5Eql4yYM7LqtVG0QTRKIY2S+TG1sQV3zAjqO9MXrPF
	 TJ1IXpRcd+e823L1jQ950BAcS8ngO2eBFR3DMCH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0167/1005] wifi: iwlwifi: mld: support aborting an ongoing ftm request
Date: Wed,  4 Nov 2026 15:58:20 -0500
Message-ID: <20261104211048.444555487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit ef704fc32ae1a519801ac4a06aa290fece5f403c ]

Add support for aborting an ongoing FTM request.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715220243.340040bdc6a3.Ifbbf70021e42bf1d59db6ec45a73f1806a1c2289@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/iwlwifi/mld/ftm-initiator.c         | 21 +++++++++++++++++++
 .../intel/iwlwifi/mld/ftm-initiator.h         |  1 +
 .../net/wireless/intel/iwlwifi/mld/mac80211.c | 10 +++++++++
 3 files changed, 32 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c
index 3464b32687124..6e174c4d8b75e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.c
@@ -449,3 +449,24 @@ void iwl_mld_ftm_restart_cleanup(struct iwl_mld *mld)
 			       mld->ftm_initiator.req, GFP_KERNEL);
 	iwl_mld_ftm_reset(mld);
 }
+
+void iwl_mld_ftm_abort(struct iwl_mld *mld, struct cfg80211_pmsr_request *req)
+{
+	struct iwl_tof_range_abort_cmd cmd = {
+		.request_id = req->cookie,
+	};
+
+	lockdep_assert_wiphy(mld->wiphy);
+
+	if (req != mld->ftm_initiator.req)
+		return;
+
+	if (iwl_mld_send_cmd_pdu(mld, WIDE_ID(LOCATION_GROUP,
+					      TOF_RANGE_ABORT_CMD),
+				 &cmd))
+		IWL_ERR(mld, "failed to abort FTM process\n");
+
+	iwl_mld_cancel_notifications_of_object(mld, IWL_MLD_OBJECT_TYPE_FTM_REQ,
+					       mld->ftm_initiator.req->cookie);
+	iwl_mld_ftm_reset(mld);
+}
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.h b/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.h
index 3fab25a52508a..e82237b314673 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ftm-initiator.h
@@ -25,5 +25,6 @@ int iwl_mld_ftm_start(struct iwl_mld *mld, struct ieee80211_vif *vif,
 void iwl_mld_handle_ftm_resp_notif(struct iwl_mld *mld,
 				   struct iwl_rx_packet *pkt);
 void iwl_mld_ftm_restart_cleanup(struct iwl_mld *mld);
+void iwl_mld_ftm_abort(struct iwl_mld *mld, struct cfg80211_pmsr_request *req);
 
 #endif /* __iwl_mld_ftm_initiator_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 69a066904a808..5234229a070a7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -2609,6 +2609,15 @@ static int iwl_mld_start_pmsr(struct ieee80211_hw *hw,
 	return iwl_mld_ftm_start(mld, vif, request);
 }
 
+static void iwl_mld_abort_pmsr(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct cfg80211_pmsr_request *request)
+{
+	struct iwl_mld *mld = IWL_MAC80211_GET_MLD(hw);
+
+	iwl_mld_ftm_abort(mld, request);
+}
+
 static enum ieee80211_neg_ttlm_res
 iwl_mld_can_neg_ttlm(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		     struct ieee80211_neg_ttlm *neg_ttlm)
@@ -2696,5 +2705,6 @@ const struct ieee80211_ops iwl_mld_hw_ops = {
 	.prep_add_interface = iwl_mld_prep_add_interface,
 	.set_hw_timestamp = iwl_mld_set_hw_timestamp,
 	.start_pmsr = iwl_mld_start_pmsr,
+	.abort_pmsr = iwl_mld_abort_pmsr,
 	.can_neg_ttlm = iwl_mld_can_neg_ttlm,
 };
-- 
2.53.0



