Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E342B2F8BE7;
	Tue, 12 Aug 2025 17:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021278; cv=none; b=kKCK9Qpfy4kzzEhJSAWGGdYT/A+uNlbXZRR3q6yRcJZmUnKTHBXsoU0eeIc5XYsC60UB/5IFEfOLo5lPEY+HDvgxZHlEMJ8C+eYt/mi0YD1yyfGzSIdLgzRRtua+FBZpkiHTrimcZo7tg7hs7akigYAHzZWAMqHojtleYXLfxhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021278; c=relaxed/simple;
	bh=hIYa65TGMCMDdr6SdDMStahmSY87zbeFJrMS7tScCOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+hGTK9xkIMrTcnDfiasS1ctwxUldBf//JeFiizQt633QGOfoONBXzXFXQfMZl+TghXlWQMGc5V4zJJh0Gnf6j/tq7oEws1WxAQ7Jl7HOAMF8Xh4ACXda4xAtQG/TwwhIk3bpNgDpxjdWm3iFqe5Xeq+m9O2nBmDj/t5IfZkvLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DeKuAQ6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DeKuAQ6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514DCC4CEF0;
	Tue, 12 Aug 2025 17:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021277;
	bh=hIYa65TGMCMDdr6SdDMStahmSY87zbeFJrMS7tScCOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DeKuAQ6kLnfFCvM9CmgiCt1G3XZwqaNZcjzmAljoiQzBxKYAsISvoyyX+jrWN/lEm
	 gFANI68bdt1etPxB8Dz5Bg3ffrrA96fgxVuudJtw9V019eAh6qaJsHM+ZwOka+iB1w
	 Zs403coQe5W0vz+C/H/etlx6Ln5mPSnzEQ2BSFfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/262] kselftest/arm64: Fix check for setting new VLs in sve-ptrace
Date: Tue, 12 Aug 2025 19:27:33 +0200
Message-ID: <20250812172955.760540469@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6d61992fe8a0..c6228176dd1a 100644
--- a/tools/testing/selftests/arm64/fp/sve-ptrace.c
+++ b/tools/testing/selftests/arm64/fp/sve-ptrace.c
@@ -251,7 +251,7 @@ static void ptrace_set_get_vl(pid_t child, const struct vec_type *type,
 		return;
 	}
 
-	ksft_test_result(new_sve->vl = prctl_vl, "Set %s VL %u\n",
+	ksft_test_result(new_sve->vl == prctl_vl, "Set %s VL %u\n",
 			 type->name, vl);
 
 	free(new_sve);
-- 
2.39.5



