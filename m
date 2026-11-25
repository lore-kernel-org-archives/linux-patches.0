Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618214;
	b=MoTW8pDvWP2Ngsm4cSOerwtUC9DPZSlCH7dhvXXC6vmrbwDL8NE6jQFCj5W92ofLOBeM
	 FZCfAd7XgAyFJ3jOodXLg2EVTgK3Jgi757NI1XVYDPCnSXMnS+tNgZeNq079ZsvjCqMsk
	 hSlPf4dFZQFwpcvmCNevZattsuGoJ/+n+iXTcg5C1PYL0FtzAB34WmOupRpjCw0gykBIs
	 udM5+biUZLIfGxVoblwLEKHp/PDOFCT2reCALsOxOeNtqgMF73pVhKPPJzilYo3yTvVGM
	 HlB80IYsfWJDCbLDLNwvkW/w/JBu3cR4soDe6fYGZrvwOQ2Nj/jTtUJQaTz/B2GfoDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kDXP3ewnKK8oDyUCEY4K1qhQkEjhpYOv/qp1OinpYUk=;
	b=SgDRHDMry/WPNPZeLhKvU8QqVe5VoclUgpHT1RrdTaDsnIajh494Hu0cqm0MsM+ilmlR
	 jbVHgbkY3RK74gPBjp0jtfF58AvEFkZjVhMxXrvRnnL6vgMvhy4nyTeUQ2mXiSD3OhO+e
	 PvKxwuXTQNTcQ9kXCCWHVzulPRWY9z+2l3kFbRGs/9AZ/IaQM6Heqcr/G/cNIqTJrcRR8
	 ma4aBNbbKYnEy0jV3hzxJgf1kvrbzqYcLxxeTVC8A19H4Ki2ZDrKIPdYAwvd9ZABTRpFL
	 Ljlc77D0uNsArfJeLw6FbYLUlVRZRvFiAImNln5vP+p3QJ3bcVIALbL+NrKIodlnMhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=niMr9qsW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796DD606A31E;
	Wed, 25 Nov 2026 14:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=niMr9qsW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7521B1F000C0;
	Wed, 25 Nov 2026 14:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618214;
	bh=kDXP3ewnKK8oDyUCEY4K1qhQkEjhpYOv/qp1OinpYUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=niMr9qsWAuQpVTaxdcZQnFTbUFt40v6Jc2rO1Mo7wRdoBxRq3ml5jFS3JMRcpBaP7
	 m9cXMd5DHUv3JCkh/iIIoW/LESK/MA1cYJ8nISAwE5cnuZ5uurh9+KNJmL0z98Ek5u
	 ULY7R86h0aJoxBvdTQtDaldN/aj3IYVt0Q6ih+us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ismail Tarim <ismailtarim7@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0206/1005] Bluetooth: btmtk: fix error handling in btmtk_usb_isointf_init()
Date: Wed, 25 Nov 2026 15:25:44 +0100
Message-ID: <20261125143826.567519914@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Ismail Tarim <ismailtarim7@gmail.com>

[ Upstream commit 3b70dd827b27bfadd89e7b1a2d422b04da38797c ]

btmtk_usb_isointf_init() submits the ISO interrupt IN URB and then
sends the vendor command 0xfd98. If that command fails, the function
returns an error without killing the URB it has just submitted. The
caller then leaves BTMTK_ISOPKT_RUNNING clear, so the driver treats the
ISO path as inactive while its RX URB is still in flight, and
btmtk_usb_suspend() skips killing it. Kill the anchored URBs on this
path, as the URB submission failure path already does.

The return value of __set_mtk_intr_interface() is also ignored: a
failure to select the ISO alternate setting or to find its endpoints
is logged, but the function goes on to submit the URB. Return the
error instead.

Fixes: ceac1cb0259d ("Bluetooth: btusb: mediatek: add ISO data transmission functions")
Signed-off-by: Ismail Tarim <ismailtarim7@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 18d9e26add2ae..ed53e1d8902ca 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -1352,7 +1352,9 @@ static int btmtk_usb_isointf_init(struct hci_dev *hdev)
 
 	spin_lock_init(&btmtk_data->isorxlock);
 
-	__set_mtk_intr_interface(hdev);
+	err = __set_mtk_intr_interface(hdev);
+	if (err < 0)
+		return err;
 
 	err = btmtk_submit_intr_urb(hdev, GFP_KERNEL);
 	if (err < 0) {
@@ -1364,6 +1366,7 @@ static int btmtk_usb_isointf_init(struct hci_dev *hdev)
 	skb = __hci_cmd_sync(hdev, 0xfd98, sizeof(iso_param), &iso_param,
 			     HCI_INIT_TIMEOUT);
 	if (IS_ERR(skb)) {
+		usb_kill_anchored_urbs(&btmtk_data->isopkt_anchor);
 		bt_dev_err(hdev, "Failed to apply iso setting (%ld)", PTR_ERR(skb));
 		return PTR_ERR(skb);
 	}
-- 
2.53.0



