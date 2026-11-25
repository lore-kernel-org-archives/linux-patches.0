Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617973;
	b=d5Buy3v7wZW5LnM2bK+HLbRVDT0VNFj0Mo1h4rMNHoRd3mkz86UySPSG+lqR37KDbwG6
	 rhe9udT0ZzgmCM9h7z9J0LEarrthxDHzLiBVyTIW3B9bNkOkzHDLD1U41coc7rvwqZMHw
	 HYYETMXFV+9aBhwHUSMFUmuhmeGzRwtfftJJajCFJUfurSFMXeHYG5/3Q050e2uzRkg33
	 yCkTrqYA4ZXKPGPbDbtcMIXq8/WVH6EyHhAU3I6uiE9WImkVoP/cidc/tb8CVarlla1DX
	 cyB3Vbx9CWDZLXpHDWppuBbjnYiq/vSjyfdVgBNA4om0mX4ynRxxgVLEbYQ+YOaYruw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=45SygyScNjKraMM85obEOsv4vZbla4C/KZXZF+UntcU=;
	b=fPeHNbwvi/+7AgnvPGy8EYTsHd07c9BbK/KbVRlKLZpnaRy7TJuCzsP5YB2u667JbIVW
	 Spj5V7d/cjCHYFXP3YOEpXpIofzMlgd6ViL2XsdiOfuCqC0Yz5owWPZUE4u3wfrYPGKff
	 V25Jpud12JIBwpWqssswILOMj8DCPdj4eLLpbPAtJI8kMIUeqICwVVKoW10x7RksCgoGi
	 5uMOJiDO0OLS1d4sCF/UT4kG7DD4AUGZmyVdDfxBrEcvxw7mcD6Zt/M9OU3TGeDhiDIR3
	 blqOAUH8SffcX9LIZ+NcFfzc+mJBRJG+Z6Bkj0irxgqh54zVrRukSVFJd/qYmRbitaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eD5v+QQ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0806606A31E;
	Wed, 25 Nov 2026 14:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eD5v+QQ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BDA1F000CA;
	Wed, 25 Nov 2026 14:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617973;
	bh=45SygyScNjKraMM85obEOsv4vZbla4C/KZXZF+UntcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eD5v+QQ96vOO+3uMV1znHLild9lx0tksGIFeMNnfR3BJBP8l3vM50XAm5gNgF2NoQ
	 JQv37eKbWcnGQHFul6VR3x+7TmTRyMUDmgUCxcLCdOPQLAV8PRu/LtysItQSaip8gb
	 oZAu82zaDAbxYnnwHfIq5ksFrOIUd0unFarn6jR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0134/1005] ata: libata-sata: allow re-enabling NCQ with the same queue_depth
Date: Wed, 25 Nov 2026 15:24:32 +0100
Message-ID: <20261125143824.877437603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Pylypiv <ipylypiv@google.com>

[ Upstream commit d7c5cc8cc21c1264cce07feb4a51be158688280e ]

When ata_eh_speed_down() disables NCQ due to excessive errors, it sets
ATA_DFLAG_NCQ_OFF without changing sdev->queue_depth. Userspace can
re-enable NCQ by writing a queue depth > 1 to the sysfs queue_depth
attribute, which invokes ata_change_queue_depth() to clear
ATA_DFLAG_NCQ_OFF.

However, ata_change_queue_depth() returns early if the requested
queue_depth is equal to sdev->queue_depth before clearing
ATA_DFLAG_NCQ_OFF. As a result, writing a different queue depth > 1
re-enables NCQ, whereas writing the current sdev->queue_depth value
leaves ATA_DFLAG_NCQ_OFF set.

Since ata_change_queue_depth() already checks whether queue_depth equals
sdev->queue_depth before calling scsi_change_queue_depth(), remove the
early check so that writing the current queue_depth > 1 clears
ATA_DFLAG_NCQ_OFF and re-enables NCQ.

Fixes: 45623d33bfc0 ("ata: libata-sata: Improve ata_change_queue_depth()")
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20261029184445.1615717-1-ipylypiv@google.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-sata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index ad40f516c6d43..7078f168def80 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1287,7 +1287,7 @@ int ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
 	spin_lock_irqsave(ap->lock, flags);
 
 	dev = ata_scsi_find_dev(ap, sdev);
-	if (!dev || queue_depth < 1 || queue_depth == sdev->queue_depth) {
+	if (!dev || queue_depth < 1) {
 		spin_unlock_irqrestore(ap->lock, flags);
 		return sdev->queue_depth;
 	}
-- 
2.53.0



