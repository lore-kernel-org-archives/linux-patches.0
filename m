Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0192FA627;
	Tue, 17 Jun 2025 16:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179432; cv=none; b=HwJMpl/xH25dzpq9eq63zWIhSThWCLAirSOwhNx/yqpobnK6n7yoKHmpnU8fppkuPxkaHoFf8oZdPMnr3heZyDvGKDkWO4g2HMvjW3OoC/uLnDuR84HQqM3qpLLK1gq2GsrLmn4komrFDT6mCE5KBV4ku5tEawq6xeiskUXn/YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179432; c=relaxed/simple;
	bh=uXblQ3iXCzRXgMh5chYxVSzahtbgjn+n3tmkQaeL31I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7PKGtkEf9pyzZhjMil4y/AGLfE+tRqQRka2SvBqQcDMhL9plOOu0OM4rI60mkDasJ71E8FTuwtk2SwKysvIjb38wO/Mbmjl28ISXcZoFhJxuCLmNcC9QAdHNGhVZQPfpniD59VV52sDfihAQsJICZws7TIcruFzLpjoalU4Cxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E53QR4dM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E53QR4dM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A51C4CEE3;
	Tue, 17 Jun 2025 16:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179432;
	bh=uXblQ3iXCzRXgMh5chYxVSzahtbgjn+n3tmkQaeL31I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E53QR4dM9qmv+6U1dyW67rDQYhMgLAc+fVDaUHObLpGJ08+06K1jc1yYmva3xVPF8
	 xX30J4qNH+/pzP2rmjtWH+7Ef02EtM39VYpGLMoACDOIAJpYDN7Pg+zmd5in72xR7A
	 xX/7rJ+2ydH4DHkUhOQBXejymDvttfcRDZS8er2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.15 745/780] Revert "wifi: mwifiex: Fix HT40 bandwidth issue."
Date: Tue, 17 Jun 2025 17:27:33 +0200
Message-ID: <20250617152521.839665080@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit 570896604f47d44d4ff6882d2a588428d2a6ef17 upstream.

This reverts commit 4fcfcbe45734 ("wifi: mwifiex: Fix HT40 bandwidth
issue.")

That commit introduces a regression, when HT40 mode is enabled,
received packets are lost, this was experience with W8997 with both
SDIO-UART and SDIO-SDIO variants. From an initial investigation the
issue solves on its own after some time, but it's not clear what is
the reason. Given that this was just a performance optimization, let's
revert it till we have a better understanding of the issue and a proper
fix.

Cc: Jeff Chen <jeff.chen_1@nxp.com>
Cc: stable@vger.kernel.org
Fixes: 4fcfcbe45734 ("wifi: mwifiex: Fix HT40 bandwidth issue.")
Closes: https://lore.kernel.org/all/20250603203337.GA109929@francesco-nb/
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20250605130302.55555-1-francesco@dolcini.it
[fix commit reference format]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/11n.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/11n.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n.c
@@ -403,14 +403,12 @@ mwifiex_cmd_append_11n_tlv(struct mwifie
 
 		if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 &&
 		    bss_desc->bcn_ht_oper->ht_param &
-		    IEEE80211_HT_PARAM_CHAN_WIDTH_ANY) {
-			chan_list->chan_scan_param[0].radio_type |=
-				CHAN_BW_40MHZ << 2;
+		    IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)
 			SET_SECONDARYCHAN(chan_list->chan_scan_param[0].
 					  radio_type,
 					  (bss_desc->bcn_ht_oper->ht_param &
 					  IEEE80211_HT_PARAM_CHA_SEC_OFFSET));
-		}
+
 		*buffer += struct_size(chan_list, chan_scan_param, 1);
 		ret_len += struct_size(chan_list, chan_scan_param, 1);
 	}


