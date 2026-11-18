Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039318;
	b=uJm0cyyj6vJiGD75Y/97CCiknmP8ErV05JCZ68YDY3Qpjxc35X5Glh1enaiB5ahRJWdS
	 Nf9zUs6wxahMQLQkNvOFR/LS3LlTaZjAN+hy6BsXB5z9aV7EKJa/QkfzgsOOYqGvME94j
	 WaMf1FIYaxGmxXUgWtjiiucdy0Ed8168aSrgLjB3UeX/YJKCiedthMv2t+KQIk7CBY1Av
	 o9eM3ChlhERQh0gE1x00GCYgRsVyUWdBo/DJj1ux2ssf0zN4y+XMzMdr/WCVbRp10hzDa
	 dtk9Vl4FZXrK6hPfLtBblUipv1I8e+TYd2MFimJc8V38smhyg4h/iZnQ+nkDR8sSQxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Eh8kkubvvD1b6DEF4xiYb7EcuNZIYT6Wi4qIn95vxU=;
	b=Ip1f37A+fR/pvfL2mzCOV/K0T9TRWZtoNHtlWJCZpJBT0Tgw58162939a+GTw/thW8u4
	 7TMPDbdhlzc20rx/g4dvAGCfLFYZmwFptOcPncSo4gk4Yc8JYxwPovmivLBnoH1e4pgHI
	 D8dc88CLqbKn/XC9mTxBjHHaUnd0vZJjR4Yxa5bX6C+5c8gWxijlbLplfNhL+MfPdGH7z
	 fH7CdU8fKC8jsYD8KUsp8BCUwmQJpPj/6GniUmv7ApAp6CZC6wIWusfauJcd9tYXekMaZ
	 R644tCIufmafaMr/d5+VLLANTkyDa+jvc09oK2bltf1vQqsFtSwlSBa6v5Y7coikmpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YhCojeZU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9839606A320;
	Wed, 18 Nov 2026 22:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YhCojeZU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD3B1F000C4;
	Wed, 18 Nov 2026 22:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039318;
	bh=8Eh8kkubvvD1b6DEF4xiYb7EcuNZIYT6Wi4qIn95vxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YhCojeZUM2k1mwoXNR0GCogre3xMuCs4MlAVPgmpOprXRdfhkkU6sAMdTsLLqK8uf
	 7HqerpDFDSfQLjA3RF063V+YsUGirtKDmte/rFqipnBfqN4iW8ykbZnKRMxWH8kubG
	 fSN1i4C5v1zNgholan+Py3QvGFKw9n1g0FLQsM7g=
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
Subject: [PATCH 6.6 2059/3318] ACPI: extlog: Validate elog record length before walking sections
Date: Wed, 18 Nov 2026 15:44:41 +0100
Message-ID: <20261118150423.835605394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ca87a09391359..9d59b5f54b3d8 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -159,6 +159,15 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 
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



