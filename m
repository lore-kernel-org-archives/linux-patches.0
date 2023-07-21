Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C481F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D27C433C9;
	Fri, 21 Jul 2023 16:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956108;
	bh=k94FU4zggxS/Icrp7ag8aFDkwB8YTvGxXKA/VDmBQqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgB+/ReZelZVbc+DvFGVXX50YzdypAGY8oNf3qk9YHZDF3yHqlahMmKZ8yqTWtSXH
	 vkeLq7jir5+8flGcbiWcTzVfQ6oFazTuPgWMbuMOtCcwacIfavmPF4mfE/A0MKTs8K
	 Jx0mDCy/knBaOO3XmtH42ZxZ0fk8RIQhJNM8iqYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 103/292] net: txgbe: fix eeprom calculation error
Date: Fri, 21 Jul 2023 18:03:32 +0200
Message-ID: <20230721160533.217431226@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit aa846677a9fb19a0f2c58154c140398aa92a87ba ]

For some device types like TXGBE_ID_XAUI, *checksum computed in
txgbe_calc_eeprom_checksum() is larger than TXGBE_EEPROM_SUM. Remove the
limit on the size of *checksum.

Fixes: 049fe5365324 ("net: txgbe: Add operations to interact with firmware")
Fixes: 5e2ea7801fac ("net: txgbe: Fix unsigned comparison to zero in txgbe_calc_eeprom_checksum()")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://lore.kernel.org/r/20230711063414.3311-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index ebc46f3be0569..fc37af2e71ffc 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -196,9 +196,6 @@ static int txgbe_calc_eeprom_checksum(struct wx *wx, u16 *checksum)
 	if (eeprom_ptrs)
 		kvfree(eeprom_ptrs);
 
-	if (*checksum > TXGBE_EEPROM_SUM)
-		return -EINVAL;
-
 	*checksum = TXGBE_EEPROM_SUM - *checksum;
 
 	return 0;
-- 
2.39.2



