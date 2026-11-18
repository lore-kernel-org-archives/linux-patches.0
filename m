Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041680;
	b=KbLCqSd5f1uaPzsHiVo+8aau65+exLnV1zfbVRL/TmydlKtlwkY7FHj815Q8WNhM/ka1
	 nYsaCzo6m97Ksqsap/aGc9mmGN3OeMXLTiOaIWovzXRhK6J/4Bu9t4EKPAJNqjZ9CmSSf
	 ExpRdj7XVawK418pBBuaLTvmoYtFi+GdwwvNbKNGpzoc4RVLqzAVU7scHWPZFM08pdzWN
	 +KzCs3SbeGfBQVGmeWAyWV34aMljFhuaHDwQDF3NEBp7lkVSY38HT+jkmeZ9ACPV8+LDo
	 WtUqX092RUDXjtozXg4x4Iddt3DpooKXwM6XaYhzZR/3MKa+5T/c7Xv1SQzlaYi+Uig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JWLoyNJxoKWoUSqVImVSPPVy86gIYqG7P723BYLJjj0=;
	b=Id8rdPTPHWUPp8q3sTbSy0Tsxwxyb9RCHoCW/nhfFFqz4IuZ7QWyN1TlOlMHwlyO9P9Q
	 qmieN4xpa9pGSb+7H8y4aKT7nx1q6rtXX+GELQLQJmi1uxXDkON2I7V5tnN0d1sBiemT8
	 Hnb1JwDoIjgnVauzWSvYmIDHVnu9cI8lefnSPki7FyrBKUa9FVISvRQGpRakwKLtKRE3S
	 fdVTjXtymACYRSc3hrX1UC5zclDRM52qO4uihLJvVsPcVmze3rwSt8TlF4beOoyrvQYo+
	 /ZghtGcDA2ainn9tua89npjk8blbIBujm8VhGzKbAXCCA/HtVToe4OGONwo3hWe0klw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zlTP7HLm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2F9606A330;
	Wed, 18 Nov 2026 22:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zlTP7HLm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5063E1F000C5;
	Wed, 18 Nov 2026 22:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041679;
	bh=JWLoyNJxoKWoUSqVImVSPPVy86gIYqG7P723BYLJjj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zlTP7HLm9qRfmbrPMnSHIa7+dNA3zpMphXcyfrSb12xwh4ujZWILWSUL7VQTcdSdj
	 //8pEHW/s2lYlFYiYfdlLQwVmrVB4kExAIvVjJ+3vN2IFOPxsTboEqXg7MqM2Y6Rw+
	 SnNKOy3G3t8PhK8JY5DHphuZDZ+y8XggA1voA28c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyrylo Biryuk <illofspeed@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2901/3318] ata: libahci: re-enable FBS after error handling on a port multiplier
Date: Wed, 18 Nov 2026 15:58:43 +0100
Message-ID: <20261118150447.510879163@linuxfoundation.org>
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

From: Kyrylo Biryuk <illofspeed@gmail.com>

[ Upstream commit 23eab9e877497397a0e2394ee9174d576816209e ]

ahci_do_softreset() disables FBS before resetting a device behind a port
multiplier, as required by AHCI 1.2 section 9.3.9, and re-enables it only
when that softreset succeeds. If it fails, for example because a
hot-plugged drive is still spinning up ("softreset failed (device not
ready)"), EH escalates to a hardreset of the PMP link, and nothing turns
FBS back on: only ahci_pmp_attach() does, which runs at the next boot.
The port keeps working with command-based switching until then.

Seen on a Marvell 88SE9235 (1b4b:9235) with Marvell 88SM9705 port
multipliers (1b4b:9705, in a Synology DX1222 expansion unit): after
hot-plugging a drive, the kernel logged "FBS is disabled" followed by
"softreset failed (device not ready)" and a PMP hardreset, and never
"FBS is enabled" again (twice, on two different ports).

At the end of ahci_error_handler(), re-enable FBS if a PMP is still
attached and FBS is supported but disabled.

Fixes: 89dafa20f3da ("ahci: disabled FBS prior to issuing software reset")
Assisted-by: LLM
Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20261012103917.389-1-illofspeed@gmail.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libahci.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index fc809d6e1bc38..c33760d7ccb3f 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2238,6 +2238,21 @@ void ahci_error_handler(struct ata_port *ap)
 
 	sata_pmp_error_handler(ap);
 
+	/*
+	 * ahci_do_softreset() turns FBS off before resetting a fan-out link
+	 * and turns it back on only if that reset succeeds. When it fails
+	 * (e.g. a hot-plugged drive is still spinning up), EH escalates to a
+	 * PMP hardreset, which never re-enables FBS, so the port would keep
+	 * command-based switching until the PMP is attached again (reboot).
+	 * Restore FBS once recovery is done and the PMP is still attached.
+	 */
+	if (sata_pmp_attached(ap) && ata_dev_enabled(ap->link.device)) {
+		struct ahci_port_priv *pp = ap->private_data;
+
+		if (pp->fbs_supported && !pp->fbs_enabled)
+			ahci_enable_fbs(ap);
+	}
+
 	if (!ata_dev_enabled(ap->link.device))
 		hpriv->stop_engine(ap);
 }
-- 
2.53.0



