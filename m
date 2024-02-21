Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57CA1E4B2;
	Wed, 21 Feb 2024 14:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524729; cv=none; b=fjgfy2/f5XcuTMbJqRI8/AOVuaz3fP1uDudocyzhk0HUECXW21mxfPPFOXJ02m8yhpfgwd5wGC/N8AszQBcwkupeuaKmw3/o7FAHGgOs/WWfyO748GDJutVCb69wB6uj9pUQ+1skEoNGfwJzgFcDwqyiqWUAr3ENGgqRAKr3rn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524729; c=relaxed/simple;
	bh=wV5t+vPLe+TJfUHWopypMXbPhVB5VbK1zrVnnZm5F04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=km9viUPfKVpWHJBkfct5QJiNpErAds+L6mvFQRsyn6B14T0iImSYWtGFLJ35kXPFrkM3e6z4LBv4B9C12TomlhzVK9oxT8gWo3TrN+uYvceRV/0YnDatNHHkcQJ/N1IAbO9yHwdCXQVxVKuHOAxGbH+18w774oMonQcfzLVaMbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSVrGgx4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSVrGgx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E14C433F1;
	Wed, 21 Feb 2024 14:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524729;
	bh=wV5t+vPLe+TJfUHWopypMXbPhVB5VbK1zrVnnZm5F04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSVrGgx4Qz7QzYfciXN+4AnP8xRzkaUwbpwKoKDeBiPgHTuus7viugKFkt0bbgunX
	 O5LjtENd8kwD6FkXykVaB+6TBgOs0CqJsCrniR6kjdpp/BLIVrDwi6Ph9Elddf6Oe2
	 MEsQ/RgB2Nl7nVNIEICTj6TyNAUK4FU0KaEzcSAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Mazur <deweloper@wp.pl>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	stable@kernel.org
Subject: [PATCH 5.10 331/379] x86/Kconfig: Transmeta Crusoe is CPU family 5, not 6
Date: Wed, 21 Feb 2024 14:08:30 +0100
Message-ID: <20240221130004.769663365@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


