Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043183;
	b=jGMRd80tsunajEBqBuG7k4M1wgrLnKQPF0z4/7qSbc54hE3u7FwLB7BDtFE+vHQarmeb
	 4KsUdhS3WiIbykeXoBDKQDVliTRGCsySCLFx4N54VOP8ofM0rnjqPEqmjvBC4DyCP9uts
	 Bpp4sGFhWZRZe0z9LBumb6SA07EEfKTJ8pn85z7TGrJz2Z2zk6ay6zK40YGP8Nr9e48t0
	 14w0/1NQNuewfzxG0s+xggaSq2vZFDDvqSUK8gnKBt3QnXjZ5untWeK7uzfprvISYPza+
	 W0IUcOUug7bNF5O1xuvmBnnJYeCJ78MIkNEULzH2CRY+p0zGbRlEIfYphTEJAtABnQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j5gutJ8909IcDhRNSPxXNT7DHrXUYaA34AaIB+3dvrY=;
	b=KYLecO/ODsSJTrpN3zzpmStJIlTpl/spfNjUgWFiG/P9K+evjedzGYEsW6bQtcbsDxEx
	 mOM/PdM0PcnJGkDgPhJ5Gwt4d7x+aJuiADgpSg/HuPaI93eM3upulQRxKdQXnI331zrVH
	 f5pHajjVbl9N9Kct6+39txwc+FElukjOic1M0AUOn5GNhn+gcCi1kH+x0ggxzWp60YVp8
	 W3whBCTGitkN4zr7L3WuPzNC+f2Wq0gyD1HGII16huHmDZYeGNkFjd/qJjTicuFZDoeB0
	 i6PYottl4dUGS5C0zo7QDeTb/BG5YVSA4K3WEGHCB2/lNBnoqJNCix9eJtDBJ+gF2Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AhuCioER;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5B9606A332;
	Wed, 18 Nov 2026 23:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AhuCioER
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180231F000C4;
	Wed, 18 Nov 2026 23:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043183;
	bh=j5gutJ8909IcDhRNSPxXNT7DHrXUYaA34AaIB+3dvrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AhuCioERM4Em/k0ThkNfOI1UsN+iUa8SCK7oIcYr0MVAEZ4tgeUEMFYR6JpPL9rc5
	 Kjx1op24NPpjfyv5LtluJ3g5WLdcAykpP5fqtqzUs6DzBEX4ksqTqb2C/qC52yWrYn
	 SLp3cPjozUXsGTgasiTW0ilu/kbr46fluvwx2r5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0121/2857] misc: ibmvmc: reject oversized inbound messages
Date: Wed, 18 Nov 2026 15:19:15 +0100
Message-ID: <20261118150205.708221550@linuxfoundation.org>
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
index d7e6fcd1ecf92..fbe5e8e5de319 100644
--- a/drivers/misc/ibmvmc.c
+++ b/drivers/misc/ibmvmc.c
@@ -1661,6 +1661,13 @@ static int ibmvmc_recv_msg(struct crq_server_adapter *adapter,
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



