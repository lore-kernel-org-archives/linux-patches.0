Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607961D27B3;
	Tue,  8 Oct 2024 12:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390792; cv=none; b=qzSBEbrH72+5DLOSTmBRQtAgnLmtIfxJeYPjZ6xAHHqD1p49fO7l5OiMKNkVzUhSz0R6xs6g1EPh5k4z1+s7CKCVGiC+5zdEjhwpcGHnncSP84PM5TSObrVyZvOjmQVTfXCKM5RBuYFrALdgpASc2oLf2KKI9vcjawM2/JjGL7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390792; c=relaxed/simple;
	bh=k4teYPH8mUWW+PO2wQo/wca5qzvEO+haNG7GzJnCwLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxAK7FzV72i1yJmXNN0fD18Wu2JCg2+PCVnoPK2fgonvKT/TsB2G0fv0usqdSSk4TvFttPK+zxCBuirDyWCe27omal0InZRmXov6KHUuI2ojKGtb30XAF/QycsLn3u6fQvtQ1WVArgbsjJPdN7kHLI/CW/o6mYrMHLZ3nJ3Yv28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIuLAaVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIuLAaVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EEDC4CECF;
	Tue,  8 Oct 2024 12:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390792;
	bh=k4teYPH8mUWW+PO2wQo/wca5qzvEO+haNG7GzJnCwLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIuLAaVmMILeYGaBOza6Zjy/NLjJ4giS6sNiPX8VOz6gpK0Nrjsr9H5m7LOmaPx6t
	 Wp+VtRLlxPDY/qj4LFofZvVUhTpRGNF1+nETfnvah+A7/ADB3mm1g+Hc1srntIE0wJ
	 q5bHZa4sxOPDLCj6CfQRRw24HGVEX81r4W5ZpTEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James More <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.10 363/482] arm64: Subscribe Microsoft Azure Cobalt 100 to erratum 3194386
Date: Tue,  8 Oct 2024 14:07:06 +0200
Message-ID: <20241008115702.708105117@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Easwar Hariharan <eahariha@linux.microsoft.com>

commit 3eddb108abe3de6723cc4b77e8558ce1b3047987 upstream.

Add the Microsoft Azure Cobalt 100 CPU to the list of CPUs suffering
from erratum 3194386 added in commit 75b3c43eab59 ("arm64: errata:
Expand speculative SSBS workaround")

CC: Mark Rutland <mark.rutland@arm.com>
CC: James More <james.morse@arm.com>
CC: Will Deacon <will@kernel.org>
CC: stable@vger.kernel.org # 6.6+
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Link: https://lore.kernel.org/r/20241003225239.321774-1-eahariha@linux.microsoft.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arch/arm64/silicon-errata.rst |    2 ++
 arch/arm64/kernel/cpu_errata.c              |    1 +
 2 files changed, 3 insertions(+)

--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -289,3 +289,5 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Microsoft      | Azure Cobalt 100| #2253138        | ARM64_ERRATUM_2253138       |
 +----------------+-----------------+-----------------+-----------------------------+
+| Microsoft      | Azure Cobalt 100| #3324339        | ARM64_ERRATUM_3194386       |
++----------------+-----------------+-----------------+-----------------------------+
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -447,6 +447,7 @@ static const struct midr_range erratum_s
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_X3),
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_X4),
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_X925),
+	MIDR_ALL_VERSIONS(MIDR_MICROSOFT_AZURE_COBALT_100),
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V1),


