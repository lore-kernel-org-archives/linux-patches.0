Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015609;
	b=jdYe3JJ4NfXV+X9hhCO7/dJ+72F7mCZ30TBdoFoxbb4Nh6Kg324dOe5AHMm+cN7BO9jn
	 68GUnAlkVjp0Bwoa5+4xIRrSzZAutm1skKV3IlP3YQh9cPeSHuACRBnoO43Tub1OM4S1D
	 MXomshlLCwhINhRmmS47j0GdIXhgCEpiPQeoRwY43tSppsYgY8hJNr60H7XqWusYZSbPm
	 vSDGqc2Or87VoK+duzp1yhyOez8Y/2ZZOTeIlyIKOJjHf51PpHqRW7bCiCACetSAQJJDU
	 jK/u2BlgiMRbPypOduvTFW4L6uNnaBaUqOGJJgkaHH8iZZg/IO54VhLQ9OBw2k1+tkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gLcuVMmyrwtfPc/gDyl9aaTthzr0AsESZccpgZhoCm0=;
	b=FryWG8tlbpu+BsJPOiRE3ZRzTxQoTGQ9pqUC6uvjsg8T8dKiYBVSm4q9LM4c1O4+zy6M
	 ZX8HhSm2DqleZz3q2acoM93Aa1RP5ef8eGZNRJqkAxY48ANnMcovO/PYtEkBIxfSwzior
	 +oZT/2cp97xjQHefersYm7bSnkmbGj69+BVOzY7JID8yxK/Vr9UEHsEWRRYl61M+AzFSv
	 llSY3Bv+B926+yCRtYT14NtwJ+TYYldYTJ0i00gz3HK0wjoTGQjFkmj3/Z12pZGVnyrUD
	 PQGiWtK/NlmUb2L+uKERZd9n9wESND2Ky504wiuUcKeaIZXATYr/FUVHwv/tywQP1TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CCxsA/9L";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E60C606A320;
	Wed, 18 Nov 2026 15:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CCxsA/9L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16851F000C4;
	Wed, 18 Nov 2026 15:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015609;
	bh=gLcuVMmyrwtfPc/gDyl9aaTthzr0AsESZccpgZhoCm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CCxsA/9LY3jiHwuqkPqVD+jPMBs8cPADJLS5OnBZ1uSL8j4zNrjcAdOH3joIOoDKA
	 hmFKoOQdqDAHqEOaFldrckIyIZoQhrAYJU33eawQtMnGZw5d831G1D5kAUYCLE9qcU
	 uv2Y787bavQ7Zf1uC/MLe5R5ZPI4mDlqWVa6k9ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Alison Schofield <alison.schofield@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0233/2651] ACPI: extlog: Validate elog record length before walking sections
Date: Wed, 18 Nov 2026 15:24:33 +0100
Message-ID: <20261118150256.246420116@linuxfoundation.org>
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

[ Upstream commit e1fd582a8134150aa10c1f0286dbce00cf63b086 ]

extlog_print() copies a fixed ELOG_ENTRY_LEN (4096) bytes from the elog
record into elog_buf, then walks the sections using the firmware-controlled
data_length. Nothing keeps data_length inside the buffer, so a malformed
record walks the section pointer past elog_buf and reads adjacent memory.
Unlike the GHES paths, extlog never calls cper_estatus_check().

Reject a record longer than ELOG_ENTRY_LEN and run cper_estatus_check()
before walking the sections. The length test alone is not enough: a wrapped
length reads back short and passes it, which cper_estatus_check() catches
via the header check added earlier. Drop a malformed record with
NOTIFY_DONE and without MCE_HANDLED_EXTLOG, since extlog did not consume
it.

Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260714231835.303081-1-dave.jiang@intel.com?part=6
Fixes: f6ec01da40e4 ("ACPI: extlog: Handle multiple records")
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260904172337.1409775-4-dave.jiang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_extlog.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index 7ad3b36013cc6..046e92ee195f9 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -208,6 +208,15 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 
 	tmp = (struct acpi_hest_generic_status *)elog_buf;
 
+	/*
+	 * Bound the length before cper_estatus_check() walks the sections: it
+	 * iterates over data_length, which is not yet known to fit elog_buf.
+	 * cper_estatus_check_header() then rejects a length that wrapped, which
+	 * the bound cannot see.
+	 */
+	if (cper_estatus_len(tmp) > ELOG_ENTRY_LEN || cper_estatus_check(tmp))
+		return NOTIFY_DONE;
+
 	if (!ras_userspace_consumers()) {
 		print_extlog_rcd(NULL, tmp, cpu);
 		goto out;
-- 
2.53.0



