Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0111019E48
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7439BC433EF;
	Wed,  7 Jun 2023 20:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170190;
	bh=jugi7M+Jek6OyKTKdp1HfbJUlFSn8lr5RV2goxUhyck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOnvujwT/I4EUPNGXj/I/rRX/p1Hea+iKrj+5qJEMBituTEbT2HcVd7eDeH/hlKCh
	 59EtOzwV1j2dO3Y6Temg4jMNQjqrWI6n3pt+ZgNCLpvDQSSV0ejYWQ250gfs73PGeA
	 InEQ7mx7arMrFtpGwpioBnXEwpbT0VlZIJHc2MWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <natechancellor@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 79/88] rsi: Remove unnecessary boolean condition
Date: Wed,  7 Jun 2023 22:16:36 +0200
Message-ID: <20230607200901.696774874@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200854.030202132@linuxfoundation.org>
References: <20230607200854.030202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <natechancellor@gmail.com>

commit f613e4803dd6d1f41a86f6406d4c994fa3d387a0 upstream.

Clang warns that the address of a pointer will always evaluated as true
in a boolean context.

drivers/net/wireless/rsi/rsi_91x_mac80211.c:927:50: warning: address of
array 'key->key' will always evaluate to 'true'
[-Wpointer-bool-conversion]
        if (vif->type == NL80211_IFTYPE_STATION && key->key &&
                                                ~~ ~~~~~^~~
1 warning generated.

Link: https://github.com/ClangBuiltLinux/linux/issues/136
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -924,7 +924,7 @@ static int rsi_hal_key_config(struct iee
 	if (status)
 		return status;
 
-	if (vif->type == NL80211_IFTYPE_STATION && key->key &&
+	if (vif->type == NL80211_IFTYPE_STATION &&
 	    (key->cipher == WLAN_CIPHER_SUITE_WEP104 ||
 	     key->cipher == WLAN_CIPHER_SUITE_WEP40)) {
 		if (!rsi_send_block_unblock_frame(adapter->priv, false))


