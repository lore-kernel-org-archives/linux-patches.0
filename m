Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060664;
	b=GSanqCPLRYcb/ZaUgZrqGYknDU2XluUu0ihlTUZmoVYo7HZxPa/Qwpu5WNdEQZ/5bMbw
	 pxnchsiWd7n13Ybgm55yJijosd7CZqUOPzdS3/3pWbFORzRMag/xWF+SBg36AzmTpDw7H
	 tvawZgnnaq3HRzVvYX55dO5YHFBz8yuotDUGxnTSwrCIodSIPKXMKFyF/plA8HCFaghKU
	 wXRCFanjHniCzN8szynvEPTfT7HXdBm+h84P3xwEH7fHORdl1zRPDkHqKMN3V1daVPYEG
	 mgWSKhnE1cDNB3BgzuFxRGNtv5er/2wSVC5aSbzpRu10a094F0Xix0cJ5rUspIahncQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a0FKbj7231NhVPuBQqN5yoqeyLlF2aUWqDKa5oJb9hQ=;
	b=HaS77AFfH6ec+Oz0c8JYvprS+wMu+jYJ5K0KVWl9Op6nCnoQl0Ac8e3ARLjZfjizBc+K
	 oNsOJ6alUr0QRBf/zIw17ZLHAMJ7PwGVXIl4djnu+3TR8CM2IQEPX1h2LwJTfdjGvoii6
	 avaQgdRkvSfQfRSmYOuZVhbIfynrwzAUsr8RikiXAytxPZ7kn+YG5//BFd4Dnggc+wQJW
	 vLdwUXvK22apGY/FdOzGtmRsHhE9lm3hPmwMjyWK3HmVt8us8KgJdlt9IHWWHAcfG5nnI
	 yw+sESri6kw69vqDswsS6eLIKH/Rb2XcTb7Shrl99QxeZ9S67wW5RRgqksri/FX1eew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iFecMk8L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70472606A326;
	Thu, 19 Nov 2026 03:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iFecMk8L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93821F000C4;
	Thu, 19 Nov 2026 03:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060664;
	bh=a0FKbj7231NhVPuBQqN5yoqeyLlF2aUWqDKa5oJb9hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iFecMk8LvocSPxhXnrk7DTg1gQ7ZxtzrdPAO+ve3zAtYF7tD2XOQKl0bRRynAU/mN
	 HhSjsKfKN9r+CrPEVcbZ7Aqrrukz7SZcPvA/WcIwrozuG/Ss5gFgFrWCtPQoX7CP+F
	 98LVtyQ0j9UF6WRCzWUOC+QOhEgnvJlK6e33kVn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1243/1848] ata: libata-scsi: Fix ata_scsi_hotplug() reference in kernel-doc
Date: Wed, 18 Nov 2026 15:54:41 +0100
Message-ID: <20261118150011.865116566@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 5915ab523e33057224a0240e27b88c6c2798b919 ]

The ata_scsi_remove_dev() comment misspells its caller as
ata_eh_scsi_hotplug(). The caller is ata_scsi_hotplug(). Correct the
reference, which predates libata's move from drivers/scsi to
drivers/ata.

Fixes: 580b2102327a ("[PATCH] libata-hp: implement SCSI part of hotplug")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20260912101215.86413-1-kmehltretter@gmail.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d3791425b9335..6374cd9062a24 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4462,7 +4462,7 @@ int ata_scsi_offline_dev(struct ata_device *dev)
  *	ata_scsi_remove_dev - remove attached SCSI device
  *	@dev: ATA device to remove attached SCSI device for
  *
- *	This function is called from ata_eh_scsi_hotplug() and
+ *	This function is called from ata_scsi_hotplug() and
  *	responsible for removing the SCSI device attached to @dev.
  *
  *	LOCKING:
-- 
2.53.0



