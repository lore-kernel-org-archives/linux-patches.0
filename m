Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0B531CA7E;
	Mon, 27 Oct 2025 19:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592552; cv=none; b=Hzbu/GlCoDQkYoTbGb02rfYjexhPsI9HjoiIKin53oH9bYOPdiiO6TTu0F0YugTB8iRWsf9r9C0U54ADPy81VkvC5asm4QludO0eaMzr3wsoVTSmLAcjKfIAAvQkgCptoKrjD65Aj4VHstKc8SYvdtBn2OE2tPVQs1Z9RgODIKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592552; c=relaxed/simple;
	bh=Fi9+kG8NitJLPayNE7AQeAU2ufAH4mpCqZbP+U4eSqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uD1A+3cCdGN0fbDoXywCIfC7ud8qyK+V5smrxhfKN3M2RKIYePlEk7maOPYTnPo6ftX7Nm7lZOuDUIu12crqz29Yi4Sw6uSklj09ePXVCVCseNxpHT/B5nKzFNIaiAQkgGw4C6NV8tB2aBnOJp+YRclai/92wBQEbaMuUBy8Jdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g7FxJ5qP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7FxJ5qP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F36DC4CEF1;
	Mon, 27 Oct 2025 19:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592552;
	bh=Fi9+kG8NitJLPayNE7AQeAU2ufAH4mpCqZbP+U4eSqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7FxJ5qPjM8wEWeNjhs0Alv+i0cu+eW9iXbrqaugzwoaG/OqXoMUmZ3gwQ7QZCkBJ
	 HNxSjfczxFKyI0lGtarO85JG7tJrKMMm5q35jOBkhpPIMeG8yAvUYor/Irx/YCaChC
	 UhTnl9QX4MkhSdB69dmw4s8XJupfBXKzPDj9WVos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH 6.1 157/157] arm64: errata: Apply workarounds for Neoverse-V3AE
Date: Mon, 27 Oct 2025 19:36:58 +0100
Message-ID: <20251027183505.507492969@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
User-Agent: quilt/0.69
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

commit 0c33aa1804d101c11ba1992504f17a42233f0e11 upstream.

Neoverse-V3AE is also affected by erratum #3312417, as described in its
Software Developer Errata Notice (SDEN) document:

  Neoverse V3AE (MP172) SDEN v9.0, erratum 3312417
  https://developer.arm.com/documentation/SDEN-2615521/9-0/

Enable the workaround for Neoverse-V3AE, and document this.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
[ Ryan: Trivial backport ]
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/silicon-errata.rst |    2 ++
 arch/arm64/Kconfig                     |    1 +
 arch/arm64/kernel/cpu_errata.c         |    1 +
 3 files changed, 4 insertions(+)

--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -181,6 +181,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-V3     | #3312417        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Neoverse-V3AE   | #3312417        | ARM64_ERRATUM_3194386       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | MMU-500         | #841119,826419  | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | MMU-600         | #1076982,1209401| N/A                         |
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1027,6 +1027,7 @@ config ARM64_ERRATUM_3194386
 	  * ARM Neoverse-V1 erratum 3324341
 	  * ARM Neoverse V2 erratum 3324336
 	  * ARM Neoverse-V3 erratum 3312417
+	  * ARM Neoverse-V3AE erratum 3312417
 
 	  On affected cores "MSR SSBS, #0" instructions may not affect
 	  subsequent speculative instructions, which may permit unexepected
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -457,6 +457,7 @@ static const struct midr_range erratum_s
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V1),
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V2),
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V3),
+	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V3AE),
 	{}
 };
 #endif


