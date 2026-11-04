Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830887;
	b=ixdeMc8ZkQUBCerOZmfiLfRJUS65tSIBKM+VpSc/8gt2o6kGz/BR/CKCGZlOXVnWgpA1
	 Pm3o1Tapf0Bny+7xuU0WFeypTThW2MhDCDTPy/lJCLyFXDpRP8xYPFInoBTJZduD72I5Y
	 kVSMGY5lw3xc3c5ptoRAKdocZ/3+j5tgrDM4wieIMglIWAwijrugd0ebJYA4K6eDI2h5s
	 JI/oxlki2Mx12cEVg8GmqJM9KDapvhx9BX6X8I/jDqDZbmxMSeQPW13s6E9h/F63Ocjk0
	 M5g+TRIVKxnx7/0lMG9mlN4vNGcJH4o/gT8EU6ytGCv2A6ILGeTT0gyWshlLyup56cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VraUUxnzVE1P0tC5XpBlZ7BymVim1Ib0w1nmOBGrNE4=;
	b=Vj+IU8U4W5iS/PzRQxpdssUttL9anK9eEtlepY7f4Li6QpanREN1Ek3O8XKQaIEpfb53
	 5RKYXgvCJ2+6cIu4UxqHyDQtJNWF+Hy75oAnrJ/CgVTEqB28LD+o54mMmuxGL6AXmURCb
	 dRLUanDIEXE0TQ23CnMib329KMr+8CwXz7T/ID54+UXiJ5K77EZhpqcGnGicO3Wlfb6GL
	 eQmXwjaiPCik8icHnKpkeAJPXIJynpsNMqy/o0+Xp8O4BWFCfA4QWp9vqev4ctkmO21rQ
	 oorL767gJKD0z5RfWDAmgOtR1qpU5C38D7JOt3L1T68lf6XHlMUte8gf+Y+ixUM0AyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uUdhw8A3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5798B606EE9B;
	Wed,  4 Nov 2026 22:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uUdhw8A3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15311F00A02;
	Wed,  4 Nov 2026 22:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830887;
	bh=VraUUxnzVE1P0tC5XpBlZ7BymVim1Ib0w1nmOBGrNE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uUdhw8A35O5ufWcwmcxTq4iNyG+6PIwuKfM15tCA7iMVALyjOMKUb2ILbvwtPUqVF
	 bwkkpjbsQ/6f6fiWebxc7ACdWb2KxyQLpLHQxa7ySHE3fPqpKuyZk8XLO3kPBqdCbu
	 JqVkey9CYO0VM0NcJND2j5XvF8X8ZxuMGu5u7pmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0349/1005] Bluetooth: bfusb: validate received block boundaries
Date: Wed,  4 Nov 2026 16:01:22 -0500
Message-ID: <20261104211053.757567520@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit 6afadcff79b157a4770c4e987a6005bff40a670b ]

The USB receive path trusts the block header to contain the required
number of bytes and passes it to the reassembly routine. The routine
also trusts a malformed HCI packet type and can append more data than
the skb allocated from the advertised packet length. A malformed USB
transfer can therefore cause out-of-bounds reads or an skb tail
overwrite.

Validate block header availability, declared block size, packet type,
and reassembly tailroom. Drop the partial frame on an invalid block.

Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/bfusb.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/bfusb.c b/drivers/bluetooth/bfusb.c
index 8df310983bf6b..d31d797639b51 100644
--- a/drivers/bluetooth/bfusb.c
+++ b/drivers/bluetooth/bfusb.c
@@ -301,6 +301,11 @@ static inline int bfusb_recv_block(struct bfusb_data *data, int hdr, unsigned ch
 				return -EILSEQ;
 			}
 			break;
+
+		default:
+			bt_dev_err(data->hdev, "unknown packet type 0x%02x",
+				   pkt_type);
+			return -EILSEQ;
 		}
 
 		skb = bt_skb_alloc(pkt_len, GFP_ATOMIC);
@@ -319,6 +324,13 @@ static inline int bfusb_recv_block(struct bfusb_data *data, int hdr, unsigned ch
 		}
 	}
 
+	if (len > skb_tailroom(data->reassembly)) {
+		bt_dev_err(data->hdev, "block exceeds packet length");
+		kfree_skb(data->reassembly);
+		data->reassembly = NULL;
+		return -EILSEQ;
+	}
+
 	if (len > 0)
 		skb_put_data(data->reassembly, buf, len);
 
@@ -353,6 +365,13 @@ static void bfusb_rx_complete(struct urb *urb)
 	skb_put(skb, count);
 
 	while (count) {
+		if (count < 2) {
+			bt_dev_err(data->hdev, "short block header");
+			kfree_skb(data->reassembly);
+			data->reassembly = NULL;
+			break;
+		}
+
 		hdr = buf[0] | (buf[1] << 8);
 
 		if (hdr & 0x4000) {
@@ -360,16 +379,28 @@ static void bfusb_rx_complete(struct urb *urb)
 			count -= 2;
 			buf   += 2;
 		} else {
+			if (count < 3) {
+				bt_dev_err(data->hdev, "short block header");
+				kfree_skb(data->reassembly);
+				data->reassembly = NULL;
+				break;
+			}
+
 			len = (buf[2] == 0) ? 256 : buf[2];
 			count -= 3;
 			buf   += 3;
 		}
 
-		if (count < len)
+		if (count < len) {
 			bt_dev_err(data->hdev, "block extends over URB buffer ranges");
+			kfree_skb(data->reassembly);
+			data->reassembly = NULL;
+			break;
+		}
 
-		if ((hdr & 0xe1) == 0xc1)
-			bfusb_recv_block(data, hdr, buf, len);
+		if ((hdr & 0xe1) == 0xc1 &&
+		    bfusb_recv_block(data, hdr, buf, len) < 0)
+			data->hdev->stat.err_rx++;
 
 		count -= len;
 		buf   += len;
-- 
2.53.0



