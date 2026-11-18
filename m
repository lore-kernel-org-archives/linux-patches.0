Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039064;
	b=t40HvrtDgG3FzmtBWl2lZUSkwDjo4GSmwfCLOy84a1gP3sbH2hq646mcPQXyDZ30T1A4
	 L2kGQ0VP/0Gj6ZpwwTXbj3RQ7VUeKLAiDPRjD8CY2bv3pHcwpn6oGaOmcEImmAHkafAeg
	 oin4SDRfsy6GIT0bYI5N6oRxUTXNP8uRJIa5sEGCrFqMQek79m8fKsXP2GLEeghDNsUq0
	 JH5hwHN/fMXdA+cH7s4iQYRO1lZ0LsQTPpBGUzj5YIimhmdUEOM4unCuIaHIRsvedqpiX
	 q5YA4hd+hEB/0Vj29tFS1w3CIN7kppl1xLRvflg5ICSib1Blig0gEqhiguKIolW185Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DW6GqwvSFQQqSGe3biXoiYBmOqtD9M4OuWG42Iv9gKY=;
	b=alXgYVc22A5g6GGDcAklvJ9fJetaXz72ul+Exz/3lRfMe3cIgwm983egiGbl7WzDpyMr
	 GjP/eAOWB/5yN0YKSna5DRvbF/czL4GkZ7KqJgrPiABSHMelfwnVyTj8muC70yXjCObT4
	 weKFB/jTJUAxEzfWdmMrhtEVB8nwKvvxM6XuCgP4fTib1SjbKpmmWWy10FOgsyO8hGoWx
	 C4zzITVhvcrYy0XJqimOFxKjaHiohdsVkcoomrBaVfMLEtLu7UaTOiwPpseJj4tUfOX6a
	 eBJ6t2URmHY4tepSAEUzIyxmFfa7uACT8Xp8DfyebIi2LyZ/r6/C9NYGJUYF5c65lbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HIvSTHuq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EE4606A325;
	Wed, 18 Nov 2026 21:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HIvSTHuq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E4C1F000C4;
	Wed, 18 Nov 2026 21:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039064;
	bh=DW6GqwvSFQQqSGe3biXoiYBmOqtD9M4OuWG42Iv9gKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HIvSTHuqbxhCHO9VWpiezWcrWrc0txOSnWrxukX1gPzNqOePuFJBy9cu+e4Jh5AsV
	 aLpfNfKhg3v7K6/gNdrmRg4MrY4Kvtne2bfMhN315TQ6FMiAtIMILV5IGZGxxtghd7
	 bvAVJDwJ6qBCPO+98c7Yp+QzsqQif/5NcYTHggio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Qin <hao.qin@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1924/3318] Bluetooth: btmtk: Remove resetting mt7921 before downloading the fw
Date: Wed, 18 Nov 2026 15:42:26 +0100
Message-ID: <20261118150419.734249839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Qin <hao.qin@mediatek.com>

[ Upstream commit a7208610761ae9b3bc109ddc493eb7c332fca5b2 ]

Remove resetting mt7921 before downloading the fw, as it may cause
command timeout when performing the reset.

Signed-off-by: Hao Qin <hao.qin@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 52a7f727d2dd5..7f3dfd1cd80d5 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -1001,7 +1001,6 @@ int btmtk_usb_setup(struct hci_dev *hdev)
 		fwname = FIRMWARE_MT7668;
 		break;
 	case 0x7922:
-	case 0x7961:
 	case 0x7925:
 		/* Reset the device to ensure it's in the initial state before
 		 * downloading the firmware to ensure.
@@ -1009,7 +1008,8 @@ int btmtk_usb_setup(struct hci_dev *hdev)
 
 		if (!test_bit(BTMTK_FIRMWARE_LOADED, &btmtk_data->flags))
 			btmtk_usb_subsys_reset(hdev, dev_id);
-
+		fallthrough;
+	case 0x7961:
 		btmtk_fw_get_filename(fw_bin_name, sizeof(fw_bin_name), dev_id,
 				      fw_version, fw_flavor);
 
-- 
2.53.0



