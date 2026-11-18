Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051194;
	b=fyNikOaagk7V1PD5T+WscR4OS29zMt+6SHSaV2V0vpglF4q3WdUg35cAyPdAPSarRWfT
	 lpmyLgbY4ZPZJ9jsIJbto77lGz0L+0MGJ/OaFCWxKjX+pZWRrkI5SNJF6K6wB1+1OdHg1
	 vHtz3y1VKAmsqC+HOHZps1Y7ZdONscUKQeG735L3PbrqhCm44+V0rQcel3hKkDCaHoRcT
	 +E22W35vd5KoDno1AwXY8ceGqyRnPDzhGo/04Us5izryjymLbrr6mueyT7ckWM35w3o+B
	 26g5XkSZq8e5P7AvCQNSqbSvHv1aPylGDYw31AZmtw0b8eDyYualpDsU+MFyroMprSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4/dZf1QsK7DuL1Kk2XowbpKUGRm9p0l6MYeFxq6pTCE=;
	b=4Y/jd1uEwc/VlrIq51SfjmFRowcKbFWtqrIY9rZw0+2Vja17g5JThO78LzlsaO3aqmiq
	 zQ2qJoNNg41lMxCdwxxqNuj41iAT1OE7/vQg7WfNkfxC7uyByrHF89sonZSugFR9o+HZp
	 nw2Z1Aq9WcCpUHtCFWyS5zyyRnaRdubhp772R+UdCZClazjAgUuZ9K2YeMDcxYszGl7on
	 OLI5hjQgTqiu9KSASPbcV6NY/VkWfdwKhFPnSpEZwdOylToboZKo1ZhurCmw4czpuENni
	 9X3rWh5k1INIGSJeAeT/EbP0x5AfZ3WGdn2JYE2xrxteThvZ4SR45MxmywGb3S/oiSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="i0GtWlo/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3531606A325;
	Thu, 19 Nov 2026 01:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i0GtWlo/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB851F000C5;
	Thu, 19 Nov 2026 01:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051193;
	bh=4/dZf1QsK7DuL1Kk2XowbpKUGRm9p0l6MYeFxq6pTCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i0GtWlo/FpLlrP/ZAt0SdjRyBzC6JHSuN5W4L+HcY8R7cBbxoHr/OktKH7GNEtt2I
	 SMeqOWqXzjCv2PR8Z/Az8r5Fv8dc4ztfR4+dXiZ1AkvYdYAvv8YhOcxqfIh1TiW39J
	 90nNYsYPAjmBy0kaXhislKZ744Mi+XAnMZyb4M4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0121/2214] power: reset: piix4-poweroff: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:29:57 +0100
Message-ID: <20261118150014.943182729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit ffefc5d9a052f67bc87b57d1107fd7cc1fa1a3d4 ]

The driver has a match table for the pci bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704152336.51384-1-pengpeng@iscas.ac.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/piix4-poweroff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/reset/piix4-poweroff.c b/drivers/power/reset/piix4-poweroff.c
index 7f308292d7e38..19ab3822338ed 100644
--- a/drivers/power/reset/piix4-poweroff.c
+++ b/drivers/power/reset/piix4-poweroff.c
@@ -96,6 +96,7 @@ static const struct pci_device_id piix4_poweroff_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371AB_3) },
 	{ 0 },
 };
+MODULE_DEVICE_TABLE(pci, piix4_poweroff_ids);
 
 static struct pci_driver piix4_poweroff_driver = {
 	.name		= "piix4-poweroff",
-- 
2.53.0



