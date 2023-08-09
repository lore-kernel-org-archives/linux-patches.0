Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189BB17AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647B4C433C7;
	Wed,  9 Aug 2023 11:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581049;
	bh=+d5mMCIhTSOvYtvKOVHme5m9mXl228xHRH6jts+oFPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSHHOC6jzD5/JJqf+X8e3vhQHPw4ywc2KXCAI7klCvAwuxEThgOeCikC43eN4vAOS
	 GjH5gzbeYTsYkDF8DmRejC6kYoxMhMNMfcZ1lMkmYaxpNQL3X/il1jaojcVw36dVE/
	 lFe1WUe3eKwk6/+IywJscfWpwyXArAP/kYeczV44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/201] block: Fix a source code comment in include/uapi/linux/blkzoned.h
Date: Wed,  9 Aug 2023 12:41:00 +0200
Message-ID: <20230809103645.771940685@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit e0933b526fbfd937c4a8f4e35fcdd49f0e22d411 ]

Fix the symbolic names for zone conditions in the blkzoned.h header
file.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Fixes: 6a0cb1bc106f ("block: Implement support for zoned block devices")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20230706201422.3987341-1-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/blkzoned.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
index 656a326821a2b..321965feee354 100644
--- a/include/uapi/linux/blkzoned.h
+++ b/include/uapi/linux/blkzoned.h
@@ -51,13 +51,13 @@ enum blk_zone_type {
  *
  * The Zone Condition state machine in the ZBC/ZAC standards maps the above
  * deinitions as:
- *   - ZC1: Empty         | BLK_ZONE_EMPTY
+ *   - ZC1: Empty         | BLK_ZONE_COND_EMPTY
  *   - ZC2: Implicit Open | BLK_ZONE_COND_IMP_OPEN
  *   - ZC3: Explicit Open | BLK_ZONE_COND_EXP_OPEN
- *   - ZC4: Closed        | BLK_ZONE_CLOSED
- *   - ZC5: Full          | BLK_ZONE_FULL
- *   - ZC6: Read Only     | BLK_ZONE_READONLY
- *   - ZC7: Offline       | BLK_ZONE_OFFLINE
+ *   - ZC4: Closed        | BLK_ZONE_COND_CLOSED
+ *   - ZC5: Full          | BLK_ZONE_COND_FULL
+ *   - ZC6: Read Only     | BLK_ZONE_COND_READONLY
+ *   - ZC7: Offline       | BLK_ZONE_COND_OFFLINE
  *
  * Conditions 0x5 to 0xC are reserved by the current ZBC/ZAC spec and should
  * be considered invalid.
-- 
2.40.1



