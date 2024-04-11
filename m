Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24F513F452;
	Thu, 11 Apr 2024 10:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830563; cv=none; b=Ri/N8d8n5XCv2kE2e3J/s3Ixe2tjY8Ib4fb92NmzkOKr56KToqxQspJwRIkgtHW2iI5LZvRdRBdZC1Sd0FwQcucPKGNqTYG2y4Y/YGAjREwGSLobdzPBqMiEDYgGCh1ZgXC9NfZcVF1ZcCvz3xhClANT3B8beUmHFqMK0XfAoys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830563; c=relaxed/simple;
	bh=zD9vhlldqA1nCo7Ceb5Mr/ZY57Wl38P0IUgPOfJDofo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2ur+Ls7DL0yD6AvVMvunDg/GXo7Cf2htTVxr3jEI8H4tU3idEjwo1aTtgqFf3elJQJrjfeYvuFtBldDYcE0q/LfASgWVwpaqQbYG1gaCUyUV7qslNjsdWW+reFZutwqFfkVJCyXsZgbwk9YZsWWVZ5tTGS2HYCnopJlqReMF3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYRZ3guK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYRZ3guK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E306C433C7;
	Thu, 11 Apr 2024 10:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830563;
	bh=zD9vhlldqA1nCo7Ceb5Mr/ZY57Wl38P0IUgPOfJDofo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYRZ3guKvXOmQhVcZuMgPv55/DzDFbWeb8wYnwi9a+RIs8WsDtXiuTkWy6U6fNAv1
	 bMGOemaoeHn2DPb2qulMv71FyOXZ+gdN2TuAlY1xk01pu/Iz4vVph8mjH+sT9HmIv7
	 3J1tQ2eF+s+mXT+d5ZelF444gCSO9U8jlfl6k1AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Toru Katagiri <Toru.Katagiri@tdk.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/215] USB: serial: cp210x: add pid/vid for TDK NC0110013M and MM0110113M
Date: Thu, 11 Apr 2024 11:54:11 +0200
Message-ID: <20240411095426.159652220@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 88659a75f30f9..5353fa7e59696 100644
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



