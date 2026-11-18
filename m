Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048085;
	b=e9Rz+ryF6GVJOYyqUmpo/A5Ep6qGHSSzbqS+buvbvt1ByM2ytAoK6I1DnygPWkEDS6VG
	 2eOTL/IPkSCSadco/sat78wSVwnspi62uXAxe0ITrUGBjRM7SxuQAH5YG88kk1CDUxnqb
	 CYHRA1effgWqos1kBIEO1d2exBSED3mMxYftdZoS8sGnF6FEPhI9Mb7fPS0V98pQI8cKJ
	 3+q5uhQEM2Tl49ooX0oKDaxyHkVpZGiKRKcx0711EBHVtINWbxEHicZ4Y5e1TIXJ8JDD8
	 MCDwrKNp8A+rA4p5Im3B20JeuttAXknIqSUT0LoXNfjWhjg47QKng1FGUhuog5xYJ+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6h2cDlMP++hyTMUt7GNjBm5LWnkp1qIk+Ll+rqpAQpw=;
	b=JDfehYbsDrg7KWOZlgjmWnK8ZL71TbPiFkNI0U9m4RR8Hq+IMLaY5qo8ZGYzyWfIWKML
	 b1qWlUrq2OrcwIZrlmrrrVW/YlP5S3HVLFUh9fAkp/Kk4FYhRe0tuTCT4pvWyhCD4kS26
	 Vo9qYuahlnxqMot+bqZnGd4NKw1lU5m4W4PW7EsjjCa1HRwKcpCWYX4gdd9/+cvVKR0nC
	 n+W6huyx0OKkeCuqn5vwtu2ibVy0cwizx9K9VMZx23gSMZX7e3XkYs96M/hjjQbmNueS8
	 cclWRenDSEpruttSYDdtaN+qP/et1i+xfl4StVYBpRnH8sZRbzMRFfyYlcMOX8Zsl0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mLmPF0oV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8F0606A31C;
	Thu, 19 Nov 2026 00:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mLmPF0oV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5751F1F000C4;
	Thu, 19 Nov 2026 00:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048084;
	bh=6h2cDlMP++hyTMUt7GNjBm5LWnkp1qIk+Ll+rqpAQpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mLmPF0oVILWFI65JJtXxNXncRUeH+pqklfNpx8SwF4i2FI281U0+Lx2QFw0kxpvQy
	 +VF0DsOGiYKdw7De7i9RKkkgjFVlyMhhEhhzxzvZFyUSyEnBeSAVzIXpiQkXQ+vXcV
	 5ssPWG2RP8eHaURp93z2Gk/3HuN8qXbPEXCJd/mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5f4b29d9fe710a964482@syzkaller.appspotmail.com,
	"Jiangong.Han" <jiangong.han@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1870/2857] USB: usbmon: fix null-ptr-deref in mon_bus_remove() when mon_bus_init() fails
Date: Wed, 18 Nov 2026 15:48:24 +0100
Message-ID: <20261118150308.566257338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangong.Han <jiangong.han@windriver.com>

[ Upstream commit 0c6cae0f56239e3274b30dbe5b362cd297ccacc7 ]

When mon_bus_init() fails to allocate the mon_bus struct, it returns
without setting ubus->mon_bus, so mbus->mon_bus remains NULL.
mon_bus_add() intentionally ignores this failure because the USB core
does not require monitoring to be established for normal operation.
However, when the HCD is later removed, usb_remove_hcd() fires the
USB_BUS_REMOVE notifier which calls mon_bus_remove(), it dereferences
ubus->mon_bus without checking for NULL, causing a null-ptr deference.

Fix this by adding a NULL check for mbus at the top of mon_bus_remove().
If mon_bus_init() failed, ubus->mon_bus is NULL, meaning the bus was
never tracked by the monitor, so there is nothing to clean up and
returning early is correct.

Reported-by: syzbot+5f4b29d9fe710a964482@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5f4b29d9fe710a964482
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jiangong.Han <jiangong.han@windriver.com>
Link: https://patch.msgid.link/20260801095128.46322-1-jiangong.han@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/mon/mon_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/mon/mon_main.c b/drivers/usb/mon/mon_main.c
index 9812d102a005f..6882d8938a546 100644
--- a/drivers/usb/mon/mon_main.c
+++ b/drivers/usb/mon/mon_main.c
@@ -210,6 +210,9 @@ static void mon_bus_remove(struct usb_bus *ubus)
 {
 	struct mon_bus *mbus = ubus->mon_bus;
 
+	if (mbus == NULL)
+		return;
+
 	mutex_lock(&mon_lock);
 	list_del(&mbus->bus_link);
 	if (mbus->text_inited)
-- 
2.53.0



