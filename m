Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829545;
	b=xxpLgVHoMKhZ03XkrhzFJ6/0sBAGUR1FrJy1rxtow9V5W7SZKCRD/n+TGNPx7+JxSIyo
	 YYHAsW0JGnioJ76SNZ2t4/8q+MgRhIQLSK7QzDn0cpi4GXj/YcvtAJtUrRZI+XoXYox72
	 hiKJaS3TU89AWcr1/ypI+NrlFQGtZITzyZFSpxcm8HyC4kijjUhxznhYiGTeWOQN2jBbX
	 5yja3ZlEpXBv/Ubfs1A1bEoHLXgk0RpSI119zpoPFS5FCVabHUC2XZJ/SfVI2TFcrwnD5
	 B81nJ8MMl+3uZPRul2GJ1+JtaVMlSXHkCZusG/JTvrfm/8F+Hney28xdkzWmHcGEZ0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bwpUOoTmnA19RFKToeBByoSSzWx5f2eXghingd+JmOQ=;
	b=i2BDhKbN+Q+D6kHEFPGMUavK8QrKUZrbJCIUPPcfc2af/8Njnaq1RinLbSX/sEQ0UFHu
	 l2C4+rTuIYfjXHmKPSmd9UyZT1PL4Lfjt+mzmTI9FeYcEpMNplhJQW40FiWiMZhARy+xq
	 k4Xzy0/1TDUyg9R6cz/b/VoCSKkU2xH1JGGAvEoqWJlUNs4IMW0Z91L9z+sM/6Vyn1+jU
	 mLm09N7El6HiCdfwpk6XFMLI/d/hjUy6+RjidtloFOtRSczpKk5KdN4WRf09OFimHj37J
	 3C4CsA4QsUP8pM2m+Y+zozN3lMPDuSCBU5ptgAOnOAEMWa1V9hOLjoSORfx3eyA8ROA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2aV0a7k8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02826074FBD;
	Wed,  4 Nov 2026 21:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2aV0a7k8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFFB1F00A16;
	Wed,  4 Nov 2026 21:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829544;
	bh=bwpUOoTmnA19RFKToeBByoSSzWx5f2eXghingd+JmOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2aV0a7k8f4IlIalKY77UeEtnDMRQAYXu/zy94PAaGD2d1mCPmOFeARsU+oNyX3kEU
	 JTxZfJBvlHclX8a4G7+OQ4XjfYXVGpNAzzzv2VlYrZYn7j/n7t2Q3B3ukz3kXU4lO7
	 vwdIycPvx0fZa10Ks045+yR7kMr2lbq+BauJ7Sis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0194/1005] misc: ibmvmc: reject oversized inbound messages
Date: Wed,  4 Nov 2026 15:58:47 -0500
Message-ID: <20261104211049.231229988@linuxfoundation.org>
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
index af84e94ec5f0e..b26ee0d3626f5 100644
--- a/drivers/misc/ibmvmc.c
+++ b/drivers/misc/ibmvmc.c
@@ -1659,6 +1659,13 @@ static int ibmvmc_recv_msg(struct crq_server_adapter *adapter,
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



