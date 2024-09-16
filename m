Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E022B155335;
	Mon, 16 Sep 2024 12:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488319; cv=none; b=YQ/lbElzPN08W/0pHHD51YR1m6yvU/5NmovtgIyHjwF1ADDBjWZq/2wJBcH/J+zBJtbd9u/3jC1RF/KKFqiPgpy5brNL3tdT3d79h2BBC5JSVglViMJOuQlXk8A5UhDy7P41la9Pioxc5I4XSThbqoKuNAG7/NowbztP9gCA4NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488319; c=relaxed/simple;
	bh=/N5jjXPCyejEs7f6NFIAB6J1La70pDbYqrAINk4X9r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKup5p+l+q0cmRWHi4Gw5kmPljyMKxNKWFhD+ywI9usstwO5Xnsez6y9ii+qvp06NzYvQuXqsJL0T7jVrkBNgmBrrsAc3GKJs/U5Nv0K5kNwRP2xXOxgFs3IeZmTDldnh/sPFIa3BECRDRe7RcsfyKcXG6xwPoB140e7nvkxk2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUhnchnV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUhnchnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E70C4CEC4;
	Mon, 16 Sep 2024 12:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488318;
	bh=/N5jjXPCyejEs7f6NFIAB6J1La70pDbYqrAINk4X9r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUhnchnV8ksw4F4XmXmTHKCZXsX4sfKZXpcbKjR68dqewHDztBZh1wQNAx6aBASK/
	 wrBJup2mBEblerJYmlsoqDDmD6Y6wSiTPF9Ii10P/XWsjFYTl9iew9P2700ZZ3XkJf
	 GeNAwFwdWnnjgMbpMVV/mWWeLbt6sAPDg4ZRhvUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 064/121] eeprom: digsy_mtc: Fix 93xx46 driver probe failure
Date: Mon, 16 Sep 2024 13:43:58 +0200
Message-ID: <20240916114231.287100717@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



