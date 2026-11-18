Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033986;
	b=l9ZihdvUBBnsMv5jp1vGdDCnBAYVvyTZKu97v/mvFRdhSdF1NbOni6kr3IfJlu5QnsVk
	 3dOe66UAkEqgCozTHehzi16iDTXXnJItpKN91e6v+7oEy4U2mmPg+/rS2z9MuzgqbhrH1
	 /MV0P1TJABvtMOHS/as73CCa4CehV8Qy1PNBQSq897UX8EuSppabdw7ZtJqtecJbhgpyU
	 IqpSg9BNr51fQ8ubfcXnLuTh1YnWE3/7se/tq72AFUs3CjoCp74eIOF3JNqo+pby6IX3J
	 8EV/gggWjfs9CRZrBVqsqDBbQH+7pbczHwgGZO+ucRwt/63sE/VlsqtDIRll85W6sSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SIvZceOzAqCzG2lelbqwdibmhTw2JinHlGv9bmUWQ8Q=;
	b=RuXcE0kg7hcC9/6++k8Cg1fT/wbSrIhTG14SEPYKJ3VvG6+vh3C6JnTJKEN51kt0N4oi
	 PzSO9M6hzdqucXR2resf38HAS/mwmxlc8f+FmQ4edPIWa39OYPlHe04zAC8JXr6ueZWGV
	 2uqAprwsJfQqi8qOEeOSziibEBn4FrcXo0j/b94UjKGtlwDdgwS8JOjqt0wcUZ/pGfUVj
	 MNH6OPq07JQMWj1ds9Eyo+/035bubvdexBz/xC4VZgPH/k3Pd1ZcWltb5QE525UVisrdX
	 ew6PX+6NIzWEr8a6jJpbCc657PRD42o174CsWRgTF3603wPYyGSlO+vNNAs8OP8ivDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OLOD+W6c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD3E606A332;
	Wed, 18 Nov 2026 20:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OLOD+W6c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A245A1F000C8;
	Wed, 18 Nov 2026 20:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033986;
	bh=SIvZceOzAqCzG2lelbqwdibmhTw2JinHlGv9bmUWQ8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OLOD+W6c09pfj93ygbpno8dW5qDUn4L2397OJa29S8CoWNZ0g/E4JjVW3J3hq+TsW
	 mnpwzqhQfskHZ+bl8ez/+4O4Cr+910vG+jVFHVyLxRCcBcFjAJJ0gM8SqLggP0EBnz
	 oLOHqscA5hYOo0stNnbme9nC6nma8/Z6St6Z3QV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0158/3318] power: reset: piix4-poweroff: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:13:00 +0100
Message-ID: <20261118150319.300532083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



