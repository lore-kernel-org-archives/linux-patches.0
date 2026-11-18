Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060357;
	b=fdwwwJgMtSIOH+EQUbZIXIe1ugyJyKvXnKCSKUEZ6bP6kNS+/OCCOYlL8mgMb7pu1Lle
	 A+Po/6sDTAJmrDlIbsUZQO99UCZl2UCjSVuV7KBIJr1H/XASbzY0lsCzEM/Q9r9/44FDl
	 S3DoXBqJbXuugoZZ4Grx2WqL8Dn3RiMbxD56iRj9llBeWIDhl2W29uma/tvS9KI0qo/us
	 Th+BA0JGObmA3ShJOLpPlNcs1WgeI63TOt8+o2F7XLi0Ciw2NI0dSa/2XioDSM9L2SKqp
	 bLbL5wHlSlq/1rxhXchdJdf0PCYXCBm3hO5OGfXdLFFQd/U1Lo9Z0VyR7tenDLEw5Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m0erdV8JdWfCuSLGg/BGMiAzjPpd118CTX7J6089jrE=;
	b=mBcbwiilXqW0icVJpp2Ykj2GF4DRyGFPHcyfKxzuzTwSzlpKe72oh/d4ZsqjgX3eTmYh
	 nRRbnVsbiWko+6dmIRHg+QmpByOAVfrTDSpMZ/zJVmH0y9U/2JyIAUkmhjOQrhv9mFmHQ
	 U2Yy1TZY48ZSxfhE5sCVmwKrLCStPWLlLg5W/to0rY3wLnCGgXvOI0SPfBoqqZPks8bWN
	 V0/D6u6JGtIWBoRTFmSq+Eff2H7ewQuv7/AZERjKxfU6A8iWp7UbDZECp7nYv6zRErAUz
	 t+T5rtfLyKhCVkIeXPHni7+7qWyIPmpYyx2vWF6AYfTxMhAg18X2oxRrool45YB1Cfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="v/8U8BNy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6296B606A326;
	Thu, 19 Nov 2026 03:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v/8U8BNy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9121F000C4;
	Thu, 19 Nov 2026 03:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060357;
	bh=m0erdV8JdWfCuSLGg/BGMiAzjPpd118CTX7J6089jrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v/8U8BNy9fQiNo6jCOOHgdW0rvYyMtK1oL3IusEE5sqCUFIXvHeWGdmVpTZknCQiP
	 C2T6/IuvOwzBvuXoT8ejfm0UdH3TeT2z9/djFwiQa0EkK4rY0C03mw6u+/Uz/s0coa
	 8dWp8rqhQcS649N8EN1hLwGQUp1g1kncJge5jW8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1170/1848] efi/cper: Reject an error status block length that wraps a u32
Date: Wed, 18 Nov 2026 15:53:28 +0100
Message-ID: <20261118150008.614983838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 41e25ef5e417c62eb7bf39b187242b283b3ef9f1 ]

cper_estatus_len() sums the firmware-controlled data_length (or
raw_data_offset plus raw_data_length) into a u32. A data_length of
0xffffffec wraps that sum to 0, and a length that reads back short defeats
every bound built on it: bert_print_all() passes its "remain <
estatus_len" check, then advances "estatus += estatus_len" by zero and
loops forever. GHES survives only because __ghes_check_estatus() rejects a
length below sizeof(*estatus) first.

Reject a length that cannot be expressed in a u32 in
cper_estatus_check_header(), which both of today's callers reach: GHES via
__ghes_check_estatus() and BERT via cper_estatus_check(). extlog reaches
neither yet; a later patch routes it through cper_estatus_check(), whose
ELOG_ENTRY_LEN bound needs this to hold.

Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260714231835.303081-1-dave.jiang@intel.com?part=1
Fixes: 06d65deade9a ("ACPI, APEI, UEFI Common Platform Error Record (CPER) header")
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260904172337.1409775-3-dave.jiang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/cper.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index c540d521ee6c1..44a4efbbf26b9 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -682,6 +682,17 @@ int cper_estatus_check_header(const struct acpi_hest_generic_status *estatus)
 	    estatus->raw_data_offset < sizeof(*estatus) + estatus->data_length)
 		return -EINVAL;
 
+	/*
+	 * cper_estatus_len() sums these into a u32, and a wrapped sum reads
+	 * back smaller than the record. Reject a length that cannot be
+	 * expressed so no caller is handed the short value.
+	 */
+	if ((u64)sizeof(*estatus) + estatus->data_length > U32_MAX)
+		return -EINVAL;
+	if (estatus->raw_data_length &&
+	    (u64)estatus->raw_data_offset + estatus->raw_data_length > U32_MAX)
+		return -EINVAL;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(cper_estatus_check_header);
-- 
2.53.0



