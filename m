Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F991F890F;
	Tue,  3 Dec 2024 15:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240062; cv=none; b=PqfaZHmf/at+4TcN/bVVeBromO06bg8Hh6XjpTLVPI6LcvXByYB5oQZZPSGGkzjL1JFIjB5HTmCJESUoy0vndsO9CFhRUyds/qcUAoc8MSc6jtoAb4C8u5DDiAEXBuXoLDBwzJldX/MQbG7fXz3UeJQLiTKBXl2eJHUZtEWwNHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240062; c=relaxed/simple;
	bh=LqDIrgEnb+5IXZsegJZEOxzisTyyvY5a63MfebA9FqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYTg/5FUpRV/t3TF75zi4qH7v2Vqx8FIzdgIg3hRYAb/UeU6/3k8xFBzK5RPja0uK5+EbYruseOSoiYhM/UbwUoNKRcWDvM6SbaqoRm16sDdbsKUXqPQPNjfTxImV7y4nlbwPp+rgEoqItdupEC3wqzZPwkyQFQlu5m3kqZD4Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPcSUwFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPcSUwFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1E3C4CECF;
	Tue,  3 Dec 2024 15:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240061;
	bh=LqDIrgEnb+5IXZsegJZEOxzisTyyvY5a63MfebA9FqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPcSUwFt1sspHE0nBu+HBydDnIlKqkBFC+FKIdCpf/DW7lq5X6OTee68ILIVeuSch
	 ORh+e7pML/2R2F9KfpFpO+1XmhECQw4EBb4Onx40yjpK9Ey44m1EE0XTIbr+93oim8
	 drj2W2W9jPbVhBSGgIjxwzlDlN8upsAzMWtSuq+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/826] kselftest/arm64: mte: fix printf type warnings about longs
Date: Tue,  3 Dec 2024 15:35:37 +0100
Message-ID: <20241203144743.847521705@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2b1425b92b699..a3d1e23fe02af 100644
--- a/tools/testing/selftests/arm64/mte/check_tags_inclusion.c
+++ b/tools/testing/selftests/arm64/mte/check_tags_inclusion.c
@@ -65,7 +65,7 @@ static int check_single_included_tags(int mem_type, int mode)
 			ptr = mte_insert_tags(ptr, BUFFER_SIZE);
 			/* Check tag value */
 			if (MT_FETCH_TAG((uintptr_t)ptr) == tag) {
-				ksft_print_msg("FAIL: wrong tag = 0x%x with include mask=0x%x\n",
+				ksft_print_msg("FAIL: wrong tag = 0x%lx with include mask=0x%x\n",
 					       MT_FETCH_TAG((uintptr_t)ptr),
 					       MT_INCLUDE_VALID_TAG(tag));
 				result = KSFT_FAIL;
@@ -97,7 +97,7 @@ static int check_multiple_included_tags(int mem_type, int mode)
 			ptr = mte_insert_tags(ptr, BUFFER_SIZE);
 			/* Check tag value */
 			if (MT_FETCH_TAG((uintptr_t)ptr) < tag) {
-				ksft_print_msg("FAIL: wrong tag = 0x%x with include mask=0x%x\n",
+				ksft_print_msg("FAIL: wrong tag = 0x%lx with include mask=0x%lx\n",
 					       MT_FETCH_TAG((uintptr_t)ptr),
 					       MT_INCLUDE_VALID_TAGS(excl_mask));
 				result = KSFT_FAIL;
-- 
2.43.0



