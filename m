Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CBF2BB1B;
	Fri, 15 Nov 2024 06:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653644; cv=none; b=AsnLJpj9p6oKpb+y4ZN0gl900pqDv8wY5ZrthcK8iqO2VdxaspPGx73zOJjcxmylULnVwOVihI84yJihOyGedQzdT9gp41qbV31IVeW5H/RH7wwZ9R5hHYpCVyiSxqrpuOoptpZPLKQOdqpRoD6RlsC2MlRT5PaMZTdPGEpjvbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653644; c=relaxed/simple;
	bh=XCEy3iPMQR00/PpQKkgEck62Y10R3gdd8sdJtepwGrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGv+e+6dCueb/u4o2qqRTAG3v24GO0BvpFEJlMMQMhNTpgmOJlk8aSomvRdHByMm+VpFGm9/GH+UfDjpNGnrF2rTPulctLRfJPl8htWjmzUs45t+oOGnFmbAdf+UcLAv7kuH0CKnj01O19P3OG7DPCqAlt2nV3PBZ6wnqbDkdG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2b9HpvBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2b9HpvBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE47BC4CECF;
	Fri, 15 Nov 2024 06:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653644;
	bh=XCEy3iPMQR00/PpQKkgEck62Y10R3gdd8sdJtepwGrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2b9HpvBVhQoua12F1nRdP4sxSGYgzOqSGkPr2MSgmV/6s4DJFX18pUiyi0VJpRgNS
	 XpBMLU/UbNugJnp7ivXRHF2nzZ2062jFN55UrQVlgIKB6eaXuR6kbih0L1H9jgx5QX
	 Ndp9gvgj5XEtdqza0aSR2SLzUwVC5rxUTFz25HSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Blum <stefan.blum@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 10/39] HID: multitouch: Add support for B2402FVA track point
Date: Fri, 15 Nov 2024 07:38:20 +0100
Message-ID: <20241115063722.982012066@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Blum <stefanblum2004@gmail.com>

[ Upstream commit 1a5cbb526ec4b885177d06a8bc04f38da7dbb1d9 ]

By default the track point does not work on the Asus Expertbook B2402FVA.

>From libinput record i got the ID of the track point device:
  evdev:
    # Name: ASUE1201:00 04F3:32AE
    # ID: bus 0x18 vendor 0x4f3 product 0x32ae version 0x100

I found that the track point is functional, when i set the
MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU class for the reported device.

Signed-off-by: Stefan Blum <stefan.blum@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index e7199ae2e3d91..7584e5a3aafeb 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2020,6 +2020,10 @@ static const struct hid_device_id mt_devices[] = {
 		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
 			USB_VENDOR_ID_ELAN, 0x3148) },
 
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_ELAN, 0x32ae) },
+
 	/* Elitegroup panel */
 	{ .driver_data = MT_CLS_SERIAL,
 		MT_USB_DEVICE(USB_VENDOR_ID_ELITEGROUP,
-- 
2.43.0



