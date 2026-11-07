Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060748;
	b=C6j5je2auceSIFM/SQEzaO5ytEgscgzjT3SSka7qPZWjoOjh2YAoQC5uVE0lEwJtanIB
	 yU5dejkqdDW7JMikIQWL6zoaj5TYDRFfUfK7cLcAP7MNFvkI1T3/9LN39hJjI9cXZMw00
	 Jp0OKBZAzUBbyQswfsqepdHeEOy4vpU+mkMC7r5PfRXa3xI5gOkxpHqM/0D2lbFS5YXRE
	 502DgORczgjnS0iyW1eGAEDzkMORW/k+cVfOGNRzEDPi+Ueod2OpUtqPuR3HMJoKBCIti
	 U7egil5J5UtqFHtxVhOty94nuagLncufKI6qu+nhuxIziW1y+XMEZcAVh7eixt1+HnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RdvaZTsWfUrLYFf+jdA39gAE3Qb2q7J/YYM/oH1X9s8=;
	b=Des83ZGyf3PJbL6IyvfhDlxD9M6pAxo239xvYV1lwwbWCKjgjWhWkkuaEMEhxOE5WhVW
	 2KObVYQ0IB0w1rkj8RSg6lB0X/+/7Bbcw6DuapnnSMSbdNFBvOLkiOuBQDc6oZJXPsJIJ
	 DbAPkURKAKzRfz+ABAbrtKktQijyyyo/RwmWzrW1MxcbNXbIvEQAVT97TfB1L/OL+d9ox
	 /tjXUAKF8SPT45IWUnLfo1WRmpFZCH/M+TJ7dIM2YQN/Z54CKJkpOncGl+Yaukdv68EHb
	 D9sy1Qbhhq+PhlXBwUdpf/1OwKmwifQX0jynVEAitFCFLRjsGiuSnxedwmSLxOeJCcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dZJ+LRTl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5208B606A32C;
	Sat,  7 Nov 2026 14:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dZJ+LRTl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FBD1F0089F;
	Sat,  7 Nov 2026 14:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060748;
	bh=RdvaZTsWfUrLYFf+jdA39gAE3Qb2q7J/YYM/oH1X9s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dZJ+LRTl38Eqvn8K+L7FWL2evP+gxRrEqj/Iaoz7kMlk0q9MQx73dVcvVo/GYxWF1
	 BGS7C7QVTA89OtL5xmmEQn5h+5wY7FV8oTfc2pP/HJe9z7NvgGdaaqttlFBdhIiJkW
	 aKviRDD1IegOXdakfYuqMfsO0uFN2nmJ1xui4nH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0161/1536] misc: ibmvmc: reject oversized inbound messages
Date: Sat,  7 Nov 2026 08:36:17 -0500
Message-ID: <20261107135002.194313945@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



