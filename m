Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047837;
	b=sd6e8Tt2j0RjHtPknk3nrsB+5fZkyM97pz9uHOkP+dktBxIGPivTaQ3cJ0tFVG91J3Ot
	 N+rkUuACi6RPm/tKnu1VLZNTvP3cd+8xobePjTLqzD/mngh5g9PHGWHR1lYFzD2UAJOeB
	 LbdFceExDLkkDYmCgO0/K0GYMCWjkVrPHrOzGuGSdZHqjBpHKn1zD61D4gOV1b1bnNwrI
	 4Lq0VW3Pjucnl93DB0zXh47p69mD1WH4PULE73V2ux9usYxfu1dfzJ3iLZwEpbpeAtLQ1
	 OnWNcVyHmauCdzA6CWeSuwT4Mt4dh6ZyPZTep8KQZJGPGDNVRKAl39RoxlbnCNvj4Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CKH9b7u6pAHBEUOJOMVKNeHE3rWPetFKrgCVnWT4r4w=;
	b=kao6Vj1AhMiysa7xUGSHXg/c5v1YMjClyR9H7DopVcZ6ncVTpUky/mSmtRpZTfMp8MSh
	 UzL8iSzwh5OHqkfB10Q8N8oe3z8ZzCekZXL1Vj33xLWcl9trZb04we6o8ggu8PwMbn0C6
	 1H+huRK3GJo8Vmzaxid3+0WTfFdHdpW9g3Xa775v3Qx/A7eNzO9r3/cpegLA803+kenft
	 dba36K7HGwGoe9aUcQvIU63HkmOZjRsX9kGAovSprpI09tTTR4AosQnJE/ZrBXRdwRe5n
	 STLG/xRe/SQIIyZ4psPksaydvEozP1DMzh73DWIimhL8OGBdIX+zzhuJzf722b/p1AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MjNmJpDY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9EB606A320;
	Thu, 19 Nov 2026 00:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MjNmJpDY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18F91F000C4;
	Thu, 19 Nov 2026 00:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047837;
	bh=CKH9b7u6pAHBEUOJOMVKNeHE3rWPetFKrgCVnWT4r4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MjNmJpDYtuIZ8aQa88cW3FCXkiCfS3IttYkwVCDTA80LupAGsIXqLX+b1x5Ns1oAy
	 HuwYVJOACWaKm0rH7i1O/GRFuGNjEiSr0i4ZzOFs6CCB/bfJgaGSUIzcRrWf3REwnI
	 5Bl7CCAiaIP2RWM5oEOQ/YiKpb+JqixqIWsMZ47w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Faure <boris@fau.re>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1782/2857] soundwire: intel: initialise quirk_mask before reading it
Date: Wed, 18 Nov 2026 15:46:56 +0100
Message-ID: <20261118150305.439995854@linuxfoundation.org>
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

From: Boris Faure <boris@fau.re>

[ Upstream commit ee8a8cfe4e8d3c67456e554c988017c252710a25 ]

sdw_master_read_intel_prop() declares quirk_mask without an initialiser
and ignores the return value of fwnode_property_read_u32(). When a BIOS
does not describe "intel-quirk-mask" for a link, the property read leaves
the variable untouched and stack garbage decides whether
SDW_INTEL_QUIRK_MASK_BUS_DISABLE is honoured, so the link may be marked
hw_disabled at random.

Initialise it to 0, matching is_link_enabled() in
sound/hda/core/intel-sdw-acpi.c.
Found by code inspection, not observed at run time.

Fixes: 395713d8ca43 ("soundwire: intel: handle disabled links")
Signed-off-by: Boris Faure <boris@fau.re>
Link: https://patch.msgid.link/20260820212220.226912-1-boris@fau.re
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel_auxdevice.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/intel_auxdevice.c b/drivers/soundwire/intel_auxdevice.c
index 96c6b2112feb6..766bda681c736 100644
--- a/drivers/soundwire/intel_auxdevice.c
+++ b/drivers/soundwire/intel_auxdevice.c
@@ -65,7 +65,7 @@ static int sdw_master_read_intel_prop(struct sdw_bus *bus)
 	struct sdw_master_prop *prop = &bus->prop;
 	struct fwnode_handle *link;
 	char name[32];
-	u32 quirk_mask;
+	u32 quirk_mask = 0;
 
 	/* Find master handle */
 	snprintf(name, sizeof(name),
-- 
2.53.0



