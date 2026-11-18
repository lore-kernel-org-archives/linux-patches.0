Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017783;
	b=wutiS/zXDEcblozcnth/Mv2siRibQHFkEhLh4mxTMjGr5uYFWrNxzRsMzjzNSNmy44n7
	 5OkleTjoeL0YTZUO4bY7LeoXifY6ysHXnQt1m524Y21T9Hl5Ocsg1VOxlIbgUOF3Adfap
	 hX463DibyJASQqE/6oOWd/tC/stu2YdeQMzAydSpgKQcOkiQ0o+V4ZeotWVGLHrLwu+hc
	 F984Yep9lB1ngsOMd4ggFjNbuq+JlJ0JU3ZFJy0BtKv/i++axO+fYQhNhAMovlrhTj2pk
	 e1yZRsT/wu+QgbR84yIstOdmcSbv0NyuN3sj/zTIh3aDFj7Agx7yeqDgTPihqW+UM/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R7xe9gssy5xoqq2JVn2ghIyjeBhIK2BIanYbgDyLhPI=;
	b=U8yTT/MQNYZrqMYIP0ScSfjh2qXcwX3rPztK2/6bisDJLtqoUw9P+JSFyJ0yWa0LNTwH
	 urdNPWX329vfq1vys/So+AJFs5hIw86aQWQfAJnSEG4rIDmzTR/LH999PO0sPcVxR0VOI
	 /DSsuimOsnYLqwSsSC30R0ETClPlqryv0CbDuHsa5aNQky1MPaCKKiviKyuwBkQlI1wWi
	 Xjp+NPM8IMTg/2Ocy1JLT6nOOg8j61JfPsj/9dxxFvgivYgnR6ySlzUUnyGZotMEEH0HZ
	 6bTboCnnfPCnwDGYNANOKLELXudYi8lLnsD0zL4i4TqF2rzY5nH942aYYBKWd8nLm3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=njaHo5VU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B86606A31C;
	Wed, 18 Nov 2026 16:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=njaHo5VU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731631F000C4;
	Wed, 18 Nov 2026 16:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017783;
	bh=R7xe9gssy5xoqq2JVn2ghIyjeBhIK2BIanYbgDyLhPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njaHo5VUKHijLcylxs7k2RDEjjNNP03qwQ9F3FrS+Pu04fXCEjclBoNNSBSmuU25t
	 z17A8Jwoc+AzR5tAhGUC5lnb/kQe3M8Lnah42MgWuM/rqU4Kq8He+0SDlTxQ5fgqBn
	 SlfXulInHatFF1KYEsSt9h+wj9NycuDfVM66RaTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1008/2651] wifi: nxpwifi: fix return value check in change_vif_to_sta/ap
Date: Wed, 18 Nov 2026 15:37:28 +0100
Message-ID: <20261118150324.206763406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Chen <jeff.chen_1@nxp.com>

[ Upstream commit f833415e49981bee131841e805da3f24b90a7524 ]

nxpwifi_change_vif_to_sta() and nxpwifi_change_vif_to_ap() both call
nxpwifi_set_bss_mode() without storing the return value, then check
'if (ret)' which tests the stale value from the previous call. The
'if (ret) goto done' is therefore dead code, and errors from
nxpwifi_set_bss_mode() are silently ignored.

Fix this by assigning the return value to ret, so the existing error
path works correctly.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/anwqp-LuExbRshYu@stanley.mountain/
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
index 473e81304ca8a..dcdb7b2bd9aec 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
@@ -844,8 +844,7 @@ nxpwifi_change_vif_to_sta(struct net_device *dev,
 	update_vif_type_counter(adapter, type, 1);
 	dev->ieee80211_ptr->iftype = type;
 
-	if (nxpwifi_set_bss_mode(priv))
-		return -1;
+	ret = nxpwifi_set_bss_mode(priv);
 
 	if (ret)
 		goto done;
@@ -888,8 +887,7 @@ nxpwifi_change_vif_to_ap(struct net_device *dev,
 	update_vif_type_counter(adapter, type, 1);
 	dev->ieee80211_ptr->iftype = type;
 
-	if (nxpwifi_set_bss_mode(priv))
-		return -1;
+	ret = nxpwifi_set_bss_mode(priv);
 
 	if (ret)
 		goto done;
-- 
2.53.0



