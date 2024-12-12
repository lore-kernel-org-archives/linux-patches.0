Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DD76F2FE;
	Thu, 12 Dec 2024 15:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018430; cv=none; b=tBtQrNIQCe3bI07FcBQEY7raIutNyJedxS4+UI6y8hgD6F6lhvDqq3HnMMG2QN6q475vyxuw4U/nrZzNJS0314/7sK/T4TiT3dNmrRWK4m6OXmUQiGRJe7wzVfvtxN2DndE65DM+UnPvNapSYdBaE4MO/Sq1+78SbqpzlClL5Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018430; c=relaxed/simple;
	bh=RtPunM/hCg0kz4zTI7RyTNLkIHdKy+nRubKmSBgk1c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noFC+uFdEghvD8rS6+NA3rQvZEalFL+y2z3iWp3E3aXWWrWEkakRwZASde/tBtyAhDwm3r8/FOiqrdp0Dz+7xuSqnAqP0Uwk5VbjsaJaUQhxth9+8ImgKOtXl8ffinuEExatMUHhdVN9lU+2bHi2PtoaaYnw/Gt/FVD0cU0OH/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mklXQ1CC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mklXQ1CC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74B3C4CED7;
	Thu, 12 Dec 2024 15:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018430;
	bh=RtPunM/hCg0kz4zTI7RyTNLkIHdKy+nRubKmSBgk1c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mklXQ1CC1goO4Gb1Nemhxg1AtAvf9HZVs260yo2a5QqVu864gy48MNH9b2+vsuJyN
	 J013r8IIxFeVybeTiKbKq0/5dICSPgjU7GAGg5qCc13QshhyoNTueULsUehsNh89v4
	 0tv8dHJt5avwkq9iRp3mymdd2un/KrHLE7oGioNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danil Pylaev <danstiv404@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 260/356] Bluetooth: Set quirks for ATS2851
Date: Thu, 12 Dec 2024 15:59:39 +0100
Message-ID: <20241212144254.869475575@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danil Pylaev <danstiv404@gmail.com>

[ Upstream commit 677a55ba11a82c2835550a82324cec5fcb2f9e2d ]

This adds quirks for broken ats2851 features.

Signed-off-by: Danil Pylaev <danstiv404@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 326ef250bab94..fe5e30662017d 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4490,6 +4490,8 @@ static int btusb_probe(struct usb_interface *intf,
 		set_bit(HCI_QUIRK_BROKEN_SET_RPA_TIMEOUT, &hdev->quirks);
 		set_bit(HCI_QUIRK_BROKEN_EXT_SCAN, &hdev->quirks);
 		set_bit(HCI_QUIRK_BROKEN_READ_ENC_KEY_SIZE, &hdev->quirks);
+		set_bit(HCI_QUIRK_BROKEN_EXT_CREATE_CONN, &hdev->quirks);
+		set_bit(HCI_QUIRK_BROKEN_WRITE_AUTH_PAYLOAD_TIMEOUT, &hdev->quirks);
 	}
 
 	if (!reset)
-- 
2.43.0



