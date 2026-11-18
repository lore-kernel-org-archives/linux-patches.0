Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042836;
	b=nT8phEltUdpMReH2hgCq5C5Byh3SfyQJFhZjYnLQufjWgfn5xaZWrMFMAlFI1OJWcRjj
	 BBhjNgalPFVJWUdbbY0jP+lUrsPpvPUbk3IKw3avDJD0yqx60j9JEVIXFzMgaBj/vptq7
	 XUBm5LibehIxnDO8FbNWQ7P7IJmUoIJ//LMXoQSo5ph9/hfwJZ1wzBlYgQc4xH7BjdQWE
	 zxhBRPIkOCQSUrvcbSHSLNrehxE+eRSwvdtkLxjTYDmqNlNAFfDVEwPgTgwU6zjaVjNTE
	 WBrowrG8c1/Xoezsk/q2F6zi1N/L/Wb2CTvFdT8rFX2CiEY5zHUTSEH1ksSMKam5raQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042836;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/GZYygUMgC0NnypUxKP5WopSOSj9Jck/0jD0OROyB9c=;
	b=uiUpayYvU7Xl5FxyHp4f4nBs+3fOPl6TVjXpoGRK5vh80d23pi9lc9lf6env/CCRsDBm
	 ZcUaujBinc4DqbxI89d+63q7JIcO2oOpPMRmBmo9xfWTe8B8/vb/MXUPTtnPOMMJO1Lot
	 2h1uS+CdPUqNXN/pUiPQW/rXcaX+OiTCx0iJx+/wDd+INsYrH1JSnmWZFId8HK4cK4/S8
	 nLXdHGySCTnuWCAfeIcoIBzxBvx1GnBJzvY+vkxQ/fSw/k7pTzJ3was1KLBILx32xjfrJ
	 Q6nETjTr8q8uucMCjJhiq40cqQ2x+5xF8PYd2JpAeYBgmqpse7BAlTO5TOnvDNQygKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aaHAdFBt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EA8606A31C;
	Wed, 18 Nov 2026 23:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aaHAdFBt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402131F000C4;
	Wed, 18 Nov 2026 23:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042835;
	bh=/GZYygUMgC0NnypUxKP5WopSOSj9Jck/0jD0OROyB9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aaHAdFBt1QvSnn+SSjM2YFAtET/i6jgs1ncU3AcHcG+739DMqhVmmCo8vQEfTkBCd
	 UTwP9MPiyQEPNrOfwZyRb2pUtIQ670ZgOC9uuw2Mr6eok7gOhAgJRl7M53FA3/VRoO
	 zVkkHCzQJCtmgRrlnpc7H/JkhflCDmTpnUmYnoOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.6 3312/3318] wifi: mt76: mt7996: fix alignment of sta info event
Date: Wed, 18 Nov 2026 16:05:34 +0100
Message-ID: <20261118150458.939717755@linuxfoundation.org>
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

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

commit d58a9778f7ca0634622d2fc2e9f76163467bdf5b upstream.

Fix the alignment of struct mt7996_mcu_all_sta_info_event.

Fixes: adde3eed4a75 ("wifi: mt76: mt7996: Add mcu commands for getting sta tx statistic")
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -181,7 +181,7 @@ struct mt7996_mcu_all_sta_info_event {
 	u8 more;
 	u8 rsv2;
 	__le16 sta_num;
-	u8 rsv3[2];
+	u8 rsv3[4];
 
 	union {
 		struct all_sta_trx_rate rate[0];


