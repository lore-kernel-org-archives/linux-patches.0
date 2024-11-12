Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF619214409;
	Tue, 12 Nov 2024 10:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407433; cv=none; b=hj0bZilD1HPpoyje52Six/Vq625Tb4hTMdsnPkY0qxt4XpMi4ObhLpWkbapCb9PksHZ8JBH6NiAPDzybitCssd05W03T/H6HM0okg/1IiGbSyWn0F5ds4wZi1MR61ZS2JPvowigwtKurnEKskmcqDUZQQXBFOyLA2gvhEeJi+Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407433; c=relaxed/simple;
	bh=i3767gGOkGdF1irdVagLzYyEDwDxcQ7WH00XSfmIAGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3Qx14bbN6qsAP43kPlvGn7DUq+0pdwO6cqjzMcwwnWv/H1dONx1P6srtC3uUsr18WYCzYISs6n8Cr9WzpKlAOSY5U5fja2e2hjVwtkyXosPJpamOX5D91sP+Je/MnN6ElfVTqHkFKYxIF/hMsBIxm5hskdNVpCTUV7lUASEKmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nC5eeoFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nC5eeoFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DD9C4CECD;
	Tue, 12 Nov 2024 10:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407433;
	bh=i3767gGOkGdF1irdVagLzYyEDwDxcQ7WH00XSfmIAGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nC5eeoFIuTz5YuA5KDXsWysXBw4jHs+tHj0Dj+XAWaAQ0HHKlz2FUiEiIyCcpN3xQ
	 UouUokclGeg37k3U1u/E5q+LMbHUKnkkgVwPihYLDzcn5wFMahjBkTiukDA5iYQGOG
	 aLdF+NA3A0ONT6oY/JWLlxbNe1K2rve4XHyTzFWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 73/98] arm64: Kconfig: Make SME depend on BROKEN for now
Date: Tue, 12 Nov 2024 11:21:28 +0100
Message-ID: <20241112101847.037143420@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 81235ae0c846e1fb46a2c6fe9283fe2b2b24f7dc upstream.

Although support for SME was merged in v5.19, we've since uncovered a
number of issues with the implementation, including issues which might
corrupt the FPSIMD/SVE/SME state of arbitrary tasks. While there are
patches to address some of these issues, ongoing review has highlighted
additional functional problems, and more time is necessary to analyse
and fix these.

For now, mark SME as BROKEN in the hope that we can fix things properly
in the near future. As SME is an OPTIONAL part of ARMv9.2+, and there is
very little extant hardware, this should not adversely affect the vast
majority of users.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org # 5.19
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20241106164220.2789279-1-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2113,6 +2113,7 @@ config ARM64_SME
 	bool "ARM Scalable Matrix Extension support"
 	default y
 	depends on ARM64_SVE
+	depends on BROKEN
 	help
 	  The Scalable Matrix Extension (SME) is an extension to the AArch64
 	  execution state which utilises a substantial subset of the SVE


