Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454A2175549;
	Wed,  3 Jul 2024 11:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005814; cv=none; b=Cq++5H89VZdgYV7AaCHbqKesc4V8/fE52M0r/s2O7+wPXmSlxxF4nLCme1RG+9vvqmx50f0BV5GTibhoXL9Jgx9fFb9qi8aM2by2bWf92uplv9iYyvLbVU7QOyiiMyohnmgPlVpUBjeHp/6nKatb4RCgOJrITm+uJxGhKpxWriA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005814; c=relaxed/simple;
	bh=dbkUfvKcv+hhhCVmuNXd19qx/79r6gaNwYOL/xwDJNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcihbQjx3Ckk7ErQsHDJYLiehJgPruGndXFEvF4oUCvmStCTH/yBnVl6TUGVgFPEgSg+EPUX2Crv5G3lYfYb7+Gja/4EZDM+IgOrBV2tC8rjZvZYTrOVTwoYr1AXwr9TYisU7RxSP4KJOCIPPCoBrXPXv6kllvVrkeFuDr7Zqc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zYQB0FGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zYQB0FGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F8FC2BD10;
	Wed,  3 Jul 2024 11:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005814;
	bh=dbkUfvKcv+hhhCVmuNXd19qx/79r6gaNwYOL/xwDJNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zYQB0FGUIRJHL+/16TzQwkxGpJzkA8wXoQRz4bsWuxQIdsKg7upuPLg2Kqu31UCZl
	 mls/MjcGVaiHXRmK0hVtmPK6oI23xi/JrINIveVWOxuXsmw48Ta2b2QFDrtE5ROT6v
	 DizngmD7edVuHOoufYDko40e+6axnhVZcxkfWuY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5186630949e3c55f0799@syzkaller.appspotmail.com,
	Oliver Neukum <oneukum@suse.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 205/356] net: usb: rtl8150 fix unintiatilzed variables in rtl8150_get_link_ksettings
Date: Wed,  3 Jul 2024 12:39:01 +0200
Message-ID: <20240703102920.860576494@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit fba383985354e83474f95f36d7c65feb75dba19d ]

This functions retrieves values by passing a pointer. As the function
that retrieves them can fail before touching the pointers, the variables
must be initialized.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+5186630949e3c55f0799@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20240619132816.11526-1-oneukum@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/rtl8150.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 4a1b0e0fc3a3a..17b87aba11d19 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -778,7 +778,8 @@ static int rtl8150_get_link_ksettings(struct net_device *netdev,
 				      struct ethtool_link_ksettings *ecmd)
 {
 	rtl8150_t *dev = netdev_priv(netdev);
-	short lpa, bmcr;
+	short lpa = 0;
+	short bmcr = 0;
 	u32 supported;
 
 	supported = (SUPPORTED_10baseT_Half |
-- 
2.43.0



