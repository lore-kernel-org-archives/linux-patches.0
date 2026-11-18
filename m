Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038618;
	b=Tte7t0lZNKQSwhlDe7zUFX2eOxXiS7sC7PiMyimeFjS1JEqeJ1Qjh+7u0v4H9nCnf1s1
	 cirGC7AVCE2MtuFP4AxuOk1G+hf3AGMI9jvLmM8VnF15W5S4FlFAbnTh5qwiiV/1u6dQE
	 bbqEoV7i9g6KSOllKI2mPyoFJ6vRvK6VynsQSf/YEJaIZNntlZzrcftHNsSkujI2ilNZB
	 ZNlOusjMMlazS7HyyhsfWEqYpldDmN/RuCiArvwS9ADon6d63ZMDRCKpk6bW9sKQtJLFC
	 Fy/H4rABUj3pIkYn1mFJieNPCeAFZnbYc9wvO+e5eYDL/kZ/dUNNKVsKS6Gv9A93wBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+f+j2fmVNG+tSajwpaj/Tz9NRZj/YsAOda0S1xA/V2U=;
	b=D7/9z8agiasexY3MyWMZYwF6vKrpGHuZ8IbDGeDDySYzoqlGer92pdhrRDI2IMX7ZgxH
	 Ipq66guG4laVcQlCsavKqp6zPHtfyXfWtBfo+Z7HkWDodCjvQA5d8J3X6A9mhhmUibjLp
	 0MA9fDhzIner8HSodBVXKt6I0hZSPa4mhYcSbXbJZJu9euI1w19IA584MnhslqqWXZBbp
	 mAkNhCPb4H68uoJo6u5srUif58zPu6sm51tHd1LIML1zXDFQPpHfXN+0/E8bySt7N0hmp
	 jRcVs6edkjeBHZLe/Z/mRaZGEeiILyenpeKJuALZV6kCTPsKA+qFwtokLWqzbz5tQ+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0V2ZzsUm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2153606A31C;
	Wed, 18 Nov 2026 21:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0V2ZzsUm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4DB1F000C4;
	Wed, 18 Nov 2026 21:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038618;
	bh=+f+j2fmVNG+tSajwpaj/Tz9NRZj/YsAOda0S1xA/V2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0V2ZzsUmnAIt7ing+3lDzq8W7ofecZMkJcXJf2/kBY3sYrCQXNGE2/jjBH1RMLwwO
	 sVT6u+ko6VX6nph4NSsnb6mCk0msTbF/dDqnXdogmAIaoosSoPLGueeDSFVaYZ609n
	 797NvFm3BbhplTIDRv7xuMwbhlkw4cMeq+mY3bOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1807/3318] ACPI: APEI: accumulate the queued flag across error sections
Date: Wed, 18 Nov 2026 15:40:29 +0100
Message-ID: <20261118150416.063657934@linuxfoundation.org>
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
[ sashal: adjusted ghes_do_proc() context for the older else if chain without CXL handlers ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 36917a7613d06..fd491c5476dfe 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -557,7 +557,7 @@ static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata,
 		 * and don't filter out 'corrected' error here.
 		 */
 		if (is_cache && has_pa) {
-			queued = ghes_do_memory_failure(err_info->physical_fault_addr, flags);
+			queued |= ghes_do_memory_failure(err_info->physical_fault_addr, flags);
 			p += err_info->length;
 			continue;
 		}
@@ -706,13 +706,13 @@ static bool ghes_do_proc(struct ghes *ghes,
 			atomic_notifier_call_chain(&ghes_report_chain, sev, mem_err);
 
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



