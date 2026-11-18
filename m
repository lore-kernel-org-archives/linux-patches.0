Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054754;
	b=1/yHI3tReB/y/X6pKXjUaS9jLnKm2tQuRdEVEbvdE8oJOIE7qnWR2mFpvHMLk7kpkCIh
	 XPWKiyW9Z+abkw2otMV74UUXTMuTX7Dkaf2R0TNlx81fV1s8yGm5/egDMgq2fAECSczRT
	 PU5agtwsiUvqn0iZq6FtdVzBSGIweffEVvuzb4KJeEsP0Ndp0fkE5y2QPQUv4StmZXY8+
	 4fjjWYwSyjN1TtnIl2+6QuegYWsCNTUGbi7zMaCNfP4YdYhZS4lkuh5N/rBavf+NCp6oe
	 /pqBUaoNStnUo1+BpkwiDE97MVXzmV1R42VM0pzfYyZ1Yb8CjnXMOL3TxH+XfbSVAxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NuOX+Zu0QDPkC7xFrl0wdLAXfREgAuQJGBqLyq9zf+Y=;
	b=eaLEEaItzWhpRzWzNRGx3ja4/ovikE8cqaXnVIHH8xkLu7Xmv5vpFvXq+peXflMzCKVr
	 zfWXrerFGSblkas+9rv9bY+wGdz3IwLSPPFrZ0+movItth6VU4aO4tZQ4iNDbJ9geX7td
	 p33Gi+dcXbZM4V6BMLLzXilUrSxInBOFJ8k1QkCo0AlKRzpYbTJle2zVJyWxjHa2YEBWA
	 gwoOHgSF6iQ8+/ZNRvIEnopOXQT6XGUmb5/G0YlD/IwZm4khXmT+ZXWr2VWN+s4u7Z+qB
	 eAK7oQ+PcLQtR69EFl1WxDHoLdFOCjhENNKabnbBE/WPQSgjZ+eT1A46Rh6J0dyl+/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l39o6zJ4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0134606A31C;
	Thu, 19 Nov 2026 02:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l39o6zJ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CC81F000C4;
	Thu, 19 Nov 2026 02:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054754;
	bh=NuOX+Zu0QDPkC7xFrl0wdLAXfREgAuQJGBqLyq9zf+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l39o6zJ4iDWwXgvAUfYPA+1cfpcXhP5UKq/siD4mxvYpQ5oVRbwQLdV3u/Kz5DGB2
	 brU6umvwdCgeZ5kISJQbug2gvDR/bHApZlizyoQ5Vc5u4q/5zHZGe/z55uD1iID2Q3
	 N7ttPpq9/Rspzs0jRa+T0Be4Kx1SEUAUxokdZifE=
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
Subject: [PATCH 5.15 1388/2214] efi/cper: Reject CPER records with an out-of-range error_data_length
Date: Wed, 18 Nov 2026 15:51:04 +0100
Message-ID: <20261118150106.863884759@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d45f653502206..9d665e858036c 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -688,7 +688,7 @@ EXPORT_SYMBOL_GPL(cper_estatus_check_header);
 int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
 {
 	struct acpi_hest_generic_data *gdata;
-	unsigned int data_len, record_size;
+	unsigned int data_len;
 	int rc;
 
 	rc = cper_estatus_check_header(estatus);
@@ -698,10 +698,18 @@ int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
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



