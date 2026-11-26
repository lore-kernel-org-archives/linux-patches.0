Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705374;
	b=ocWWw9sCtwcm4KI84cxYwM5sbfAkFAwYQlj0Lib0xf/qAfwHATyEjzR6q/RKe878ZKR8
	 76f/1vB/eBxef27+1uoT2p+FBzEkG84tLXXpR5Qe1XkY6/8/Vhdhc7SeuLGAt0DXfG6ij
	 kMq4uf2pt7fSwL/23pGsSn9NqjEFL+qzjG6iCxw9aUqbo0kizF/OAI8BC9lp2KxhoK/ha
	 Me+n4erZXwhLgQeAy2RVL2qZ0P8CmcmrFPRlYJoD1OjIyB7hD/Vhu1o6fvBMVJX0B0i84
	 Vyv259P//gPMWxedouGk6g4v9CuPtel4qEpVq1Up7o1eumHgNbFaf8fm3GYe//22Blg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kbXVmJxsjucOhAcxv1Hr9eJdgAsYp+Bq3gHLK9QZ75w=;
	b=ufnKWtDwXBFYYrvzRGiXOhPxBXNJOzn85ZCFSiyGaDE7Jex8bGWOWW/+apBpqON7el08
	 wTY9rulNC5PEwyMNVkf0PHeuzORnjbTj/4XRz1qYy4dfYUBiLO46XNc2nxENVaY5g7wdO
	 qk0OtRwhW1vlZmVHjEvLp/UWGfNfXJaR2llnRJTdLinJNCLQ4h8IZPzAvYtPfWIYyyykJ
	 FOa/+aia9/AtdZ2yqEIhMKw4kz4ierVu3v4SMZxIZQyI4MymmqXbdfq0sOdzpGoweDqJh
	 YiWz7rBGlKzaDtK6WKnKMIBXxkw1BcX/tJNCsUTyvooT3D9EtzxeyfhaeYSz0HIQglQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S9Oq9j0e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFEE606A323;
	Thu, 26 Nov 2026 15:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S9Oq9j0e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA491F000C0;
	Thu, 26 Nov 2026 15:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705374;
	bh=kbXVmJxsjucOhAcxv1Hr9eJdgAsYp+Bq3gHLK9QZ75w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9Oq9j0eZOiFfJuMS2NAlhukcbXkeTtaq5ZTWZfnq0UJosKeQ/z0tCwxpPVbVRZgU
	 lIbLMNidRXENCFao0K5fScy8Ei/UNoGriOjizVe6SJitvhHX4Ewfr9G9wnAw0z5bxE
	 u3zUZbbLGKTex4Fg2by4uDCZrPhtZM2uVpjx0BNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/319] ata: libata-scsi: Simplify ata_scsi_mode_select_xlat()
Date: Thu, 26 Nov 2026 15:38:19 +0100
Message-ID: <20261126144009.702726301@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 261e150799305e546753554babccab83a0d50627 ]

Use get_unaligned_be16() instead of using hardcoded accesses to
16-bits big endian cdb fields.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Stable-dep-of: a1eb72c477ec ("ata: libata-scsi: reject MODE SELECT mode pages with a wrong SPF bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 7433be9adc016..f162a2bea70eb 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3730,7 +3730,7 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 			goto invalid_fld;
 		}
 
-		len = (cdb[7] << 8) + cdb[8];
+		len = get_unaligned_be16(&cdb[7]);
 		hdr_len = 8;
 	}
 
@@ -3756,7 +3756,7 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 	if (six_byte)
 		bd_len = p[3];
 	else
-		bd_len = (p[6] << 8) + p[7];
+		bd_len = get_unaligned_be16(&p[6]);
 
 	len -= hdr_len;
 	p += hdr_len;
@@ -3780,7 +3780,7 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 			goto invalid_param_len;
 
 		spg = p[1];
-		pg_len = (p[2] << 8) | p[3];
+		pg_len = get_unaligned_be16(&p[2]);
 		p += 4;
 		len -= 4;
 	} else {
-- 
2.53.0



