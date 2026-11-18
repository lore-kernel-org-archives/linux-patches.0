Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018935;
	b=3hacIIsGNp/2eLxiH0yrcLjBAuZg+tpnP3FkV0SMBoQZY/zch+63EYcSeHlRAjY2pIr+
	 Ktk98vx9duXzcxbp83fNaxYQ4GiCMS5Uo7tY0CFbOe0WjOrodoEvt1RI4hOIUVU4j4EdP
	 Ez/xpNyG1mtqAZjdinwJp9Ebt3+HrC/fDzDXyk5uVSuY1NmEtgvSSUgVSc9DNLmrLZzPF
	 Xo8e0f6eezQA5b1mOJU2iFAdUdkyMGa9l5PrCfCVk34BDsSqhQgHK4qp8vCZEa7wbNXVj
	 JDE1O7A7eXvhZV1XRCqoI0IixYX5a7Qx3ItrHeMT/vr5bnKZoeqE9WcCQqxrBGSA8JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=trU2TitYpSazBXOe7+RobIYvc/d6L/yZ2g1NYLHYvVc=;
	b=pLthfp5hD/UjkwMj0N7blPbMyIKJN4TF0UDwLG8cWEpFm/uDE05L7UPx+7cku8e5wtya
	 CCtymVs0PBszTTsZIvtAMs/3EkdYEWDmTu9Nmt7i52yspbeGqTuEcJxxGikFH1pEhQpjm
	 YnHoSEOOAgcmuQrk1ZDuOGmPi1SCmo9Z99BwW/lz4Q5AB+/90etH0Wwg6y+tlbazx2UVz
	 3VWorQvet8SRMexwLhspACXtWfjlXL1GKhuXRnGR9YvyCKh3a80lC31Mpopg9Egm4bpjI
	 0foL0uNw2yyt3LqAFQBtSLtjI4juSWQx5zLNeTKqeDYKGUP6X/aIx0ATTJkY5x8mqPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NvRmcIJZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F12606A320;
	Wed, 18 Nov 2026 16:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NvRmcIJZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05C71F000C4;
	Wed, 18 Nov 2026 16:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018935;
	bh=trU2TitYpSazBXOe7+RobIYvc/d6L/yZ2g1NYLHYvVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvRmcIJZsIlLpTu5zTTqCEYGZLvwL1yfw/HSIiJp2o1jNb43P8PnbWkFy+MZaXdfK
	 FbH35OETValzcXRoQP6Mkoify76hNzr58MQfs4IeMGq+q1Hhv0iXQN09HIk4UchjPK
	 ZC64SWApEELpOiPaL/yEH3WWcja1lN1Il+f+DAmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1417/2651] wifi: mt76: mt7996: bound RRO session id before indexing addr_elem[]
Date: Wed, 18 Nov 2026 15:44:17 +0100
Message-ID: <20261118150339.029795895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit ec0889c74734131c6526493bd3134eea7de25bf8 ]

seq_id from the WED RRO indication is a 12-bit field (0-4095), but only
values up to MT7996_RRO_MAX_SESSION map into wed_rro.addr_elem[], which
has MT7996_RRO_ADDR_ELEM_LEN (128) entries. A larger session id computes
an out-of-bounds element index that is then read and, on a signature
mismatch, written. Reject an out-of-range session id.

Fixes: a09d2f9d69af ("wifi: mt76: Convert mt76_wed_rro_ind to LE")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index a9558381ad91d..a8c4f629109b8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1936,6 +1936,9 @@ void mt7996_rro_rx_process(struct mt76_dev *mdev, void *data)
 	struct mt7996_msdu_page *p = NULL;
 	int i, seq_num = 0;
 
+	if (seq_id > MT7996_RRO_MAX_SESSION)
+		return;
+
 	for (i = 0; i < ind_count; i++) {
 		struct mt7996_wed_rro_addr *e;
 		struct mt76_rx_status *status;
-- 
2.53.0



