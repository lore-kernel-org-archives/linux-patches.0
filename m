Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8815E171A6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C42C433C8;
	Wed,  9 Aug 2023 10:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578580;
	bh=4NABSnIdEipjSVkVrpP/vibGRCB+i7EwOD2nQ0nERuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1krVaRZwNnGnKe4bDocxNx/VU2gDwSkug5umjbCcP0DL3urbLNgl5A6BaW39HN/J
	 7D06P8tkCmBkDr7DrMDaJvZob7K3urjvkUnQ4ECt4HrKI5CnOYMtkSJv5hUIi0MUw4
	 scyZgP5bb1eoo7RJNcMpIJ3yCVQDID0x3FuVtdVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Roger Quadros <rogerq@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/127] mtd: rawnand: omap_elm: Fix incorrect type in assignment
Date: Wed,  9 Aug 2023 12:41:38 +0200
Message-ID: <20230809103640.285254255@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roger Quadros <rogerq@kernel.org>

[ Upstream commit d8403b9eeee66d5dd81ecb9445800b108c267ce3 ]

Once the ECC word endianness is converted to BE32, we force cast it
to u32 so we can use elm_write_reg() which in turn uses writel().

Fixes below sparse warnings:

   drivers/mtd/nand/raw/omap_elm.c:180:37: sparse:     expected unsigned int [usertype] val
   drivers/mtd/nand/raw/omap_elm.c:180:37: sparse:     got restricted __be32 [usertype]
   drivers/mtd/nand/raw/omap_elm.c:185:37: sparse:     expected unsigned int [usertype] val
   drivers/mtd/nand/raw/omap_elm.c:185:37: sparse:     got restricted __be32 [usertype]
   drivers/mtd/nand/raw/omap_elm.c:190:37: sparse:     expected unsigned int [usertype] val
   drivers/mtd/nand/raw/omap_elm.c:190:37: sparse:     got restricted __be32 [usertype]
>> drivers/mtd/nand/raw/omap_elm.c:200:40: sparse: sparse: restricted __be32 degrades to integer
   drivers/mtd/nand/raw/omap_elm.c:206:39: sparse: sparse: restricted __be32 degrades to integer
   drivers/mtd/nand/raw/omap_elm.c:210:37: sparse:     expected unsigned int [assigned] [usertype] val
   drivers/mtd/nand/raw/omap_elm.c:210:37: sparse:     got restricted __be32 [usertype]
   drivers/mtd/nand/raw/omap_elm.c:213:37: sparse:     expected unsigned int [assigned] [usertype] val
   drivers/mtd/nand/raw/omap_elm.c:213:37: sparse:     got restricted __be32 [usertype]
   drivers/mtd/nand/raw/omap_elm.c:216:37: sparse:     expected unsigned int [assigned] [usertype] val
   drivers/mtd/nand/raw/omap_elm.c:216:37: sparse:     got restricted __be32 [usertype]
   drivers/mtd/nand/raw/omap_elm.c:219:37: sparse:     expected unsigned int [assigned] [usertype] val
   drivers/mtd/nand/raw/omap_elm.c:219:37: sparse:     got restricted __be32 [usertype]
   drivers/mtd/nand/raw/omap_elm.c:222:37: sparse:     expected unsigned int [assigned] [usertype] val
   drivers/mtd/nand/raw/omap_elm.c:222:37: sparse:     got restricted __be32 [usertype]
   drivers/mtd/nand/raw/omap_elm.c:225:37: sparse:     expected unsigned int [assigned] [usertype] val
   drivers/mtd/nand/raw/omap_elm.c:225:37: sparse:     got restricted __be32 [usertype]
   drivers/mtd/nand/raw/omap_elm.c:228:39: sparse: sparse: restricted __be32 degrades to integer

Fixes: bf22433575ef ("mtd: devices: elm: Add support for ELM error correction")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306212211.WDXokuWh-lkp@intel.com/
Signed-off-by: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230624184021.7740-1-rogerq@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/omap_elm.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/mtd/nand/raw/omap_elm.c b/drivers/mtd/nand/raw/omap_elm.c
index 4796a48e1012a..22d37fc37e98a 100644
--- a/drivers/mtd/nand/raw/omap_elm.c
+++ b/drivers/mtd/nand/raw/omap_elm.c
@@ -177,17 +177,17 @@ static void elm_load_syndrome(struct elm_info *info,
 			switch (info->bch_type) {
 			case BCH8_ECC:
 				/* syndrome fragment 0 = ecc[9-12B] */
-				val = cpu_to_be32(*(u32 *) &ecc[9]);
+				val = (__force u32)cpu_to_be32(*(u32 *)&ecc[9]);
 				elm_write_reg(info, offset, val);
 
 				/* syndrome fragment 1 = ecc[5-8B] */
 				offset += 4;
-				val = cpu_to_be32(*(u32 *) &ecc[5]);
+				val = (__force u32)cpu_to_be32(*(u32 *)&ecc[5]);
 				elm_write_reg(info, offset, val);
 
 				/* syndrome fragment 2 = ecc[1-4B] */
 				offset += 4;
-				val = cpu_to_be32(*(u32 *) &ecc[1]);
+				val = (__force u32)cpu_to_be32(*(u32 *)&ecc[1]);
 				elm_write_reg(info, offset, val);
 
 				/* syndrome fragment 3 = ecc[0B] */
@@ -197,35 +197,35 @@ static void elm_load_syndrome(struct elm_info *info,
 				break;
 			case BCH4_ECC:
 				/* syndrome fragment 0 = ecc[20-52b] bits */
-				val = (cpu_to_be32(*(u32 *) &ecc[3]) >> 4) |
+				val = ((__force u32)cpu_to_be32(*(u32 *)&ecc[3]) >> 4) |
 					((ecc[2] & 0xf) << 28);
 				elm_write_reg(info, offset, val);
 
 				/* syndrome fragment 1 = ecc[0-20b] bits */
 				offset += 4;
-				val = cpu_to_be32(*(u32 *) &ecc[0]) >> 12;
+				val = (__force u32)cpu_to_be32(*(u32 *)&ecc[0]) >> 12;
 				elm_write_reg(info, offset, val);
 				break;
 			case BCH16_ECC:
-				val = cpu_to_be32(*(u32 *) &ecc[22]);
+				val = (__force u32)cpu_to_be32(*(u32 *)&ecc[22]);
 				elm_write_reg(info, offset, val);
 				offset += 4;
-				val = cpu_to_be32(*(u32 *) &ecc[18]);
+				val = (__force u32)cpu_to_be32(*(u32 *)&ecc[18]);
 				elm_write_reg(info, offset, val);
 				offset += 4;
-				val = cpu_to_be32(*(u32 *) &ecc[14]);
+				val = (__force u32)cpu_to_be32(*(u32 *)&ecc[14]);
 				elm_write_reg(info, offset, val);
 				offset += 4;
-				val = cpu_to_be32(*(u32 *) &ecc[10]);
+				val = (__force u32)cpu_to_be32(*(u32 *)&ecc[10]);
 				elm_write_reg(info, offset, val);
 				offset += 4;
-				val = cpu_to_be32(*(u32 *) &ecc[6]);
+				val = (__force u32)cpu_to_be32(*(u32 *)&ecc[6]);
 				elm_write_reg(info, offset, val);
 				offset += 4;
-				val = cpu_to_be32(*(u32 *) &ecc[2]);
+				val = (__force u32)cpu_to_be32(*(u32 *)&ecc[2]);
 				elm_write_reg(info, offset, val);
 				offset += 4;
-				val = cpu_to_be32(*(u32 *) &ecc[0]) >> 16;
+				val = (__force u32)cpu_to_be32(*(u32 *)&ecc[0]) >> 16;
 				elm_write_reg(info, offset, val);
 				break;
 			default:
-- 
2.40.1



