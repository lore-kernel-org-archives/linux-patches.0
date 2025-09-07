Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159214315A;
	Sun,  7 Sep 2025 20:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277541; cv=none; b=fonHF2fRZsvBh30yl3+RtSkiXYppojBfX839DP0fIOknIj9w02lY/MLjBtC99CHGKQuaatljxYi2/A+eiTWd2YAiDcTRuF2F+hbw1I+jOW6bVktmEEPKfcbRY4N/w2nJO7bqNPnlQaI5g8r87YhYT2+F6++tM4Vypz2d3QkJUq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277541; c=relaxed/simple;
	bh=YMaD3E1xWEnCe5thLlTBMsP4GHBwZ2RQz3Rc1+lQOqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CS9lfNrOWnGbzLguvdyLsr6ppE4T2HMRruokhpIpUxZt6yc1pp57yfTNdfSYPAnB5rAoGOB0+X8tdtPMBXtJz8+IIMmoD9F2Q2oTyZG3lYYieILa7C4uBifD9ErrNtyDCWeQ6QxpGY3xRrh9xUIj0RG6UN013za51Rzcc00byFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9+GkPFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9+GkPFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFF8C4CEF0;
	Sun,  7 Sep 2025 20:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277538;
	bh=YMaD3E1xWEnCe5thLlTBMsP4GHBwZ2RQz3Rc1+lQOqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9+GkPFQWJQkajmPA0GLxkGy+hgjoVgYJX4iZ9ooicaJoBoRXoND3lK6Z4ly8JO+2
	 zJPS1xo+RNtKK4wAtCywAza308JUE1s3oCIGLufrYfLPwr9ITbTDdP2QLTWCEH3RFB
	 UBIGR321melAh3Q65J38xIv8YV3xOlQineIF74KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 046/183] wifi: iwlwifi: cfg: restore some 1000 series configs
Date: Sun,  7 Sep 2025 21:57:53 +0200
Message-ID: <20250907195616.871439318@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 22e6bdb129ec64e640f5cccef9686f7c1a7d559b ]

In the fixed commit, I inadvertently removed two configurations
while combining the 0x0083/0x0084 device IDs. Replace the fixed
matches for the BG versions by a masked match and add the BGN
version back with a similar masked match.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220477
Fixes: 1fb053d9876f ("wifi: iwlwifi: cfg: remove unnecessary configs")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20250828095500.fabb99c2df9e.If0ad87bf9ab360da5f613e879fd416c17c544733@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index e4e06bf9161c3..b66a581c2e564 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -726,10 +726,10 @@ VISIBLE_IF_IWLWIFI_KUNIT const struct iwl_dev_info iwl_dev_info_table[] = {
 		     DEVICE(0x0083), SUBDEV_MASKED(0x5, 0xF)),
 	IWL_DEV_INFO(iwl1000_bg_cfg, iwl1000_bg_name,
 		     DEVICE(0x0083), SUBDEV_MASKED(0x6, 0xF)),
+	IWL_DEV_INFO(iwl1000_bgn_cfg, iwl1000_bgn_name,
+		     DEVICE(0x0084), SUBDEV_MASKED(0x5, 0xF)),
 	IWL_DEV_INFO(iwl1000_bg_cfg, iwl1000_bg_name,
-		     DEVICE(0x0084), SUBDEV(0x1216)),
-	IWL_DEV_INFO(iwl1000_bg_cfg, iwl1000_bg_name,
-		     DEVICE(0x0084), SUBDEV(0x1316)),
+		     DEVICE(0x0084), SUBDEV_MASKED(0x6, 0xF)),
 
 /* 100 Series WiFi */
 	IWL_DEV_INFO(iwl100_bgn_cfg, iwl100_bgn_name,
-- 
2.50.1



