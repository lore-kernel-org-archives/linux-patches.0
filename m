Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274E42F7477;
	Tue, 12 Aug 2025 17:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020533; cv=none; b=n8aumgANjxJKJeSZYc9zX8Eo9uxiIQZoVf+Z1lUT1yLza+AuKspIe1OIy10CyXSlFu0MQOoYI2eg4yb6iv1d3/+POZSoU/8JAbjYuMxotgM+/Zcmq4aCpbxwNRnXX55wi8CvyHgrjEkV2iSSr/76dQnjxq8ObtUqWEJDCbpN2P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020533; c=relaxed/simple;
	bh=wz+e2GsxBSuDXKkzGXWeG+Xk5nF06CR70w5FasRpbts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKBpYmWicmCr5LKDGSm4BXml2myGNVfb38dXHvnujQxEkpUk1CtEM295TZ9ShcQ4yNY0h8BXd660TVzSXzpNzKieoevrpQE9UAckSXUHvQmGu2+xuKkd5A7jaeG3bczwJcp9p1UzeYPcWQDq3CcCYylw3CIUvLEprQjTUS4FeGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWJ02GOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWJ02GOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8E5C4CEF0;
	Tue, 12 Aug 2025 17:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020533;
	bh=wz+e2GsxBSuDXKkzGXWeG+Xk5nF06CR70w5FasRpbts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWJ02GOaPQvVERa6VUzet0b9ISeftKAqBT5SCbaB/3UQKCWD2LnvWy2aboXpZAFUQ
	 nATSISYm3Wj8aan8AnqSSx05VU8y9xnttPjLryauW2RhT4yt1/c/4MJiKiFyC6Tzrr
	 au8VCVPch5wFKKgxJy4JgsQ3Zhb2rDUz7ZzZJtEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/253] kselftest/arm64: Fix check for setting new VLs in sve-ptrace
Date: Tue, 12 Aug 2025 19:28:17 +0200
Message-ID: <20250812172953.361675911@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 867446f090589626497638f70b10be5e61a0b925 ]

The check that the new vector length we set was the expected one was typoed
to an assignment statement which for some reason the compilers didn't spot,
most likely due to the macros involved.

Fixes: a1d7111257cd ("selftests: arm64: More comprehensively test the SVE ptrace interface")
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20250609-kselftest-arm64-ssve-fixups-v2-1-998fcfa6f240@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/fp/sve-ptrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/arm64/fp/sve-ptrace.c b/tools/testing/selftests/arm64/fp/sve-ptrace.c
index 8c4847977583..91dd31629ffe 100644
--- a/tools/testing/selftests/arm64/fp/sve-ptrace.c
+++ b/tools/testing/selftests/arm64/fp/sve-ptrace.c
@@ -241,7 +241,7 @@ static void ptrace_set_get_vl(pid_t child, const struct vec_type *type,
 		return;
 	}
 
-	ksft_test_result(new_sve->vl = prctl_vl, "Set %s VL %u\n",
+	ksft_test_result(new_sve->vl == prctl_vl, "Set %s VL %u\n",
 			 type->name, vl);
 
 	free(new_sve);
-- 
2.39.5



