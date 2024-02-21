Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1C769DF9;
	Wed, 21 Feb 2024 13:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521728; cv=none; b=eZbNLy5GztPV8m4LxsaMh+iX6Jt3BRPsVoMRB6dKroC4R5OGYCD+CTi/xxvC81eHTkNDlyuyUTOd5mBfmq7epd/Mibh8Hpk2skCyHBNIRARRPjsx8L7tZSVS/XO+ZCQcgk0hh2sQDRhimwFWs5jIl/A8cmVzlWV4tFhcWnXrXS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521728; c=relaxed/simple;
	bh=tQqROP3nSeLwa3D/gqkiYZ7PR9w3fI1ErN/p5bO2/qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tn4hBUbNNj4pP7dKoSLShtV5e9JnpQTCRjw97YqjCF3H00FYnI8k1v0pFCB8QI1oI3+FbPS5KUnf0tC1JbB0ZXCgKoP2H7UugaiinZHKDEyuCjn9lI9SNgWP2aU+1+ObrKLVFxYeojg9X9gn8BJMJ36M4HW0W1B3opJPvpTRdCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4MSTLN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4MSTLN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A895C433F1;
	Wed, 21 Feb 2024 13:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521727;
	bh=tQqROP3nSeLwa3D/gqkiYZ7PR9w3fI1ErN/p5bO2/qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4MSTLN0XH6IyY0ILCBvM/z/m/E7Qnr5jVFWpINEEyH1/XJ0/NR5YHHurEr7Jflv5
	 jhXvNNFkRxWK1pkn4viio9fN4vRO1eHYEaREJ439QWC7lb88W8yJjU4uhnSoLZljyY
	 EzdkUR5CZnzqFmeeUSODa6AtqciULlVcUb1fPFs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Mazur <deweloper@wp.pl>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	stable@kernel.org
Subject: [PATCH 4.19 189/202] x86/Kconfig: Transmeta Crusoe is CPU family 5, not 6
Date: Wed, 21 Feb 2024 14:08:10 +0100
Message-ID: <20240221125937.909950687@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -372,7 +372,7 @@ config X86_CMOV
 config X86_MINIMUM_CPU_FAMILY
 	int
 	default "64" if X86_64
-	default "6" if X86_32 && (MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MEFFICEON || MATOM || MCRUSOE || MCORE2 || MK7 || MK8)
+	default "6" if X86_32 && (MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MEFFICEON || MATOM || MCORE2 || MK7 || MK8)
 	default "5" if X86_32 && X86_CMPXCHG64
 	default "4"
 


