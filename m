Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047896;
	b=F+Uuk8iOSvvGG4bBzUR9ZKSpwxmFPP92u6wJj9JXJnsjBIp+SRp8FMGP39DdmbXgiVvm
	 YcdxWVr0jQj2vjviillQSVVM8j5YxrCx3hK/MboW3WzBTyycQIKAo6MtDC38fvg2YZA8X
	 UaPE4NXdM6sszqs5UPDhidwLiwEXa/mZ78/zhe8+qLOPsOKPgwXEb6fwPEjmVFMEui37M
	 6P4e91yYZkC74I75Zf65c7XlNBPHitjnJVQxVFmRJwY7GWfAEi7D86sh+EFisMsl+wcD4
	 CnN1BnlftjVgx4WXKPzMNlYTXhm8xHvCL/Cyw3Le8IujZ7QKhAtAl7FTo1ok6zlQT6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IaE6nTrFm24tYzY609nHW1NIGynwwI+8GhI7rHpErWE=;
	b=IA8DCJ8Fda8HFg8IDUhAQq59fJfEpwvoCHmxjHu/U28+vuyK8PDkk87u6O0PgLSpxk+E
	 tWQbQC/kilrkSLNkCKetRLT3gKDD2C/ZXpHo96f7fOHjLl7T0PMFC0jr9Fnv0CclEtedr
	 IL1pXNb024o4jH1lubQQvE1SGD5DE2fe+zvUJcECLZQKZoUAVHbwmDu6b2554ccEliVd6
	 MGxaDdOnU1KSgbIb/zB0HQkN6N4x7dZFuU4DCrkwAcyUEBSPwC8HvhcyaSt8+HOTWHQBs
	 KzatOv/iu/37Rgstfg9PdLql/j4MWRivN8sveCxo4MkHkHW80ldcCFqSsEgla0X5Hww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q8WHFR0h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A35D606A32C;
	Thu, 19 Nov 2026 00:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q8WHFR0h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8691D1F000C4;
	Thu, 19 Nov 2026 00:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047896;
	bh=IaE6nTrFm24tYzY609nHW1NIGynwwI+8GhI7rHpErWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q8WHFR0hk3pEF5pcdcCRqHyKfRH57RchUAZSqQs9tlHm1IhRlo82KTi6vJP0dqKyi
	 +hcxEOkrFd+E4gcoiHi5aA50JLEE2W6OKI06QeyOeMIXb5GXMImPYFCyF589YxIdjS
	 Qn9kmv+HW5b1eePwmt02RFGL5mZ1NdQAlcoIEHKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Hanjun Guo <guohanjun@huawei.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1801/2857] efi/cper: Reject CPER records with an out-of-range error_data_length
Date: Wed, 18 Nov 2026 15:47:15 +0100
Message-ID: <20261118150306.100739148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit a5a612cd3eecbadf135df1e9b2b40bc9f4c28f1c ]

cper_estatus_check() sizes each section with acpi_hest_get_record_size(),
which adds the firmware-controlled u32 error_data_length to the header size
as a signed int (see <acpi/ghes.h>). A value in the top sizeof(*gdata)
bytes of the u32 range wraps the sum small rather than large, so it slips
past the "record_size > data_len" check: against the 72-byte v300 header,
0xffffffb9 sizes the record at 1 and acpi_hest_get_next() walks it a byte
at a time, off the end. 0xffffffb8 sizes it at 0 and loops forever.

Use check_add_overflow() to reject a sum that will not fit the int those
helpers return, since the walk advances by that value. That subsumes the
"acpi_hest_get_size(gdata) > data_len" test above it, because record_size
is never smaller than the header.

The later "len < sizeof(*foo)" guards rely on this per-section upper bound;
they are lower bounds only.

Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260714231835.303081-1-dave.jiang@intel.com?part=1
Fixes: 45b14a4ffcc1 ("efi: cper: Fix possible out-of-bounds access")
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260904172337.1409775-2-dave.jiang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/cper.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 8669d1e8d84df..b12212df2e890 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -716,7 +716,7 @@ EXPORT_SYMBOL_GPL(cper_estatus_check_header);
 int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
 {
 	struct acpi_hest_generic_data *gdata;
-	unsigned int data_len, record_size;
+	unsigned int data_len;
 	int rc;
 
 	rc = cper_estatus_check_header(estatus);
@@ -726,10 +726,18 @@ int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
 	data_len = estatus->data_length;
 
 	apei_estatus_for_each_section(estatus, gdata) {
-		if (acpi_hest_get_size(gdata) > data_len)
+		int record_size;
+
+		/*
+		 * The <acpi/ghes.h> helpers sum these as a signed int, so a
+		 * huge error_data_length wraps small rather than large and the
+		 * walk then advances by that wrapped value. Reject a size an
+		 * int cannot carry.
+		 */
+		if (check_add_overflow(acpi_hest_get_size(gdata),
+				       gdata->error_data_length, &record_size))
 			return -EINVAL;
 
-		record_size = acpi_hest_get_record_size(gdata);
 		if (record_size > data_len)
 			return -EINVAL;
 
-- 
2.53.0



