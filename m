Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060932;
	b=Msqx5qISXobQ/FYNvlHBReqBZKEq2hiVI7exYk7Nf7E5wOMOn5ZDpUYo5Hrs3lOMpEe0
	 VPVt27gH8xSdmM8RVmf5+gKVLEqABNdnPmsbABqRnlrIVhIfzElE8FbGvuv81+NrFgGkN
	 q0BW72N7G8/ymq1WBWiM0ZqEjARJf7+AjvWidPQrZFB5Romg+HI7t35bfX0Cw37CJKKWM
	 vFUyzkeXYN5NPffx30/6NpqEwN3bZve7l5uWl25puzhj/FOONv+Ru6uXwrqLbFy18wvsA
	 e+HFLEzOASpVCWtjDPmGTDB0MDX+tpHOHVJu8di4Z+BKgwggpS1jfZtpSHBbY/vrq2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EX20CXYSEpSegSBKr4/fAQlBHq/bzvIMhpUlJeH2USE=;
	b=E8lB0a12hMB7z3n6o2fetUUfcgyGJrWrGucyaiE5xnKjdDFhvVHVvw1FHd1565r5trJd
	 lqErqQzVio0fKr5LFhh6ePIoThuH6/8wT8DTd1gmd1TBaJmX3E4ZcHeyZZHGZtJ3XYMBm
	 pR8iirXbxWooq3ji9I8ADeKKDxWAtCbkBq+NB6oPbk1vHOMtkE/gQ7AJersg4pX0gmMmu
	 yty/U/Skz3AzJlbJzKf5LAHFwA58L7uQOGgFEEHiwt+268CLq8z+jFAfLMJIaqTW/zDA+
	 mxbk1K5H6eCOu5SJfUritYpZfQ6GdnihKmOR/tCbU7EpjERh4UWxyXz4GeuTtCw3XTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=th972L1V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E091606D819;
	Sat,  7 Nov 2026 14:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=th972L1V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285031F0089F;
	Sat,  7 Nov 2026 14:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060932;
	bh=EX20CXYSEpSegSBKr4/fAQlBHq/bzvIMhpUlJeH2USE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=th972L1VIP8LVxXo8XPpRQy7gEaKuE8IfN+c/EuPKFIR/LfyhebpOBXS8IMLBd0h1
	 rnH1NDU4Pckx28x19mLHo8BGrBFbpE3VTcUsDymOSyEIG6dTMlbhwexIt/4ShCG4Yb
	 AtH1UtaeQmslgRmi0HQT1rHFOdohHvF4nkGIHVxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@h-partners.com>,
	Wupeng Ma <mawupeng1@huawei.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0290/1536] ACPI: APEI: Handle repeated SEA error storms
Date: Sat,  7 Nov 2026 08:38:26 -0500
Message-ID: <20261107135005.876557163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Junhao He <hejunhao3@h-partners.com>

[ Upstream commit e61487226b7df39e5f4683b036ee6aa7a5039d7b ]

When hardware memory corruption occurs and a user process accesses the
corrupted page, the CPU triggers a Synchronous External Abort (SEA).
The kernel invokes do_sea() to handle the exception, which calls
memory_failure() to handle the faulty page.

Scenario 1: Memory Error Interrupt First, then SEA
The page is already poisoned by the memory error interrupt path. The
subsequent SEA handler sends a SIGBUS to the task, which accesses the
poisoned page. This flow is correct.

Scenario 2: SEA first, then memory error interrupt (problematic scenario)
If a user task directly accesses corrupted memory through a PFNMAP-style
mapping (e.g., devmem), the page may still be in the free-buddy state when
SEA is handled. In this case, memory_failure() will poison the page without
invoking kill_accessing_process(), and then takes the free-buddy recovery
path.

After the CPU returns to the task context, the task re-enters the SEA
handler due to the same access. However, ghes_estatus_cached() suppresses
all subsequent entries during the 10-second window, preventing
ghes_do_proc() from being called. This suppression blocks the
MF_ACTION_REQUIRED-based SIGBUS delivery, causing the kernel to fail to
kill the task immediately. Consequently, the process keeps re-entering
the SEA handler, leading to an SEA storm. Later, the memory error
interrupt path also cannot kill the task, leaving the system stuck in
this repeated loop.

The following error logs are explained using the devmem process:
  NOTICE:  SEA Handle
  [Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 9
  [Hardware Error]: event severity: recoverable
  [Hardware Error]:   section_type: ARM processor error
  [Hardware Error]:    physical fault address: 0x0000001000093c00
  [T54990] Memory failure: 0x1000093: recovery action for free buddy page: Recovered
  [ T9955] EDAC MC0: 1 UE Multi-bit ECC on unknown memory
           (page:0x1000093 offset:0xc00 grain:1 - APEI location: ...)
  NOTICE:  SEA Handle
  NOTICE:  SEA Handle
  ...
  ...        ---> SEA storm
  ...
  NOTICE:  SEA Handle
  [ T9955] Memory failure: 0x1000093: already hardware poisoned
  ghes_print_estatus: 1 callbacks suppressed
  [Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 9
  [Hardware Error]: event severity: recoverable
  [Hardware Error]:   section_type: ARM processor error
  [Hardware Error]:    physical fault address: 0x0000001000093c00
  [T54990] Memory failure: 0x1000093: already hardware poisoned
  [T54990] 0x1000093: Sending SIGBUS to devmem:54990 due to hardware memory corruption

To resolve this, return an error when encountering the same SEA again.
The subsequent SEA handler invocation uses arm64_notify_die() to send a
SIGBUS signal to the task, which terminates the process and prevents it
from re-entering the handler loop.

Signed-off-by: Junhao He <hejunhao3@h-partners.com>
Reviewed-by: Wupeng Ma <mawupeng1@huawei.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20260527082707.2013499-1-hejunhao3@h-partners.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index e1cbc35919cbf..03cf3d63e609c 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -1267,8 +1267,16 @@ static int ghes_in_nmi_queue_one_entry(struct ghes *ghes,
 	ghes_clear_estatus(ghes, &tmp_header, buf_paddr, fixmap_idx);
 
 	/* This error has been reported before, don't process it again. */
-	if (ghes_estatus_cached(estatus))
+	if (ghes_estatus_cached(estatus)) {
+		/*
+		 * Return failure on duplicate SEA entries so that the
+		 * subsequent SEA handler invocation sends a SIGBUS signal to
+		 * the task to prevent it from re-entering the handler loop.
+		 */
+		if (is_hest_sync_notify(ghes))
+			rc = -ECANCELED;
 		goto no_work;
+	}
 
 	llist_add(&estatus_node->llnode, &ghes_estatus_llist);
 
-- 
2.53.0



