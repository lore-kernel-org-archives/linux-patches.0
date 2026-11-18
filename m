Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059783;
	b=wYYys4/zUbCFvhIgxQYF8RO4rwx5xgjkcjt7j0vvFltvxGyQ5bpMS5aqvriNl6IlHwTk
	 DApQkMTY9tF31dBKPLQsdwLAyKkl/cf8HI8RSJTMgnc3IzYzlijF3hxnX2zFv9B+4RwVz
	 /m8TLFZIjbBlFGyG9fFEMuqJfSdqxCkI6jhs8D6twPZslIEVzQk9lQi8QblNkXRoaG0k2
	 Q/gzE8WGIhAEOA22HFNsi2ko+v9cMqyoeWs8Q9X9j8NifvwR1MapnQiTQ0OT0VyZiNslX
	 kfHO65tHprk0d0kYdSlbCmGMlOlJcad714IC19z/T6Cx6saKDNxlBnFpt9n9ZuPHT6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n2tppj1VPpEMX5pPpSayWSR18fEn69nDJagdq/F83OE=;
	b=P/Mft4X7C/E1NxWxHGis7iaUTi1wgxOy0i9pLuAfnjpQ16l++AOtHieBEANKffdMMvAP
	 K791Bxl7vz/2IqL42d/CfnInDJBgOSicbeNBgorZxYnzaKxALthbcEKVjudTGqjuxqc8H
	 pUJlDErJtoaqDKHSnUrRrz/4RnOxIbUjPwDZ2vsy3VVkVXutfEAMbnE0qs3dw4chJK118
	 VEQPHR+TN1G3+I5ztISvkW9kMJTTsI00x6LNyArWMMbAHGj0g3+Um/7KkUb6DCfpnQK3X
	 MEiUo3EmAaIyIm0B2qzADIwkjPpP+JqMwRHEALB6H+AAi97MN8esdqECkmUfnu1LEBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vzhWp9x2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDF9606A320;
	Thu, 19 Nov 2026 03:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vzhWp9x2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873C11F000C4;
	Thu, 19 Nov 2026 03:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059782;
	bh=n2tppj1VPpEMX5pPpSayWSR18fEn69nDJagdq/F83OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vzhWp9x2BdAM50TEnY8ki5BkOOfTmL6b4C2AX+tprp0N0g2byJsk2GmWgDb5mbWoF
	 GlB4YdaSJN+8aC4Oq5X1KoMkXldFGztcp87DuynBIZF7gaiSgucuWi4kTwICj7Rz08
	 qamjFM9lUlHyBLkNsXZaoeyTjsEM0pMc8JUOIFSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0964/1848] ACPI: APEI: accumulate the queued flag across error sections
Date: Wed, 18 Nov 2026 15:50:02 +0100
Message-ID: <20261118145957.322925291@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit f341307a14895e5da056fb419a31ef7fb534ab18 ]

ghes_do_proc() walks every error section of a CPER record, and
ghes_handle_arm_hw_error() walks every error-info entry of an ARM
processor section.  Both assign to "queued" instead of OR-ing into it,
so only the last iteration counts: a later section or entry that queues
no memory-failure work clears the flag an earlier one set.

Instead of reassigning the variable at every time, just do an `OR`, so,
if there was a single match, it will return "queued" as set.

The comment above the check says "If no memory failure
work is queued", which is the semantics this patch implements. I.e, only
SIGBUS if there are queue was not handled at all. If we want to SIGBUS
if any event was not handled/queued at all, we will need something more
sophisticated.

Fixes: 7f17b4a121d0 ("ACPI: APEI: Kick the memory_failure() queue for synchronous errors")
Fixes: ccb5ecdc2dde ("ACPI: APEI: fix synchronous external aborts in user-mode")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Link: https://patch.msgid.link/20260925-ghes-queued-accumulate-v1-1-df50553957d4@debian.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ sashal: adjusted context for the older bool-returning ghes_do_proc() implementation ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 88c01d4a7f8fa..29cece11ccb22 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -529,7 +529,7 @@ static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata,
 		 * and don't filter out 'corrected' error here.
 		 */
 		if (is_cache && has_pa) {
-			queued = ghes_do_memory_failure(err_info->physical_fault_addr, flags);
+			queued |= ghes_do_memory_failure(err_info->physical_fault_addr, flags);
 			p += err_info->length;
 			continue;
 		}
@@ -671,13 +671,13 @@ static bool ghes_do_proc(struct ghes *ghes,
 			ghes_edac_report_mem_error(sev, mem_err);
 
 			arch_apei_report_mem_error(sev, mem_err);
-			queued = ghes_handle_memory_failure(gdata, sev, sync);
+			queued |= ghes_handle_memory_failure(gdata, sev, sync);
 		}
 		else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
 			ghes_handle_aer(gdata);
 		}
 		else if (guid_equal(sec_type, &CPER_SEC_PROC_ARM)) {
-			queued = ghes_handle_arm_hw_error(gdata, sev, sync);
+			queued |= ghes_handle_arm_hw_error(gdata, sev, sync);
 		} else {
 			void *err = acpi_hest_get_payload(gdata);
 
-- 
2.53.0



