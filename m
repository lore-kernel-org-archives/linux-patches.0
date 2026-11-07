Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060776;
	b=eIxLgF1aIGo5xhPQFGTw5W3Z6l6BnP5vAejhYxyZdxBS5PPWmijVtOs8ygPb/1fzPS4T
	 2PPtbIB2qxiLtclEvGfBm1XG11SwbDnsZvK9J3UO3NUOUQNwaPHEB7Vq9fv661dTFPdLB
	 0PswKAsiJ7c7X4+Fztl3xaAdF9yldJN48tGBam9tp60VFhvhgwkwDl672vh3WshNOvGz9
	 xtnD/Vt03TSzoTzyMiM3ij1NiZ2InQdeH54VcUuaWNkDw6Sohw4hFx9t7HsjuMygQBduo
	 xgccvvfkfwMPEdWlSX//V7jgsPurZ5usZXfDHXbMi5Q/40GyHW+8BPKGXG4vPFr42hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K0jQmOjHXG9QvGpRhXmdvmi3bkRxt2La51ay9h5HoYA=;
	b=JaAKDUhnH/OCl6Ogv31dfEFCoLS3VYqMYgbO4XfDBnMQc3qkP4pMChdkJBAdzqMYwib/
	 RARbo6MKuiiwO40M8KumQ3fT42Z7DXV89Ol4sDhyZy8iFKGQy7F93NMx9TYRI08sBXhWR
	 Wb+tBh1wImn3gGcDRZQZJ+MChBHMGGJxDpSMZTr30p/1TYTxQAyhCRs1c7nx9TDtATB73
	 fNjTwyKjf9Js/2wV4FfSTtf13Ovj0SW2EhRVvvaghdHEr7lLdmIQ/kHYuCLtXn03p9Pjk
	 ECaLDI26q71BnfSwoxAPvS4twCKDBtS45D3B1e/oWnk7IgqAzZ15oO+CFwaDD/HtDOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T4bzw1VG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3621606A326;
	Sat,  7 Nov 2026 14:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T4bzw1VG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFC71F0089F;
	Sat,  7 Nov 2026 14:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060775;
	bh=K0jQmOjHXG9QvGpRhXmdvmi3bkRxt2La51ay9h5HoYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T4bzw1VGsfeALdLdnh1O/wxZt9AcgZKOh6nJCjRiKHozdqejkFFJwjLwuUfuWHiWl
	 PH3rQ99KQir01bi91XefzH1tJD0H/V5i3ZHbYJqNP5Z48RDOLEywIAGVsCRQzqlMTj
	 64wX6pJ0KIg1Or70Pbh/cDRA4yN2ffMetsidUUXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0183/1536] power: reset: piix4-poweroff: add missing MODULE_DEVICE_TABLE()
Date: Sat,  7 Nov 2026 08:36:39 -0500
Message-ID: <20261107135002.797866595@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e6822c0210000..1a6f3d22d2974 100644
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



