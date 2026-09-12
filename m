Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D564932B108;
	Sat, 12 Sep 2026 15:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226585; cv=none; b=EqowfDJxJzHiG6jrm3PGSMvgDPnNdPoyfhNKpvRc4OiXtUGpUvGe+JKfyOy8sjbzJTk6JK85MK+QOytQ0K3EYqUrQnbFX3LO4tRn+yQm8zpTMfuunqpptWM7f1cuPTWH82RraF4+0g6srx9B9+ODI17+KcevyVxaQWskgwSd2rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226585; c=relaxed/simple;
	bh=Gl3RQuVbhHLwLnFR8UC+S2/zLCq4aH4eI+altvUZ7o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEbcHoSj2YgHeip+CqHuXsh+RtGGu22YY1hhm7PcLzD2waWwGjkd9nFD2vbD0LrsrFAMB3ApsLW00UcaIT6cGbas/yRVWAqYUNvEfAQWwY/o892MXXzYtp7hjtVEv+sGhEyt1ynSjP8830ZHWM+81EE4QgL/dV2JoEB9WQ8jWKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vmh5dHys; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vmh5dHys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762081F000FF;
	Sat, 12 Sep 2026 15:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226584;
	bh=r2OTd6pa9eqSBhTDTv7ueXF60MheGEYUHhQx5n3Z68k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vmh5dHysF/8wpGGSy82Ynyp1NuKoKbt0KppHaxcABmGe5M75o4p3rX/qaKx535c39
	 CmzB2IvVdVRn9jEB/CoOro05FwKwBUQg2D84SbhexzacKpFH1+M3ClvlWGvbdJ2srT
	 AlAyKPEYrLerhV6Q0c3B8MMmp6H3TtcJAu7FrgZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Shi <yang@os.amperecomputing.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Dev Jain <dev.jain@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1409/1424] kselftest/arm64: mte: Skip the hugetlb tests if MTE not supported on such mappings
Date: Sat, 12 Sep 2026 09:04:01 +0200
Message-ID: <20260912065638.814017857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

[ Upstream commit 306219d59b72cfca4005229b2c6ad43a16479e3b ]

While the kselftest was added at the same time with the kernel support
for MTE on hugetlb mappings, the tests may be run on older kernels. Skip
the tests if PROT_MTE is not supported on MAP_HUGETLB mappings.

Fixes: 27879e8cb6b0 ("selftests: arm64: add hugetlb mte tests")
Cc: Yang Shi <yang@os.amperecomputing.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Link: https://lore.kernel.org/r/20250221093331.2184245-3-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/arm64/mte/check_hugetlb_options.c       | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/arm64/mte/check_hugetlb_options.c b/tools/testing/selftests/arm64/mte/check_hugetlb_options.c
index a8087c9288176..d1dc587b18254 100644
--- a/tools/testing/selftests/arm64/mte/check_hugetlb_options.c
+++ b/tools/testing/selftests/arm64/mte/check_hugetlb_options.c
@@ -227,6 +227,8 @@ static int check_child_hugetlb_memory_mapping(int mem_type, int mode, int mappin
 int main(int argc, char *argv[])
 {
 	int err;
+	void *map_ptr;
+	unsigned long map_size;
 
 	ksft_print_header();
 
@@ -245,6 +247,15 @@ int main(int argc, char *argv[])
 		return KSFT_FAIL;
 	}
 
+	/* Check if MTE supports hugetlb mappings */
+	map_size = default_huge_page_size();
+	map_ptr = mmap(NULL, map_size, PROT_READ | PROT_MTE,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+	if (map_ptr == MAP_FAILED)
+		ksft_exit_skip("PROT_MTE not supported with MAP_HUGETLB mappings\n");
+	else
+		munmap(map_ptr, map_size);
+
 	/* Set test plan */
 	ksft_set_plan(12);
 
-- 
2.53.0



