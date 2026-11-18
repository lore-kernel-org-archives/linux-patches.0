Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054757;
	b=X9voWvVbV9VBqGxy/VAIXeAjU7cdNJwdjy1s41ETONPn7zkfl/s5LD4jjqVKOSy6eB/9
	 SZcM3LQir8tNzo6CscoselSByS5uv1HZO0vHUnqgRk29423rpwQ/HdRDjoZ0znYJhR0LK
	 9VgnA7DzEP51N6CEACM1yptIY0pGrWGOMeO0pGGINClc4RN/aCSzDY0aM7++Eq3OWDoUu
	 68h0DK0c4g46swWuZWarvi54t1HeVMfW6S/C3pFIUBBYeXVb7zclvbUJ7Vjpo2WP/4MwG
	 Zq2i8SHowYmvrXcImSpF8lTaztBYsNX9sw+s4TPa97av27Ej5lLXKx05cbXjUY3dXKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yl3Dfo9M/rkD0NvOjCLQ8l6D83LGQNSt8Fj2Q4MUkdM=;
	b=wohU441h7CYgbATpNTSNFfEO/GzP5M4u1kfVtdQlFzRm9JhjxJYP0Jw/IUzri36j//t0
	 O1ZaT/O+6H1gc6NgArImqZ/8WejGKhv8lS6KmIQHBGLns3J7JYQlN42dbYptMI45LG7qc
	 ZUHIiy6YGkQUZQ9/VxSZXyEgEt96GS+5G6JHcgsufUzzmMm3Lu5URgl46+pbF1U9FJGuq
	 U1VkRh/MdP9WIH0bZdUUNy/840LUd73XlW0ySbo51PDvZ3DMEresKbXRZ5Fvopo2Zfgrj
	 e+wjMyFwuVdjEHuIhFPHbc7EjNY2Jnq/FYlIpos5VB2Oy/ZyhmZl7yURKFJZXyECvlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rg8IQREg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3985A606A325;
	Thu, 19 Nov 2026 02:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rg8IQREg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841391F000C4;
	Thu, 19 Nov 2026 02:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054757;
	bh=yl3Dfo9M/rkD0NvOjCLQ8l6D83LGQNSt8Fj2Q4MUkdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rg8IQREgnzwbdGo/N5sAo9r4X9WKK+6U8wCma3Wfm5ei8CetG1n/FRuu4pSateW0c
	 /64HbXnVw27P+Z+9tGVCreH67E+A09AGECjQg99SxcY/wQGqf+squE9PY9HvWMiK2g
	 QSLi7Us6ZbledgzVL915q4e0LISTMgjctE2GUDOQ=
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
Subject: [PATCH 5.15 1389/2214] efi/cper: Reject an error status block length that wraps a u32
Date: Wed, 18 Nov 2026 15:51:05 +0100
Message-ID: <20261118150106.897279312@linuxfoundation.org>
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
index 9d665e858036c..057813687d14c 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -681,6 +681,17 @@ int cper_estatus_check_header(const struct acpi_hest_generic_status *estatus)
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



