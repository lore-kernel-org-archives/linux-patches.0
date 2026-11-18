Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026684;
	b=kQxV9C794Ttu1xjULEsaUIZyBK1WFBW1rw59aFo6T2scmFRU4q80AF/uSVUIfkzQ4tqW
	 HBtt0i89H5DUB1bqsZRmCuhxMHwC/m5IVvJcjoT49EFFlhFXSBdpKTwR9e7yXxyrumhMU
	 HnHqsZXLoqMSjWlASGs9535rw8Nhqen8G7yMZBLle29u9X14D7PJY7dcUQe6ocEtSDKu1
	 IzKJw6PHc3c/5cegRJOEmJ8oe13IXLt+2INFK4ZfCpI7oiM0apDKJKto/+hznjH48z3Gv
	 leaywTjBoF9FsPCoJ3HwnWQ2m8TbrKBabcLhzlu0b3OMT185VDU16MtUG4Hp+0tUZhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ibmD+1obPiWYXWaEYiK/NtWu5JIrnWBAT5fmSgZ4UFA=;
	b=wgiU2hCW3/hC81iyK4Mnx8ItTmeRcf+Nxm+m03VA76DBOvNOMlAkEw7qXAAFzDBgUGp3
	 dtQs/SE9jyP21n9e73sBcN+wmJ4qw6EKeOwIFmEUPFaVyVV0AvNO/ye5V6jic+WskJ+zK
	 UeUi6blOyVGtOKA1XVtlc1Sunv7WFxpdM1DdXi1ocj41I40RD6FULboGjiT6xzdYd3dyK
	 gBXX7eZ676AOO/ApEy4/18uGsga6uBa/gqPybTz7ZX2UUDTThIgaDs+tcwf8QaTVzx4EN
	 Nxp1qZ/3o65tiES/smptEH3si5WjMoDa2rBFngFmNtaljdTkXmCHbNd+qD+bzGqc5oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ROtdQoPc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A1E606A31C;
	Wed, 18 Nov 2026 18:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ROtdQoPc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D6E1F000C5;
	Wed, 18 Nov 2026 18:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026683;
	bh=ibmD+1obPiWYXWaEYiK/NtWu5JIrnWBAT5fmSgZ4UFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ROtdQoPcrr1asBTSODIerTxgyytABcMTt+QGGcpfoV7LZ6t01k1uZHA9WisL7zKfc
	 rIkCmYfth9ylNg5ke4dhDLgF0sgWnlX3SMg9b6WljPMC0+qIfr+YVS6stUHuASKtwN
	 BvLauCL8lgi8V9VVMDaJQ6Ix2sMud9efIZJOronE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1523/2151] Bluetooth: btmtksdio: Remove redundant firmware filename override
Date: Wed, 18 Nov 2026 15:54:18 +0100
Message-ID: <20261118150217.316300051@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit 8c947cd1c27d6493ed7e6630e168222454f53edb ]

btmtksdio_setup() derives the firmware filename with
btmtk_fw_get_filename() and then overwrites it with an snprintf() that
open-codes that helper's fallback format. Commit 7f935b21bee4 ("Bluetooth:
btmtk: apply the common btmtk_fw_get_filename") added the helper call
without removing the snprintf() it was meant to replace.

None of the device ids the helper special-cases can appear here: 0x6639,
0x7925 and the flavored 0x7961 belong to parts with no SDIO interface, and
btmtksdio_setup() passes a flavor of 0 accordingly. The helper always falls
through to the snprintf()'s own format, so both produce the same string and
removing it is a no-op.

Remove it anyway, since it silently defeats the helper for any device id
the helper special-cases.

Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: a2bb734c3687 ("Bluetooth: btmtksdio: Pass the hardware device id to mt79xx_setup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index a9ca2d37b8c5a..70f7fe7ba2930 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1155,9 +1155,6 @@ static int btmtksdio_setup(struct hci_dev *hdev)
 		btmtk_fw_get_filename(fwname, sizeof(fwname), dev_id,
 				      fw_version, 0);
 
-		snprintf(fwname, sizeof(fwname),
-			 "mediatek/BT_RAM_CODE_MT%04x_1_%x_hdr.bin",
-			 dev_id & 0xffff, (fw_version & 0xff) + 1);
 		err = mt79xx_setup(hdev, fwname);
 		if (err < 0)
 			return err;
-- 
2.53.0



