Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827193;
	b=euHsuHvmdGjlEDLLaNVhEQzzkZ2b0GigU+fFMRzU87Cw8PV02GpkgQzItIeDlu6WQCfz
	 9MT8R+O5ZdxE5e9tFz+/G7K/yvJ0HemdzNP/W/uG/bkBljmj35Y0g9Sd26CTWht2uQAi8
	 /FPoalwlHokmp+S2gJcjOtG3D2GICH3C+GJWGS707njvq4t6hso9OxJjwjvnmXOkOn2xt
	 CVjH3lbHgdk69nouxrN9wS/7oLvLyiRKOTRoGiBNmyTUtVEfmwEW6WEE5T/9ERc+JVFHL
	 P/6IxQVPa74kWalfebRUu/jSvxoSV5nlt8ERTTL8XEYRVfgbY7v/XrdCfcX8eB8b/bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E1xYwfT2C/hy/dOozl66oe7H+IEPI8rnoetCkErapEk=;
	b=MI5jNl3XJL4/sE52Mfv9LagzRyq7ch1GEFXG6TMbPEFNSjJ+iR82651bLlPYFw/EOJp8
	 WRYwme74wz0sPo7GJtjsDCSyoMwRb/6Pg7uwEOFRVGdMH2WEsl5mFbbDbUqJs4PJ2gkbO
	 R2hqAF4PzvDTaEpvksUgax4nXJFiZyavP2HrNq0nMA55KHndpDa/AkRHf6x5kRWKyrgbi
	 zjDwdC3Ifpng9B9U5FLs6phY6G4s6aTEE4VYVHT6EFsO2vtPX+5zfBDNIWZphCS31xThI
	 VFf6f+L4OlSFE/jj6zf1xT8PWP+GEmex/KemtysvcRvjeIk7bhlJgTKvMfSk1Vqhu9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TpYuqzLv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C02606B2C1;
	Wed,  4 Nov 2026 21:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TpYuqzLv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D63B1F00919;
	Wed,  4 Nov 2026 21:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827193;
	bh=E1xYwfT2C/hy/dOozl66oe7H+IEPI8rnoetCkErapEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TpYuqzLvWsxARJgZq94Qkcs4iaaE7w9C5bMcokqbrhFIFMLxVzIpjY4035uNRS3Vw
	 Odw7cvNutwnd9Ox1iUJljEx/RVZ5R9CW+Wkf/zNONotNfdpxRnNOnMmwAicOUF32dG
	 jyaewDuqRydLzh9A7V6qSMpD9DCBypgdAKEx00+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 7.3 249/547] wifi: mt76: mt7996: unlink TWT flow if the MCU rejects the agreement
Date: Wed,  4 Nov 2026 16:07:13 -0500
Message-ID: <20261104211045.248095698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

commit 022f5f8b7a0580da50fcbc34da853d03d4321fe2 upstream.

mt7996_mac_add_twt_setup() links a new flow into dev->twt_list before
asking the MCU to add the agreement, but exits without unlinking the flow
if the request fails. The flow-ID and table masks are only committed
after MCU success, so the still-linked flow is invisible to the
mask-gated teardown paths.

If the station retries the setup, the same slot is cleared and its
embedded list node reinitialized while it is still linked, corrupting
dev->twt_list. If the station disassociates instead, teardown skips the
flow and station storage can be freed while the node remains linked. A
later scheduling or debugfs twt_stats walk can then dereference the
freed flow, resulting in a use-after-free.

Unlink the flow when the MCU rejects the agreement. This restores the
list to its pre-request state while leaving the unchanged mask and
agreement accounting untouched.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260729173632.14387-3-enderaoelyther@gmail.com/
Assisted-by: Codex:gpt-5.6-sol
Assisted-by: Kimi:K3
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260825112620.97568-1-enderaoelyther@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -3285,8 +3285,10 @@ void mt7996_mac_add_twt_setup(struct iee
 	flow->tsf = le64_to_cpu(twt_agrt->twt);
 
 	if (mt7996_mcu_twt_agrt_update(dev, &msta->vif->deflink, flow,
-				       MCU_TWT_AGRT_ADD))
+				       MCU_TWT_AGRT_ADD)) {
+		list_del(&flow->list);
 		goto unlock;
+	}
 
 	setup_cmd = TWT_SETUP_CMD_ACCEPT;
 	dev->twt.table_mask |= BIT(table_id);


