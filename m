Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3F631AAAF;
	Thu,  2 Jul 2026 16:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010273; cv=none; b=kgfLqPnGfn9zxYHr6e/gyj+z+ICEbZQHsijRhn2JPV0Yu5Q8RwrP9IfWjqb73yEHAGAlToQ0ASigye667Re2fnMO6hHuiQF+ifbzoJoxVneGOawz8/jmHbPqQtiu2r3GQ37Bix5MaMxNqehzcnCE9D01X4zAC4biiRwIkYDTWWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010273; c=relaxed/simple;
	bh=Aff67xS7+h5aUc+QD5VI8VLaHKvB4YTx8sGv4ExI5JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKOab/laxney08UxUdWrIA+XAZmJ9hPRte4JwqTnDbYtSP2HrBQ23FReOKBhZhnZlUxjgcY+HJBmpOkQOo9DaBHL0JSEEY+M6AKj9sQZJsPiQ3YEBf1855ROi1ILvy5jkQ+cOv9QWiAZtKHI/iLGX5FP1HO9ftuwNhts6NiUJHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KdAQ5d0C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KdAQ5d0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D6B1F000E9;
	Thu,  2 Jul 2026 16:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010272;
	bh=RnupWTxYGrELkIQT4JIkiW/IWEfiDhRMlPTHLQ2Kz5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KdAQ5d0C5WhSaTGNMr1pO03y4FhSXbJED5HYCBpIzPPq1kYIQl1ZR2EtLHuOc5vkj
	 eP0jIyocrFf9s/rZDbfLRGJeWRe84rcHdd6XN5SaHD+v/9kigNM/npV0BgUSYHvXLU
	 rBcYRBARxPDyRPd/JZ2wjC/70EwxtR4I1CCujDDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Gejak <luka.gejak@linux.dev>,
	Salman Alghamdi <me@cipherat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/204] staging: rtl8723bs: fix buffer over-read in rtw_update_protection
Date: Thu,  2 Jul 2026 18:18:22 +0200
Message-ID: <20260702155119.598612073@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Salman Alghamdi <me@cipherat.com>

[ Upstream commit 514ab98364595007d4557ecc85d7e5f012c504d3 ]

rtw_update_protection() is called with a pointer offset into the
ies buffer but the full ie_length is passed, causing a potential
buffer over-read.

Fixes: e945c43df60b ("Staging: rtl8723bs: Delete dead code from update_current_network()")
Fixes: d3fcee1b78a5 ("staging: rtl8723bs: fix camel case in struct wlan_bssid_ex")
Reported-by: Luka Gejak <luka.gejak@linux.dev>
Closes: https://lore.kernel.org/linux-staging/DI2H39EAAFBZ.3KI5NWN02AQ2S@linux.dev
Cc: stable@vger.kernel.org
Signed-off-by: Salman Alghamdi <me@cipherat.com>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Link: https://patch.msgid.link/20260508222649.23989-1-me@cipherat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -449,8 +449,11 @@ static void update_current_network(struc
 
 	if ((check_fwstate(pmlmepriv, _FW_LINKED) == true) && (is_same_network(&(pmlmepriv->cur_network.network), pnetwork, 0))) {
 		update_network(&(pmlmepriv->cur_network.network), pnetwork, adapter, true);
+		if (pmlmepriv->cur_network.network.ie_length < sizeof(struct ndis_802_11_fix_ie))
+			return;
+
 		rtw_update_protection(adapter, (pmlmepriv->cur_network.network.ies) + sizeof(struct ndis_802_11_fix_ie),
-								pmlmepriv->cur_network.network.ie_length);
+								pmlmepriv->cur_network.network.ie_length - sizeof(struct ndis_802_11_fix_ie));
 	}
 }
 
@@ -1070,8 +1073,11 @@ static void rtw_joinbss_update_network(s
 			break;
 	}
 
+	if (cur_network->network.ie_length < sizeof(struct ndis_802_11_fix_ie))
+		return;
+
 	rtw_update_protection(padapter, (cur_network->network.ies) + sizeof(struct ndis_802_11_fix_ie),
-									(cur_network->network.ie_length));
+									(cur_network->network.ie_length - sizeof(struct ndis_802_11_fix_ie)));
 
 	rtw_update_ht_cap(padapter, cur_network->network.ies, cur_network->network.ie_length, (u8) cur_network->network.configuration.ds_config);
 }


