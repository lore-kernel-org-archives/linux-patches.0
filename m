Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064634;
	b=UdMF3F+6VIOU5QkcxCC0EK/MW7oMBe2v+ryQ8ajwrof/4x8+1PkHLfM9DkADDD0HKy1T
	 nahqk97IuVWQov0Op8FRZ0Y4JR4BRcCd9KUqoDD47CIcY9mS3qiaB/CnvutKGxAURKUW9
	 06+wE3VvGMci75Q6lN8DgWsbJmcQoAcpwgb7/VFCWRhIIZh09ZIDRlQyohlLjnQ7R9r5i
	 8aCCIkSmTYwHmpvfmAMOBlYs8fQIpUGqCICidJuRCixyx233qRABymfyvv9j8RdGw+vFG
	 aELBf05gV5jgai2nJ6wLVIqBWIri8f9cIJfZxocsLC5rsR4KLZ525xHgUEOA8M4T0BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IvZlEnFz/ujguoD84inyN+AMa+JgJJz8lonvNjHLyTM=;
	b=Rc5vBSzNdFcCIsNx+uuqY924HkE7lHaTAjB9xUZi8DFIJyLANqLsNuJFYPE/KNvoJcsa
	 vd83gqsJ9v6wR9FtITh99Nyp/bjiCWJywepd1SkIXpTsNuykyi+26AFyqifaXuI7ikKjg
	 XRIB06DxZefN3RIFWZAePtdgxGFqLG0dkjZJL71KNUR2DPqmGNmEeZCIQ1MmlP3eHGChe
	 PS9YAwnv+8vEwSRSORuFXTLLODukMjlypocqM81qmbhNZaxUJcSDPGsy9vYKP0lr4j7Wj
	 u8FaHlzeKiOczVnRoQrXWwgIyxkt4n5LU4hXobS8f9dw4RojWNT0z5TgcjMmdOShgxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A69R7KQs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BEE606A9C2;
	Sat,  7 Nov 2026 15:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A69R7KQs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788441F0089F;
	Sat,  7 Nov 2026 15:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064633;
	bh=IvZlEnFz/ujguoD84inyN+AMa+JgJJz8lonvNjHLyTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A69R7KQs3y+FJJ654haZqgsCjhmfmekRQUuHi6VQhCz8lrw6JMjL5aO+aqHuikUo2
	 tD0ojBCvdV51tWlR/1VjI0B2JIPu8cOFwVhXz9srNwX2Ry5fwiQFiOwgu1llIdJdFP
	 MhqxsPTMWdYHWvo3uWaaTIkzcTxGy9tIpVO9uPZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0641/1257] ACPI: APEI: accumulate the queued flag across error sections
Date: Sat,  7 Nov 2026 08:48:57 -0500
Message-ID: <20261107134956.981987852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index fe10ab0e02f68..ec2d5ca51db02 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -603,7 +603,7 @@ static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata,
 		 * and don't filter out 'corrected' error here.
 		 */
 		if (is_cache && has_pa) {
-			queued = ghes_do_memory_failure(err_info->physical_fault_addr, flags);
+			queued |= ghes_do_memory_failure(err_info->physical_fault_addr, flags);
 			p += err_info->length;
 			continue;
 		}
@@ -951,11 +951,11 @@ static void ghes_do_proc(struct ghes *ghes,
 			atomic_notifier_call_chain(&ghes_report_chain, sev, mem_err);
 
 			arch_apei_report_mem_error(sev, mem_err);
-			queued = ghes_handle_memory_failure(gdata, sev, sync);
+			queued |= ghes_handle_memory_failure(gdata, sev, sync);
 		} else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
 			ghes_handle_aer(gdata);
 		} else if (guid_equal(sec_type, &CPER_SEC_PROC_ARM)) {
-			queued = ghes_handle_arm_hw_error(gdata, sev, sync);
+			queued |= ghes_handle_arm_hw_error(gdata, sev, sync);
 		} else if (guid_equal(sec_type, &CPER_SEC_CXL_PROT_ERR)) {
 			struct cxl_cper_sec_prot_err *prot_err = acpi_hest_get_payload(gdata);
 
-- 
2.53.0



