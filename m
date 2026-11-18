Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057385;
	b=1vhBfURXKAq5hNpZfDfFQfKCp01I4p0S4onS470uFOCALWjU+2sB+B6h6XdaCL8N6VS0
	 K7ts/Ohkva2GfJIphDGARLnjWqRg9giET+0HfTnkE3ymrb2d6/npwas+As2yUMGYjhfWg
	 gCUuFy5bHf5jfxJIO0Ynm3GGg7oaPkNcz6NFwuCWemOaikHLU3zmzsqxyGQJE4GxNlsab
	 PfHq8My2ine7oBEV1bnyFrui89tCTrAsbaizzPdthvYhDZtpqjqVzMM7yk0Li0cvapABw
	 6QTRl+y0QXs4PmtWTfSsqPPmSYj+3WOzqc3Ze2ksKXbiBmPvft8h4jygayb5IKh3IWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4tgSwSq7hJUBJvB9QHsAShGR/JiueOlMO1RolZEEW8s=;
	b=EzJy/Px/aHYfRt5xrbwB+GCs9PQ5rPH5EnXiFsALxq43QPYtP5AGXPTddAxcVjfdDsb8
	 ov7GUYlKePjSXy8HPoAlvws0SML0rMbug2wEH/qNlMUjkPsstSM881Mn9CUVnSIOkhKTv
	 I0mhiojNzkQtwoNKuUwHEwKGGphiSeFMowCoMo+JhMabZvaCTrHKN0MhBISwl7FaryVBr
	 XFY+jvFmdgI+KnCYKNiNFm4SKVR73HLPBkMZk4VST+nGC9sMfcH3MyB8oZqjKu4r3hiwJ
	 BQ8fYZb8H/5R58JLhsWldkLnyLVdR+Dpi9SAOW73b0/LWhLrwOV8XoPjcoyxGsHqklg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQnHpHg5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCF660A260E;
	Thu, 19 Nov 2026 03:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQnHpHg5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D20B1F000C4;
	Thu, 19 Nov 2026 03:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057385;
	bh=4tgSwSq7hJUBJvB9QHsAShGR/JiueOlMO1RolZEEW8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQnHpHg5IuLmh6soboGHXC3PAJLtUu4NrqexjYPAXFX8PCMDoQizMxxhJ56QJOkRj
	 6KYm+Z2kQ3HIIjQDMWRDt7+ksu8/bOWZyHLsSumWFNaPa12UeBmqeOw7638INiOOsD
	 jmm5j+dWcD3oLoXaO81P3NqNa8uapVyySXHu35cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0095/1848] misc: ibmvmc: reject oversized inbound messages
Date: Wed, 18 Nov 2026 15:35:33 +0100
Message-ID: <20261118145915.081214098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2d778d0f011e6..72885df3f553a 100644
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



