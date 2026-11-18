Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017383;
	b=K37RNwxWbnt3NL1iU2BDg36dnPFhjuToFjwm9BjkgSKTYYTDRCY3WFuxXU2ANixBgsLD
	 iKEcNQlKnaHbP65k5E/+AGMmQu3QFmu18eCf+eZSslhrNxeSoBXroI9RNexgAVJ9gh/s0
	 /lRWPz/h7TEREOKSXtYJXdN+ZqAOvNjxQoeKMaTNYi6Sy3MwUyhIibBuhbG1PvmyBE6X3
	 hC0+5yt8ZVHDtL9ePciN6kB/whmWMeeeR4Pms8WT7t2ZacJtJPjp3U3NKZtOHMSF6bBtH
	 1PZePbphu+X5YeguYmdCuArAqMqG6xopQuVfaTgOfxMu2b9zo8k+wCeMDMqJ5RdjWfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5hId6e0WZtZ8gOma9JW7RIev4A1x31a3+u2zUUUyL/Y=;
	b=w6laSBaxYQqsB7dPWO9dsg9FBnmW4fQs/k4lWYqeapNqql+CP86GozBH9wxLDkmGIAtP
	 LT4DcuDqHX/rj7xjp45/dt64eMDIaDfS1X9R1fdrA75a2pxs7Woa4ny8y6iMwRINwq+2+
	 wEBMPc4exAWkOtOLA+bWLDSsncssZwDsO8npRBFMBa4QbWajGaqLtyA0slBLtD4Bz/cU0
	 2V2O65QSEzAQWJ4qoiVNEJBxc/+jjO7VIHv+bod/lTWPDCy5Rp0DU62OPIYfyXZ1q/d8Z
	 L2EAsEWS4r4TcHENHdZuwAk/R+EqNJ12aRAHorTrrsgrzROj5j2mYt2pT+P2jI4Xd6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H4a54yu8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B4160A2601;
	Wed, 18 Nov 2026 15:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H4a54yu8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72C51F000CC;
	Wed, 18 Nov 2026 15:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017383;
	bh=5hId6e0WZtZ8gOma9JW7RIev4A1x31a3+u2zUUUyL/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H4a54yu8oMBTigJd9BxXoAVa5j35elDO8cj5e5wqJcBqQaLGgcI+uaYGTS5znoPIR
	 S0KxVzXZZtNOveLs7bBtQ6EZKuvMycse60xfs1i1gMGmxvT3fzQoQ/otNk2jiD/Iuq
	 SF9oTOHiedQqGHgeaP768/F9mTsKuP7z9Sm3nQ/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0863/2651] ACPICA: Fix memory leak in acpi_ds_create_field()
Date: Wed, 18 Nov 2026 15:35:03 +0100
Message-ID: <20261118150318.929435996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d7d56cc600d31..f7e503bf57c87 100644
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



