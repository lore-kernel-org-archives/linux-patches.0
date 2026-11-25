Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618087;
	b=X7CkNwOYNT3ID/XXyqKVisCteJQAZhKxKrEQgTUMkE6rT2sFEoC8YqQvkaDOYSvBI5lm
	 Hz3XUb7mESWRGNZ/5GOwOjyi5vMUtDxhWmgSrsH2vFkL78bm3f/ERZD34HpDrEBEb6Xgt
	 yEKbwysT4sr5twdime1vdTmKYzA8itSGGhOqFs3MqOJZ43y5mFVYk7q7TaW+FniyQnEBA
	 AcdSZJqHK53iWWHkvvjIJgmv9OyEgaS+zEs0Fuw85GRNEQtvHfR7Wk6QnTouGPwZV2UCq
	 jtObhf9pxtvIL9I3/TM4nEnoOMbcNuQ0uGpk7g86f1Uhf5t8t9ZAYoKMVdt8pnEXm7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=tW9R3KVTbJCd+iXUKendANAArCpImA2YaEne1Nduv+g=;
	b=schxHd86rrHe3ElbU25lYD/JUTbpcMRacBF6UJ2wI+Xvy590OUrYTTowv9KEoDY6XvDf
	 ifpQg9Ou3rRc1yEb6S9i48UZuIITGV9Z5iJkv0VOU+Gw7jukGzO9/nMMUAExVTJiCjf9n
	 sxiorv9jeY/NAjaDOEr0ScXmBlS+yzc4lM+rFWkkRIcWknHjGV/qRPjZbJmmOLBDilZ3U
	 BkPVdWc/8804NeLbGUdaq1kNQmBqAd77pZZV8EZyx87eV9JnGJuccezeOuSQZK9kGP3Ug
	 +2LXd3XA/LRQpGnAl238vwlRAKRzq3iDodoVnss70AgPGRHDAZPzOgEsxnF9BYcFAEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i+NPfrRG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC2A606A31E;
	Wed, 25 Nov 2026 14:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i+NPfrRG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E54E1F000CA;
	Wed, 25 Nov 2026 14:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618087;
	bh=tW9R3KVTbJCd+iXUKendANAArCpImA2YaEne1Nduv+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i+NPfrRGpoMEMN58yDHsHiTaHFunCdgk2Yr9EZcRFLNNeCVdzM6AfyCIOiJiCqmn7
	 V4r2+EjLbduX+yAva1ruxdBrZl7NC3Solipf6+smPC/j9vHKv8bJwCp8YQ5EVzX/U5
	 5kaf+x9f2uJiGyLneFk0ZPbFWsV91ig6Xq0A/8rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0122/1005] firmware: coreboot: Dont skip CBMEM entries outside of known memory
Date: Wed, 25 Nov 2026 15:24:20 +0100
Message-ID: <20261125143824.598907786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Kopeć <michal@nozomi.space>

[ Upstream commit e094fd05defaf0b05774ea1c65fc2d0ab798c809 ]

coreboot leaves CBMEM out of the /memory node of the device tree that it
passes to FIT payloads, e.g. LinuxBoot on arm64 Chromebooks, and only
lists it in the memory reservation block. The kernel has no resource for
that memory, so region_intersects() reports it as neither System RAM nor
Reserved memory, and since commit e31ecda9e3af ("firmware: coreboot:
Skip no-map CBMEM entries") all CBMEM entries are skipped on such boards.
That loses the coreboot log, the TPM event log and everything else that
CBMEM devices expose.

Also accept entries that don't intersect any memory resource. No-map
regions are still skipped, as they are IORESOURCE_MEM resources, as are
device regions.

Fixes: e31ecda9e3af ("firmware: coreboot: Skip no-map CBMEM entries")
Signed-off-by: Michał Kopeć <michal@nozomi.space>
Link: https://lore.kernel.org/r/20261017090351.1266064-1-michal@nozomi.space
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/google/coreboot_table.c | 42 ++++++++++++++----------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/firmware/google/coreboot_table.c b/drivers/firmware/google/coreboot_table.c
index 25ee8cf534290..6b2ea781ddf77 100644
--- a/drivers/firmware/google/coreboot_table.c
+++ b/drivers/firmware/google/coreboot_table.c
@@ -114,6 +114,30 @@ void coreboot_driver_unregister(struct coreboot_driver *driver)
 }
 EXPORT_SYMBOL(coreboot_driver_unregister);
 
+/*
+ * Whether the memory of a CBMEM entry may be mapped: it must be exclusively
+ * System RAM, or exclusively Reserved memory, as CBMEM often is on x86, or
+ * memory that the kernel doesn't know about at all. coreboot leaves CBMEM out
+ * of the /memory node of the device tree that it passes to FIT payloads, e.g.
+ * on arm64, and only lists it in the memory reservation block.
+ *
+ * Anything else, such as no-map regions on arm64, which are IORESOURCE_MEM
+ * (see request_standard_resources() in arch/arm64/kernel/setup.c), must not
+ * be mapped.
+ */
+static bool cbmem_entry_is_mappable(const struct lb_cbmem_entry *entry)
+{
+	resource_size_t start = entry->address;
+	size_t size = entry->entry_size;
+
+	return region_intersects(start, size, IORESOURCE_SYSTEM_RAM,
+				 IORES_DESC_NONE) == REGION_INTERSECTS ||
+	       region_intersects(start, size, IORESOURCE_MEM,
+				 IORES_DESC_RESERVED) == REGION_INTERSECTS ||
+	       region_intersects(start, size, IORESOURCE_MEM,
+				 IORES_DESC_NONE) == REGION_DISJOINT;
+}
+
 static int coreboot_table_populate(struct device *dev, void *ptr, resource_size_t len)
 {
 	int i, ret;
@@ -149,23 +173,7 @@ static int coreboot_table_populate(struct device *dev, void *ptr, resource_size_
 
 		switch (device->entry.tag) {
 		case LB_TAG_CBMEM_ENTRY:
-			/*
-			 * Skip entries that are not exclusively System RAM or
-			 * Reserved memory.
-			 * On ARM64, no-map regions are filtered out as they are
-			 * IORESOURCE_MEM (see request_standard_resources() in
-			 * arch/arm64/kernel/setup.c).
-			 * On x86, CBMEM often resides in standard reserved regions
-			 * (IORES_DESC_RESERVED).
-			 */
-			if (region_intersects(device->cbmem_entry.address,
-					      device->cbmem_entry.entry_size,
-					      IORESOURCE_SYSTEM_RAM,
-					      IORES_DESC_NONE) != REGION_INTERSECTS &&
-			    region_intersects(device->cbmem_entry.address,
-					      device->cbmem_entry.entry_size,
-					      IORESOURCE_MEM,
-					      IORES_DESC_RESERVED) != REGION_INTERSECTS) {
+			if (!cbmem_entry_is_mappable(&device->cbmem_entry)) {
 				kfree(device);
 				continue;
 			}
-- 
2.53.0



