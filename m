Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031886;
	b=LiYwnKzzZxyxyqTZjDskPqW/ROIIiIG0ZbvHD2qHY5wvD3rSqMq2ODTs7zhtIrMutAA7
	 U1CfLYR6PNtkv0muvz3ex+buVdSV9CubEmwiqIdw8V1HwV4H2v3y2S6EuyaGsVA6apEr2
	 H4VJuT8ocN8lqHirvx11yViSwHI7BnyhQQjlL3RHM1QN02vJti39Gno1+9FHzBH9APebg
	 geQsufaF2kQDimgCnlygwvpdAjN60IBAHhy33IWZyxSyTWkT1Np0rt+WexEQTxqge7LrM
	 7KzfT3tj06J7zKUk4FkC80liHpb40iGHAogTdJX5vccIg31wGIn98GnPi+MkrY7ensg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zLJ/1HwTlX9JMp4ncXnDBS6EG5NzZ6vFiCxZ194XbNU=;
	b=JGrvweOOrpL+MInx7fTJ8qQekQdKBSW75/vxUTKlhBGVf4yuPq25kDZQTGDITX1fJcL+
	 2jd+w4nHW+aWAY8aLmvY1Ud14b7efjnuOmH3Fxle79uIDu+y7QH4ffouLz5Tu43cwzmoA
	 JNX4AerK1Im8bVMXWTgTjA+tO6cVpjt+xOiUNoWrvvxeBAs4JJo4i7lzUEe3cQPTv3CSQ
	 nBaewiVdHKN4eQB25Cytph7/Xyu4NfGAB/y8H10Jgqp20LAcfKCwMFcGewL2uAL2oMFfC
	 Mu6iiBwXKYS3MwxA8PXfqFTo7imIZLaGvIe5iisOofsZFobjFGO57VLWhVYyqBnPt8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KXulkmJc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D63606A31C;
	Wed, 18 Nov 2026 19:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KXulkmJc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740001F000C5;
	Wed, 18 Nov 2026 19:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031886;
	bh=zLJ/1HwTlX9JMp4ncXnDBS6EG5NzZ6vFiCxZ194XbNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KXulkmJcLHTIGzItqv8uH88PWjMxLBsl9bVoXoyMmgRWi89LaaJsk88Zfm2fP8p3k
	 3Lbb0TbAZwJcSp5BOsKQpT0+UOHf/SMXmH0wZP+JTuvCnZzxVM7LQrNCvOoGjpgOkp
	 nP1Y7F3wKE3eDMRKOJbxCW2BjSQv38tTTT1r8gD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1216/1756] Bluetooth: btmtksdio: Remove redundant firmware filename override
Date: Wed, 18 Nov 2026 15:55:43 +0100
Message-ID: <20261118150058.207643705@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 575bac139715b..3e3e6970d48d1 100644
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



