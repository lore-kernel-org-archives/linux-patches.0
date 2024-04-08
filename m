Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34F077F1B;
	Mon,  8 Apr 2024 13:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582014; cv=none; b=L4RVsLB/hPlV3K5Mhheglg1OAU7f50vd01wsaLbEvdJrIWZwCbkKc5Y/sI0ccE1WKP0oWdz0/O5QCeetSuuX/IpBVbThdg0Mibegb+iGoZHtjp9kTOLsjJu09i8m9Xa5ligtpdXiuuLX0P6pGeJi+Ks5o1YcagQBqmXCLJulWdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582014; c=relaxed/simple;
	bh=WQRUDgrJtiVurlZjtxnP/YehHUgAUIfnHsyrLN3QAiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWJ5no/JwVYXwqEuBd8NYP+JItKwNJ3bB0IYGSuDm5+xvEQ2UVDbToQ4QJWlRwdtaCYv5nemaJq9AlA39mM3XNjkFGMMxLKViCkXqbBh6S9/T6yi3nPYzt08hmCQ2rGcMIEmfvduwSrNO6ySAxexKsIug1jk9DecLnIoeKOLmpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPABBSpl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPABBSpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E65C433C7;
	Mon,  8 Apr 2024 13:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582013;
	bh=WQRUDgrJtiVurlZjtxnP/YehHUgAUIfnHsyrLN3QAiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPABBSplCjcZm8VZGJVyojvy/88hXp+eA7XJ0cyRdVYjMzQWObm6phW8XlGmnNst+
	 iBXJ5MUP2OTZgW7GMEPaesCsKYfGZnHOFUQ2HYLAe8ppA+oWz6Al7sKOJrTgwRjVI5
	 T/fbRTIbrM4gy5Sl47T49azyg7G9fwF4F1n/F3Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/690] x86/CPU/AMD: Update the Zenbleed microcode revisions
Date: Mon,  8 Apr 2024 14:49:30 +0200
Message-ID: <20240408125403.263580431@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit 5c84b051bd4e777cf37aaff983277e58c99618d5 ]

Update them to the correct revision numbers.

Fixes: 522b1d69219d ("x86/cpu/amd: Add a Zenbleed fix")
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index dba7fe7ecea91..9fb890574f36b 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1021,11 +1021,11 @@ static bool cpu_has_zenbleed_microcode(void)
 	u32 good_rev = 0;
 
 	switch (boot_cpu_data.x86_model) {
-	case 0x30 ... 0x3f: good_rev = 0x0830107a; break;
-	case 0x60 ... 0x67: good_rev = 0x0860010b; break;
-	case 0x68 ... 0x6f: good_rev = 0x08608105; break;
-	case 0x70 ... 0x7f: good_rev = 0x08701032; break;
-	case 0xa0 ... 0xaf: good_rev = 0x08a00008; break;
+	case 0x30 ... 0x3f: good_rev = 0x0830107b; break;
+	case 0x60 ... 0x67: good_rev = 0x0860010c; break;
+	case 0x68 ... 0x6f: good_rev = 0x08608107; break;
+	case 0x70 ... 0x7f: good_rev = 0x08701033; break;
+	case 0xa0 ... 0xaf: good_rev = 0x08a00009; break;
 
 	default:
 		return false;
-- 
2.43.0



