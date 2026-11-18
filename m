Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043234;
	b=N9aMg/SqH8NuwFsdds7HxMdXD828S7G17ZEam9qGuy9cdWg4AH6je52Wp33POVD1KCHi
	 +dCnkjmVyOOuHr2MWfQ/HINsZEulkE0PMTgk1StM2lpw8q5wR9MtGKJX3qyFs1AM5uvPs
	 +3vAyrcqJYVdcX30ey73wvQ01q38vy6HGmaNuYkrWf56Tu0+Q6K/zOw6db3gK9+qT7JP9
	 pBTGIMUZ9H0ScxhGZSt7swPSIluyUstbRqZmIB6gBohUiyLvxsovvNxLre+1UWlQcyeL+
	 nvTxJ+e19JnkIEEYPqgu2dTSs7wc7XDeCrcVKeiSoRmW1WNOrd4a3IghwVWDCrsiDAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e1OpcAqtvK9xU84pauz0ueXsV+xrykbPmDerOA1oq4w=;
	b=sCKvs2N/jYKU5CVVYYp8MCtOdw+BmqdzO+ilZBRIdHHaJBikKSCVdTADRnzZnYJeKQ5w
	 NjYZaxb/19ablitPftLPXEE2Z3njYbb33DrQWeccN5jPzO0xdRvgJ7lKaHsf5jwSyv6Mf
	 2q/osIGKOQjHUbAfrWhw0aPa4MN4HRrV5noGkuqKJV8JmhmR/qEffHlWvGo2p6nF42H/Q
	 SLN0DuTtwop/vL92W4W20dh//jMLdqXagwrneAVFcL50/AqmX7YfCmk+2+dnyh+XG+glp
	 +pugK6qShBCpbf1KfqdTSAfdtFw5faHDGPm+d/oRTPIi1bLLznS0R24Gdkskv3fCVyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gq+0HhxZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEF1606A320;
	Wed, 18 Nov 2026 23:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gq+0HhxZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A001F000C4;
	Wed, 18 Nov 2026 23:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043234;
	bh=e1OpcAqtvK9xU84pauz0ueXsV+xrykbPmDerOA1oq4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gq+0HhxZEx2ErCUi4tJbx7cuHd3dXA4xxzUFLElkYxuv97OUZC9Ok39fmJtsfFd03
	 Vo2HrLcIxi9SANo3akreJ+eqgIrHH+XD1QOmWvJkNSxxzbHjlCKSf5cCboaWgwjL/K
	 Tdha9shvliUHNqbdoHEepsKyjnJOM9vNz5Mk8liw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0137/2857] power: reset: piix4-poweroff: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:19:31 +0100
Message-ID: <20261118150206.285327945@linuxfoundation.org>
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



