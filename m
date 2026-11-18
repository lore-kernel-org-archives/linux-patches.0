Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032002;
	b=35TMbR4nDXVv7lnodjLdYtMT/n/ETvb2tCZSSqLNsTr8Cgya1sBMtO88FB/bHpvElLOG
	 XgieWagGF0FFGMmC5PeJ7Z+BF1BSn35xYRQDinxftF3Yhr/ZPZ9Rk0r8bsVAFE7u401eT
	 IJqO0VkNbtMEAWcqq1jmIB1Gdr9zHOliLQFpegCWJ//FEMfuwVnnO4VlVCFbfB4XFUxMA
	 Nz4UaaWKxS5eUL+P9P2Jll1KVVZ9SCLjHuP0HTm7fXYtQ2E7FM0jKnoLU8uvqZVIJywin
	 I5H57TBpMzpkVfiWNjcSURXUVBcZQDjmEKFpEg3ICQKkbkaOCoow7T/GHzm+M2I81iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dMsICbCgJd15Oceolr37vvMHbbHDIJlLqQpQ0SiTM4U=;
	b=qCx3wfRu0EGqtmXcYaHYz0y3kR4l09sOkEV+gjZ+KXyJui9stJM8WNnySO38L05jNozT
	 l9IdykSGyJvnhm5KG+VS+mQLWOVMep248O9tyhOf2+nLprlN96BAU0VH7i/hCeRJBUlDb
	 9LWZOm7m8c6tgTfp4/j9Ff1q/5/une98eZ1jQXm2eRrPq8rVrsaGLi/61/f3UcXYj8HW9
	 hIzEyk7Eq5nOTHbyuG9j3QAdYQQr4SczMsaF/SLvL4XXVb+voMwrmCkGSHUfzqTaZg9Z2
	 Qr3+78MBOkrtG57fKb4qQWQdv4dVtyP2kxEJdTvoWjlpdiU/L/B5Jw4g54mKb9jAEAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Es2FFnUW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DDE606A325;
	Wed, 18 Nov 2026 20:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Es2FFnUW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E76B1F000C8;
	Wed, 18 Nov 2026 20:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032001;
	bh=dMsICbCgJd15Oceolr37vvMHbbHDIJlLqQpQ0SiTM4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Es2FFnUWLASq6B8A2VLF0oH3cSw2gJALmh6IDsmChLGlZpi9mKJwj/NJh3K4f92S2
	 k0i6tW9rV+zK9gvEQdYuhw2LHLXbGGiFn8g4gZzShqCXBknmkUKeaWVpICLOV8uOSM
	 nhqXXAiL/ykqlu8m2X+7EN9SAJrSJpu8AB5tJRRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyrylo Biryuk <illofspeed@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1257/1756] ata: libahci: re-enable FBS after error handling on a port multiplier
Date: Wed, 18 Nov 2026 15:56:24 +0100
Message-ID: <20261118150059.727768883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index cefb5013186ed..fdc3d0564e62b 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2236,6 +2236,21 @@ void ahci_error_handler(struct ata_port *ap)
 
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



