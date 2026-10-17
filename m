Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6395A3A7580;
	Sat, 17 Oct 2026 16:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253585; cv=none; b=mvMt6iC1Tx26hQIxauaxpJMS3QAiTewLalbBNm/Kj5ht3kdT9Wv0E/gpOlsL3yELkwIY6Y8A/EgeZmyeVd4IZ9JYRvF4N3Mn+VPu17TBpK5yVsWVkecLz4SWcDC6W5Rzy+t0NpEMSwuKiklSiQMQuK8c3oEHRAiAUd85zPJVzpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253585; c=relaxed/simple;
	bh=GCVTM0tZ2ErmXEZnZnnnriIbcLPP+X0fTSQO7wVzVjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfnqcZPTPE6ngaLunry+bV5ET18MX/WsoaxjuzRTTQrQ9O1FDUOdUdd4gfUiFr4e8p1EpN2JH22gml11tDZQ4lqsjhLpTbGO4jMvn1SGZuXaBpup+YjQ7EnwmN7GH+1mAUyacW+uGVv8l1B0FXL/0ECuou0eUJ7XtRRg7QDXP9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hjp285aS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hjp285aS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA261F000C4;
	Sat, 17 Oct 2026 16:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253583;
	bh=m/p/oTuSTzZKNcTkGkfJq3Xhha6D5Ogu03uFOBBv9Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hjp285aSbVi9X9rF9Csi09bSbSjMqQ8x4jYvLl1grUBmKb4HRzJ1JUe1eRj/wCGTl
	 5EEueD2n/q/VGqWVcTfbKHgMPZNu49Dy9rKzfq+1nQOirDCgyCAAFpQ22CBNXmYwIW
	 VmLdxtZMtSuB4/eY5f+b9HpeoVrPqbaSzB5G6jos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 167/869] wifi: mac80211: fix typo in HE MCS check
Date: Sat, 17 Oct 2026 17:50:08 +0200
Message-ID: <20261017160041.330734466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 29968432874bb03f7dcaea602efb7d00e7c33b0c ]

It printed the AP RX MCS value instead of the TX one.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250101070249.743c7c1914f4.I1e5888ac6c8324d078fe91d01da31daa76d0e328@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 99067b58a408 ("wifi: mac80211: don't WARN for connections on invalid channels")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fc02194233f82..d194587bf020a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -420,7 +420,7 @@ ieee80211_verify_peer_he_mcs_support(struct ieee80211_sub_if_data *sdata,
 		    ap_rx_val < ap_op_val || ap_tx_val < ap_op_val) {
 			sdata_info(sdata,
 				   "Invalid rates for %d Nss, rx %d, tx %d oper %d, disable HE\n",
-				   nss, ap_rx_val, ap_rx_val, ap_op_val);
+				   nss, ap_rx_val, ap_tx_val, ap_op_val);
 			return false;
 		}
 	}
-- 
2.53.0



