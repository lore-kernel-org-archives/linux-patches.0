Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057281;
	b=JDL21KcldbJ8Q+7+011LYWlwOZvQZt6OcaC5pQRlFvycpfXenXs30sbFEpNEqsQeEOWQ
	 9eus+lYJA2/H8DPJHh9kVL3OOfvNUt+T9ZGkUB1GrKNd7Z88FxAopfViqR8VJbB0jXG5O
	 9m6tGS99RSx3SsYQv2gI2NE4TwwRQGPK6BR6MjeVjE5a8q1LkQ63EljShpgnbxP1NFbt5
	 ZlF7OS8KWDuflpjmhb7ocGBW3rfWMfAT+8HnnR4EX9WCZgS40OLQGfK8EOWAmlk3lbmsi
	 S6ivrWmlbpta/yRq7HgZmcBVVC4Ps4LjoXD4QCHSwIN9zsydOByCiIdNUkWCmeqvw4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iDjsUFu2mjPHN7nMUMaJaGUJASMK8vQaoT5T5MvbYyE=;
	b=JEnvGo+rsdWUnb/4wOhSi1n7axSPBCfpLGmWdK1dbrpelrIlCjK+F7u1GfLcnLYw00s3
	 XRe7Wut5mtBtkDHNiWzIvaAZC1tMLDgaPxjzvk43B7qYV0NhmXs/7b22OlB75Ia5mNTNB
	 m9GUF1nNUYOmzxR7sNc7qdnOal0vcxYuQToy9s3DDWGlU65pEQg6ons691d3gXCJRPDub
	 L3IpBSvvWy717D07o5KfN6WJhhGheqmoRJtNobpMZXkn/a/1MRw9CcQ15YaXdiqISkmAs
	 jcd97k6c1rQev3+klUPjWrDT++4EjvnySslDkcFpfOB0zzbCBRUTjqHeJOCaAerM4qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WXr6D5j+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CB560A383B;
	Thu, 19 Nov 2026 03:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WXr6D5j+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA5D1F000CD;
	Thu, 19 Nov 2026 03:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057281;
	bh=iDjsUFu2mjPHN7nMUMaJaGUJASMK8vQaoT5T5MvbYyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WXr6D5j+rfiR+hhouKHeNBTG4tEVTsNKjl+q1Z6oArhYD/pxlZP1opVyVsZZBySei
	 02v6UDts96PfyYyoU+7AdRG9mx/T+ucq9HwPS8/yXC0RR/HSPrHvD4cHyo4fyy3Wn3
	 BsEACplUN4VsQHfZB7J1TdkQDe4bisP+AJLYSZvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0075/1848] media: cec: tegra_cec: dont break off msg on NACK
Date: Wed, 18 Nov 2026 15:35:13 +0100
Message-ID: <20261118145914.278781069@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit be627f257ce283c95fd2988080dc0db3a20d0d2a ]

The Tegra CEC hardware has a bug where, if the first attempt
to transmit a message is NACKed so the transmit is aborted,
then the second attempt can contain corrupt data.

Ensure that the full message is always transmitted to avoid hitting
this bug.

I suspect some internal state is not reset in the case of aborting
a message due to a NACK.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/platform/tegra/tegra_cec.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/cec/platform/tegra/tegra_cec.c b/drivers/media/cec/platform/tegra/tegra_cec.c
index 43fe54f792b65..c30df776bf8a5 100644
--- a/drivers/media/cec/platform/tegra/tegra_cec.c
+++ b/drivers/media/cec/platform/tegra/tegra_cec.c
@@ -243,7 +243,18 @@ static int tegra_cec_adap_enable(struct cec_adapter *adap, bool enable)
 		  TEGRA_CEC_INT_MASK_RX_REGISTER_FULL |
 		  TEGRA_CEC_INT_MASK_RX_START_BIT_DETECTED);
 
-	cec_write(cec, TEGRA_CEC_HW_CONTROL, TEGRA_CEC_HWCTRL_TX_RX_MODE);
+	/*
+	 * TX_NAK_MODE ensures that the whole message is transmitted even
+	 * if each byte is NACKed. Without this flag the retransmit of the
+	 * messages after a NACK can be corrupt. This is a bug in the hardware.
+	 *
+	 * While less efficient, in practice you rarely transmit messages
+	 * that can be NACKed, with the exception of POLL messages which
+	 * are just one byte anyway.
+	 */
+	cec_write(cec, TEGRA_CEC_HW_CONTROL,
+		  TEGRA_CEC_HWCTRL_TX_RX_MODE |
+		  TEGRA_CEC_HWCTRL_TX_NAK_MODE);
 	return 0;
 }
 
-- 
2.53.0



