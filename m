Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72995745ED;
	Mon, 15 Apr 2024 14:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191852; cv=none; b=F7wK0VwVLFuQBI7QBna3mNKh/6sLqnxt8Ui+Sski49BevihEZ5K4jSV1o7/OwWUkDZgTTZZjWJHmYwrfP2P2baozNkZ/rfjxV8oN7wOgZNcaFKO4aaB2FROv06F/zuQG5j3Oew5G+c4X8m9yXoQcARgzorsrgbexqeizlwY3ZzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191852; c=relaxed/simple;
	bh=nibfTLhRzxlYERJlpfQu9o54hQF3+C4mqLlkjZjr4Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GlKLLbFUrICy3ISy4/dWf6WPfiRiRrCGvSScq/rGwUAbd0aCLcqtXZmIz1djtxnNCSLSF8SFQO2qeNqkaLqfOKvXvrbTEcEQS37TsQOj6vg8M85FIhpuIXpIQtNYPwLH+//sSFyQg/1EUgpA9bK2Wtl/mSSAiaifmPVkl2EC/1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2COpcpiB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2COpcpiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2642C2BD10;
	Mon, 15 Apr 2024 14:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191852;
	bh=nibfTLhRzxlYERJlpfQu9o54hQF3+C4mqLlkjZjr4Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2COpcpiBVTDO8b2BH5IfXbhF1a0DKrhEPeR5wj1iKOuLHaSynZLR4j3R0bY39oUYN
	 gpew4XJGU1JFD91gMrfz2/KKj39Sc0GB9fs6k3TBxP2+iES1CRIpPNdkxupbuBeKZQ
	 MJvxJXHnSr348jcFWpPGjVpc0fXT6CYFNM8yvbMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 107/122] x86/bugs: Fix return type of spectre_bhi_state()
Date: Mon, 15 Apr 2024 16:21:12 +0200
Message-ID: <20240415141956.584327135@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2808,7 +2808,7 @@ static char *pbrsb_eibrs_state(void)
 	}
 }
 
-static const char * const spectre_bhi_state(void)
+static const char *spectre_bhi_state(void)
 {
 	if (!boot_cpu_has_bug(X86_BUG_BHI))
 		return "; BHI: Not affected";


