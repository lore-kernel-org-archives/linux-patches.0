Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CBA33936C;
	Mon, 31 Aug 2026 13:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184165; cv=none; b=Dff1y2I8sXvQSUyDa9bIqd4iCAaVI7EZRO0x6u3MmOljqvokFHUZSjhqEYbnC07YQEetAr83++h3SG+sdzKj85X6HSM4TbrOqEK+6paCMje+H2TT3dXmo2zgHNOWEbR/M4uOUHxiLi+P7iXkVGRXdupvufVU4pdw2cqXj2eh4I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184165; c=relaxed/simple;
	bh=P43ptgByxMJNvhdVYQD3OBuf+iwUNXF+nmLaDKab8go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eYXDY53q75Wyj/0iWXdgkwGLRS2rIK7ccg6O0CpLziIl9SifrRHHmyn9gjjhgZeUBGRoozw80svLBbpWp0++A1mqagU2LvHOxtMTOFfSSDhGDq0f8mZfwndYduVY1qpXZMNQQ3C7V98AZSbtMQC4nWvFGPBoqRVE6IaPNHbLvzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M8EMEdTE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M8EMEdTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF071F000E9;
	Mon, 31 Aug 2026 13:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184162;
	bh=1nQyxmkp8tlhFDXVLiFpoKYrMGHF3fMThmSxilPpkeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8EMEdTEXjZcLkKJCz1SSbGMlLrGhFNQXf/cdo0i30LWwSdCoBklH7GWhi3pdTLNO
	 A7T2mf67OJXd7muC35vAbdj+1KR06TzW5FeN37K1inL9krLV07wH1wqObg1mpcwP+2
	 bSCYVEKv+RjnpC3PSeejBR70HzeZwGmoQMJ/9bTBbo0CsqNbo2vJJiBWkYiEwRxyEp
	 KZMPiLRcYRcH99KoaE39GKekXcYv4P5ixLm9kmQoZYrRjxj3C3kD9dl5lc6hNDoS9F
	 307FKeBsEvbK+Qabcf2GcmM4gVBp3A60IxDtwm05Wb9IXqd1+9WG+9jAsN1VZ0ASTP
	 M4oisIk3DPcwQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	GitHub Copilot <copilot@github.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mvm: d3: validate D3 resume notification payloads
Date: Mon, 31 Aug 2026 09:29:16 -0400
Message-ID: <20260831133314.4125787-528-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit c1a1dc162870a5447cb0fbcf81983473744772d2 ]

D3 resume notification handlers read firmware notification fields
before validating that the payload contains the complete fixed structure.
This causes buffer underread on malformed or truncated notifications.

Move payload length validation to occur before any field access in:
- iwl_mvm_parse_wowlan_info_notif: validate before reading num_mlo_link_keys
- iwl_mvm_wait_d3_notif D3_END handler: validate before reading flags

Assisted-by: GitHub Copilot <copilot@github.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.762193753434.I148991b8136cc5042fa08b5faf7b57d38aa2fb47@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The branch check finished: the fix commit `23939b1d1be` is only on the
`autosel` branch, not on current HEAD (`v6.18.44-1-g2736c32da98b9`). The
ancestry-path from that commit to HEAD is empty, so the buggy code is
still present in the checked-out tree.

That matches the earlier analysis: this is a prepared backport candidate
that hasn’t been applied to 6.18.y yet, and the **YES** recommendation
still stands.

 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 46e95e25dcd44..dd1c21065bc33 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2141,16 +2141,16 @@ static void iwl_mvm_parse_wowlan_info_notif(struct iwl_mvm *mvm,
 					    struct iwl_wowlan_status_data *status,
 					    u32 len)
 {
-	if (IWL_FW_CHECK(mvm, data->num_mlo_link_keys,
-			 "MLO is not supported, shouldn't receive MLO keys\n"))
-		return;
-
 	if (len < sizeof(*data)) {
 		IWL_ERR(mvm, "Invalid WoWLAN info notification!\n");
 		status = NULL;
 		return;
 	}
 
+	if (IWL_FW_CHECK(mvm, data->num_mlo_link_keys,
+			 "MLO is not supported, shouldn't receive MLO keys\n"))
+		return;
+
 	if (mvm->fast_resume)
 		return;
 
@@ -2970,6 +2970,11 @@ static bool iwl_mvm_wait_d3_notif(struct iwl_notif_wait_data *notif_wait,
 	case WIDE_ID(PROT_OFFLOAD_GROUP, D3_END_NOTIFICATION): {
 		struct iwl_d3_end_notif *notif = (void *)pkt->data;
 
+		if (len < sizeof(*notif)) {
+			IWL_ERR(mvm, "Invalid D3 end notification size\n");
+			break;
+		}
+
 		d3_data->d3_end_flags = __le32_to_cpu(notif->flags);
 		d3_data->notif_received |= IWL_D3_NOTIF_D3_END_NOTIF;
 
-- 
2.53.0

