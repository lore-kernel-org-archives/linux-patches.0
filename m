Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212652;
	b=QtuEf5Du4b7ElNEeyrjSjPDdIuQ/vvbC64twBMuacwfK4mRXbux3SQSZ3pDQ/m60iJHC
	 wef8K1tI7oO6Sq/ltEpfeQoA38Bs7+BXNxNrfd0hGbu7m27qnJQKsKsfpRvH7eArOsyNo
	 igv5//djFOajPnTQcujTU7niaX7YPXrJufbnWoQ48bJ8D0qj4OMHa0Jyo5nbBYXbhvcOY
	 5/MN82LhKrEzGCk8C3izDoESBelYBNFYi86T+VvF+h4oeYM340Ay2AFPoR7CCI5B2E7E7
	 i4IXxffHv9Nl8Tjy0CuvfQQ4eDlPCbEMXPToHrUgB/NtIAJHvCuPdpzvHhfkLU2WzuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nlt/SSZoqCAbVlQEnT1WqZ+A2NrMRfEgU4/DOp8sa24=;
	b=0+3NuJqVwWK/PWJZhv8x4DK4FSqr/gAL646qDwDe8TyeVhRysJUp0aLYWpYUiUaS38df
	 XojbcBW5UKHEzkpbo0HXca2oQpxJrccLWKzd+WaXPYc9ko3UxNSIBEoPTfQ/vfrZ8Gud+
	 hcrH3TYRTk6XQNHX/7kqvhfKwobbpZwU3sceuxI2V0Dv8OrkedPqZ79axO2dq5I67jh4E
	 leR2PbsMyd75w0InF/7DVbDuEy1soPVhiCFaVsg3W2viBBi/o8ru1l3axE42MoJZtyxPF
	 UEo1YAXCmXCqcsxj59j1chMt1VplImF4fyRR9pO+RkS26bA7QvbtW921hrrS+mhhYhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sRSC2rGT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F74606A31A;
	Wed, 28 Oct 2026 18:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sRSC2rGT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9748D1F01825;
	Wed, 28 Oct 2026 18:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212652;
	bh=Nlt/SSZoqCAbVlQEnT1WqZ+A2NrMRfEgU4/DOp8sa24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sRSC2rGTNj3dZqtVL067HL74sFE2+27zswmVFb2dgNz6uV9fnpVoLHR7p5sFJv7Mu
	 uWSgSwAu1ne5wN8blhv3GwEpsMOf4Z9R8rQITcEBcCu2fpdjx+QQDhESDxWHEuaEfK
	 wt3J2ppSj6FMbVdSuD5kUyasWPNoTaJQq24XUoOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Teja Aluvala <aluvala.sai.teja@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0229/1887] Bluetooth: btintel: validate DDC record lengths
Date: Wed, 28 Oct 2026 17:38:45 +0100
Message-ID: <20261028170504.444852017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Sai Teja Aluvala <aluvala.sai.teja@intel.com>

[ Upstream commit c9c15d4d8956df8c564f7c210e4dc5b9b820d97a ]

Parse DDC record lengths in unsigned storage so 0xFF does not wrap.
Reject records smaller than the mandatory three-byte header, records
exceeding U8_MAX, and records exceeding remaining firmware bytes before
issuing Intel_Write_DDC.

This issue was reported by Claude Mythos.

Fixes: 145f2368c5fd ("Bluetooth: btintel: Add Device Configuration support")
Signed-off-by: Sai Teja Aluvala <aluvala.sai.teja@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 1cba08e9403a4..91162384835d9 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -363,8 +363,16 @@ int btintel_load_ddc_config(struct hci_dev *hdev, const char *ddc_name)
 	/* DDC file contains one or more DDC structure which has
 	 * Length (1 byte), DDC ID (2 bytes), and DDC value (Length - 2).
 	 */
-	while (fw->size > fw_ptr - fw->data) {
-		u8 cmd_plen = fw_ptr[0] + sizeof(u8);
+	while (fw->size > (size_t)(fw_ptr - fw->data)) {
+		size_t remaining = fw->size - (fw_ptr - fw->data);
+		unsigned int cmd_plen = fw_ptr[0] + 1U;
+
+		if (cmd_plen < 3 || cmd_plen > U8_MAX || cmd_plen > remaining) {
+			bt_dev_err(hdev, "Malformed DDC record (plen=%u, remaining=%zu)",
+				   cmd_plen, remaining);
+			release_firmware(fw);
+			return -EINVAL;
+		}
 
 		skb = __hci_cmd_sync(hdev, 0xfc8b, cmd_plen, fw_ptr,
 				     HCI_INIT_TIMEOUT);
-- 
2.53.0



