Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC91C315781;
	Mon, 18 Aug 2025 13:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525493; cv=none; b=eTnLyeD0zCf8rn0pIQ/qSduhl3ixNjlC9UIIASWR24Hxt8qpbvnh7z3vdyDL8KLUz/g9XBhZOJ0+2dRvoLFa8D3YAv3GpQAGZPfXyhq9vt+DxHPGiH6rKldR0wHA/v+ZxFr8w8ZICp11+vYmp9HK6bvrEN4kenHePLtT02evKaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525493; c=relaxed/simple;
	bh=R8F5W5q2yBUzsKf/72txLbM2kmKUMDyj/zgsJtBMs0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5D1S5fhOwgtEkRrqLdyeinlPBiUTgSF5khf5eV7jlW/ixsnzQjM/07AgIPbuqUalXoJkPpo1f/ScgAqdEKgHe7siPjBVyoAzjE51Ed6GkRwjtfPW+cDEPL85K3lEScDRcbfwaPnM7j/j9N7t3kHfHrYeUDWEkWxjQk9otW9r14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ya8hmn0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ya8hmn0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADDEC4CEEB;
	Mon, 18 Aug 2025 13:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525492;
	bh=R8F5W5q2yBUzsKf/72txLbM2kmKUMDyj/zgsJtBMs0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ya8hmn0Dya44E1bLte/WXXu0NecGBlZr1u+eimvIx7ja03OAvrFyTLrCb/uHHfsQk
	 nwuxUFzZFEaNc9/LP0hYF54uv+dNzGc6jNh6Lt8nBNUqv8E08oIqzQiFh8RBTupa+7
	 C/0zDZD4Y/G0trnf2K9j3+kXLyS2VhkCp2/+wfUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 280/570] kselftest/arm64: Specify SVE data when testing VL set in sve-ptrace
Date: Mon, 18 Aug 2025 14:44:27 +0200
Message-ID: <20250818124516.634867524@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 9e8ebfe677f9101bbfe1f75d548a5aec581e8213 ]

Since f916dd32a943 ("arm64/fpsimd: ptrace: Mandate SVE payload for
streaming-mode state") we reject attempts to write to the streaming mode
regset even if there is no register data supplied, causing the tests for
setting vector lengths and setting SVE_VL_INHERIT in sve-ptrace to
spuriously fail. Set the flag to avoid the issue, we still support not
supplying register data.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20250609-kselftest-arm64-ssve-fixups-v2-3-998fcfa6f240@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/fp/sve-ptrace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/arm64/fp/sve-ptrace.c b/tools/testing/selftests/arm64/fp/sve-ptrace.c
index c499d5789dd5..16320aeaff85 100644
--- a/tools/testing/selftests/arm64/fp/sve-ptrace.c
+++ b/tools/testing/selftests/arm64/fp/sve-ptrace.c
@@ -170,7 +170,7 @@ static void ptrace_set_get_inherit(pid_t child, const struct vec_type *type)
 	memset(&sve, 0, sizeof(sve));
 	sve.size = sizeof(sve);
 	sve.vl = sve_vl_from_vq(SVE_VQ_MIN);
-	sve.flags = SVE_PT_VL_INHERIT;
+	sve.flags = SVE_PT_VL_INHERIT | SVE_PT_REGS_SVE;
 	ret = set_sve(child, type, &sve);
 	if (ret != 0) {
 		ksft_test_result_fail("Failed to set %s SVE_PT_VL_INHERIT\n",
@@ -235,6 +235,7 @@ static void ptrace_set_get_vl(pid_t child, const struct vec_type *type,
 	/* Set the VL by doing a set with no register payload */
 	memset(&sve, 0, sizeof(sve));
 	sve.size = sizeof(sve);
+	sve.flags = SVE_PT_REGS_SVE;
 	sve.vl = vl;
 	ret = set_sve(child, type, &sve);
 	if (ret != 0) {
-- 
2.39.5



