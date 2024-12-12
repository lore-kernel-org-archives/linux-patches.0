Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDF42AF0E;
	Thu, 12 Dec 2024 15:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016975; cv=none; b=QTYgvn21Eimz/H50LFYbIeUad1mzvnH0NPfpVEaExSuy2AQKa7H7t/0oOhTUo4nAU/g4JHQkwe7Ei/a+RZPbLSIaZrBupM82aX1rIhzJUwmlVoSpeLEa01NJVw0vr4FdUXy7bMIU2M9sRjg3hYCbdDdNfXD9r5RGlenaXtNySvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016975; c=relaxed/simple;
	bh=/GBSPLpD7o0CDUU2jGkrXYoDE9DY35MEzkUMzIjRzlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRxCwCsPqAks76Nbww6neOfHlDRODKmzb0e8SYuKaCw3RCNFMYjtPnKNY8NqTjCDbstnfkZEarDLxJunH2eh5+bwaQCxu47ShI55TLk0cPqegGvRdsHETCavCrGrRyy4fHnBLiKiYXOjxaghEl/rygI7bqpd1/TariFVZwZsbvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qW1INakK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qW1INakK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF5FC4CECE;
	Thu, 12 Dec 2024 15:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016975;
	bh=/GBSPLpD7o0CDUU2jGkrXYoDE9DY35MEzkUMzIjRzlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qW1INakKCTQnMbLZguxa6AOdWkMYTsMwR/qFuHzsWgYnoa4LrxiPibp4jUkSkeAut
	 ROy57rx6cyeinCCJlKjVFFwG/W+jpn+gqk5pfe/B3SiG6kn6ZQyHIKfO8W4LKBskNJ
	 J85oXYQozrWZfAJmn1OeOJfcLUuK2JNn+4TIoiTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danil Pylaev <danstiv404@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 346/466] Bluetooth: Set quirks for ATS2851
Date: Thu, 12 Dec 2024 15:58:35 +0100
Message-ID: <20241212144320.458063694@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b44c990bab422..2a8fe85371804 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3911,6 +3911,8 @@ static int btusb_probe(struct usb_interface *intf,
 		set_bit(HCI_QUIRK_BROKEN_SET_RPA_TIMEOUT, &hdev->quirks);
 		set_bit(HCI_QUIRK_BROKEN_EXT_SCAN, &hdev->quirks);
 		set_bit(HCI_QUIRK_BROKEN_READ_ENC_KEY_SIZE, &hdev->quirks);
+		set_bit(HCI_QUIRK_BROKEN_EXT_CREATE_CONN, &hdev->quirks);
+		set_bit(HCI_QUIRK_BROKEN_WRITE_AUTH_PAYLOAD_TIMEOUT, &hdev->quirks);
 	}
 
 	if (!reset)
-- 
2.43.0



