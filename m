Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA74C481C6;
	Mon,  1 Apr 2024 15:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986788; cv=none; b=HaemhamZV9cH75gHvl1TP24prMe3pKpPyM38Frx52Vc/alx9OUOWHeHWD51Z7pqVcHFkR8kgTIkPV7R+DkxC3JQVnybPnIQJJtCYKXtX5UOlf6618XI9IwZI51P05EsZUdctWFxSNC5tJZT/HJZNyXJuZUSxj4i0if0TdCZ7/Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986788; c=relaxed/simple;
	bh=NVZKhMhBpLsaJiOx2t08oCgzk0/pmxaOTDFs/4v036A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pz7e6vWH2Bm0Gn+W0kXUNY4hkLXbN8c+9DIy9z6+DsweWUjzdfCZAzrCxG2SQQ9zfOq1rqPIvy/WGMPLjePH7CWB0emI++j/jiA3AW78gSNXuzig5UYADsV+z9mXB8pRGG4skJ3hfGBlndNp3cVXSoSfidADIsDYEmMQWRl/AW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYHkXCXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYHkXCXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AB6C433C7;
	Mon,  1 Apr 2024 15:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986788;
	bh=NVZKhMhBpLsaJiOx2t08oCgzk0/pmxaOTDFs/4v036A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYHkXCXA79wRhj87sJsF7QfXltBjwMmLnw7rcXLmeC8A0M6gCn1bmhlnkpv/iPCJT
	 0PJSTch1FWIhbh77qWeuySo+At1uS6KXh6LW8bvtQbUbxBfzeX4EEtibZlMkBx3XE5
	 +t/+ZKhqYEsrVsqkSOxljdi1Fe5UggMB5LaPlC4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Toru Katagiri <Toru.Katagiri@tdk.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 085/399] USB: serial: cp210x: add pid/vid for TDK NC0110013M and MM0110113M
Date: Mon,  1 Apr 2024 17:40:51 +0200
Message-ID: <20240401152551.716430271@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 2169b6549a260..21fd26609252b 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -56,6 +56,8 @@ static const struct usb_device_id id_table[] = {
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



