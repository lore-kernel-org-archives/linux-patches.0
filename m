Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5D933939A;
	Sat, 12 Sep 2026 15:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226512; cv=none; b=Gr+Cp4k1xguJ7kOB3WxsY/Q3Ht1MOVnTGwH71lPhBcn/i3btazIQRp3zmyrhy1ggY5smz9pU9OTsMJZwolE5WTYK0yYW4giI1TnnQX+UydMK4HHGzF83hYEWt1Pw9ipEKa7RymxAUxBZpuZrTK3Rn+dXDX2GwqpZ1NH+Eyb4Dxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226512; c=relaxed/simple;
	bh=vroOTbihTVuheACczYWOOsXP81+jqc1ugPVNfyL+O30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkBWmrlaBl3EVsSuZ7oAMGYQZdDVmgOkVLQQ3vw+KPuf7DT8xa5AhNp1xrrbYepa8N2RzS7tSLE5phmd21gk0nJkZid0/UljIMohAHlWL+8LQ2PZ4nPL03T/OHXRwh3U0fzI5cLMKlYf9mO0/I4PXt+eewCI23txkoF4LuCgRQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SS++B4Q5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SS++B4Q5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F201F000FF;
	Sat, 12 Sep 2026 15:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226511;
	bh=jvGQMXRahwUwvDT24NsKnyrRj0DKyhsbyw2lH2iG8k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SS++B4Q56gVLsAj4GBEr0nzmui8m8Hf9d4VC6c78A7lMtjdhXUBFFWLJEXUgkCOkO
	 8tY9xN+/InzwdWLT2N4p0X1QyzbwB5J3UtBsdfdvd56Wn1OKtAEpRZDvoP/FTEdinV
	 DegdKOthRQ62F/D25ePNuPa4yPzgnCB3l54E0EoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Shi <yang@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1410/1424] kselftest/arm64: mte: Use the correct naming for tag check modes in check_hugetlb_options.c
Date: Sat, 12 Sep 2026 09:04:02 +0200
Message-ID: <20260912065638.835569015@linuxfoundation.org>
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

[ Upstream commit 7ae95109c64d64cdcf195788cf466ec0b3019a94 ]

The architecture doesn't define precise/imprecise MTE tag check modes,
only synchronous and asynchronous. Use the correct naming and also
ensure they match the MTE_{ASYNC,SYNC}_ERR type.

Fixes: 27879e8cb6b0 ("selftests: arm64: add hugetlb mte tests")
Cc: Yang Shi <yang@os.amperecomputing.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Link: https://lore.kernel.org/r/20250221093331.2184245-2-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/mte/check_hugetlb_options.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/arm64/mte/check_hugetlb_options.c b/tools/testing/selftests/arm64/mte/check_hugetlb_options.c
index d1dc587b18254..cd7667187ed5b 100644
--- a/tools/testing/selftests/arm64/mte/check_hugetlb_options.c
+++ b/tools/testing/selftests/arm64/mte/check_hugetlb_options.c
@@ -283,13 +283,13 @@ int main(int argc, char *argv[])
 	"Check clear PROT_MTE flags with private mapping and sync error mode and mmap/mprotect memory\n");
 
 	evaluate_test(check_child_hugetlb_memory_mapping(USE_MMAP, MTE_SYNC_ERR, MAP_PRIVATE | MAP_HUGETLB),
-		"Check child hugetlb memory with private mapping, precise mode and mmap memory\n");
+		"Check child hugetlb memory with private mapping, sync error mode and mmap memory\n");
 	evaluate_test(check_child_hugetlb_memory_mapping(USE_MMAP, MTE_ASYNC_ERR, MAP_PRIVATE | MAP_HUGETLB),
-		"Check child hugetlb memory with private mapping, precise mode and mmap memory\n");
+		"Check child hugetlb memory with private mapping, async error mode and mmap memory\n");
 	evaluate_test(check_child_hugetlb_memory_mapping(USE_MPROTECT, MTE_SYNC_ERR, MAP_PRIVATE | MAP_HUGETLB),
-		"Check child hugetlb memory with private mapping, precise mode and mmap/mprotect memory\n");
+		"Check child hugetlb memory with private mapping, sync error mode and mmap/mprotect memory\n");
 	evaluate_test(check_child_hugetlb_memory_mapping(USE_MPROTECT, MTE_ASYNC_ERR, MAP_PRIVATE | MAP_HUGETLB),
-		"Check child hugetlb memory with private mapping, precise mode and mmap/mprotect memory\n");
+		"Check child hugetlb memory with private mapping, async error mode and mmap/mprotect memory\n");
 
 	mte_restore_setup();
 	free_hugetlb();
-- 
2.53.0



