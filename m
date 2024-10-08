Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460361DEFEA;
	Tue,  8 Oct 2024 13:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392463; cv=none; b=sF03dgrJM3vDW6ixVxourmgXq1XNndzUxv7jJmWICUR7J36AJi7lkLVY/F5xCzqwSXhl3aqyc7kZBl1jK0o+TDMi2ThLAH6REEdgqDbGxiRhTTqfl8SwkXHN83LzjaacAw0hg1X72ECibhhAK9jDO9dIDTUlx4aTPxw5swK7Koo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392463; c=relaxed/simple;
	bh=tc5upXEyP+7uX0aKhx2+yxTMRSCjv6an198tCH2r7S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IB16razh8QTiy142vSWXRHjUBONWIu7dPcNM6wUCOfKkSK4Bfer+WfEBUwz4UkmF03zsj/22VKBBOTqFXq1CuaN6clt8+qIl+JQPqRDt6PDmGbwN0YhbX6OW7yRxhkm6YGIsZbjRc4RLaC+ope+rxYmR+6GmjKJUUV1iGImjXDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/baXhCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/baXhCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76B6C4CECC;
	Tue,  8 Oct 2024 13:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392463;
	bh=tc5upXEyP+7uX0aKhx2+yxTMRSCjv6an198tCH2r7S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/baXhCJPCxtKbWcf3WfZ+oFOYbIb0PhgV4dpSEtS3QLO8ZYcfFgxWIz66rMFa7E0
	 /EJyrhdSPGLo38+hNRVuYjO7fkWprnHTw+UpwVDTUHMPIlrOkHHvVn66nqMUAnpP68
	 nhet1v8afTk/2mbRnUliFMgT6tUbgcw1lmprrTJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James More <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.11 423/558] arm64: Subscribe Microsoft Azure Cobalt 100 to erratum 3194386
Date: Tue,  8 Oct 2024 14:07:33 +0200
Message-ID: <20241008115718.918355663@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


