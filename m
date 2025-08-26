Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED60635FC0D;
	Tue, 26 Aug 2025 14:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219108; cv=none; b=fJRVXsAY9ywhWF7V0dJcdSJocpcTHNLkbYIJl7k0598a5Igw3DdHZ0Eq2zkmefjhGQ62hCP8/Cx23UqWT2TsMqNEeacPVOGePDKDP/VZOhtpA7AvPL4VVxSgScjekioQSdjFCuv8p/Uv9ARmaT4raT2cCO/Xcq36Yvm5dUCToUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219108; c=relaxed/simple;
	bh=kXw2sIolxUsxuos3O3CqDxDY1xaShKBn7Wp3W9iIQ4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdmUCPJXB7P0MPGXP2oUt+oVXIXBpY75e0jfpWTMU2OvIv7ps5/f9ngyl6ZHsn7D3y5o1F2LSXVcrJbWLxDSsNMhEbZ/K9TGStWsibRiCVBStWDDPDowIAC9P9Xranwjj/mjHB58hbQDOV1A9MltK5WczwkWnDzbjtAXbDrrB5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qX37U+Vk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qX37U+Vk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285F9C4CEF1;
	Tue, 26 Aug 2025 14:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219107;
	bh=kXw2sIolxUsxuos3O3CqDxDY1xaShKBn7Wp3W9iIQ4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qX37U+VknauHzvkFKm4hV4CY4u/IMG7Qddtuzvr9ly8fq/nuGFKZ0wSPNw/qCHGaA
	 rkSWufEcBAGSTbP/L6jUerXo+KdPuzTMw2QB2LmY4vVwbkwtywaSmS9PVxJGp/sApt
	 Rx69cOQ1AlzTlPBqnMmbpqtqbXeCF+W1hFtA+xZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alexei Safin <a.safin@rosa.ru>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 224/403] wifi: iwlegacy: Check rate_idx range after addition
Date: Tue, 26 Aug 2025 13:09:10 +0200
Message-ID: <20250826110913.018450661@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stf_xl@wp.pl>

[ Upstream commit 0de19d5ae0b2c5b18b88c5c7f0442f707a207409 ]

Limit rate_idx to IL_LAST_OFDM_RATE for 5GHz band for thinkable case
the index is incorrect.

Reported-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reported-by: Alexei Safin <a.safin@rosa.ru>
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Reviewed-by: Fedor Pchelkin <pchelkin@ispras.ru>
Link: https://patch.msgid.link/20250525144524.GA172583@wp.pl
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 20c933602f0a..31f1c57450d4 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -1573,8 +1573,11 @@ il4965_tx_cmd_build_rate(struct il_priv *il,
 	    || rate_idx > RATE_COUNT_LEGACY)
 		rate_idx = rate_lowest_index(&il->bands[info->band], sta);
 	/* For 5 GHZ band, remap mac80211 rate indices into driver indices */
-	if (info->band == NL80211_BAND_5GHZ)
+	if (info->band == NL80211_BAND_5GHZ) {
 		rate_idx += IL_FIRST_OFDM_RATE;
+		if (rate_idx > IL_LAST_OFDM_RATE)
+			rate_idx = IL_LAST_OFDM_RATE;
+	}
 	/* Get PLCP rate for tx_cmd->rate_n_flags */
 	rate_plcp = il_rates[rate_idx].plcp;
 	/* Zero out flags for this packet */
-- 
2.39.5



