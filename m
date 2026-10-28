Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214833;
	b=mNW1EA0FQCUqHqOi/pXDYQX+rZDSYBJXR/yzyOj7PX8DTd5WjyAaejd3qsIPYcwzXbX6
	 h/tY65wdBk5yYHozEmVCS2U9DRkTZMZGNl5NjvrB1SN7CXYOYW8D4BIlvlLc5w9+c+lQ5
	 tsUG+i0ehuK7mrM7qsZyN3VqFY4MTf7lVR/DikfwB8IMmxmJ2Do+AgUo1k9cakUhKwouE
	 6WB7H2Ve7uSHmUAk/k0RaEoSon1oId4T1xgpvOEEwDNj1+5ocExWOwjWNVVWGpJcx74qN
	 KASSk4r5TEQ608Q/KRWhdrMXnZQ3QITVbRlfLlaMmT1YSGmno9flMOCJ4JvQxQhuBOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/kCEfvt0rRJxx1fWcpTmeDd3L5CXcrdBUXgZ0+h2KwI=;
	b=2coH/GzEKRFwoTNr5UWEej2kI/YYLAwWREbu/aDG4RvIMcLMyduCnSGzV53epsWCcn4C
	 9/Voc20XlYsRW5NLpEdsloO72dEGqTOBlifAWy3XyaVaJscvD8a3Mv/BMweD8eqmxRjgO
	 EjDWdFyfVAe9YPG3LPweFKRxczxgfYNQXPzeBGoFx9xAwHUhy4KUy0siN/SHL8apg+Ntb
	 G+W8beqP/+kHhoF5NZKSFHhXxpVA4opvhatJFL5ssHkCxJgbHP66SlXeGweNCkKrqctEr
	 cbSSS+xpc/F03yCgQLCWaZmUFNNwJey6P5HLc1mWavYdKW7cYQUQcQOgPsg5WXqgePg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILZAT9+n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E48B606A320;
	Wed, 28 Oct 2026 19:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILZAT9+n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA601F01825;
	Wed, 28 Oct 2026 19:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214833;
	bh=/kCEfvt0rRJxx1fWcpTmeDd3L5CXcrdBUXgZ0+h2KwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILZAT9+n8FLY8o6LJTVrsQ2W1M+otnmkaIHHeDhK23Lo+oHLHFL+o5VcpggfrgdIp
	 vyWEXwVaIA4Qk8IAqDk32k9z/O8PMnIVbUdR3Y5B9jWYfpkizoBUhr2TCBNB+ubXju
	 mLNpKW3qR7foDh9b7uJSC4xiO24K9ufHvMt0hOR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0954/1887] s390/mm: Add missing secure storage access fixups for donated memory
Date: Wed, 28 Oct 2026 17:50:50 +0100
Message-ID: <20261028170521.115943749@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janosch Frank <frankja@linux.ibm.com>

[ Upstream commit b00be77302d7ec4ad0367bb236494fce7172b730 ]

There are special cases where secure storage access exceptions happen
in a kernel context for pages that don't have the PG_arch_1 bit
set. That bit is set for non-exported guest secure storage (memory)
but is absent on storage donated to the Ultravisor since the kernel
isn't allowed to export donated pages.

Prior to this patch we would try to export the page by calling
arch_make_folio_accessible() which would instantly return since the
arch bit is absent signifying that the page was already exported and
no further action is necessary. This leads to secure storage access
exception loops which can never be resolved.

With this patch we unconditionally try to export and if that fails we
fixup.

Fixes: 084ea4d611a3 ("s390/mm: add (non)secure page access exceptions handlers")
Reported-by: Heiko Carstens <hca@linux.ibm.com>
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/fault.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index be6122b0e6d15..dc0aa423e142e 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -855,10 +855,17 @@ void do_secure_storage_access(struct pt_regs *regs)
 		page = phys_to_page(addr);
 		if (unlikely(!try_get_page(page)))
 			break;
-		rc = arch_make_page_accessible(page);
+		rc = uv_convert_from_secure(page_to_phys(page));
+		if (!rc)
+			clear_bit(PG_arch_1, &page->flags);
 		put_page(page);
+		/*
+		 * There are some valid fixup types for kernel
+		 * accesses to donated secure memory. zeropad is one
+		 * of them.
+		 */
 		if (rc)
-			BUG();
+			return do_no_context(regs, 0);
 		break;
 	default:
 		do_fault_error(regs, VM_FAULT_BADMAP);
-- 
2.53.0



