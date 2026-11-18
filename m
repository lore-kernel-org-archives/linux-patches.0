Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035705;
	b=sSTg14WkAShrDfFoasF5L59MAwoeeRWaJWBUuppx7q4RZbvhzbwapcsK9DC+SeGHvyTd
	 jfXFOQg6XnoRWGGwobfOx45f51oH0utVmcm5cbu4Qg+8j0zE83kgpzpQwmZqtDrHmjIP0
	 O9z9Uh0GNgNGtCrBFc/oqg6XioV2VZ0cfJbuekNMdGiuPvVRDmJxTbIoIzDY11onwJ6ti
	 tdv1eXsmjBCYeKkd0h8e7Qo3BcFMspN4o8/Jgbrfr7bNEgWOxRsP5zyKyGuDt9kexKx0k
	 E1+li6bFPRzDfOv3Nptf1WxKiTGwgW/wwIpBFswP96D1sVdaSe0s2EklRDKBBJozXdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xt/Djoaqeu+ndYqb1Xm3BwiJpb18EIT2Mca6Dogvtt8=;
	b=beg+/5TupEEyVDnqb8EVWIcnI64xE5tBFULMagZiMMyUYDIoClRYTEmRXnm+D40uDEtA
	 iP5CTQlsJBPaV7gtTkWFclYT1Ka/65rZitQ0ACZkdT/eCCOX9Vxm1gp+i7sKB6JGgwnNw
	 YqNmd4J6SNUM7Z4shEXeJQ3eB0d69PDQi0CzLraF9m8P/xNYSAKKBhnr3JgshtgiLKdI7
	 scwGsWwJOo0+eVqJ8AdGB/bDbcaA24kS9yBXRs+IqQPB/PhZZn6KS555kJNFvGgkMevUD
	 ienVmkxR/c2n6thJgEVOFCj67gPQXFHybA6W5u27fZHfnTd2dObksfjVT9FvunP81KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZV5ECgj/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93010606A33F;
	Wed, 18 Nov 2026 21:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZV5ECgj/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B827A1F000C4;
	Wed, 18 Nov 2026 21:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035705;
	bh=Xt/Djoaqeu+ndYqb1Xm3BwiJpb18EIT2Mca6Dogvtt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZV5ECgj/MO7NOFo99TQD/PX+w/upuRrONY9pSFY0jBdadzqZZlGXm5acOqJ8DZ+Ll
	 D+pfgdg3iEQrHtJj2VH3kTvDhnOCmv2nGABrnKUsW/MozpQ0KYZTFjBRUw8jhQU91z
	 wv1wbUSnlGvUNdhdEbgN0Ehi3G82qWSN2Rl7Ofyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0799/3318] media: redrat3: Ensure we dont read beyond the end of the packet
Date: Wed, 18 Nov 2026 15:23:41 +0100
Message-ID: <20261118150342.893355098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ee474c95c7561..b99279ae24bfd 100644
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



