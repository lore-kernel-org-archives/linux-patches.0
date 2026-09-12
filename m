Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DCD37F314;
	Sat, 12 Sep 2026 19:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240758; cv=none; b=RIt6yUOKuE7Q0sJRMnIGSaoldlyH4ndEVqEYol8OSYJp9AluF3d7OSmUl865INTad2z+K1Xr87TeV0oDIn9S5Jydtv3ofdzJl48NIWNwIopLTGHetZtsD2+zlZuc3Y1q25wRA4PDTn7ZoZg7n1h+f96rAIW4yp6E/ExvdIWT028=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240758; c=relaxed/simple;
	bh=EaVUgaPS/dV/O9v2JrwEFuCN1iRYsAI81O++G5cOhWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8NWNUYXo9Fu+yjqccJ/T/TKI+mam5/IIo1MB7G+KtToU7W4p6meXHXAXlkR0Vepmo6KnavMSOsXHYIVHlWgSea3gJ+8qySoUtqmfgsSXZ34PXzCi0lDCF6+wyKco7av2KKIMcOCuIQosoc2/mRKhQhUFGn7Y70NediTuvKw3xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3wBko+D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3wBko+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BFE1F000FF;
	Sat, 12 Sep 2026 19:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240756;
	bh=oSlJGNySHlDmaozomvkVPFAUFMsge+nD9kkfvKq6Ca0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a3wBko+D/EBYY1gJYKrp/vvvBtjeVY8RXVCylg/MLVX/2re+74Snjtufr/USozkZO
	 Uy/h4d+SGYzsZXlZjnTuNwAaFCKy5VyRGjEDKwqNwloVCTA1EgXrcFmhqDiYoNcx4y
	 kr9/z4CnpibGiFQadFBC2s1jiKRVWkN13c2o8BqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Shi <yang@os.amperecomputing.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Dev Jain <dev.jain@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 932/935] kselftest/arm64: mte: Skip the hugetlb tests if MTE not supported on such mappings
Date: Sat, 12 Sep 2026 09:06:02 +0200
Message-ID: <20260912065548.197312224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



