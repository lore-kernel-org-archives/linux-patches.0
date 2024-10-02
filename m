Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F038E1D0786;
	Wed,  2 Oct 2024 13:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877315; cv=none; b=WiQlkObQk+6sbssr7LyTVHDaGUFUyq4QR0SR25+ly3QPu8pOSJcqd124jtM4dummZ1colwIfFLbo8IifMow7bdHidmPduX39ipw7H/y6tnbK09hqfrzmcVkcp6YSyJJ16VOHVJOouTKiD2ZVZbGoCo/dqCP/uE3YvPWhQtTVY+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877315; c=relaxed/simple;
	bh=Og8p+2wfL9aNy8fY2LVmYXY7O6O+3wP6ReZ+wJDZhKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URliZ3lDeSIyY/KUZfH6le+/J/o62LJTXA+dxtOGubb6j6B47bBxT0CA+Dn3CHtuQx9JWOlpmw3MSnDYpLK4nGWWRTWl519CzcZ1pm3119YPFq7D8kvUbqn4PIKSPJ/1zQZtPBrxyoI6bar5XOIXyTK8mZ39yL0D0zKsjX2pq3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sve+IVPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sve+IVPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7A2C4CECE;
	Wed,  2 Oct 2024 13:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877314;
	bh=Og8p+2wfL9aNy8fY2LVmYXY7O6O+3wP6ReZ+wJDZhKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sve+IVPRhAYm+tVZSO9Whs2bLP1doPoXh6wJE/+mXVDXYbXrbkeKC0kKg0Iean/B3
	 SztHaJRSI6rRd/sdYkJ6Ai3mE9ylyI9iWkf1yHczO++6k+gVE55G8lQ8ZyavuoFTNb
	 nDuBbAtMW4g9th4anUCUJT/MKnlVRS02jwo0A4pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 040/634] wifi: iwlwifi: mvm: increase the time between ranging measurements
Date: Wed,  2 Oct 2024 14:52:20 +0200
Message-ID: <20241002125812.682096411@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3cbeaddf43586..4ff643e9db5e3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
@@ -109,7 +109,7 @@
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



