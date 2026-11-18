Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020317;
	b=aBHu81QLtluXSmUru/EhjfDbiuO6s18BM/C3AbX5p+IOQmolmZaJq3vvXq+bGiVnltmW
	 uOI9FX4NOBbaC04A0HtsHZFWKNqk0YzDY1+fOqj3vsFp/rdE88Mh2TtqJgO7qN//kLTHZ
	 vA4fk1ejkzYMv4/sd5T6CAUlsWUVF3U4DSHfxihjUF/aqcPsjYQP0xssMGNIm1n1GOyV4
	 Oa7eK3XK18wwt1jzTR35OC5ApfT4clGNXA80gMhHSyMQ3i8qZVoyS3HAOOK/aEmT/m5xL
	 x7spSqSDKTZ45iXWhEIaKK4IJwW4zeIu/mXO1ZjYyxP3JhDHSZ3goy+nta9eGQNMF5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O4493bqCnLMHxGZxuf0PCG36Qhr9mjjEAZvBHB15bNY=;
	b=lDnd/q0Ed6X7zQ3xLsbH53aHBYxGIO+wP+diz8Hc8sKQphYf1ARgD22Q/+IYVs6HaQYJ
	 8aJCXGFTbEXX5UhmiObME7591uNCJLMyAd+U7cqi5htI8rWQ0meWOa72DvhFldnD1+LBf
	 +DN1XsLjxzb7HYrIzYI7ulUPDS3tZCj7a/oBJEiiyvTjKO2lIKnhha3SbhO7wQet8zIdd
	 kSAozZ06A1O2kVa5lJl1NmO5oDVfTvw6UyMRBJNodYr3zDEfbzmxSXgYOW0Woske3VuSm
	 YMF+GYOmYVs40+BUG1YopTxUYXorGZRhXn5E3wruO/KnkP50Htg6tmofnv8+OwNn9QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVn8IXVO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08430606A320;
	Wed, 18 Nov 2026 16:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVn8IXVO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CA01F000C4;
	Wed, 18 Nov 2026 16:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020316;
	bh=O4493bqCnLMHxGZxuf0PCG36Qhr9mjjEAZvBHB15bNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cVn8IXVOwTS65U3gG77M/mOiLRUb2UVm20C7kCDySPCcIn8JBRp6I/3xcnh3Ukd1H
	 J/BdzaP2NFeL7bEm4z5iJwqkTsYDYhcpbyvkq6GV8Qi06n7kEMkUpNbZAu/QsGsXG2
	 oR5RxZrbJ+ZNeHJGQzuQnxcAzr6zG4HKULAmfsaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1907/2651] Bluetooth: Fix the LE Read Connection Interval response layout
Date: Wed, 18 Nov 2026 15:52:27 +0100
Message-ID: <20261118150355.459899372@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 5874f8d03268d34189c6c12c56586b64d26a8bcc ]

The response to HCI_OP_LE_READ_CONN_INTERVAL carries a
Minimum_Supported_Connection_Interval octet between the status and
Num_Groups, which was missing from the structure. Without it the minimum
interval was read as the number of groups, and every group after it
from one octet off.

Take the minimum interval used to clamp the default rate parameters from
that field rather than the smallest group minimum, as the number of
groups can be zero, which left it unset.

Fixes: 2f8784cfe8a9 ("Bluetooth: Add support for Shorter Connection Interval (SCI) feature")
Assisted-by: OpenCode:claude-opus-5.5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h |  1 +
 net/bluetooth/hci_event.c   | 16 ++++------------
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 1641d879dbda9..9dc714d9145ee 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2527,6 +2527,7 @@ struct hci_le_conn_interval_group {
 
 struct hci_rp_le_read_conn_interval {
 	__u8	status;
+	__u8	min;
 	__u8	num_grps;
 	struct hci_le_conn_interval_group grps[];
 } __packed;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 3ea6c06adaaf0..3288f92fe41bf 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1247,8 +1247,6 @@ static u8 hci_cc_le_read_conn_interval(struct hci_dev *hdev, void *data,
 				       struct sk_buff *skb)
 {
 	struct hci_rp_le_read_conn_interval *rp = data;
-	u16 min_interval = 0;
-	int i;
 
 	bt_dev_dbg(hdev, "status 0x%2.2x", rp->status);
 
@@ -1261,17 +1259,11 @@ static u8 hci_cc_le_read_conn_interval(struct hci_dev *hdev, void *data,
 		return HCI_ERROR_UNSPECIFIED;
 	}
 
-	/* Store the smallest minimum supported connection interval reported by
-	 * the controller so the default rate parameters can be clamped to it.
+	/* Store the minimum supported connection interval so the default rate
+	 * parameters can be clamped to it. It is reported on its own rather
+	 * than derived from the groups, as there may be none.
 	 */
-	for (i = 0; i < rp->num_grps; i++) {
-		u16 min = le16_to_cpu(rp->grps[i].min);
-
-		if (!min_interval || min < min_interval)
-			min_interval = min;
-	}
-
-	hdev->le_min_rate_interval = min_interval;
+	hdev->le_min_rate_interval = rp->min;
 
 	return rp->status;
 }
-- 
2.53.0



