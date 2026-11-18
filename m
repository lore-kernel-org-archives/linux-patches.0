Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052792;
	b=RqwC0hmIEqgeyJF1jIHSHc6it7l8EVJHe7PDU4zSH86V3bHDxKJ4MZ0LQbfH3IkuTLJr
	 UocErVtfAhywWUhTS9RvivLrVDJqQDGD+NrQP4CykYrgdddDK7bpcUdutCAPbDD52Q5UI
	 mrP7Do1MnO4ZlXwkjP+S34Pakm/+fYI0DvZmohLG9qWI10QUPa7lJs7bBi6qwHO8C3nS/
	 mUoM4io9XDMG8RnyJMo4Jhf8NfwqXMcJU2hs9cXZeSLvteYR4k49cPnT2lRw4U1SqmeR2
	 DsiOdrc8lzdu5CVdyeCt8uoPbmf+Z96CquGTTkl0DfViqcJqcp/5jPxa/JebS5xe6mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052792;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OXAD4pQWwS0gafV+BLUqTWeWSMjWlSveivNFG25vrLU=;
	b=z9x2DARIObQpG65sxXfN4RAO04W1BVuBAR4w0LS731j0MxqviATSTo+Fukp7Ak/FO+BV
	 qgyZZHnz1wlocmnfA9cbabHks8yeEBpo8+FUVb5MOmuUwfNshDGMnbzWFkkijvAldVu0g
	 tb/54bR2ScjOG4jacfOlwH2wrbTaz6xyFCokBe/eYWT2jzuFmWpx8GKN4kkvkKcvpHljG
	 E49pqyK0L9GTg7MVbpo5AHR3JcN6IIxFfg8AE+dwsr4S5XgteRHho2tff/TRZuC/hXevy
	 3ObIppHIiq8xQY0oyMQAi0Ac6DX/F0NQg9lbPr2mk0JUiornDya5E4JrPAZTGUUok/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tOUKXB4w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50278606A325;
	Thu, 19 Nov 2026 01:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tOUKXB4w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E33E1F000C4;
	Thu, 19 Nov 2026 01:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052792;
	bh=OXAD4pQWwS0gafV+BLUqTWeWSMjWlSveivNFG25vrLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tOUKXB4w2rkzbA0bw+0300zV61Dd5DSXGXnBzItfA0ARnPKI5j5nheEPWARrVfxtf
	 Zfhfxq0uCZiU36gQQhEAA681NK7HzT6p66lfEPTbwmkHHK7RJeblG2s1meGjOH3Vx6
	 VAsQbc9nz4hR/XuYsXlyVVlY1nm/b8y1XRlXfulI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fang Xieyan <fangxy@xiaopeng.com>,
	Liu Chao <liuc63@xiaopeng.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0691/2214] net: wwan: iosm: validate msg_head before indexing msg_ring
Date: Wed, 18 Nov 2026 15:39:27 +0100
Message-ID: <20261118150039.361800641@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Chao <liuc63@xiaopeng.com>

[ Upstream commit 46cbf85155e5451b6682ea0c17bc62ec564aec36 ]

ipc_protocol_free_msg_get() reads msg_head from shared memory and
uses it directly as an index into msg_ring[]. If the head is out
of range, the subsequent memset() writes beyond the message ring.

Validate head against IPC_MEM_MSG_ENTRIES before using it as an
index. The ring is a circular buffer, so a value outside the valid
range indicates a corrupted head pointer; report the error and fail
the allocation instead of writing out of bounds.

Fixes: 64516f633bfd ("net: iosm: protocol operations")
Cc: stable@vger.kernel.org
Reviewed-by: Fang Xieyan <fangxy@xiaopeng.com>
Signed-off-by: Liu Chao <liuc63@xiaopeng.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20261020094254.4017726-1-liuc63@xiaopeng.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
index 4627847c6daab..455b3b6f09917 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
@@ -14,6 +14,11 @@ ipc_protocol_free_msg_get(struct iosm_protocol *ipc_protocol, int *index)
 	u32 new_head = (head + 1) % IPC_MEM_MSG_ENTRIES;
 	union ipc_mem_msg_entry *msg;
 
+	if (head >= IPC_MEM_MSG_ENTRIES) {
+		dev_err(ipc_protocol->dev, "invalid message head %u", head);
+		return NULL;
+	}
+
 	if (new_head == le32_to_cpu(ipc_protocol->p_ap_shm->msg_tail)) {
 		dev_err(ipc_protocol->dev, "message ring is full");
 		return NULL;
-- 
2.53.0



