Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018666;
	b=mRM9IwY5JC35yIgKDGhzBPZ5Cgk5bQAotmMSvEtCoqd02y0Xt2PQ+fIVXJ1BH5ZlW6GN
	 G8blFPjB7HitdkMm4/GzPhGY7SzV78BxRxhqF6P0J70iZ54ok1pjJUBJ5li7aoO0Bfqfz
	 AQU5jyQhz2ENGOiCb5e5Y3ipyQvf4oBLY8DRM1Gz1pyZ/+6cYzE6/cytY3cVd/2ZCHdZU
	 OmalzrvEe1KPp0MI+iCnnoUIucju3uWi7ewWGVngcLDBiYnEE3tSxmACdRXK3Rcr6PoSn
	 N9yy8ccy4EjBpHaI5y5UOFKA8whMShFalkbXcQ7GKBrHSI4G8SKSkIQE+lgP7HBxVmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PZGxpzDmajxT2JUwSXT2xPypJBBXgmGyqyVIh82l7II=;
	b=EsTtd1HKg/QVE7b76EOo8QQOPHSvXpuAr1hQzXJozgfaAyS+1KydreLMNPw3PKLJpFh1
	 xxTamQ2n9bsKCqFnEqrGGHFxseloZmPoOt0S2nYghuOxuPRX3i/NrgUm14yr+h4Rbf3Fy
	 Zz2lTVReEldauqvM7udplhsMN5+gmWOE2T+XT4KtoPdP8nNkuLGiItS3GQkbVeBhSggGI
	 2RC4Syqv22Gh+ZvNc7y5+DNafzPg23FKqzIIOrK6ecJYNotODYliOWTfv8IfECS0ahlJ1
	 GS4WHm6TkxtWF0qABheFXn1XePORJkv4pCI1dLd8yNmqSCwTen/1AEisIV1CB8y91CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RNbk4L0h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB791606A320;
	Wed, 18 Nov 2026 16:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RNbk4L0h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EDD1F000C4;
	Wed, 18 Nov 2026 16:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018666;
	bh=PZGxpzDmajxT2JUwSXT2xPypJBBXgmGyqyVIh82l7II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RNbk4L0h0x51ECcEF1nzrrl2cFbt/frW4xBcqo6I+NhxW36l255J6Ulxay5SgL3Nv
	 r2lJlWC0QNbQighUtoG9NEqB1/mCRY3TpFWb5BUL8KLQgw8LfA64or4kQuXBboSvC5
	 SHdQnoOck4jaHujAUrPN97XopX1F2ZinNf7F7Q9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1322/2651] wifi: nxpwifi: fix missing error codes in _nxpwifi_fw_dpc()
Date: Wed, 18 Nov 2026 15:42:42 +0100
Message-ID: <20261118150335.595391390@linuxfoundation.org>
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

[ Upstream commit df40d3645443e884897b5b95873f9871bb44b7e5 ]

When nxpwifi_register_cfg80211(), nxpwifi_init_channel_scan_gap(),
or nxpwifi_add_virtual_intf() fail, the function jumped to an error
label but left ret == 0, causing _nxpwifi_fw_dpc() to return success
despite the failure.

Fix by propagating the return value of nxpwifi_register_cfg80211()
and nxpwifi_init_channel_scan_gap() directly into ret, and by
extracting the encoded error from the ERR_PTR wdev with PTR_ERR()
before each goto err_add_intf. The P2P client interface path had
the same IS_ERR/goto pattern and is fixed in the same way.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/anwshVbQWXXHTJpa@stanley.mountain/
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/nxp/nxpwifi/main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/main.c b/drivers/net/wireless/nxp/nxpwifi/main.c
index 9e13348105c3b..8eefd57e92c93 100644
--- a/drivers/net/wireless/nxp/nxpwifi/main.c
+++ b/drivers/net/wireless/nxp/nxpwifi/main.c
@@ -603,14 +603,18 @@ static int _nxpwifi_fw_dpc(const struct firmware *firmware, void *context)
 	maybe_quirk_fw_disable_ds(adapter);
 
 	if (!adapter->wiphy) {
-		if (nxpwifi_register_cfg80211(adapter)) {
+		ret = nxpwifi_register_cfg80211(adapter);
+
+		if (ret) {
 			nxpwifi_dbg(adapter, ERROR,
 				    "cannot register with cfg80211\n");
 			goto err_init_fw;
 		}
 	}
 
-	if (nxpwifi_init_channel_scan_gap(adapter)) {
+	ret = nxpwifi_init_channel_scan_gap(adapter);
+
+	if (ret) {
 		nxpwifi_dbg(adapter, ERROR,
 			    "could not init channel stats table\n");
 		goto err_init_chan_scan;
@@ -623,6 +627,7 @@ static int _nxpwifi_fw_dpc(const struct firmware *firmware, void *context)
 	if (IS_ERR(wdev)) {
 		nxpwifi_dbg(adapter, ERROR,
 			    "cannot create default STA interface\n");
+		ret = PTR_ERR(wdev);
 		rtnl_unlock();
 		goto err_add_intf;
 	}
@@ -632,6 +637,7 @@ static int _nxpwifi_fw_dpc(const struct firmware *firmware, void *context)
 	if (IS_ERR(wdev)) {
 		nxpwifi_dbg(adapter, ERROR,
 			    "cannot create AP interface\n");
+		ret = PTR_ERR(wdev);
 		rtnl_unlock();
 		goto err_add_intf;
 	}
-- 
2.53.0



