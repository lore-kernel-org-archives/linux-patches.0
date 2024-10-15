Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B655A1D90CD;
	Tue, 15 Oct 2024 11:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992265; cv=none; b=n8RE/DT4D2vJmNG8+KHvp6cOX/gZ3aE/pBjLb+r+BuruXbeWE6qxVguZUuXarZNoOx/AQRGv7kd2cWrPUsOjHlZCalCGwmxwIJykhFfXXE2boXBl8t5CWGiKFFRusrieV7spwHjf6n1DIDhjmudVPKNsFp79iwWdsJ6/2cEmwQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992265; c=relaxed/simple;
	bh=S3efWtw7aSgi5j2NT2CXbhm6IERW8pKyaYHAvSPqwBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdIRywrklV3qilqErWFvpMM7Fg7vul6GQ/elB7Z+qkglOpxu56GHQvAbMG8HQxjeShp2RQN7l2Bfshwi/kE3xp79C2pjqod2Hqxik5NSt2Bi3GJ4uWEpZtCLth4vGbn8G0ZBx0czMDK7WWcICNZSXXq82wwcXRvsrBEHTGFpPpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=foMtLiVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="foMtLiVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95ABC4CECE;
	Tue, 15 Oct 2024 11:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992265;
	bh=S3efWtw7aSgi5j2NT2CXbhm6IERW8pKyaYHAvSPqwBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=foMtLiVRzpJniVuVovVID0fDSKdo4cgSrNy42ywd20HpNTxYj5RNl5MwzYUGnkQu1
	 7XV2Cd4sy+bKS4rytkOMCqzuelMuc+2wQoUZhRqeIACiRcCVs+oi8YwOwWSIacTCyo
	 TX/RJ9dRIFLHwhRjMZrLs0JyqrkCEMNvzZQ7lHPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <lenb@kernel.org>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/691] wifi: iwlwifi: lower message level for FW buffer destination
Date: Tue, 15 Oct 2024 13:20:14 +0200
Message-ID: <20241015112442.973431668@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit f8a129c1e10256c785164ed5efa5d17d45fbd81b ]

An invalid buffer destination is not a problem for the driver and it
does not make sense to report it with the KERN_ERR message level. As
such, change the message to use IWL_DEBUG_FW.

Reported-by: Len Brown <lenb@kernel.org>
Closes: https://lore.kernel.org/r/CAJvTdKkcxJss=DM2sxgv_MR5BeZ4_OC-3ad6tA40TYH2yqHCWw@mail.gmail.com
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240825191257.20abf78f05bc.Ifbcecc2ae9fb40b9698302507dcba8b922c8d856@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
index 239a722cd79d8..ae55bde3a57a4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -64,7 +64,8 @@ iwl_pcie_ctxt_info_dbg_enable(struct iwl_trans *trans,
 		}
 		break;
 	default:
-		IWL_ERR(trans, "WRT: Invalid buffer destination\n");
+		IWL_DEBUG_FW(trans, "WRT: Invalid buffer destination (%d)\n",
+			     le32_to_cpu(fw_mon_cfg->buf_location));
 	}
 out:
 	if (dbg_flags)
-- 
2.43.0



