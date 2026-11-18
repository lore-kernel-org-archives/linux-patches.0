Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029128;
	b=TlPyu/c3WEPHmtcYoNZBmXygRB/JHypHNPSbFjG9zoa7pYiVauN2ro8hz6B+i0+rqx1J
	 xR+CFb5cCVP23rhUAT40bCgrv0Qgn8wHeTa3z07FIKSaoXy5DLmJ39vUGF9dWDed1XkNc
	 ptUnGir3LpeS47rDcOpTTArk1fTYzpVxF00qwXQOi+JBF3TPvzwP5EUOqrp/DR5TeZi0t
	 q7VcnC0iF7F50ZYp1bXiAw13ek0g9DzDnUAv6TsVYZs6BbUbfKutmm51flCgFPtvHo+gQ
	 WfiDkK8cgbEA55oZhxJiHqFXmNAdQCeybaoAB91GKe01CiM6l7c3vO7DXZOenqrtGKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=84thjLfmzMrVp9X25CpLhh8a1ut0xQ2iMA9+r71K0+k=;
	b=bM1a9lzM5gS/I1TlokxtC8y2h/feqzinWS+IQCvOryxHxuRD4hb/d7rSvKtNV1vdH1kI
	 UV8oWmD8v+vfADLr0AXOgBCGuhllLUMM3qbKjQDhUiA4o6Nc078srw2KxBqaBhazH1cqV
	 tv2cIrSpD0ShcZ9XrnlQkHXznM1pdyRGD9tz21rTtU8qjzxQfevu1WPCMu6BjvLoyyLYp
	 Uk/AOSUWf4j+c08mDgAp/ruIY2sLQIJWgipgT5a5EWCC4l+zcRFVohYl7y5AMAh6g1mT4
	 1L5yLaTVvCsleDUi7jjb+knIxB+3ZzRelDKL/rAWjzPhb7nnDy3zrlssu+fGwcmSS+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W4EtHmcB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0C1606A31C;
	Wed, 18 Nov 2026 19:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W4EtHmcB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA581F000C4;
	Wed, 18 Nov 2026 19:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029128;
	bh=84thjLfmzMrVp9X25CpLhh8a1ut0xQ2iMA9+r71K0+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4EtHmcBYsGRkXTn8vJTHMYVNHPWBA0bmY3+ZutHTPLau0k3slW/W05IEII4xcTlm
	 xf976eCCOrh8WijY/WuQOT83Kwpmomy2EMhz16VOUJoW+WoMni04dXqadzz6LTM64O
	 /RFAChTV/LFiKOYNPGsrzCmJcTB+sEnks98UT7+4=
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
Subject: [PATCH 6.12 0240/1756] efi/cper: Reject an error status block length that wraps a u32
Date: Wed, 18 Nov 2026 15:39:27 +0100
Message-ID: <20261118150017.888000923@linuxfoundation.org>
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
index c696a1c2cc39e..f8c4866c480d9 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -746,6 +746,17 @@ int cper_estatus_check_header(const struct acpi_hest_generic_status *estatus)
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



