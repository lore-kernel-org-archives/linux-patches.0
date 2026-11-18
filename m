Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030121;
	b=T3yYWIxs0vmOR5t12XOZPqPKZRv4qCtvGjH2z0L3lN4iCoNNQS/ddJWqW8vCHFAdg3CH
	 rwc2/ohGi2SqDkPGvYZlV9NryVhcCFB+yd5gNVoBBdBV+VS+UUS9G7xrCozseeHSn99AQ
	 I0DEHp7Vjdr5qjwv+TQFfDMgyVAiB7ryhkb1Tt1gjgd0z7+kTMvxLTG3dm+LolB5ECuKE
	 /U1fv/upZmE8OlCDahZOXTQ7yH1sXHjXmERQGgWiUG5usQ04QAylYMvx54WEO/Kr443GY
	 FlKOKhM11PCYi5u1OP7oYI9pq7SGvdm9lFg2GGEqKxgXmn8rdvNJRfO1zpgRvsQzeoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yd41dDpjCOkeKfWj1lfsuZDVivfdHn8Ll7Gp55JUirM=;
	b=tDqoWnyuOMwl6HrhlCn83tIwpZSisi11Qwv12z1q/o2/TSy/VoP86fyN7CxsLL/hTZbR
	 Pb7cZbkTZxHgbnZQlFeOq4JKXxa7BPjeyV3iKmg9GbGCb2d18P3EtsXwZEhCHtgd+qmx5
	 msKI4Tn6wBc3SXDYxblVg6FCjCK+Uu/mA1hdB1CcVnt+l2NhTzhtnfxXMrFzyWP3hSccY
	 axP7JJemI0PpHbkaEPzNa94rslLVQ6/i6eHFTn8JDCDbAOliNPV1zLdpyKZ1/f5iyFWkT
	 CCLpCkTdMRPocTUsFPYPgraOfB9CL+8K6v/X6T5YcT7BlqX1ufI85NOk35TA5qe7d9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XhXybUa+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20043607216F;
	Wed, 18 Nov 2026 19:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XhXybUa+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718931F000C4;
	Wed, 18 Nov 2026 19:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030121;
	bh=Yd41dDpjCOkeKfWj1lfsuZDVivfdHn8Ll7Gp55JUirM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XhXybUa+WOLueSy//AjwGN/057dcJdY0jgw1N235A0R2lPw1FmA5CpRTndWiZJMoz
	 ztmb68wNi3tI4iM05L9ZZK2o75QZ7MRM3c1DYAKI6GCv/O7Rp01JgIh3bvNOd7wzJx
	 BLE166fhpaCoXmruqGflH5ZbYpXcWP/S7Cb0AI1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0591/1756] ACPICA: Fix memory leak in acpi_ds_create_field()
Date: Wed, 18 Nov 2026 15:45:18 +0100
Message-ID: <20261118150032.533251848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit dbb3d99ee95c32711950850ddd33eb22a6042eb2 ]

acpi_ds_create_field() allocates internal_pcc_buffer for operation
regions in the PCC address space.

The function runs once per field, so a second field on the
same region overwrites the pointer and orphans the previous buffer.

The matching ACPI_FREE() in acpi_ut_delete_internal_obj() only ever sees
the last one.

An arm64 platform whose SSDT declares regions with multiple fields each
leaks two buffers at boot, as detected by kmemleak:

  unreferenced object 0xffff000051e65400 (size 192):
    comm "swapper/0", pid 1, jiffies 4294668436
    backtrace (crc 0):
      __kmalloc_noprof
      acpi_ds_create_field
      acpi_ds_load2_end_op
      acpi_ds_exec_end_op
      acpi_ps_parse_loop
      acpi_ps_parse_aml
      acpi_ns_load_table
      acpi_load_tables
      acpi_init

Do not allocate a region if it was previously allocated before,
preserving the current design, but, not leaking memory.

Fixes: aa6ec56b574d ("ACPICA: ACPI 6.3: add PCC operation region support for AML interpreter")
Link: https://github.com/open-acpica/acpica/commit/c71849d476bb5f97ca1867849e893368e12a69e6
Signed-off-by: Breno Leitao <leitao@debian.org>
[ rjw: Subject tweak, fixed the Fixes: tag ]
Link: https://patch.msgid.link/20260925-acpica-pcc-field-leak-v2-1-e37008e715af@debian.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/dsfield.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/dsfield.c b/drivers/acpi/acpica/dsfield.c
index 532401ecdab0c..9009f4a3022e0 100644
--- a/drivers/acpi/acpica/dsfield.c
+++ b/drivers/acpi/acpica/dsfield.c
@@ -522,7 +522,8 @@ acpi_ds_create_field(union acpi_parse_object *op,
 	}
 
 	if (info.region_node->object->region.space_id ==
-	    ACPI_ADR_SPACE_PLATFORM_COMM) {
+	    ACPI_ADR_SPACE_PLATFORM_COMM &&
+	    !region_node->object->field.internal_pcc_buffer) {
 		region_node->object->field.internal_pcc_buffer =
 		    ACPI_ALLOCATE_ZEROED(info.region_node->object->region.
 					 length);
-- 
2.53.0



