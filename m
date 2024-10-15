Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2171D89F5;
	Tue, 15 Oct 2024 11:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992173; cv=none; b=R7mp1P4CI2159P836iAVDu6PdHiRButWzJc9D4CETCpuTiT21+KXjbywCH3vRBB3VQWI/oJH09sJjmPm9DCqA1Mbw51m9IP91THcMZZRU8aCtsumBEJY3ap93qHZmnHXCGXdpdXlDSSYHX3MyszOiarDH0+/+eBud4roVwl5eio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992173; c=relaxed/simple;
	bh=Lp6FBngX1HS+2oanf6Yl8tVk+LAt/N6nIWqKXUUY78k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4t0OdCk4al47I2rFi5SO8MEDuWZG/OBbKMDcXp6KTdCsijCzIig/hDkOYfiGNYXFbPpNmbqWOArUwJoRgLhfUT8CaklI8Ga8RBO+W5awuCsuIVtT2THKA2iijpH92FhNSoERqJF4+CM0RdX/8TET89kdO5QT89I0gm7EaRtiak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UefNHJwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UefNHJwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2BDC4CEC6;
	Tue, 15 Oct 2024 11:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992173;
	bh=Lp6FBngX1HS+2oanf6Yl8tVk+LAt/N6nIWqKXUUY78k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UefNHJwu6b9BgsAaIVuY8H2qRRc7PFtlKY63GT64/Geb3kd4GWxY84k+gHzqfxvk0
	 McrzlsDoDqL2U4mI9b6fbHqvuLdiUJVq+z3FPXZCOcHT171sKx4spK5tYIqHyjgtUS
	 UtPQYZekRFey6bWmaasGLAXaz0eAj3/Wi8Get3Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/691] eeprom: digsy_mtc: Fix 93xx46 driver probe failure
Date: Tue, 15 Oct 2024 13:19:46 +0200
Message-ID: <20241015112441.850292722@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 2b82641ad0620b2d71dc05024b20f82db7e1c0b6 ]

The update to support other (bigger) types of EEPROMs broke
the driver loading due to removal of the default size.

Fix this by adding the respective (new) flag to the platform data.

Fixes: 14374fbb3f06 ("misc: eeprom_93xx46: Add new 93c56 and 93c66 compatible strings")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240508184905.2102633-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/digsy_mtc_eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/eeprom/digsy_mtc_eeprom.c b/drivers/misc/eeprom/digsy_mtc_eeprom.c
index f1f766b70965..4eddc5ba1af9 100644
--- a/drivers/misc/eeprom/digsy_mtc_eeprom.c
+++ b/drivers/misc/eeprom/digsy_mtc_eeprom.c
@@ -42,7 +42,7 @@ static void digsy_mtc_op_finish(void *p)
 }
 
 struct eeprom_93xx46_platform_data digsy_mtc_eeprom_data = {
-	.flags		= EE_ADDR8,
+	.flags		= EE_ADDR8 | EE_SIZE1K,
 	.prepare	= digsy_mtc_op_prepare,
 	.finish		= digsy_mtc_op_finish,
 };
-- 
2.43.0



