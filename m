Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049860;
	b=4IPeh/00C9+by+re0l5CMFioQirfAHmIHgvyEiPsyg8q+PQgV0EqnJrE0FH/XcrKf4VZ
	 Ps56vzQQUMDNxveDHPeLscwZpH6hMYrukJYhIfXhAdLmemA17QLatztq7v9OR0mwMYoPT
	 8jQ9n01sG7BcfgJcj35O7WVQ2PNZcUpTAvJfYDn92mbTqxlaFNBMZ+/PVoUXtLeEIFNFm
	 ZvOpNGhQ+DfV45htMHU0yO7YLHlsY+MkAT4+b3bXOMddPjhX/u+CDSQ84QnPmghzqGWre
	 cHrmwZKyV/uCqnBaA+fxnRo124LHL8+GQd5irE1SS8IbpsqZ+5GMclAZtTaVtkW8Xnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RqhYzs1w222FbFDkRyiuSKR19PvljNMfk4rgQOaROKw=;
	b=AxOy1IbtUqxgE98ebEapmXaUu1EkoDtkYnZmmV9RSrqw8mgqlVhCcjuVjyDVSEOUYZE9
	 uNuEnbMwWDL1/t5+DQQXVNt+tiiwwVEgqYOVqfAEyWGwLK+OemSkxbQOtPTI4l1IrjeWK
	 ksr6QvnZsbzZIXu5pT57+SiVPqCzV2Q6+usFSQym4M/pA8FO9QB3joVJqC/gSh2MWqAjV
	 0zgR40AiribY0JOrgCRNVsmJDgcyUaQI4E+o0nF8A3vk+uDvYMXkN0EwxGK29P5abI/aU
	 hwuJUSV40mtE7Um4rD/mOPyrF3RuGAJyxxwzLiUdZa9U33HjVODzlCMTopGwkqTYKbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DMkj1Ivz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FF6606A335;
	Thu, 19 Nov 2026 00:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DMkj1Ivz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877AB1F000C4;
	Thu, 19 Nov 2026 00:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049860;
	bh=RqhYzs1w222FbFDkRyiuSKR19PvljNMfk4rgQOaROKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DMkj1IvzLh5f8IuVmfCa5de/sUnbUI4rcirLgm11aUfN+y57nMmTOPWZ0RGtF4d4V
	 t3a56F4RESVA6W0gp4h89cG0FM0VHvixAiXeWzugIrpqK2YBb3x2xOt2Qi8q1wV1vY
	 EtWDZrzrLEIZWmkqSXDMgPU50sW3uRpSLcs3ovWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2503/2857] Bluetooth: btintel: propagate version TLV parsing errors
Date: Wed, 18 Nov 2026 15:58:57 +0100
Message-ID: <20261118150331.678838950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

[ Upstream commit 3a74624b5deae7f5e2b98e638687fbf9594a9781 ]

btintel_read_version_tlv() ignores the parser return value, so setup
continues with partially initialized version data after a malformed TLV
causes parsing to stop.

Return the parser error to the caller so an invalid response fails setup
instead of being treated as successful. Keep this behavioral change
separate from the bounds checks so it can be reverted independently if
an existing controller sends malformed data.

Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Reviewed-by: Ali Ahmet Memis <ali@iusegentoo.com>
Tested-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: cf87709d7ff8 ("Bluetooth: btintel: Zero version data before parsing TLVs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index efc4788b3d30a..7501a946aed7c 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -626,6 +626,7 @@ static int btintel_read_version_tlv(struct hci_dev *hdev,
 {
 	struct sk_buff *skb;
 	const u8 param[1] = { 0xFF };
+	int err;
 
 	if (!version)
 		return -EINVAL;
@@ -644,10 +645,10 @@ static int btintel_read_version_tlv(struct hci_dev *hdev,
 		return -EIO;
 	}
 
-	btintel_parse_version_tlv(hdev, version, skb);
+	err = btintel_parse_version_tlv(hdev, version, skb);
 
 	kfree_skb(skb);
-	return 0;
+	return err;
 }
 
 /* ------- REGMAP IBT SUPPORT ------- */
-- 
2.53.0



