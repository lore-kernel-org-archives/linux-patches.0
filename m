Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FF425F78E;
	Tue, 11 Mar 2025 15:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706427; cv=none; b=jLThCXuMl3uSDufVetts7yuspCLuQ5sooSLvtr9HpNpRU3DHTb56P6wWd2MSfxJRwfJBS46kNtReWxhGvzIAwCBhP4HKMUCqH55phnZ/7rl9ZD5XoE0M6Jlw+L+GAcSKbpa0tW86mfdZ/8tBN+ChiCK4g9vxLuqJIWDy0W4rzj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706427; c=relaxed/simple;
	bh=DGd8bJmT+VkUYRWwUXdv3aj7+tAJ4vzb+ahvSsmMPfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDn6TZ2bUSCgYYbI95VV5veN5bSCRl6GbvxAvoR/RIreDdqCcDmH0D0LOqQzLb4pLru36uwHvQU8PRzqN3ot33MbfjdUx0Nd6UpoPoDD/aRfjw4hzO98AIMEHZM4u6oXA7+wwp9PBM1yC67RDN//oBhOLJ+bwrmmmOiGWUYZzaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmHq0Rcl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmHq0Rcl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65D8C4CEE9;
	Tue, 11 Mar 2025 15:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706427;
	bh=DGd8bJmT+VkUYRWwUXdv3aj7+tAJ4vzb+ahvSsmMPfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmHq0Rcl3EBZ02tdn+v+wJiOkEHsGti/d49jzQK6xG3I5Ayd6zfPGF7meOTtOenuc
	 Wi3hF97wUQ02pH3S8Z0oZW0RYb2bvmU92DyioY4srAqSW5YakIm28unS+Fns5K8gyR
	 mc02LvGjxzm7EwhzZafyQ98cZWYJfidanxJMFPVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.king@canonical.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/462] rtlwifi: remove redundant assignment to variable err
Date: Tue, 11 Mar 2025 15:54:40 +0100
Message-ID: <20250311145758.915504430@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 87431bc1f0f67aa2d23ca1b9682fe54f68549d42 ]

Variable err is assigned -ENODEV followed by an error return path
via label error_out that does not access the variable and returns
with the -ENODEV error return code. The assignment to err is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210327230014.25554-1-colin.king@canonical.com
Stable-dep-of: b4b26642b31e ("wifi: rtlwifi: wait for firmware loading before releasing memory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 7e4655de30237..add6da1ce3602 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1072,7 +1072,6 @@ int rtl_usb_probe(struct usb_interface *intf,
 	err = ieee80211_register_hw(hw);
 	if (err) {
 		pr_err("Can't register mac80211 hw.\n");
-		err = -ENODEV;
 		goto error_out;
 	}
 	rtlpriv->mac80211.mac80211_registered = 1;
-- 
2.39.5



