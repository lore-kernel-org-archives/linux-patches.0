Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051157;
	b=IAvJMYCV7TbDwmzvzVp5aLHYN0N0SvF9ggTe4XzkPdX11bVCXFGvW+n9bhaNFG0CgHfJ
	 A8Smd0Wcfy6sBBDrPVOLb+Yi4NHiwKST4PyRR+4DQTn6XGS3alJrtabf+/BSqjf2LWP5E
	 HCnGcpaxeZKjBrJ2ateLxOHC2h4cvFUYWHZ2dIQZmBbdzYdn0X7wKDcY9aqUdRfpIJLC6
	 TrMBESbqYMQ5cgUhXeViqZ5DGtu/lYwPYMpYFhC32GVyn960BLhWKB6ZFmuFTJHky2Dbe
	 gam8fbv/h88kk8zEWP4i7x6QZzrcTy+QmS7s1N/HcFBQ4n81R8k2r3n7stJ1F0Hnv9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fOKAPxohR7VPvukbgZiv+Va067BXYoX3N75XZ2cTwAI=;
	b=WHEOhxFQIEm692NB2slGnEX5hm69DekbHLXxH+/ak42msz+WfQR7xCB3qYS5pibZHN0R
	 qJ5MU3IW7d1Tf5fhKheMtGI2lk8iAP5KVuY/rjQD9TfqPSl3BLqEYCLZL4Tjo462xw33S
	 OZu4LhgBqumkdc8pIg5rimU8UafESmStzL/lzDhXWA8JE57o5ZF4OFiyyVdUaGgeR6D1M
	 ORoQwJRKtG4IzPZS24CSQFp8tw2vPlqUMBV1hQOCLq23ob2SAX10pB+WHixaGrEzLbJOJ
	 YHGEpMmec0pYty7TJ8+yI7vePqkry67R6igJyk7SrmD2mHYJG/IzDSBoaNDjDClIT3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K7bdziau;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89787606A320;
	Thu, 19 Nov 2026 01:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K7bdziau
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5C81F000C4;
	Thu, 19 Nov 2026 01:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051157;
	bh=fOKAPxohR7VPvukbgZiv+Va067BXYoX3N75XZ2cTwAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K7bdziauNjM/c9AajtqEDVWvC01HjnzGRKh9xNMPoIh9oYy9tnzlWrKcxt+3AhpUA
	 tv8k0nAdmFvKAUrfkdg4XHuieL3V/PVW18Uy5+BHECbILRzq/3nubC79JagCOwn6gl
	 SrC7c5HJCG3BP15gHGKZcbFjIK7aZAvZ0mFtbe1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0109/2214] misc: ibmvmc: reject oversized inbound messages
Date: Wed, 18 Nov 2026 15:29:45 +0100
Message-ID: <20261118150014.275246462@linuxfoundation.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 18189e5d84aa0b3bc89189cba13b9105634cb6fb ]

ibmvmc_recv_msg() trusts the message length from the CRQ.

It passes that length directly to h_copy_rdma().

The destination buffer is only max_mtu bytes.

A larger length can overrun it before userspace reads the message.

Validate the CRQ length before issuing the RDMA copy.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260624175139.7981-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ibmvmc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/misc/ibmvmc.c b/drivers/misc/ibmvmc.c
index c0fe3295c3303..cd9fc00868872 100644
--- a/drivers/misc/ibmvmc.c
+++ b/drivers/misc/ibmvmc.c
@@ -1653,6 +1653,13 @@ static int ibmvmc_recv_msg(struct crq_server_adapter *adapter,
 		return -1;
 	}
 
+	if (msg_len > buffer->size) {
+		dev_err(adapter->dev, "Recv_msg: msg_len 0x%lx exceeds buffer size 0x%x\n",
+			msg_len, buffer->size);
+		spin_unlock_irqrestore(&hmc->lock, flags);
+		return -1;
+	}
+
 	/* RDMA the data into the partition. */
 	rc = h_copy_rdma(msg_len,
 			 adapter->riobn,
-- 
2.53.0



