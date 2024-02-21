Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942D478B53;
	Wed, 21 Feb 2024 13:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523327; cv=none; b=uoLu9AiAvOUgttbL/COYLXWrxUWK9jwWpQXROkjeXXRZppFIi36sMSD3bttWpcsYY0iDLgzQdOmB56CjsClFZEiqS5tKc0/Y4w8ioGz9qMYeGTFqFGlwmJb3rEtB+YeZO1quEW8FTmR/EBSVvKRMXwltPcAIBBiXpjU1XdYRAfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523327; c=relaxed/simple;
	bh=9EPw+s5zdKgFZxAycx09VlDC1eHBhS5F3+FVSDkmSsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4NWXYRZEecoBiJleYYAlCIQSP43Q6Hkz8qiB7G98Nx/5vAxFKHPLX5RAdVCI4kGgNhfuL3RZrM/kNP7TtUVMV5qKQQwJB07NJkWLoCzZ+Ru0cxw6Vcbn1vLtLawu9Fs+4mnVQfksH4j8UTbfZHAlZ75BJYoJbOaHFL8vnx6kAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBH9jIHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBH9jIHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02470C433F1;
	Wed, 21 Feb 2024 13:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523327;
	bh=9EPw+s5zdKgFZxAycx09VlDC1eHBhS5F3+FVSDkmSsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBH9jIHPQt7vJizSY5PlH+GcUWlIMQ6WA05njh10qiy4/MWeWhzcv8x0+ZPeN7Zuc
	 pODqPA0mEFRWDknp5mhmA5JyYP2WJkaxC2iwNqNojZqgOvnUJsJZEgaICcB3dCuar/
	 CtNHiYMwpfrkrqrk3UXOpNv46p/oq7uihVJh2zqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Mazur <deweloper@wp.pl>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	stable@kernel.org
Subject: [PATCH 5.15 403/476] x86/Kconfig: Transmeta Crusoe is CPU family 5, not 6
Date: Wed, 21 Feb 2024 14:07:34 +0100
Message-ID: <20240221130022.903726312@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Aleksander Mazur <deweloper@wp.pl>

commit f6a1892585cd19e63c4ef2334e26cd536d5b678d upstream.

The kernel built with MCRUSOE is unbootable on Transmeta Crusoe.  It shows
the following error message:

  This kernel requires an i686 CPU, but only detected an i586 CPU.
  Unable to boot - please use a kernel appropriate for your CPU.

Remove MCRUSOE from the condition introduced in commit in Fixes, effectively
changing X86_MINIMUM_CPU_FAMILY back to 5 on that machine, which matches the
CPU family given by CPUID.

  [ bp: Massage commit message. ]

Fixes: 25d76ac88821 ("x86/Kconfig: Explicitly enumerate i686-class CPUs in Kconfig")
Signed-off-by: Aleksander Mazur <deweloper@wp.pl>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20240123134309.1117782-1-deweloper@wp.pl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig.cpu |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -379,7 +379,7 @@ config X86_CMOV
 config X86_MINIMUM_CPU_FAMILY
 	int
 	default "64" if X86_64
-	default "6" if X86_32 && (MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MEFFICEON || MATOM || MCRUSOE || MCORE2 || MK7 || MK8)
+	default "6" if X86_32 && (MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MEFFICEON || MATOM || MCORE2 || MK7 || MK8)
 	default "5" if X86_32 && X86_CMPXCHG64
 	default "4"
 


