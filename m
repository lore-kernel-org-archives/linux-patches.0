Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040505;
	b=FwovXmVqBfhCT3LKqEIiQB2UIogATqRQ3I9GG5WbwNfeL4ORcLd2+XeWa7IISNVKFsEy
	 ABjq9jn4nVvlMwdEZIJCTA1PE8y4V1WLUlsAA750K4teAoPuFa7ixrvp0MP5tpkxVMD+J
	 xwdI6Xl0xBHCMXzT5J+VBrg8xYjgOdm5E/Pw0oaT6+r+j5S8NnBadHPV22YV6u4QAhfjB
	 uFAulRadpQu9cfGwxn5FXyGrUAWascYNdAuXuFdTDJxz4yCPpEfvHoHVQh3PLSX6FKbGt
	 gnPL92A960Kd3V8Isq3+iQzHl7y5IBoM+RF2wz73828bynzH+Z0JXMDWYzQmYhTs3vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zvqsYfhuOA1SrULL5A4/l6L4yeOXKM0afjkeq5A1CY8=;
	b=5Qza+v5jg7l0vmH8Xti9tJ8sKpDhpOuJI/jjtMAIz14S8FJ4/SpaNPsBd/Ih8UDWVKrC
	 XRSUh4BcuCkze4CZtUlu79Jzanncitzx2xUESnXht4ixGZeeIyWoe7F4pUSPsFagnu5eC
	 GaXOptuMHqedq51GzUjDEDKjm3FS/WYc53Ki1Hjzp2iDlgshyAl4ezsrYZ2/W+9fwmKwJ
	 jATLStjMmE5RDvP5tp3X8QD9hHcprW9aOHd19ZVOgMUNe3KcTThg6nnh8sxpujHHysWTw
	 Y1JTOAPcGI7cAMJreL04uPBj+Teo9oZWPLJ0XrX87esSpCY1l6snILxJXJnGGh2TxSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RfBXgelC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188EC606A31C;
	Wed, 18 Nov 2026 22:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RfBXgelC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4D81F000C4;
	Wed, 18 Nov 2026 22:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040505;
	bh=zvqsYfhuOA1SrULL5A4/l6L4yeOXKM0afjkeq5A1CY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RfBXgelCs10DHTuz+OojKw222kK5tAMVkkw4Wag2iE5lxp61FlPkQeZcs6kGPw9cr
	 uZDLnvhfNp6erYz2KHKPxh+x743JSCY0/GTcxBGfY/HCzDptSAYcZUswwqptxJ0Cfd
	 9t6qDciKYpMOk7jWBPBE/hvSAKVKOoSjc7zZV654=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Ricci <io@r-ricci.it>,
	Matthias Goergens <matthias.goergens@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2480/3318] x86/hibernate: Ignore page-zero RAM in E820 checksum
Date: Wed, 18 Nov 2026 15:51:42 +0100
Message-ID: <20261118150435.804196392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Goergens <matthias.goergens@gmail.com>

[ Upstream commit 29671cabfc09afb1ee2426b21173cdde276a95ac ]

The legacy kexec_load path reconstructs the E820 map exported through
sysfs.  kexec-tools leaves the first 1 KiB unavailable for the real-mode
transition, so a kernel entered through kexec_load can see conventional
RAM starting at 0x400.  A subsequent firmware boot reports the same RAM
range starting at zero.

The hibernation E820 checksum compares those byte representations and
rejects the image, even though the maps agree from page one onwards.
A QEMU guest showed this transition:

  firmware:     RAM [0-0x9fbff]
  kexec_load:   gap [0-0x3ff], RAM [0x400-0x9fbff]
  firmware:     RAM [0-0x9fbff]

The checksum covers e820_table_firmware, which trim_bios_range() leaves
alone.  The nosave regions come from e820_table instead, where
trim_bios_range() has already turned conventional RAM in page zero into
reserved memory, so page zero never occurs in the image, whatever the
firmware map says about it.

Canonicalise only the conventional-RAM portion below PAGE_SIZE before
calculating the checksum.  Preserve RESERVED, ACPI, NVS, UNUSABLE, PMEM
and all other E820 types so that changes to exceptional mappings remain
detectable.

This is deliberately narrower than Marco Scardovi's June proposal to
checksum only RAM and its opt-in relaxed_memmap successor.  Rafael
noted that ignoring non-RAM changes could hide moved ACPI or UEFI
regions still used by the resumed kernel.  This patch preserves every
non-RAM entry and ignores only RAM within page zero, which common setup
already reserves and excludes from the image.

Bump RESTORE_MAGIC, since the checksum semantics change, so that an
image written by a kernel without this change is refused by the magic
check instead of being compared under different rules.

In the same guest, with the page-zero difference kept, hibernation and
resume now work after both a direct boot and a kexec_load boot.  An
image written by an unpatched kernel is refused at resume with
"Unrecognized hibernate image header format!", and the firmware-booted
kernel carries on.

Fixes: 62a03defeabd ("PM / hibernate: Verify the consistent of e820 memory map by md5 digest")
Reported-by: Roberto Ricci <io@r-ricci.it>
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Link: https://lore.kernel.org/all/Z-hYWc9LtBU1Yhtg@desktop0a/
Link: https://lists.openwall.net/linux-kernel/2025/04/04/1372
Link: https://lore.kernel.org/all/CAJZ5v0jmOj0WBtMTvbnaD+2b0bTFowA=JWrqRzaaCYpHpai1Nw@mail.gmail.com/
Link: https://lore.kernel.org/all/20260623165724.10753-1-scardracs@disroot.org/
Link: https://patch.msgid.link/20260926052117.3613637-1-matthias.goergens@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/power/hibernate.c | 51 +++++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/arch/x86/power/hibernate.c b/arch/x86/power/hibernate.c
index a7ec9b8e2f6b9..15382e4e69ac6 100644
--- a/arch/x86/power/hibernate.c
+++ b/arch/x86/power/hibernate.c
@@ -62,6 +62,25 @@ struct restore_data_record {
 	unsigned long e820_checksum;
 };
 
+static bool trim_e820_page_zero_ram(struct e820_entry *entry)
+{
+	u64 lowmem_size;
+
+	/*
+	 * Page zero is BIOS-owned and registered as nosave.  Boot loaders may
+	 * therefore omit part of its conventional RAM entry without changing
+	 * any memory available to the image.  Preserve all other E820 types.
+	 */
+	if (entry->type != E820_TYPE_RAM || entry->addr >= PAGE_SIZE)
+		return true;
+
+	lowmem_size = min_t(u64, entry->size, PAGE_SIZE - entry->addr);
+	entry->addr += lowmem_size;
+	entry->size -= lowmem_size;
+
+	return entry->size;
+}
+
 /**
  * compute_e820_crc32 - calculate crc32 of a given e820 table
  *
@@ -69,18 +88,38 @@ struct restore_data_record {
  *
  * Return: the resulting checksum
  */
-static inline u32 compute_e820_crc32(struct e820_table *table)
+static u32 compute_e820_crc32(struct e820_table *table)
 {
-	int size = offsetof(struct e820_table, entries) +
-		sizeof(struct e820_entry) * table->nr_entries;
+	struct e820_entry entry;
+	u32 crc = ~0;
+	u32 nr_entries = 0;
+	u32 i;
+
+	for (i = 0; i < table->nr_entries; i++) {
+		entry = table->entries[i];
+		if (trim_e820_page_zero_ram(&entry))
+			nr_entries++;
+	}
+
+	crc = crc32_le(crc, (unsigned char const *)&nr_entries,
+		       sizeof(nr_entries));
+
+	for (i = 0; i < table->nr_entries; i++) {
+		entry = table->entries[i];
+		if (!trim_e820_page_zero_ram(&entry))
+			continue;
+
+		crc = crc32_le(crc, (unsigned char const *)&entry,
+			       sizeof(entry));
+	}
 
-	return ~crc32_le(~0, (unsigned char const *)table, size);
+	return ~crc;
 }
 
 #ifdef CONFIG_X86_64
-#define RESTORE_MAGIC	0x23456789ABCDEF02UL
+#define RESTORE_MAGIC	0x23456789ABCDEF03UL
 #else
-#define RESTORE_MAGIC	0x12345679UL
+#define RESTORE_MAGIC	0x1234567AUL
 #endif
 
 /**
-- 
2.53.0



