Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057363;
	b=dEgloiEPrPpEwhKLQujDkH44VKR6z3P12Hnjskrnqbup1gTeGm8pSZFZ1qMljS1CqEEb
	 c1u65TB1VoTj1MNnFfc43N2zB6dItLmHtq7hI7a/OMR31mwxJHW1qqhBoaNvNpaY7uYh3
	 gVRDOaChJnOnklCVK5sUVE9eyOU/CFtHH4i7saTMml8qXZYQGQCWHGvTdHq03MzsDgudJ
	 EgpRfXkbj0Q1MQWn2QkfmcF0kjupG1OLaERUUl3zJqnCJDXCwAB5MYAEjgsisp4YfnMtw
	 nP2gXXh8IrOVTkHciuQ5frSEPcfgWtkoJPWFEp6HbP7Q6AR0XPjKpgTVQcivcLcOMkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FwySRPimWKxyVqEIU10NLgSY41W9cOkTiWsw3vTRXvY=;
	b=B3OWOhJeqaub6nknUGndMgbD41COtUEdTQsesUzLOQ311Y7uBeGTq/2/9MTTW5KAw1i8
	 rFHpOb6Dry6/Y1fyc7xsLk3YjYEa4zSKY/BFG76hZ4UiAizDx3vfpllKI0kdyRhokebBe
	 gklxu7vEvzlhGSbgbOfrh68IFI5kYuu9pIlIiS7x+0IJk3LiaWoX0uJA8gLOvjr37oHbT
	 teta65eJmqaRH2Ag/SpbumRUJHu85LzdsqzwovCPys9y0HDddqB48TBvWSF8FeelrzXjQ
	 SnQovWAQNqYg69W1KtSXq6Q6VXQ9V2TXuEkEfi8DIyvmN67FZFo6C0//zm00R1ZLjkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XfKK3d9D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BC260A260A;
	Thu, 19 Nov 2026 03:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XfKK3d9D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068A21F000C8;
	Thu, 19 Nov 2026 03:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057363;
	bh=FwySRPimWKxyVqEIU10NLgSY41W9cOkTiWsw3vTRXvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XfKK3d9DrnjnbKvI3R5mtC8JtMXWwbbmyvnMV38VBU1zjXAmLqEkAc9ASfCDsx6JB
	 Bfc6WHu/3iqKqlp5+KX4Xe3gGigfVPcrJqtcQ5jBXqpbwxVXPnk/MtwGdmMgq6mn9i
	 9HkfjvnaIVqo1Yt9yDcIPb9ssS/EJA9URfqJMyTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0105/1848] power: reset: piix4-poweroff: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:35:43 +0100
Message-ID: <20261118145915.425786573@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



