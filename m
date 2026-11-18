Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057658;
	b=mfjEudYjygVExMYZFncWzMZ3z4sTKX/H1467xDmheyvByqbgvGxui3mclJuNknmpRAxa
	 kO463HOgn2ZLPhl7c8Bcmn0YBKndS+sYiwV1kXxZysomZ/AQJ9qanelwjEm4lP8vRp5a0
	 B0xs7nCRaPGb6DA2/m8R/4gFAqZkPILdErW3PQuf5IlS4R7EbzTyKzIFskVwNBBP1uKtm
	 sEYWZf4obdb0M7BEpJL6MyB5JFu7Rn7KRp3BkvOJvhTyRUcVTvjseXPsS0Q0hZ8ZFsRrJ
	 XEtuCs9W4vEv09NEH7M/g0QZeBhDhfyakw1zdX3WHt5QRcO2CVcliGQw9Bt9meIwMJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fpjC+5oFBY2LhmdLNFaDjDT1tw9MpCNXauds7vT1F6I=;
	b=TaasN3OwITb3Vi5jF71UZq8GkxjRlCBq0pbpM+5NhOvqiLAt4JjDaf1OI/5EahWHpn8/
	 +h2B20MQsRO7WdfsAmET1zKQ4LtmujOiZMlI1Ru3LWbBcidL8boPqack5inRQYPt2mQcO
	 SP/rek796iztrA0MaQDCOnZOppUCu04leTZIpg+kw+YCMZjYKnyvVVetKCp8iN0EZuv9T
	 780+HxbsjFrgv+RLbFnU1ZqlVW5Nwj8e9v0XMMo+g1HvePDu7L1rBz5kBHb7T2WoYIVC/
	 gLVqyrx2k5x80XJ6uc6Kj3chkrO/JzFafA6dlbrZbRFyYB1EwVHLiqMiFdkl/YIR8YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PL3pdaqz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C0E606A33F;
	Thu, 19 Nov 2026 03:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PL3pdaqz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED941F000C4;
	Thu, 19 Nov 2026 03:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057657;
	bh=fpjC+5oFBY2LhmdLNFaDjDT1tw9MpCNXauds7vT1F6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PL3pdaqzP6x8w3P14bXaxJvcaMOPpgeVCuyWBm9VL6C82mIx3hKQ30kScSQgHOqgu
	 rqhmQ/RURUHzKTIwDYv4Jko4w7omoqyoK0+9RNrX0B47iK8FzA686P6vqN5UonLCuv
	 jPGXI/rmzjZn+dWiTflEzdh5nZBGKpaW+qHp/BgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0207/1848] wifi: cfg80211: release locks on error in cfg80211_wext_siwgenie()
Date: Wed, 18 Nov 2026 15:37:25 +0100
Message-ID: <20261118145920.606518676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

This error path returns while wdev_lock() is still held, so one
malformed IE request can permanently block later operations on this
wiphy. Route the error through out to release the lock.

This bug is stable-specific: it was introduced by the stable backport
commit 269498ce6c1e ("wifi: cfg80211: validate IEs in
cfg80211_wext_siwgenie()") of upstream
commit a2f5286ca4f3 ("wifi: cfg80211: validate IEs in
cfg80211_wext_siwgenie()").  Upstream is safe because that function
runs under guard(wiphy)(), added by
commit f42d22d3f7963 ("wifi: cfg80211: define and use wiphy guard"),
while this tree still uses explicit locking and the separate wdev
mutex that upstream removed in
commit 076fc8775dafe ("wifi: cfg80211: remove wdev mutex").  Backporting
those locking reworks is not appropriate as a minimal stable fix.

This is a fix for stable v5.10.271 backport commit, so no upstream commit.

Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Closes: https://lore.kernel.org/all/93db0eae-f479-4343-a126-59987ae0dc22@oracle.com/
Fixes: 269498ce6c1e ("wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/wext-sme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index d27ec0163b08b..943e94f4a2634 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -339,8 +339,10 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
 			/* nothing */
 		}
 
-		if (!for_each_element_completed(elem, extra, ie_len))
-			return -EINVAL;
+		if (!for_each_element_completed(elem, extra, ie_len)) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		ie = kmemdup(extra, ie_len, GFP_KERNEL);
 		if (!ie) {
-- 
2.53.0



