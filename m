Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6107D145342;
	Thu, 11 Apr 2024 10:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829643; cv=none; b=DFUDcoiJeagodmGH63TZEPM58bxTMASsylTKY5ZH9BrrRhs5aJGIgR4amBGa0z7tpBG+rzF5zpBfh6gBN++mYR0VF8Ovg4TRl2g5RsZ7bCgEkwaPmxeif9MOu5P6KnqrzJKQGdRr8dnzZ4bubI6xRl9FAStV9nrR/3QV27Ycu4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829643; c=relaxed/simple;
	bh=oN2/EzY+jEM15YshG8m5bOxJHX5ToIvq5GV9VaS95ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hi2t32fwTztzWl12ZwM8+n1HArgx9cvQfbw0adue72Z8CbI7fcNPNTAwjkdvlFgHDtNsZ3691FmqNj2oCUD+u7oaV18zUZQMBE+5Plwyag0QvFod7rAWJYO7+FjANFru3WBbYO3J40B9wyLVG+IhhIZSEyltfEGzYNj7tXqe6a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLnvqZV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLnvqZV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF97FC433C7;
	Thu, 11 Apr 2024 10:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829643;
	bh=oN2/EzY+jEM15YshG8m5bOxJHX5ToIvq5GV9VaS95ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLnvqZV7gFKNeaZZrPj2uaNHo6Kcmq1YeMetjKuDFRLUHbXdj9/+pFWXUAoy8d/6P
	 2XsVknsnWqw88lEHgNPZPvgMZLVbOhmk43vMvnJ9ej+3nNTaYEXfBNmU9sD8flwIwM
	 lSmgJg8K2iFfmeR25sMZJ01KwQQE2OUH5n5EHNTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Toru Katagiri <Toru.Katagiri@tdk.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/175] USB: serial: cp210x: add pid/vid for TDK NC0110013M and MM0110113M
Date: Thu, 11 Apr 2024 11:54:22 +0200
Message-ID: <20240411095420.735453826@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toru Katagiri <Toru.Katagiri@tdk.com>

[ Upstream commit b1a8da9ff1395c4879b4bd41e55733d944f3d613 ]

TDK NC0110013M and MM0110113M have custom USB IDs for CP210x,
so we need to add them to the driver.

Signed-off-by: Toru Katagiri <Toru.Katagiri@tdk.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/cp210x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 4bebe0f3c201a..4686cf7c6b0a6 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -57,6 +57,8 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x0471, 0x066A) }, /* AKTAKOM ACE-1001 cable */
 	{ USB_DEVICE(0x0489, 0xE000) }, /* Pirelli Broadband S.p.A, DP-L10 SIP/GSM Mobile */
 	{ USB_DEVICE(0x0489, 0xE003) }, /* Pirelli Broadband S.p.A, DP-L10 SIP/GSM Mobile */
+	{ USB_DEVICE(0x04BF, 0x1301) }, /* TDK Corporation NC0110013M - Network Controller */
+	{ USB_DEVICE(0x04BF, 0x1303) }, /* TDK Corporation MM0110113M - i3 Micro Module */
 	{ USB_DEVICE(0x0745, 0x1000) }, /* CipherLab USB CCD Barcode Scanner 1000 */
 	{ USB_DEVICE(0x0846, 0x1100) }, /* NetGear Managed Switch M4100 series, M5300 series, M7100 series */
 	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
-- 
2.43.0



