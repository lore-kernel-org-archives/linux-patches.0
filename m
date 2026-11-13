Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585588;
	b=zASJOsvEAXwjOWac365UgeN/I6qoes5uAJbmX5HHBqdfpsrvigWQHMwjxEyHucAcM1Zw
	 TEugb9bxo+ghD2oWJRsGpomH7jmhm8utRYyIYeiswLZFsQN5gB0JycljD1hGGS0RhisDw
	 JdwbJ7/j/AIT1Qu4v6infhx2SVJdr+FXuHv0f7UMaX3yhmMrb2weLZnscqaZ/UJTouzyU
	 R9r1GYYNTyIoiF/KRSB/c1MMx8MqrybZtNuiUh51b32X6hyyS0zRqD9pVWpNTOS9AzHCy
	 lkP6ZrF5rcoq00vzh6L3eaQbszu5wTt5qOLBpJhcDOUQl81n4zGaED6lO7t5OU3oR8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q29CavvIQOfYRU6aBDuxt/iqrjlqYVrKT5m8byJdODI=;
	b=RN1IP/EcTgLOPfrD8MpHmgnSQhnUrAseAJrSDkrXhij0rgElQJ9J/wudG/7uUU2k0vvt
	 Pl52FX9foxBjisQOR9NeHUAlI02GxcwRfwMwYZISbERV/kTdecwCdDqyuVLyvXdsRuilB
	 +kKL9TD3MktrbnxgRYnCy5BZl0NbScIFogsdxNI0es5ZHTjQhwgnObd5DQ5ARxYDxVGM/
	 TpulBA/4uRLQeJYzla5dwjjSM+N8gcgkFq9lihRdN7XE/T/8gSXlFxoyPi9edX1O1wdTP
	 blR1vPR1opJ9O82loiSuLCcFLIF2uL3Z7y672xy91OzxzfyBGFeJYcwFYe3M5iE2T+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K7hYkH6G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E50606FFDF;
	Fri, 13 Nov 2026 15:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K7hYkH6G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932C41F000C4;
	Fri, 13 Nov 2026 15:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585587;
	bh=Q29CavvIQOfYRU6aBDuxt/iqrjlqYVrKT5m8byJdODI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K7hYkH6GutomdjOPOD6BYTe5gbs0cSiFAM+o9U6jHbwzn46u+7hPuWEq92r8uc4SU
	 JWl7YexaBYY64C/ygwJzEVvoaet7Guc8ipw13R3cm/fXi3EYLAZnEn7uh3ELxe4Ohz
	 +f2eH66mE1C45FuVK+GyKRSjKUxWH4RwTLohm0EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael McAllister <me@michaelmcallister.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 217/507] Bluetooth: qca: Fix the WCN3950 NVM baud rate offset
Date: Fri, 13 Nov 2026 10:48:41 -0500
Message-ID: <20261113153801.842724817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Michael McAllister <me@michaelmcallister.org>

[ Upstream commit 5b7d0386a4e75c85479da0fbd9fd66a3e9201375 ]

WCN3950 uses the HCI transport tag layout that stores the UART baud rate
at byte 1, like WCN3991. However, QCA_WCN3950 precedes QCA_WCN3991 in
qca_btsoc_type, so qca_tlv_check_data() writes the baud rate to byte 2
instead.

On a Motorola Moto G10 with WCN3950 and cmnv12.bin, configuring a 3 Mbps
UART therefore leaves the NVM baud rate at its default 3.2 Mbps and
overwrites the following byte. Firmware download completes, but the
subsequent HCI_RESET times out and Bluetooth initialization fails.

Include WCN3950 in the byte-1 case so the NVM baud rate matches the host
UART without altering the following transport parameter.

Fixes: d5712c511cb3 ("Bluetooth: qca: add WCN3950 support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Michael McAllister <me@michaelmcallister.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 22b08ab05b829..002307000d3cd 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -426,7 +426,8 @@ static int qca_tlv_check_data(struct hci_dev *hdev,
 				tlv_nvm->data[0] |= 0x80;
 
 				/* UART Baud Rate */
-				if (soc_type >= QCA_WCN3991)
+				if (soc_type == QCA_WCN3950 ||
+				    soc_type >= QCA_WCN3991)
 					tlv_nvm->data[1] = nvm_baud_rate;
 				else
 					tlv_nvm->data[2] = nvm_baud_rate;
-- 
2.53.0



