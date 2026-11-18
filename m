Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042984;
	b=2Q6GjNf5aSfe93MxbGZD1WI6/WQCrLN3NLfP/1RpJNVOeExtYWb011QUC/+XLP9p0Z23
	 Z03KzE89s4MA2kYaspcay3/stFzj9ywy/dA+saKDu5Lq77p/SedBb+Ak7bM3LvRiKl8KR
	 roaUA0J97TgA7ZE5XCrsFuAfYs0DucBW4qDuhCmn3IGTV1rgL529wAOKZU4l484IzGi6B
	 WE4PAHv5GHtTmKIW5xWWhFe2DPCkuSYoneIF5j8PJxUS4TR1k/Zc0kOiUTMsrUyJZdLht
	 ET1shgh4UcL8nkO3QILFPCL2JYW55mlyj+hKhE0z4MHFGFt6P18DpWeuontoNXu5jpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B7l1qGGnHudp7/QC5JKs3IWUJKdlonHgEdwVf5Uauec=;
	b=DmClHRrP/fHrxepbgQ5OXpRnjygP3wTvQF/dG3J8jiwEYH1+ORMeATKEVa4WZqYAZzyn
	 HcJL9ARpFyF3lY5fTAsq/3ei76P4ZErrrlC5ahRZZ9b4uciTuNmU4GmqyBOn9Zagte7fj
	 5l845NDsRpOA0keFgBPY6H/e/63AKs8GrosaShAwESSKoPwO7hVzURvGdIotBTl12VvQw
	 SwIcq/ZA4BQpxlt8Oawd0YBD9ymstCaKRtqRv7rW5KfrLFQBEg5iRE/EqdcUldkDtWM7x
	 79SF4qv9gCmipr0AvacoOcAqSdToBlTPvpJdOabiK9yBvFNVHiRlGFri8+qYFnWkPmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HMsDVlB0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDCC606A31C;
	Wed, 18 Nov 2026 23:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HMsDVlB0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D131F000C6;
	Wed, 18 Nov 2026 23:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042983;
	bh=B7l1qGGnHudp7/QC5JKs3IWUJKdlonHgEdwVf5Uauec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HMsDVlB0uGrYVmqgCINCBNAP00ExB/Rak6O0PS9AI6LSZoxN490qAemhzrvh9VBgY
	 StLhYpdfPtsCfHbOvH2hSFIZD563j+WKDa+lMz53SLuHxsjtuErRbKkg4CP0BNTW9V
	 NE4pcHZFHyfXCMsE6GCdMagHr5p8ArxsRtvcVUkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0048/2857] soundwire: dmi-quirks: Disable ghost Realtek on Asus Expertbook
Date: Wed, 18 Nov 2026 15:18:02 +0100
Message-ID: <20261118150203.053635210@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 90af3209742db61a7f9d7d054a16165818cfc6d8 ]

The Asus Expertbook B9406CAA also has a Realtek device in the ACPI that
doesn't exist in the physical hardware. This confuses the machine driver
into attempting to create DAI links for the device. Add a quirk to
remove this device.

Closes: https://github.com/thesofproject/linux/issues/5828
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260630081132.3294488-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 32a46a2d90f7c..2a98fc8c104d6 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -178,6 +178,13 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		.driver_data = (void *)hp_omen_16,
 	},
 	/* PTL devices */
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+			DMI_MATCH(DMI_BOARD_NAME, "B9406CAA"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
-- 
2.53.0



