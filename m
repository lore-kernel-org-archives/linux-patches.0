Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD81247AF63;
	Tue, 16 Jun 2026 15:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625515; cv=none; b=GnSdksRWgh4IQfU3LdbZ6uufHas394dbPn9zSWeekVrPD11Y6w5Shnml2Um1Bl/iLx2XBSEEfiPTrUcVR7p/l9WDVnk3ARfvAvNVp++lNxb+gAxtNy0uJLa1z68h9o9bvv9FN22MSc9jfdnVzN747cCvdvUkiVREwcVo14vGb0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625515; c=relaxed/simple;
	bh=nh4O6tUflC7U4iiGis4x16+wJ8GqhfUm5I+loPNW/RM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=av9mZ7aq0LE2Du/zYUhljnSDHVC+C62zbnbY9QGgFE3VuCXh+GkL1dzd6dI1lp8HAHrJhw2HuBOCMlt5Ezt2sH8nfCHsYSDS4TMqsK59ZbfEl9RnSR9JV7R/uOspLJ5o0lLf1RNzUt9Y9WDhMPHAKi3Aht1eNgXJz5o3uttga0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZ2t8yGc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZ2t8yGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833471F00A3A;
	Tue, 16 Jun 2026 15:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625514;
	bh=Ba7XPydly1pKJLTnQfybEQqotlOeRX2BLpV76cDlxqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZ2t8yGc5BUTfi7g/7z0LluD9DpkK+doG9/OQEht2dqpQku9f4ujkb1cOwkMr/lLo
	 HpW2IMdT5slOHp84pVgMKlumNM9IbOJ3RraFezEMHiwx8gnyX35USLTxP24M9qTgQ+
	 E/qM2EXFswsGMSqVOlK73vGzK4J3ZYGHLoxr28jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yuqi Xu <xuyq21@lenovo.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 150/325] Bluetooth: hci_sync: reject oversized Broadcast Announcement prepend
Date: Tue, 16 Jun 2026 20:29:06 +0530
Message-ID: <20260616145105.184027985@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuqi Xu <xuyq21@lenovo.com>

commit 5c65b96b549ea2dcfde497436bf9e048deb87758 upstream.

Existing advertising instances can already hold the maximum extended
advertising payload. When hci_adv_bcast_annoucement() prepends the
Broadcast Announcement service data to that payload, the combined data
may no longer fit in the temporary buffer used to rebuild the
advertising data.

Reject that case before copying the existing payload and report the
failure through the device log. This keeps the existing advertising
data intact and avoids overrunning the temporary buffer.

Fixes: 5725bc608252 ("Bluetooth: hci_sync: Fix broadcast/PA when using an existing instance")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Yuqi Xu <xuyq21@lenovo.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1725,6 +1725,11 @@ static int hci_adv_bcast_annoucement(str
 	/* Generate Broadcast ID */
 	get_random_bytes(bid, sizeof(bid));
 	len = eir_append_service_data(ad, 0, 0x1852, bid, sizeof(bid));
+	if (adv->adv_data_len > sizeof(ad) - len) {
+		bt_dev_err(hdev, "No room for Broadcast Announcement");
+		return -EINVAL;
+	}
+
 	memcpy(ad + len, adv->adv_data, adv->adv_data_len);
 	hci_set_adv_instance_data(hdev, adv->instance, len + adv->adv_data_len,
 				  ad, 0, NULL);


