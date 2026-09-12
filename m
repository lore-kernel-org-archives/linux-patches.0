Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4961282F03;
	Sat, 12 Sep 2026 16:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232359; cv=none; b=hhD5R9RCJLdjuX132P2YJKKNNrNEijPHCjHdsnYqbzZIVrZiniXZHsFAPKvlQYEqR1Anfi2ZVHVp5X39OiBKGBoB2ppKC4fzC60WwURrpUT++REtHxVox5rSBPRsX38/585E4jQSwaDYrtVNYcobVHXVTL7+RsYxfCf83uempsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232359; c=relaxed/simple;
	bh=5Lk8ZZFR98NMLEP1v/6SJl5A13kk0cfZY+AfI3YXbxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJZpRN9XxgR0rGm+R8F+z/UaZRSBdLX6Tb1b6CeOwmwFEX1jYiSoezhxvQj0ebX3ihUb0R8lfRy8x01psaeUSxJNMbyi+7IpyL7c2cNhGVBGH0YnuBnGYU/uKhpdmM48U5jrCLhrV2+2F1z2cu6zcMtW6ICJRgcE8xA73DTPfB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPL4C0d2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPL4C0d2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CBC21F000FF;
	Sat, 12 Sep 2026 16:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232358;
	bh=E0kUZ7/Qvv3O8ZLFakjnwMWJCDDTQoqb/VLI2OSEkHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oPL4C0d2k9XO1lTYxXt/NzUAL2XtXuPuw7rDBZk3cb4NYBiYMLphDfggSakVcas/k
	 7rIp0jXFAXsy4H+L9OgWE5i/4isXAcLfMZF6IJFGIUJXjCfBMtjZvRDB4/f0T+SqgG
	 tw8hORt6GV6cKe/aIksvNg4B5DQgnaEtfL+D6y4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Shi <yang@os.amperecomputing.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Dev Jain <dev.jain@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1185/1191] kselftest/arm64: mte: Skip the hugetlb tests if MTE not supported on such mappings
Date: Sat, 12 Sep 2026 09:05:13 +0200
Message-ID: <20260912065614.752126277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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



