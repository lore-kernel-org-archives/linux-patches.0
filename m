Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061841;
	b=35RBePvwc7MySXtLPWuOTII/W1rt4E386Qv6RTxiyjvcuo2gJcuG9bTs4+tPryddQ0z9
	 mifqiqpizjUUnVhjOF91KdyrUivw6Mp+r+C9pFhoV2aplLa6RjM3gmoZPlLbGMYCR5P0v
	 3cvVM1a0TcrbD2O5KCdH61gh8rR0uPq5pG4wDPrg6gFcywIaWNRFHeLoOYrXyy04j2oYv
	 7CdfZMOUctpQOxQysvH1qJ95jdQG6gwnxkPMJV8czaxbvmENDPPXSpD1tHVSo+My2bDlp
	 B3X9ntMKwg5+dJOe0T5LxQJWBAODCgzJZ832biZNuwR8dRjbPmWxUWzw4t6om8/aGEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UsZhs2xXJ2OYoNgoz7um3bSMKgVzJa5k9lS2Rmo7A7A=;
	b=wb+xUqpKA3+QDwIHz0ZyP78vV4UfGZEAJSnBJ9blApA+XuQA2DmD2dTCLFw7eK/+whfh
	 BKe7+wBepMDZxtqeEwqRy/bMbXGU168UOm7BdLKQ5C2NClA3w8sx+9Do10wF8qdZdP5b9
	 mNX7GXhm4/DIFABX3Q5IB9kXQT8CukN+cMrtxYgyQBJY+4xypv+D3F9ZU4gUHLLdKbYZ9
	 9m3zh3uEtkqlYpfAHjx/uo493D4I+sYol07sG9JQS0WO4yfb/E5vXBI3ER70Jw46PCCKS
	 cHq73ldgc1w10KlWPuktN9g5h/bRUJ1O6+ZQBKeo5bPSJZO+uhWJCqjxic4s6G4ff3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iSBbYySg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7980606A326;
	Sat,  7 Nov 2026 14:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iSBbYySg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6775F1F0089F;
	Sat,  7 Nov 2026 14:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061840;
	bh=UsZhs2xXJ2OYoNgoz7um3bSMKgVzJa5k9lS2Rmo7A7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSBbYySgHDliRL5/sSomFxWctcXWQcBL2JtyU5J0g6qUt5NpL4a1jOXhCYXWO29wE
	 UNN9ouOmAUAeelVZmKP/rhaOedIq+PML9KhI4UcUZDz/0HLHFPaUlUpG4JwstHTCRG
	 C3XvjL5+MPj1E9fq3Zux47KgeIcrbVaN1YcICdGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0859/1536] x86/mm/pat: Use pr_warn() for early W^X warnings
Date: Sat,  7 Nov 2026 08:47:55 -0500
Message-ID: <20261107135021.676572094@linuxfoundation.org>
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

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit ea6fd393cb9e6811a748c7551de0dd3090f9dcde ]

Nathan Chancellor reports the following warning:

  CPA detected W^X violation: 8000000000000123 -> 0000000000000123 range: 0xffffffffc0400000 - 0xffffffffc0400fff PFN 100e00

from its_alloc() doing set_memory_x() during early retpoline setup.

The warning is not factually wrong but it is unproductive. First, the RWX
permission is temporary and fixed up by execmem_restore_rox(). Second,
at the time of the warning, all kernel text is mapped RWX. So there is not
even a transient actual security issue.

The right way to fix this up is to relax RWX detection during boot but
make a final verification pass over all kernel page tables before running
userspace.  There is code to do that today (debug_checkwx()) but it
must be enabled explicitly in Kconfig.

For now, retain the warning even if it's unproductive, but make it
scream less loudly: use pr_warn_once() rather than WARN_ONCE().

Remove the warning once debug_checkwx() behavior becomes unconditional.

Closes: https://lore.kernel.org/all/20260905044253.GA3816371@ax162
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://patch.msgid.link/20260913-fixes-verify-rwx-v3-1-5e1d6a08bd02@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index e3a20be305bdf..de8f065706518 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -647,6 +647,21 @@ static inline pgprot_t verify_rwx(pgprot_t old, pgprot_t new, unsigned long star
 		return new;
 
 	end = start + npg * PAGE_SIZE - 1;
+
+	/*
+	 * If the kernel text is still RWX, gently complain, this could be a
+	 * false positive.
+	 * Once debug_checkwx() becomes mandatory for CONFIG_STRICT_KERNEL_RWX,
+	 * the warning can be removed completely.
+	 */
+	if (!kernel_set_to_readonly) {
+		pr_warn_once("CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
+		  (unsigned long long)pgprot_val(old),
+		  (unsigned long long)pgprot_val(new),
+		  start, end, pfn);
+		return new;
+	}
+
 	WARN_ONCE(1, "CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
 		  (unsigned long long)pgprot_val(old),
 		  (unsigned long long)pgprot_val(new),
-- 
2.53.0



