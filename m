Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020207;
	b=MRIZy+lk+aQ/VKCmYYDUTnXQ72y87OkgDUuZs9f/9afx8mxh7h5d8vYj2xLgdab76vkP
	 e9YBSfb7dPcYsggkG3AppBsgMpCyTG8Jc1mk49auoWalZXYBP0L40juZ+U2xNEsqTMW12
	 JydwOganPM2gziF/k9du1kAUa+stXaYhhATHlimW3WdkZSMU9IMRxIghW+m18NAh8V5TH
	 /po4CqRjbibDjJUPVGoJCxCFntSmByDkCJ3grzt83omGmseCDLYGtzvbkFL7mOKVf9biL
	 0daTR+jCC1u5/SFEXbYu96yNOsb5bc6y3K0pkKBQQwiLS2+GfX+qtqCN243VqvhTG8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WBqzeCJkN7RkIRMaGDuUlCrr95oPOBsjoxuYvkhu5L0=;
	b=c0+5xJJ0Hnix0f+50DK80vTEzW0P3fNYQTZRuHvK2+27pyOhZ8f5GwK6XGNwmUq95v6L
	 LW5vLqFDFFTXn2rp3Ut5vVV8sYgFRFqT7cLo25x+5M/nxC5hZaSDOgUW1r38wH5fIu5Wc
	 cZaICZo+yuQbgQIqxqEVMov8gdKg2pNw+98HfxMu52di5Zd+T/M4gIN6IYwpoaYRHb63m
	 zunD46OB7Cqz9TouGHwbz2dCpPdw5kRpI+M8ADN9cuWTxMuihp+LpB2veywlWlttuzGK8
	 /w0xOfKJbmL/AEdSdTsiOxGUjhEDPMtIu70R4H/mPS3wAztjvkfSDrfofNj4yUXrz+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ihpkr0Ll;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA207606A32C;
	Wed, 18 Nov 2026 16:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ihpkr0Ll
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047BB1F000C5;
	Wed, 18 Nov 2026 16:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020207;
	bh=WBqzeCJkN7RkIRMaGDuUlCrr95oPOBsjoxuYvkhu5L0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ihpkr0LloAEPNKti+RXZgrMr2zjbr01EV68SLx7FqkU1wjrChwB7Jdoshzqn0NnG2
	 wAqchUoxaCwrdphNXwS18TTnmoKDEZGIru6Td89rLL15oyBP8x6zXswLDCgDVnmrfH
	 VhXmJdFCyjJwoDlSloLXK+Fgr82f3hlSLVOPYDuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1868/2651] Bluetooth: btmtksdio: Remove redundant firmware filename override
Date: Wed, 18 Nov 2026 15:51:48 +0100
Message-ID: <20261118150354.220882594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index a15ae6598c665..79a2adb7fc5ef 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1172,9 +1172,6 @@ static int btmtksdio_setup(struct hci_dev *hdev)
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



