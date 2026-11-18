Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023229;
	b=KqnN7UU75RgEN3EVC2KZxdU27R9SyVH5wf4enAjPpV0PLJZSq1Y1MhVDRuYKlwszJosy
	 riGTPhoJZGK+82gH3LHrsdVhPzWjF7x/iTTPW8fzXIXckSiP/zLuDWQrDqHw1WL08p8yB
	 q///6N/DdpEBAqUoVIkSwaeF2jPxHPCnzCEKI7x5DvX6sbsXzQJFxhu1g+FRKv/dxUOLB
	 bwrvb9a6QR2FtJRVzuaE9yXLpp6bNT7FLF21U7oD4at1ShQGgz9iQWXf2DsaTGW7NnQJY
	 UCQzmAIViWxLpj9r+/hYObz0kSDZ7/UU+tQbidImLPaL3mPtyMALhWbWfYxbtjNwHug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E6bIoBv9hbJw5g0nGIl9oqeUcuJay0w5pWs/dyv5Y7U=;
	b=lnwYPh8LdCkllK3T0vzUdIAjUTmYJU3VP9ahoKpLTnBxad4uUGwrSc0EfbfDd6KjZTfd
	 WME8JhltJtUhLwq54NFbmq5xKOEFOBafk4ylYUGa4GsshjK+Tz1umGNuj7Jk4DbxkDhHB
	 T7IAbRjrAzJ1ovZrm/GjrFxY8FPMibae/xDo2SwkbedxuqhEYvtXuNWZIlgaV3xsV8wwH
	 SnmxYufRZAk/xEL0XCzK20UHe/seTd6HibIa2xBjaC68+26n9d9aeUz501uvaKbB8QNZ3
	 L6an3vL/FW+MnNE5fO9Ad1H1f0oBal3UxK87xhb+cxs+UVsxM+6e5nSgpVdKc09b4xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TduuPvhR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECEF606A325;
	Wed, 18 Nov 2026 17:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TduuPvhR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA941F000C6;
	Wed, 18 Nov 2026 17:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023228;
	bh=E6bIoBv9hbJw5g0nGIl9oqeUcuJay0w5pWs/dyv5Y7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TduuPvhRb1nKOlCA9vhk5WQRVn/gAKdNEzJHiuaaaYwQ4XciGfaVINTCBdT2iMpzo
	 IQqcgImPY0Y1J7xV+xEQmPsU3mFnYBjhSFDvGhPTdOoPKGy/tGtFmot5EYk9OAmEE7
	 52x3JBsqoPVvsEIAdxaE0fkCG+i4fEsYTxOMCrHI=
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
Subject: [PATCH 6.18 0245/2151] efi/cper: Reject an error status block length that wraps a u32
Date: Wed, 18 Nov 2026 15:33:00 +0100
Message-ID: <20261118150130.711719060@linuxfoundation.org>
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
index bc1d1fcbab865..254f0564a5778 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -745,6 +745,17 @@ int cper_estatus_check_header(const struct acpi_hest_generic_status *estatus)
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



