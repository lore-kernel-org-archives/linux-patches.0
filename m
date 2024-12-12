Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C5053365;
	Thu, 12 Dec 2024 16:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020842; cv=none; b=KIlWFIvlvCAVAzOVv1UqdE8tJdHw2+P5ONUE+/YCXxUEeG5T8RQgX8nzXkb+ux/vDHl37Ahw7NtIk8LvijOm96HLOp8LDpbIhkXfQXEBc1lMUd+CKsqYaqFmlYQcpdFo5IKgAVq8IyCAveG6XuT5aQ8TmiiVcWmcR7uQkshvDI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020842; c=relaxed/simple;
	bh=SGXOZ+VezDI2MDvzTwwoWOVWkPm5pKepPo1SYalecAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdNol9vKfdYYfw3knwEJfBHODV7ytf+S+Wt70sUlssyKHo2DnsHbVbcCqBOubz5SGzeKOqUaHoMn40xx7cuM+VqnbGA2F1mHbqho3S+9euxp0rP4tNkETKqqoFxembmt56GJofzFm3YAS/eeqq8NUYgqoAqbxMudpRKpi+MUCcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBoO26VH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBoO26VH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2C2C4CECE;
	Thu, 12 Dec 2024 16:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020842;
	bh=SGXOZ+VezDI2MDvzTwwoWOVWkPm5pKepPo1SYalecAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBoO26VHb/ChguCQgu0bnwmWBieUQqAu/IF7Ow5OyiOt+/eV01QvnxdA3wz04Fisu
	 t/kgeQMYbefIdNMGNC9JmvGWV+WrNC7v9u/IBEEalDGL20w5b/TE4Fx74mSeg589Mr
	 m0KYLxbfMlTZs89ipslCsC23fTs7IkHski1ofkV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 574/772] i3c: master: Replace hard code 2 with macro I3C_ADDR_SLOT_STATUS_BITS
Date: Thu, 12 Dec 2024 15:58:39 +0100
Message-ID: <20241212144413.673450692@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 103d3383e176d..621881b6bf81c 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -344,7 +344,7 @@ static enum i3c_addr_slot_status
 i3c_bus_get_addr_slot_status(struct i3c_bus *bus, u16 addr)
 {
 	unsigned long status;
-	int bitpos = addr * 2;
+	int bitpos = addr * I3C_ADDR_SLOT_STATUS_BITS;
 
 	if (addr > I2C_MAX_ADDR)
 		return I3C_ADDR_SLOT_RSVD;
@@ -358,7 +358,7 @@ i3c_bus_get_addr_slot_status(struct i3c_bus *bus, u16 addr)
 static void i3c_bus_set_addr_slot_status(struct i3c_bus *bus, u16 addr,
 					 enum i3c_addr_slot_status status)
 {
-	int bitpos = addr * 2;
+	int bitpos = addr * I3C_ADDR_SLOT_STATUS_BITS;
 	unsigned long *ptr;
 
 	if (addr > I2C_MAX_ADDR)
diff --git a/include/linux/i3c/master.h b/include/linux/i3c/master.h
index 585b6c509802d..706a583c45efc 100644
--- a/include/linux/i3c/master.h
+++ b/include/linux/i3c/master.h
@@ -304,6 +304,8 @@ enum i3c_addr_slot_status {
 	I3C_ADDR_SLOT_STATUS_MASK = 3,
 };
 
+#define I3C_ADDR_SLOT_STATUS_BITS 2
+
 /**
  * struct i3c_bus - I3C bus object
  * @cur_master: I3C master currently driving the bus. Since I3C is multi-master
@@ -345,7 +347,7 @@ enum i3c_addr_slot_status {
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



