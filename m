Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E4E9445;
	Mon, 15 Apr 2024 14:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192226; cv=none; b=B0Wb3moQhHvKQX7n1iog8odvGKVSDUhT3d69DT6IgAZkAu+7xuH9BfuCvDVpdhcCWMHBtlspOmDt6ucw0HOnrm3TEgtl3ImKJkICoXMaz449nXeJqtZIITgEMvUTeCpNRLGH2prktHpV0OMc5t1KPa8vhU/DF5HBksaCNxvKu5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192226; c=relaxed/simple;
	bh=rd/XvTXbVZYEzZ7DJwZ74soF+GqhiDFve46eK5JruJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsnNv9wNu2LTLSSY4OIdfhujA4OjUIkFjZJ3+POuxOA9sPDmSdDUSibivfxJtBKKexWJa1HYqvVhIpWAWtBWDsovrDmWruD6e1zXjtEagNdZZUrQ2WEc6f6Qjt/N8aRjYpqLNQzONDbdKFpmvGA+nnB1H7O4MumaH9gWTsTsLro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tP0xEEuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tP0xEEuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E56C113CC;
	Mon, 15 Apr 2024 14:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192226;
	bh=rd/XvTXbVZYEzZ7DJwZ74soF+GqhiDFve46eK5JruJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tP0xEEuAysUTAyB03Zox5yzmBQHvS48sRy9POC3UNGmMkU4Cz4tWJIhpx1FuTjsxi
	 e+8bG8PqEocrzcll14ZPViz5jquRRyxx3a68G7raj01+TNzthUSvCOemGsB9Jv8Hle
	 FPVlN0kXsZfNG+kJ0UonMaFxiG+IntOZ1QLhP0fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 37/45] x86/bugs: Fix return type of spectre_bhi_state()
Date: Mon, 15 Apr 2024 16:21:44 +0200
Message-ID: <20240415141943.357865891@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141942.235939111@linuxfoundation.org>
References: <20240415141942.235939111@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Sneddon <daniel.sneddon@linux.intel.com>

commit 04f4230e2f86a4e961ea5466eda3db8c1762004d upstream.

The definition of spectre_bhi_state() incorrectly returns a const char
* const. This causes the a compiler warning when building with W=1:

 warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
 2812 | static const char * const spectre_bhi_state(void)

Remove the const qualifier from the pointer.

Fixes: ec9404e40e8f ("x86/bhi: Add BHI mitigation knob")
Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20240409230806.1545822-1-daniel.sneddon@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2788,7 +2788,7 @@ static char *pbrsb_eibrs_state(void)
 	}
 }
 
-static const char * const spectre_bhi_state(void)
+static const char *spectre_bhi_state(void)
 {
 	if (!boot_cpu_has_bug(X86_BUG_BHI))
 		return "; BHI: Not affected";


