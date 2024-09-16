Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089C6142903;
	Mon, 16 Sep 2024 12:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488687; cv=none; b=Ut9lVb8GsUtIUm+G6z/Yr/deEJ4m9jIMrhRD56JWn9P8vwU5iwKwX5cBe5mVryz2x3CIaptqb6ve6X5cQX7hWSaLJ6ftc/xiST8nXval4yBUFq4Mryly4GzUmwo7HlB5OftrLVcEcHflCq9yc4guC5LXPnqqZpe+jHcdIELebbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488687; c=relaxed/simple;
	bh=O1QdZVQGT3MN1ZahrRL+XEDIpdqh7QRK1Z72kSubhmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkS45t05O5ExHqWfqSp7TAzroTBTo9L/mf+Td0YZFpgnoMkeVVhnyOIEBHGonfysSIyRW2WHMUFcPOV+Ja6jD228expdnZYif49qBoCqkfSzMw6BNaxNgC9qjJCGaWtvuqVdSXfUnkvddFuyz4Rjxg0qMRephjA85/ROV4wECqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhOn1mOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhOn1mOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7F4C4CEC4;
	Mon, 16 Sep 2024 12:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488686;
	bh=O1QdZVQGT3MN1ZahrRL+XEDIpdqh7QRK1Z72kSubhmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UhOn1mOGJb0Gbt/U+8dS9xdInR3OsCVMjHqjJDrBhQxpxgNgPWMqLru7XUnBNBsQF
	 RBFsSDXzDCx9UUNngEaoXIrdBNbJc2uAnKKSx5iTaGE7tTXuAvcS+eMamhe4KCv/UO
	 5chGmXnXuk4IcHbS152LkDq2vYI1cm00ePCB/mMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 51/91] eeprom: digsy_mtc: Fix 93xx46 driver probe failure
Date: Mon, 16 Sep 2024 13:44:27 +0200
Message-ID: <20240916114226.191917179@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



