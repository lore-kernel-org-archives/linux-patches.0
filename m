Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015603;
	b=xWNSnlhLkb87licXE+pzb8USUmHFIuQUSve3ViyLR5EuoZalGlPKmGrb7be50exs5cdj
	 Qu51cztXueu7gnjFanQMgS2XY1bPiLz/era+sq2jabaK0rIeRa/fsyc/vsFnSmuoyk4yH
	 vhXUYJ/pDIUeomGyYm/AwDtxuc1Rex5sttlRl3KP0VandGRTqse9ZAa7QbGE8yJeSAJu7
	 YuQ9oU2HwtD/nVeIQXSLF4rKMBhcPrvyuyuk+3VfNFLFvFuIKPaiiueZjvCpYK4hFVi8w
	 +c4XeyQwHfkfbPuDrNQpTcDTBhHBprlgvyAfWLmmje4J1BW8Uvv3CuteF8URKuxTz4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZHuMXuABT+1RQALdohXl4WnF0/DBXMQR+XGSdOeufmQ=;
	b=xZiOj0oZaGmzALGtRI3cg/4OQPWKrygZyM+9Ktg7jeGV0oY3XNKDVLpt2Ev8CJON2Geh
	 /hguXFGO91QIfXnU8z/CqocjYWJE8Gug9/YM89mQlcaCTDfHDaeQ3dxiP1uZWMsY5jQbh
	 CSt3vKW5S1HH5D1uo0l3bt1ofFSl2vew8ebqR+KGVSu4qfCpYJUJVkt0tVlhPiopmONJO
	 gmKR7sNLvjGwezQu80vk/DDVADEAQ/D/ZvRAHd16egnBbVUJsVfHj1/Pf+wzjweDY4/8+
	 lbRiXyNLxaVdzHvPY0ZFkKyYQs3cMLgWKj462lHkYDwSISEaC1ygvU4TblTE37fodJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u3Dna0/h";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D368B606A31C;
	Wed, 18 Nov 2026 15:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u3Dna0/h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BA61F000C4;
	Wed, 18 Nov 2026 15:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015603;
	bh=ZHuMXuABT+1RQALdohXl4WnF0/DBXMQR+XGSdOeufmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u3Dna0/hzvg1wUa6FzIE+OwEV4CWaT+7CQG4vOWmNmkRMQybezzOrWgHSGAkj2tt/
	 qeJH0ZxVgNJSbJMizP1sCwNbvKRAvSjMsooJSf172M11L+BxHfCziEU6FmV2I3LUCZ
	 XBpE6+iJjQMCXuoPeK1TLZjoLpOR3xIz7EwAttnA=
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
Subject: [PATCH 7.3 0232/2651] efi/cper: Reject an error status block length that wraps a u32
Date: Wed, 18 Nov 2026 15:24:32 +0100
Message-ID: <20261118150256.211257328@linuxfoundation.org>
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
index 332c78f2d5617..3dcef618ad39f 100644
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



