Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25341442FDE;
	Tue, 21 Jul 2026 20:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664747; cv=none; b=u7AfcoEYTfOqqAraMvNNymqtfkW6XYGs4TyEaqHm1dv0BOAAW+GKr5IccFsBcWnHbb7oG5OzC3YRhz1OM8qRyzPxO/VhpPKHME5NZi7Taj8B/hVH3l3u2L8wOL7AlRc8zowmVV3HYEq0b6/z0Dy4OKS7iXSjzGrpkmhiFR9qJ2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664747; c=relaxed/simple;
	bh=QkineAeYoM+7zJ2l4IzijkRJ0KyyRp3TQ12aemoYqAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qBNY54ezvH5g3R4r70UEccruVXMMXcuEH2M/AXJXZ4XcEaTlSRhRraeatlxQKhG2Hn+N2KjCGcTCDERcUsau5upcbWEf6LvVfiCHIXt1FjGVDBR3CPuAHkexw/qePgCf49+iyqPceKzxatwU6em8FS4Ab2c/8/YE1qg8Zh0DWYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqnzA4HL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqnzA4HL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4951F000E9;
	Tue, 21 Jul 2026 20:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664746;
	bh=9wLUQ2UWCU6UOKyex5r1jp0OyVyi2LvcNUrFWsaLVro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DqnzA4HLZEMseqmJiIeNUfCyi2S2gkYcYhGKfgfxfw6sY4JGALoSsprwuehfLwpTB
	 jueGwqhGFu7d961k++ku2ns0gG4q4Tq140wgDKVM8H3H2Hvvj4qhJ2nQZefhjcDBzZ
	 PS/gDJngw+Hl4eXeX6S4fDUd1mg8HFa2kQGH5K8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0009/1266] Bluetooth: btusb: mediatek: remove the unnecessary goto tag
Date: Tue, 21 Jul 2026 17:07:26 +0200
Message-ID: <20260721152441.999796103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit be71dfb9ad2042bba713975ef50c3a5b0429f1d2 ]

Remove the unnecessary goto tag whether there is an error or not, we have
to free the buffer at the end of the function.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 5c5e8c52e3ca ("Bluetooth: btmtk: move btusb_mtk_[setup, shutdown] to btmtk.c")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 536b013ff7aedc..926ca7ecaf0cc2 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2725,12 +2725,9 @@ static int btusb_mtk_uhw_reg_write(struct btusb_data *data, u32 reg, u32 val)
 			      0x5E,
 			      reg >> 16, reg & 0xffff,
 			      buf, 4, USB_CTRL_SET_TIMEOUT);
-	if (err < 0) {
+	if (err < 0)
 		bt_dev_err(hdev, "Failed to write uhw reg(%d)", err);
-		goto err_free_buf;
-	}
 
-err_free_buf:
 	kfree(buf);
 
 	return err;
-- 
2.53.0



