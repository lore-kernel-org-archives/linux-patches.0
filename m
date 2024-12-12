Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D69215F5A;
	Thu, 12 Dec 2024 15:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015901; cv=none; b=j6jOAa0E64PkjKQipkmyarcFZYDcj4cqOgmj15Ijnou4nU1GIORLCPg7MyiZTtjvoYvZKQmmwsfGkcOlbp6rc/u7S7I0Pz0CG50dMde8bAu2oSqGqEVEWITLQF2x/vD5MWXSGYri19JI5EBtfGTf8O/EmLycRh94xohnv0GRURM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015901; c=relaxed/simple;
	bh=pa9TSh4vxWIK9xCsNpLhfuWBtMDuEsetAPnegu33aJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bP7BL1dMorK/rG7Gbn/yZX7yD270dFFUzzRRB4EM6VHb9cAN1WZXw3EVoWUYdMvurbCncEwGJcDAVegKG8eDlt5DGxATlLZxNLLfUEQwe2XeXgO/aVkTrOG/jkGmuW+6rdF7UEjrGBfW+oN6VpkhbnTU1OQX7dOt+zg3tSSTSFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9WsFxXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9WsFxXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4E4C4CECE;
	Thu, 12 Dec 2024 15:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015901;
	bh=pa9TSh4vxWIK9xCsNpLhfuWBtMDuEsetAPnegu33aJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9WsFxXWVojTGiwUAhSeWq+o9PbeoHkbLIX1COWo+Hr4NY/ohmvPYA8i2Vkiaa8XR
	 dmmD4+5CiTM59dmirbH1XpL19FCuSJFbqG2Vp55FwSwbUk8iuYH4vxL9Zn3JAk1eN5
	 EFvoDsYTGohp23A//VKPdDFqiRys8JE07NthuPVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/466] i3c: master: Replace hard code 2 with macro I3C_ADDR_SLOT_STATUS_BITS
Date: Thu, 12 Dec 2024 15:54:05 +0100
Message-ID: <20241212144309.820469092@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 16aed0a6520ba01b7d22c32e193fc1ec674f92d4 ]

Replace the hardcoded value 2, which indicates 2 bits for I3C address
status, with the predefined macro I3C_ADDR_SLOT_STATUS_BITS.

Improve maintainability and extensibility of the code.

Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20241021-i3c_dts_assign-v8-1-4098b8bde01e@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 851bd21cdb55 ("i3c: master: Fix dynamic address leak when 'assigned-address' is present")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c       | 4 ++--
 include/linux/i3c/master.h | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index da83c49223b33..53f3959e602c8 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -348,7 +348,7 @@ static enum i3c_addr_slot_status
 i3c_bus_get_addr_slot_status(struct i3c_bus *bus, u16 addr)
 {
 	unsigned long status;
-	int bitpos = addr * 2;
+	int bitpos = addr * I3C_ADDR_SLOT_STATUS_BITS;
 
 	if (addr > I2C_MAX_ADDR)
 		return I3C_ADDR_SLOT_RSVD;
@@ -362,7 +362,7 @@ i3c_bus_get_addr_slot_status(struct i3c_bus *bus, u16 addr)
 static void i3c_bus_set_addr_slot_status(struct i3c_bus *bus, u16 addr,
 					 enum i3c_addr_slot_status status)
 {
-	int bitpos = addr * 2;
+	int bitpos = addr * I3C_ADDR_SLOT_STATUS_BITS;
 	unsigned long *ptr;
 
 	if (addr > I2C_MAX_ADDR)
diff --git a/include/linux/i3c/master.h b/include/linux/i3c/master.h
index 2a1ed05d5782a..2100547b2d8d2 100644
--- a/include/linux/i3c/master.h
+++ b/include/linux/i3c/master.h
@@ -313,6 +313,8 @@ enum i3c_addr_slot_status {
 	I3C_ADDR_SLOT_STATUS_MASK = 3,
 };
 
+#define I3C_ADDR_SLOT_STATUS_BITS 2
+
 /**
  * struct i3c_bus - I3C bus object
  * @cur_master: I3C master currently driving the bus. Since I3C is multi-master
@@ -354,7 +356,7 @@ enum i3c_addr_slot_status {
 struct i3c_bus {
 	struct i3c_dev_desc *cur_master;
 	int id;
-	unsigned long addrslots[((I2C_MAX_ADDR + 1) * 2) / BITS_PER_LONG];
+	unsigned long addrslots[((I2C_MAX_ADDR + 1) * I3C_ADDR_SLOT_STATUS_BITS) / BITS_PER_LONG];
 	enum i3c_bus_mode mode;
 	struct {
 		unsigned long i3c;
-- 
2.43.0



