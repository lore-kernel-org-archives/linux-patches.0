Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830903;
	b=Ojj/TnJjqRyxx7zhEIC93RyyOga/Aym5ZUbRHEGWdQgulVttcogiLiRrZZdZvzRj0jyH
	 alhMLX9NmmtXyiw9Cp42nVL3OBNHKtNrhKY9VIcua1Vtq3VAA+YIc9rAUZejbXHXrSHI6
	 MJaYTSF0QwOfyqtqs660cfMKI4VW8qM6bVYOqoc0SKXouGxetWEol3llsmXalCxbce0YV
	 WGynZcNfOZ1y5cB6UUtwv9VZQ7Ob6g6y5Djmn0WGM4eLvnv1pdk2RwZvdXTUeXxZDJX5c
	 Xvf1PyifBM1GdirrL8Ks7G8t7ZzxdseSD9YKgnpF8KQ40So1f6Lfgs7KF+M5ksZuyRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F87LpK+Hietc9shomr0M534xofCD8NLPWY8Ps11k4Cw=;
	b=dbI5GxYwpelIDVuol1QmQ0hzseh53+CpQ+D5JMkH7T32Etmt0lWMKx7vn1vdN1KQaSDk
	 tDkJgmAqs7w889uIJrrwfvapZ80UN6Mg/oXWephThzlXL4ajnfNltxkNjmwklD5L3hrjJ
	 FmjH6ujDJzjRQY1dcGhyH21qa5IX18/j+rq94DIuu0U9eDQ19DzVxtN1ye+PpncpacIzt
	 fSAPy7KvtG5rNvi8TGAp6mW0x+1Tl9Er0o/R3ZApZFxZ8pb1OWpVPZJkxKyFwITFgXzNN
	 c3hyUuHWAg+llgoY9ctUYdMU0Xb1eJ0hO1t7lAZ9DZuECU6ljv1nO5YuBMzxZ52uZ7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TzXRlllX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54991606A33F;
	Wed,  4 Nov 2026 22:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TzXRlllX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B261F000C1;
	Wed,  4 Nov 2026 22:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830892;
	bh=F87LpK+Hietc9shomr0M534xofCD8NLPWY8Ps11k4Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TzXRlllXxDUB2tS0ojyjqlJ4H9WcpR8+3HPkMs4KAMpsz7AhuBsENkOc6EXkRXV0h
	 bkOCYOib4Af+7ISSPEAuPKe9WKIKqwQyvRkFnduyhj3vSMxBNnFizeGLsigkNyes1o
	 hPgkwaVgqq60mMMkgFWiZfwRtzKVrmteEhu6lRUE=
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
Subject: [PATCH 6.18 0352/1005] ACPI: APEI: Handle repeated SEA error storms
Date: Wed,  4 Nov 2026 16:01:25 -0500
Message-ID: <20261104211053.933533814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 5b52455d86e02..1a77aba0475be 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -1371,8 +1371,16 @@ static int ghes_in_nmi_queue_one_entry(struct ghes *ghes,
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



