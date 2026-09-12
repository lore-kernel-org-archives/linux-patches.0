Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230102EC09B;
	Sat, 12 Sep 2026 11:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212495; cv=none; b=eot25l5P3ncO8WapAmELmjxi7BGbSeaMtujQEIoQJCdLi3ZrLaNPljs+IK0QRhP9iragFWU10pCJlnGTU3AfStlQ9ewgE5RstVaJsRReUYip4Cnbg7yBfwOSRzl2fyu4R4eoBHL72+KJ7XovkNCOObKPNMotJEJj6cu4sSbdusU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212495; c=relaxed/simple;
	bh=0sbELAaeW0KT9utPoV5Yxhf5BclKArwRCLl16wCR42k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjZBQbJgoAkaaqK1XXj1n99/KM8qrObOJoy5P9t9zUnyNUuYpFSjibunSaG3mW1jbQ8DTZdROsIOxpE9VcSSngPVohG/U9DMqEJx8cqsD1neMuJrwOANpwvJuOCYe/WIgqdD7p+xROtGWlPA5Sp7q6vU5ZU5CUMY3fPCu4NqoTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7drQBlQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7drQBlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B794F1F000FF;
	Sat, 12 Sep 2026 11:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212494;
	bh=wVwJrYQnwUyWKYpLiu1EpHLh7g5Gd6J7/PaESqTcxC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S7drQBlQ9TAHh/fJDR7fk9lRAqEyFRoXYSP1sTtbrVm1vMMzedhCi0VLTyLLksy7s
	 lk0zo6nGn5XB/R9o8REjW7oLSg3RJJMOvREMBa7nBrR4lc1cn43speZhFpCrWriK7s
	 FQ/VtB5G5iif0wlFJJEt4JRmib6yelWjrLVTUQNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1448/1518] selftests/arm64: Fix MTE prctl TAP plan
Date: Sat, 12 Sep 2026 09:00:17 +0200
Message-ID: <20260912065656.311823080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@arm.com>

[ Upstream commit bb52892f9234e4ecd982fa51222aab33ce282f79 ]

The MTE prctl test emits one result from check_basic_read() followed by
one result for each of the seven entries in mte_modes[]. However, the TAP
plan only accounts for the array entries, producing:

  # Planned tests != run tests (7 != 8)

Include the basic read check in the plan so that all eight emitted results
are declared.

Reviewed-by: Mark Brown <broonie@kernel.org>
Fixes: 1f488fb91378 ("kselftest/arm64/mte: Add MTE_STORE_ONLY testcases")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/mte/check_prctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/arm64/mte/check_prctl.c b/tools/testing/selftests/arm64/mte/check_prctl.c
index f7f320defa7b9..d16a91117eef9 100644
--- a/tools/testing/selftests/arm64/mte/check_prctl.c
+++ b/tools/testing/selftests/arm64/mte/check_prctl.c
@@ -119,7 +119,7 @@ int main(void)
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(mte_modes));
+	ksft_set_plan(ARRAY_SIZE(mte_modes) + 1);
 
 	check_basic_read();
 	for (i = 0; i < ARRAY_SIZE(mte_modes); i++)
-- 
2.53.0



