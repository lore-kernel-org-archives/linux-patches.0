Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590323;
	b=1hN8tIM/WdE7eFDnrZvTZ/k8/01YaobkoIwy3EHnhlhqSgnXrSprd54dBDz4o61+4dJW
	 SqK3X4GAf1FK5fe5clN11WmUMxdWhurTu37fth/mjawmxqYMwlMNQhJP3NUQSrZY6E0BM
	 Y8vtE6w3HAnrZaVBRBUwLzVmCsARDTyJZerdEWw7DnSDw4l2JAFygCFDf1cS2cAptBuAe
	 CxkI1zEe6bQcC2RB2WVOzDSIdiH+fE0EQuQ2g695AuFmY8WdPtf0BckHGdOfCxMaa2n9O
	 Ayt0guGE757QnjoXMbVlD4oRtaI492ackwz1j0nZPmKlP9E5Gz+45aQ36AP6LEc/qMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n17644WHpHa+0jZroZr1ql0SevdkPGZoSlVrPRivfyA=;
	b=UV8+lm8FcyaDBO2BwmrRjEVd9GzUmLEOFR8leM0lhEB9HSCdaKT2nxrVDxE4ssjT+nr/
	 O9M/1HbSxu3Qgm6R8XMoXTMD7z7Qcr6FI8L3phJWJPc+l3B4GHpPyVK6UKO7e9QZMqkSc
	 Gewy0pUTIYz5hfipEWeoy9i4BxYijNmbzY2pEr8XhlHrp6Lb8kt1QOIOnMCWqiFyEoQAD
	 UebMETO6BiNkBWV8KOkCI2EsWZwhyb67HVv64k9KSOwz+nUPMCOTstVyHsJnzRE5VGvj8
	 LEH4jS11YlvGgORweG8UtMiOnjX3O2K4CToMmo4FdV65+roho4Z1PI1BapcClYh9Iag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pOhpzhEP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE542606D483;
	Fri, 13 Nov 2026 17:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pOhpzhEP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C06D1F000C6;
	Fri, 13 Nov 2026 17:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590323;
	bh=n17644WHpHa+0jZroZr1ql0SevdkPGZoSlVrPRivfyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pOhpzhEP82AnA1iPGkEFR8oXsOLYlb77ou2D1wyJWQ80HhlE6DBV07er1sDNG9+Hp
	 FrbIVGi6z0Zmom+IPt720xzqfq0+2reJew/ynsy/utbgdNiH7ZsFcbIxC6TzCFYLpj
	 Mg5IVQx2P2ji/EnduiAkYiD4qPPTuuHGw0a1qn9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael McAllister <me@michaelmcallister.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 304/686] Bluetooth: qca: Fix the WCN3950 NVM baud rate offset
Date: Fri, 13 Nov 2026 10:47:17 -0500
Message-ID: <20261113153831.252466188@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index bdbb5801b2400..4215522e62a2c 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -443,7 +443,8 @@ static int qca_tlv_check_data(struct hci_dev *hdev,
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



