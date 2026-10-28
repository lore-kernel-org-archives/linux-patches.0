Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208568;
	b=CiBUp7APhR/+IRGZYnriC9XhLMYeQZNktPce1PLNVfwjViy4ojOEpq21QuTZrzFcMFYr
	 4HIRTzMJwMlceRdXmTbufPE/K1EafwMSX7M+xm5Gw6gMQWVkPFL0nNn4PwVnv8VgJsnGA
	 lj1l1f6UrpTdQHu6Rl1CK7tLUJrxGslGj+zEgiOUcJqOMWYmm3y7H31SdEbZmbsDhVq9L
	 L4usNj8HG7FAo2lAY5D0dwD0QJGeGsSyO7PdQSJY0Ozd41bVmo2Nc9Kc8AfxY/81yNPdy
	 feynBZiOMe3rMRVanXriR9Jcapwi3oroRpWwlPK4aKkefWkWs4EHRfGk1klfiOhIgDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l4SAo1du46UgtT4kjlmm8jlcaMBzoC3I8DOLX75mxvE=;
	b=fKEpw7mIGRHIHk4moRitx/I6Gnn6A+OzWAY2yp3wja1BSDFqX++xtYp7uJCsYZaHnDPl
	 2Y+dPeLMk8e9L53L/Sa3sfoklbbuuuaW/3PXCWejwGLl2MaX03IjzlR2mRp8Irl0MhH8B
	 F0QfSJgGOGHW5coypkdt9Apxxyk0Y9INwBt+X0GhPBn6lUij4V/wuOwHiXXpEq0gbXNMi
	 SfD/FnVg0mi8ThMtzQAdT20Tg5y6pV4rm1Ua6S+LrJo4iULDiRWjmaB+XEbonPyvOq8WS
	 kUirUi8oDDyABZljVm63CiWu7yYEs0QzPqN6gs0wQO2GWNU1y91iZj1ITPnxPyf1X8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W8EODbLW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2255606A322;
	Wed, 28 Oct 2026 17:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W8EODbLW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D211F01825;
	Wed, 28 Oct 2026 17:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208567;
	bh=l4SAo1du46UgtT4kjlmm8jlcaMBzoC3I8DOLX75mxvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W8EODbLWnSPrluxPi+E0jrHYPnt6dzQp5xfWc89qcLyq/S+rXMJF9Cg1AJSZrumQa
	 O+hoijuvXgjiGuf2MEodYDUJ4aoTMcObIkkNZ9AjKlpiH072k78FsCZPOBhg8L68CH
	 yN42tjUdwLFHgyPYWdAucX214s97pdTmYKxSlh54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Teja Aluvala <aluvala.sai.teja@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/516] Bluetooth: btintel: validate DDC record lengths
Date: Wed, 28 Oct 2026 17:55:17 +0100
Message-ID: <20261028170007.415031485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
index 8312c55abcc24..b65339f8c28b2 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -284,8 +284,16 @@ int btintel_load_ddc_config(struct hci_dev *hdev, const char *ddc_name)
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



