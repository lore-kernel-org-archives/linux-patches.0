Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7171F53365;
	Thu, 12 Dec 2024 17:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023788; cv=none; b=rD1jZuDEwlcs5z8CUjhTpSr9BByNWrRybTK1+WWoqC0NSN0IXTtIHiJouCaoFyhUvJ99zFoHwN0swdznuXbleGczXQKjcYh8c/3v3hsbNQ2LbNXX7p3i/6ifbTTAmEC9F4apXCD9t+apRwN+P7plDuYgdbanKQnSwBu2uPk8hCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023788; c=relaxed/simple;
	bh=lq3VFfVicyiBw5rhOiFkI8PjqcpXppif1UDLGmgmPWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sb0smyTFRP7V36dNK40uMfKYJsElxFdoANDc2EcC4J8axHm9M7Roln7eysNvZ3ezddyZ8tiQQ3gQ8ydsMXEfHAkwU4RSDD0zQZ1+Q9BHWGY6o7Piz2eWCT1hSatjki7c/CbhdIRdKuGRUdeh6WbSstwzcX5T6zXb+iZ1OQA1pm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZJsVHBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZJsVHBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9806C4CECE;
	Thu, 12 Dec 2024 17:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023788;
	bh=lq3VFfVicyiBw5rhOiFkI8PjqcpXppif1UDLGmgmPWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZJsVHBNvrKuuSfYKII+feKupLeCYKvcpV4ERYWv2qiQMM7KhL8i8ftwJyiuIJsJo
	 EOptONHIwyw3KvyjqebdmAge6RHyosWiBN3Ok2oBw+Vc961Qz5H3rXh1eAxymaRxeq
	 OCAIL9BsQnXDKKgOGyol/7XQg5LoBAn3tISVhQAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/459] kselftest/arm64: mte: fix printf type warnings about longs
Date: Thu, 12 Dec 2024 15:56:33 +0100
Message-ID: <20241212144255.693986085@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 96dddb7b9406259baace9a1831e8da155311be6f ]

When checking MTE tags, we print some diagnostic messages when the tests
fail. Some variables uses there are "longs", however we only use "%x"
for the format specifier.

Update the format specifiers to "%lx", to match the variable types they
are supposed to print.

Fixes: f3b2a26ca78d ("kselftest/arm64: Verify mte tag inclusion via prctl")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240816153251.2833702-9-andre.przywara@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/mte/check_tags_inclusion.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/arm64/mte/check_tags_inclusion.c b/tools/testing/selftests/arm64/mte/check_tags_inclusion.c
index deaef1f610768..74a3727f640de 100644
--- a/tools/testing/selftests/arm64/mte/check_tags_inclusion.c
+++ b/tools/testing/selftests/arm64/mte/check_tags_inclusion.c
@@ -57,7 +57,7 @@ static int check_single_included_tags(int mem_type, int mode)
 			ptr = (char *)mte_insert_tags(ptr, BUFFER_SIZE);
 			/* Check tag value */
 			if (MT_FETCH_TAG((uintptr_t)ptr) == tag) {
-				ksft_print_msg("FAIL: wrong tag = 0x%x with include mask=0x%x\n",
+				ksft_print_msg("FAIL: wrong tag = 0x%lx with include mask=0x%x\n",
 					       MT_FETCH_TAG((uintptr_t)ptr),
 					       MT_INCLUDE_VALID_TAG(tag));
 				result = KSFT_FAIL;
@@ -89,7 +89,7 @@ static int check_multiple_included_tags(int mem_type, int mode)
 			ptr = (char *)mte_insert_tags(ptr, BUFFER_SIZE);
 			/* Check tag value */
 			if (MT_FETCH_TAG((uintptr_t)ptr) < tag) {
-				ksft_print_msg("FAIL: wrong tag = 0x%x with include mask=0x%x\n",
+				ksft_print_msg("FAIL: wrong tag = 0x%lx with include mask=0x%lx\n",
 					       MT_FETCH_TAG((uintptr_t)ptr),
 					       MT_INCLUDE_VALID_TAGS(excl_mask));
 				result = KSFT_FAIL;
-- 
2.43.0



