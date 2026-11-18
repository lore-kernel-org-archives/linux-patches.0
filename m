Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023217;
	b=4j2wAubJGDXHonkDZo1lKkz7nvVIqUB4eyn8TSWE3oGl7iuExCnS/GoFHbvXxOlb1v4c
	 OgYTyEt1QxGS0sJKX8mF12LFF36XquAEiuBLJWhF4y8Zz0BvojLuv+CFahx46ivGi6raF
	 k9/qMj1zR3I09xDevYclbDnVV/AKzJO6tTia4sbUQwWSlnmJ+Hr7H7rF4dlApEoX4DTHe
	 OLv2LeKBjbRt0mJFMJHdW/0td7PK9W0aNQa3Jssb5p6SIsoJgRfOVmrhw3aPNGIomwaFk
	 oGgFAwA+GEZoj4HVu5qYODO3pQBUzXwZEyvHVPiuvdVy7VFP/I3fzbXek9wD2BW6ASw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023217;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0pDPCT+HiPbPiAt2xAZifEKBq3nwX1k0B/gC7BOeFi0=;
	b=iw2n/a1noZcNyW07l8UoOuna3yQEtE4VcpTj8HgqyhsMO/qh10vjAc3AU65IsjxJW+CB
	 q8x5/YTe9oF/OBXSFLW5sYyzkOLx3iw2Jcc/n4855CrH1XCUgt/8Mobc3biMbnK9Td6ry
	 CWiDtV9eynLrkKLwV7rDfkvczCpbDNJL6NdPLYtxtcQssZ432carsuitkeNedCMurVCq9
	 WC6ahIT7BHsofOww7luwYQkALXV5johxvwMt7F70PJSX8+5c18QqMWFtgG2XkI4Z+7P88
	 6IKM/om04zDu/UhQ4maeGnjv+aqJS7e856rVEY1TQoePy4fsfgJ+gG1ZnoPMdPFSQWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KMo4ilEq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF148606CA51;
	Wed, 18 Nov 2026 17:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KMo4ilEq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F191F000CC;
	Wed, 18 Nov 2026 17:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023217;
	bh=0pDPCT+HiPbPiAt2xAZifEKBq3nwX1k0B/gC7BOeFi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KMo4ilEqaDZS14D9Cm6rgOGHxBLiUX+E+FsNgKd/APTQkDwRj3LDvDL027Gct18Xs
	 Tk9qAS/u+qdtk0B7+yBw6TH3/BlBGcYFCaNhOmKZjM3Jh0A/LeI34l0Q9jiGIJaLNW
	 EcVYrPG1nB1GBbHpMBaS49lrtsOKAnyw2XheXaDQ=
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
Subject: [PATCH 6.18 0244/2151] efi/cper: Reject CPER records with an out-of-range error_data_length
Date: Wed, 18 Nov 2026 15:32:59 +0100
Message-ID: <20261118150130.673747819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d4dc69693ece4..bc1d1fcbab865 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -752,7 +752,7 @@ EXPORT_SYMBOL_GPL(cper_estatus_check_header);
 int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
 {
 	struct acpi_hest_generic_data *gdata;
-	unsigned int data_len, record_size;
+	unsigned int data_len;
 	int rc;
 
 	rc = cper_estatus_check_header(estatus);
@@ -762,10 +762,18 @@ int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
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



