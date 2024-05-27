Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F4617727;
	Mon, 27 May 2024 19:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838302; cv=none; b=aMCoR/EHxB9G3Rde4a5uLWA1sfDCdUj+qaOB+ln1u2+52DbKL9bvcHwPVtRMxRwueu1qOjq6MSRW5oVk67A4jWavcrUpPqSatXVRHXiU5Zi7WiiWYwm1N95fhA0NG9oAb4zXzqX2rfk7z0uFbKOJldcZpCM//hiwmu6D3RvShxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838302; c=relaxed/simple;
	bh=W7SgQVkZyof6znmWZKkDyjA1sCHsvycSndtTkEwfV8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6Hx2ugLKMusvG5xZjntFIj0k2FyRYs1M8KMMMrnNqkeOh8scJJtVPaLEsoqVi8B8jl1E1t+WTX5b45vDI85bQ4jH2rYAUAUNX3KuvGLBBI+zaqyFc71TFtrDdBgXIgrNBYSiKTJBfoQHMXFQD8W6OF08W5OizooCoX5n5QjIt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5D2q0Yg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5D2q0Yg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA27C2BBFC;
	Mon, 27 May 2024 19:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838302;
	bh=W7SgQVkZyof6znmWZKkDyjA1sCHsvycSndtTkEwfV8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5D2q0Yg0A0LcHyP8v0ZAfS73y3JnS/bQr5xHl2Pxs/xWiRfx7Fmrwvw6cxUbyRhv
	 iJznLoGbcHSGRKjDG6tIChbnoRt8o0e+T86gC1U7QzieXRI2hyA0yMfhOe2tBEzl4h
	 833ZysU1ui53DFTkFIp/Wxfls6yUdBaLsRTNX4bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 340/493] Bluetooth: ISO: Clean up returns values in iso_connect_ind()
Date: Mon, 27 May 2024 20:55:42 +0200
Message-ID: <20240527185641.406860133@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 18d88f0fd8c0fade7ae08c2778d6c6447b11f16a ]

This function either returns 0 or HCI_LM_ACCEPT.  Make it clearer which
returns are which and delete the "lm" variable because it is no longer
required.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: a5b862c6a221 ("Bluetooth: L2CAP: Fix div-by-zero in l2cap_le_flowctl_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 71a484269fc4f..6bed4aa8291de 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1904,7 +1904,6 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 	struct hci_evt_le_big_info_adv_report *ev2;
 	struct hci_ev_le_per_adv_report *ev3;
 	struct sock *sk;
-	int lm = 0;
 
 	bt_dev_dbg(hdev, "bdaddr %pMR", bdaddr);
 
@@ -1948,7 +1947,7 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 
 			if (sk && test_bit(BT_SK_PA_SYNC_TERM,
 					   &iso_pi(sk)->flags))
-				return lm;
+				return 0;
 		}
 
 		if (sk) {
@@ -2035,16 +2034,14 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 
 done:
 	if (!sk)
-		return lm;
-
-	lm |= HCI_LM_ACCEPT;
+		return 0;
 
 	if (test_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags))
 		*flags |= HCI_PROTO_DEFER;
 
 	sock_put(sk);
 
-	return lm;
+	return HCI_LM_ACCEPT;
 }
 
 static void iso_connect_cfm(struct hci_conn *hcon, __u8 status)
-- 
2.43.0



