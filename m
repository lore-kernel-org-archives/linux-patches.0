Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55863290D1;
	Sat, 12 Sep 2026 16:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232364; cv=none; b=A/drR5aiCHbfsO0D8iObic/jjnvjbzax330XKnqgKodgTbienpGRQAdQrb4JuIvSDwHkcN2hv8VCVTU1YiZN61c3GdXTNpgz/mEzMAnGgVopnGEJgMcd0LNcTEO/ZUptnsx2pZNMx2aapxRTaaawTYSAqqGkLgPVMyDmN+NE82o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232364; c=relaxed/simple;
	bh=M1ZLveJ/XiaN6rNWr1+bv0UZd+P7wWBhCJKtXs1oGkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Scja4A4lHP9MFoMXvOuN1W2m7ixXELMMcqg+pv729xhMNLM507Cqzo9MiMbLHKWFKtDCNT1wB+JkyitVzZlHuxOEsTC4nV0kL4yjeMR1mngYBP79tWuu5ja/SnR4KIqfw2VkrAkXhqvMw4vpOJVnW9GNXw6qbDW8JmjLEB/wWI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KAbYxUOQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KAbYxUOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E8E1F000FF;
	Sat, 12 Sep 2026 16:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232363;
	bh=9MUR4zddD/gHT15tFU2Rqrs8r1mE9/tCeMFGAD8lpSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KAbYxUOQqOo3qzZgYe2H5TBRnXwhbIRmr0vXgLFFwD4UKweS0aFyWUJDzSHYD8rL9
	 mfYTGAbfgqp9YUjHFVRqIdnac0TlXPD/w1soi203LJpsbEoEhyXmDQpQ0TVwhS2nFw
	 XkZ85CkZQY33TUX4YboWFQ/DW+BECLJDgjEhDPFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Shi <yang@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1186/1191] kselftest/arm64: mte: Use the correct naming for tag check modes in check_hugetlb_options.c
Date: Sat, 12 Sep 2026 09:05:14 +0200
Message-ID: <20260912065614.772714440@linuxfoundation.org>
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



