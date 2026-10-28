Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210860;
	b=KYOhWnby85/QdDw8KqaFDPwbwp9ZLgBpX9P2L6VS2x4ch9Rzh5vtvasTgt1/Ec0lupNU
	 Hk8IQ0o2TkehZ7LPPZtKQ1f1jws3BWoXziP9NfZ7V81/jGVGQRaxesxE2o3BsPt8KexNS
	 i7ZT9b7NlMCqPrucaXuqGCTZ4E2WJ3i8IjKudGoTAr2itRYBYDM0WgZcD0K0kjFVBFYmU
	 ZisTVZwsdhe9c1y0J0hwF7KHaeJkf58nsdYXlAMK09kHkLJEweH6QmWxCqKgTOOkTC99K
	 2yIj0HZcZNrONMC6haaKPqS1PxOIUbcOaSDdMn4f76UanHnAJ5/6m0RyXcsOATK1sEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2v51lUCaHo6JfdB5kqxTMiVDPUnfb6WUA5rcO9o6ckM=;
	b=VO9QNgjapAOv/ZSCnNwD8eRvN5u5UvK+uiNp86hI5L6GAjOY24ujfU6tgxDQaYvC72o4
	 fQ4tuDa+HRXTW0auzenlP4nnAc5DxuvDF2TPXUpXhHO/gVC/hnNX6RQj0u7/HrbeWbQLw
	 ZcxNiYwNc8wFZ3TmHfjfTqeQed58WMN3UJylECjxuBqdhwq8+imIDZGM2VmBlfNdj63t5
	 3cuJ7bMzr+Zjx/3Dbljn4TP45/l7X1Ek3O05BVDbvST0IFQC+5ELHfmASQ5fgf6Ii3ZnJ
	 JtdiqamR6+9YsAoj8IX44fI1dpU62hJTRjx2bvPPbKAJVl5Gr9dpgvH+TfFDNMFsijg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ewmkCLwk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C87D606A31E;
	Wed, 28 Oct 2026 18:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ewmkCLwk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC9D1F031E0;
	Wed, 28 Oct 2026 18:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210859;
	bh=2v51lUCaHo6JfdB5kqxTMiVDPUnfb6WUA5rcO9o6ckM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewmkCLwk/+4oY93VDRMFfh4atuop+BaIXrB6+Td+4Q4ohEH8JU6tY6ru1XgiAyNZ+
	 wPxFlryxgPx2KhAkMhT2bvUgYdVZFCNPj1ZqdewLqvWUPuI1o7io8pru3W8XGGNjSd
	 wTsXo5vNBYtN60AQaj7NVDojUckZIZgV0iw2DdHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Teja Aluvala <aluvala.sai.teja@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 172/571] Bluetooth: btintel: validate DDC record lengths
Date: Wed, 28 Oct 2026 17:55:19 +0100
Message-ID: <20261028170012.095407450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0635df202dfad..8f85cc300d8b7 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -358,8 +358,16 @@ int btintel_load_ddc_config(struct hci_dev *hdev, const char *ddc_name)
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



