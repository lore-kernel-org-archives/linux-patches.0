Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061882;
	b=aJS/mVmmj9nCe6pz7X6DxO5qDZec8rLLKHo6aGp9GPeCfDxKUaOfIQUq3Dik+McKbHYu
	 BJTkTa0pOprEV6dXn06xSU+ytLkzBRH5AyZCuLJCe+erdTL10g5oZ4rCz/Y3ZkRtv0hYL
	 L8SP6DivPgiWWgkj15F1Eqh2WDF0yTwLDiIvUIkkxguP835fKsSJuzjG3Hx9EMMdt06oy
	 JlXYnLoXbyq89gf5fwEXE5lvorF4yS8ZrsQ0cPtuuoDvAWodBK+1HfSj8tmiXiW//Dw0r
	 OtZ0kjnBIIrZMGMdRalut5jtrC/3rfHf5l1f2oCikULldTYMTRj/u5XC0Ls5hyEBsdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w0FCXAsxoynDRFp3LIPcmvF2Sh8xsmh518Y+u3AWsvs=;
	b=clPU9QWhfddtefXoegqPBHxxDPU8ogt0LCIf/LYEPXa2k1fjmWTHP82te+k2FVKoLMbH
	 qjCT9ELPymiarSvVwY1AvUq4c0u6bhWwUBJcfzorSKKDVhF6M+W3B4VxHGqRIgA0WjGDp
	 rIMrC+5hURACovPBYFU3aYCScxekgZsbVNIF/pwCh87CvZAdTZBOXUK6/uAu3n2LyDblp
	 LdImn8URMnEp4Z+zW8cjViJ7jhSBbnUzBlpzSllbkIrxGvAvCSIq/njREt7Teqyo/kHPD
	 QQxq8OuNS5IQV6efl0NM+Pp/dgGYBn8G+NqkCsN76GTG2mWSwMdogTZVweFqhToD1vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9vMvqBe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED8F606A32E;
	Sat,  7 Nov 2026 14:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9vMvqBe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8921F0089F;
	Sat,  7 Nov 2026 14:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061882;
	bh=w0FCXAsxoynDRFp3LIPcmvF2Sh8xsmh518Y+u3AWsvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9vMvqBeLXFtiozrTZQxLsK/xFeueaD5EmffM99vl3TKAFAxLRKBk92/7P1qfItIY
	 T/YUt2MOA1CXqp0Sde6FPglqOv1TsjFiVE6o/wMVtBvUqtF5aVdTG5L9RoYtlZcpGo
	 ID661a2P5P8eLMDRWYb4S8YT4A4SAWOaAbBHJgz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0894/1536] media: redrat3: Ensure we dont read beyond the end of the packet
Date: Sat,  7 Nov 2026 08:48:30 -0500
Message-ID: <20261107135022.740050556@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit cd49f62f4161c7340d9c9f53b67757575900c0bc ]

The length and offset is provided by the usb device, so it should be
validated.

Fixes: 2154be651b90 ("[media] redrat3: new rc-core IR transceiver device driver")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/redrat3.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 3170bd72a8e6f..4cbbe16a8ac47 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -358,8 +358,24 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 
 	/* process each rr3 encoded byte into an int */
 	sig_size = be16_to_cpu(rr3->irdata.sig_size);
+
+	/*
+	 * Note we are not checking if we are reading beyond the end of the
+	 * packet which was sent, and reading stale data. If the device
+	 * sends a packet which is short then we get garbage IR, but no
+	 * out of bounds read.
+	 */
+	if (sig_size > RR3_MAX_SIG_SIZE) {
+		dev_err(dev, "length %u is incorrect\n", sig_size);
+		return;
+	}
+
 	for (i = 0; i < sig_size; i++) {
 		offset = rr3->irdata.sigdata[i];
+		if (offset >= RR3_DRIVER_MAXLENS) {
+			dev_err(dev, "offset %u is incorrect\n", offset);
+			return;
+		}
 		val = get_unaligned_be16(&rr3->irdata.lens[offset]);
 
 		/* we should always get pulse/space/pulse/space samples */
-- 
2.53.0



