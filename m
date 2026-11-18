Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054760;
	b=lnMth98+MDqTSBMfjFL484A0BoFp92mt+AoSFcKpKyyX6iafcDNyceQDn3WC79g2ULs7
	 WFQFPhJFgaMg6Hbc/i1YJMik/jumwAy7bon6R4DTwWxUJnB/vRFczcWBcnYk9p6F9/T7s
	 AHGceO6JqXQohLqm2b+BNOynz/leSidxYMEGNy5lzjv+oZcRTrT0lk1ipXdl0G8bb7rYt
	 I74vCqcPHP5mqawtztp6rdoYzpQIM5rIzAGFBipgCdjMFE3Mq3MRc9hGEPw8SZK3MeO1l
	 +V6i6gHP/cZgS4LJ9wlZ54E/o7vTv7DMDJ2gKE+gnAwzhkoRYRLQQwNpE0ORV4Kof7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K+oc9eB6xlQ6EAiLRhFceeLMVorWe0dZ+/AbS9Gi7hE=;
	b=dw3HEcHKpic0NpBhW6CLvovqwY0seWOMkvUy1g992NGEf/HDgsM5sHZFf8xck6Y2oS47
	 N68IpLOwKeSCghF0G142aFEnwokV4A49kUrpGD5is0ikCD+wiP5V5CyYcMuHc8aetyk8W
	 u/j6hHhVezYVsjzqFEiyQwAmI5CUNQsAZYATpgm9IDEWmbmIjdUhjO1oG1ZbAwpUjJNGq
	 IzTmtOk0fcEELmKke/P91ocjXw6u97TILsH79aMdrJVbpZkRWa3WtA4fTSWE4gsZA6ylh
	 bu1ytZUQgwxDBsv29PKAe9G0Dc31tcCrgwGyBhjCUzpRilAdj4diNMjd0H/6twuugwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rlt8h2U+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34625606A32C;
	Thu, 19 Nov 2026 02:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rlt8h2U+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511F11F000C4;
	Thu, 19 Nov 2026 02:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054759;
	bh=K+oc9eB6xlQ6EAiLRhFceeLMVorWe0dZ+/AbS9Gi7hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rlt8h2U+mNidYZfkHlj9nyl6BIZBHDAx8C51GvW2A6QRFEa4P0NdKN+z6MFyMPtKu
	 /U2JJJw/s7UsSEhJX3mCAEVMTRFYl45SjxFnsp4WWGqPsmNEndrFeMDqxHv1RX4oPo
	 CCwxSlQD58eAXachZj5Yh/6nXwpKWOZmPjbpguGE=
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
Subject: [PATCH 5.15 1390/2214] ACPI: extlog: Validate elog record length before walking sections
Date: Wed, 18 Nov 2026 15:51:06 +0100
Message-ID: <20261118150106.933821074@linuxfoundation.org>
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
index 0a84d5afd37c1..6384426847674 100644
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



