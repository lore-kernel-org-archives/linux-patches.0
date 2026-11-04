Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829540;
	b=B4aGTc7hVIFrnN0E8Sd3ljyN1bNeHsAK14PvV4l8VSbKp93Sv7Ptx1CIN2+qp9Gqu1rD
	 9hze6Z8xp5gMJb0cKhKoLPIXr4d+gNIrLZgqj63JDjB9CvD16gYNukaOgMqRBde+HWg01
	 ECbszYh/H8Pi6ozaR7maqr21477OEb8RJ5U8up1KpQABNoxniZav6cqDCBJI9qaOhjjdt
	 srJlbUdIiw3bSyPxzsNvu36IHci0otDfjv/By6VnB+cDCK/eFADPgMpVpfa+2A7Iry3jV
	 lmYj7tastRGiMko3pRDpLlKHnOSBpBtVn8r3zmSoFyBuVWrFfA8oLfYizOegTXXe5hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kUCMq/SJPQAkbiBIulU58vSO/EY+qUkQdYv0bHNUeIg=;
	b=YPCm9/BZei3qRIjBB56azx8VxkScIzvUWcJ9br3BVtVAu5og4y4mO3ywyikKdSbcobWG
	 T+fcDPx0J9YkAb337p+Ffd/ELoKkple4S4pbinCL5EchzbBPIOxzhhVlasaWSG4wyAAc8
	 1YBgvk9zsWfP8oiE4p/Un3RU0RhesSgMUm8E+2tjr0AQqoO+d93ur1XbQnC/T5D4XF6QC
	 PT/GH16+vQ1VNO7G1d4IcN4rjasCwul7sEohrx2Ers2SAggFjGX3BnyHX0x6/Rb0S3Dnp
	 iBpulJSYj+9NHx79IWFIMPeW0YyQ9THJ4Tnk9pwfl8gwvizkrPpPZ7FpPfROEJtnGog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oZJCdOxQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A09060877DC;
	Wed,  4 Nov 2026 21:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oZJCdOxQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B871F00A15;
	Wed,  4 Nov 2026 21:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829539;
	bh=kUCMq/SJPQAkbiBIulU58vSO/EY+qUkQdYv0bHNUeIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZJCdOxQTxLkFc3NLd/HfDglW+L5giT3/xC0W18kMBG/c/e/MqNjWN4TEN43fSzCH
	 jpgHcgC1ysGMRyvlxv6pA1Z/XJabXAZsvM4PX5YZ/ov90peOgfFAVeL1FqaFlsIFkj
	 p/6KWh0881TIo+bU83g6OKOf4dXBFEy8XkpNxd1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0191/1005] greybus: manifest: validate string descriptor header
Date: Wed,  4 Nov 2026 15:58:44 -0500
Message-ID: <20261104211049.146117731@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 18b6510f642dbcb856c3af8be974d1600f3ba2d3 ]

identify_descriptor() computes a string descriptor size from
desc->string.length.

Require the descriptor to contain the fixed string descriptor header
before reading the variable string length. The existing descriptor-size
check then reports the short descriptor.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260706091935.78020-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/greybus/manifest.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/greybus/manifest.c b/drivers/greybus/manifest.c
index dd7040697bde9..469da3f39afb4 100644
--- a/drivers/greybus/manifest.c
+++ b/drivers/greybus/manifest.c
@@ -122,6 +122,8 @@ static int identify_descriptor(struct gb_interface *intf,
 	switch (desc_header->type) {
 	case GREYBUS_TYPE_STRING:
 		expected_size += sizeof(struct greybus_descriptor_string);
+		if (desc_size < expected_size)
+			break;
 		expected_size += desc->string.length;
 
 		/* String descriptors are padded to 4 byte boundaries */
-- 
2.53.0



