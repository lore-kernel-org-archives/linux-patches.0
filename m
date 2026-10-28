Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212589;
	b=At01kZFYiICqdIQsVx+6p3V64P8LHIR8GUujcZmMWErvwCfTQoiWnP2qkiTEXgLMxyp7
	 nQx8bL3yacQJ9VR5UM+4/Fini7bPESWH7k5q6wwD9ZhonFsN+S5vWRK9tx77WXhtRKeLK
	 FOII5hA8fczuDmNTcNtTUh/KkqKJ42E8WZFug65qjaSpwQP1y9Uoa5kowCMuO7eZTEOkd
	 tla9QHEchkZ51N9dLRPW0kJsh24U5FFb9bcs4FjmWODiqxuJIjpNyxR4URC+x7NwY8l/r
	 srp3egXxweoZvp9bQehR8GdW5iPT6wLIAyKxN5de5vRjPJKI789fSuaumkgayswjKrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SnLtTJWFNdyDxHzfJK2xm/rmMv9aAmPv/H5ISbdPXHs=;
	b=RxQKBYh1w4oUkmeSkjgTAAD6Up7awahL7/aJA3bDd6QVTqPiT6JY/zwqIyel9OlkYqrM
	 nPqMAWZPKUQrqcAUbFTVrxNs/eMG9S5nbHf+7+BiinQT7vr+JvKt/LdVKGmzhi66ByX+g
	 5N/+hi4qYkFtuV3mfXDcfRHVW8pVJjLdIVrtW4XUsvesNCdEh85Fy/MAFiLQYDhQd5LaW
	 L3wN7J2hIsz5Zi8TujUMeI5FyVCDlvS/4NEXjmoXWRQxNmhuV7QB+AkRJz03YMMBTyUvR
	 8Qbk+ernbAB69pzFoM/BdBJbAt6OGc0G2+0WB5yEsBcO0kuCsjEFA7/Ngit0+D4MDsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kov/Mhco";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92492606A31A;
	Wed, 28 Oct 2026 18:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kov/Mhco
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB611F01825;
	Wed, 28 Oct 2026 18:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212589;
	bh=SnLtTJWFNdyDxHzfJK2xm/rmMv9aAmPv/H5ISbdPXHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kov/Mhco3Nh0ozIYCGfBDtQ6ML2dHvqiFJDPKYzcYLz5CZ3lkV9ZqOqqUkfcWg20b
	 4l6o9AFy25ZenhtvriU5szQQ4GWhh6Ylmp/Sbz5/PyQap4O+GyD7xVnFbg9VtvxK1H
	 siwLFFIYi4axlcZ6lxlhOhi/BmsNwSRbRdqDK7zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0163/1887] HID: hid-alps: use default remove for hid device
Date: Wed, 28 Oct 2026 17:37:39 +0100
Message-ID: <20261028170502.943189533@linuxfoundation.org>
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

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit 989f7cc94f1174269282a4a46bb735c7f11527de ]

hid_device_remove() will call hid_hw_stop() as default .remove function
if no function is specified.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: aa9dde93e05a ("HID: alps: unregister DualPoint Stick input device on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-alps.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/hid/hid-alps.c b/drivers/hid/hid-alps.c
index 72c21014de845..8aed5e17e5819 100644
--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -825,11 +825,6 @@ static int alps_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	return 0;
 }
 
-static void alps_remove(struct hid_device *hdev)
-{
-	hid_hw_stop(hdev);
-}
-
 static const struct hid_device_id alps_id[] = {
 	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_ANY,
 		USB_VENDOR_ID_ALPS_JP, HID_DEVICE_ID_ALPS_U1_DUAL) },
@@ -847,7 +842,6 @@ static struct hid_driver alps_driver = {
 	.name = "hid-alps",
 	.id_table		= alps_id,
 	.probe			= alps_probe,
-	.remove			= alps_remove,
 	.raw_event		= alps_raw_event,
 	.input_mapping		= alps_input_mapping,
 	.input_configured	= alps_input_configured,
-- 
2.53.0



