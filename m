Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057355;
	b=AL8i4OtKazLU4/QNVKHfp3/x2mQ3H4ZbPvluu3yikXqbNWJmadPPBQmxVPal7uSpQdJk
	 h7mzerlhkIoIfeR/EoTHStCqoUCvKoHYJIsmqawoCg7fTd3iu5RyuGvpPhyxckSVdpl9v
	 067964BTTS/iaHZag+A/5RO7HhbiuvBek1HA+a8/i5W+S6m24rSjogD00lE89j16Hc6uK
	 a2XVrzNAzhS0cl8dmy+SVvEZc/owEXe+02lF7yqmn4IBcYAVEF1M9MP1OjUOJ6OYpccbg
	 n64XOdIG5KfJ1THh5MIQ2m6Zgi6pB1vEJXCXhOYFr4A6aQcgs9MgzZoUrMP3GCGGFTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=usiqXPaqP/QUNWZbFeB4LTSbvQa3ckmBxHPq1CYOSUE=;
	b=onD12/X8wbJH42L4KAiyhup8F1p+wBLKJ75F5JW7LltF3SbFQbCcYoynG9tQLznhvF3s
	 6EbyfrvOAkOiVhQX/GjvyI6MOpYrNOKz1m4WkreTdWZHiLl1Kaa24LY8MnJneH88C4hL8
	 HUsy5KslU4Atz6SmODvdczNASLkfnL/xLzNdb9iAsUFajw3OGbVyQmSCO2K2EHMEZt8Am
	 wMD9rXhxq25JNbIEbQ6Vj7Ouu9NDO6CZoz5Y6F6TdhkUj4z5TAnVg6LAIfVdgU37He5sE
	 19dOmkiYHrD/6SZPjdcd6xMy0w3j5UJvdqL46KwtFzU3Y1f0BR7i5BZI4yBrnsMPWNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKJrh5bg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BB160A261F;
	Thu, 19 Nov 2026 03:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKJrh5bg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945541F000C4;
	Thu, 19 Nov 2026 03:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057355;
	bh=usiqXPaqP/QUNWZbFeB4LTSbvQa3ckmBxHPq1CYOSUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YKJrh5bgPaM+BRRlWft4Ubgcid6YVIgMc5VpEqWs3EUHloxB8Q8UKsP1GOqzt/p9n
	 GnH41IgnJPcaz72MnkkA+4pW82/9AeLrkLNwvOT1mlPPvk02YvYBXSFloRPbXWWPIX
	 m5/uIO8NMrL4aUNyOl7RRl7QnBatxF1w01ML/Oto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0094/1848] greybus: manifest: validate string descriptor header
Date: Wed, 18 Nov 2026 15:35:32 +0100
Message-ID: <20261118145915.050096756@linuxfoundation.org>
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



