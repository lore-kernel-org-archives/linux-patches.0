Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427F8AD4B;
	Tue, 26 Aug 2025 13:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214443; cv=none; b=bYC8IrAl8cEZs5XyquheCzL/OPaPJ9M3/A0kwMcxaRPFtGuqWadbVZYwDqyB/BZ/tuvJDxfUVAoUcRELKfMaEoSvaKOfPlfEFJqbdcgKCJhTAoSOwuP5Zmik6zj+WPYUkBwfkNOAaEhntjud2pGmJX4Zj7kUbJu6tOfBfDbxeak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214443; c=relaxed/simple;
	bh=hCiMe5XgobARM+Q/Vb3qN0MsTLH+Ll6cVEa9P9zYUHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ru3z9ljFqu+AmP1ePrQPOHEdZWByNc4xcU7GaW3miy8pNlGzock/Kc26wHjFBI5azX0z83ksaLj/5dvHCuQWEQzi1ILBdj0W53r9qMolH1krOV1CNsupSOp2Ibe6TwaaXPabhAc7LTTmw8UCw/Z6+x1OYwGGusuWo2qtMBD1pDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjcUkqKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjcUkqKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F62AC4CEF1;
	Tue, 26 Aug 2025 13:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214443;
	bh=hCiMe5XgobARM+Q/Vb3qN0MsTLH+Ll6cVEa9P9zYUHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjcUkqKMo3j+xby+ewlckZYBqifQmVQXY4Bnp3HZLJUe/bbwfJZ3KuZ068knZBqyF
	 SsfFCcO8Otcw2QBjvwyndCK8vWcLK0+5NoCNlP9OCrGh+GS5OUAvIA5WstQRuPc4lG
	 YJvtyyjL9XYG3i1lKiAbOLyTh+G5a+6s/gVFGVnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/482] kselftest/arm64: Specify SVE data when testing VL set in sve-ptrace
Date: Tue, 26 Aug 2025 13:06:32 +0200
Message-ID: <20250826110934.253126855@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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
index 91dd31629ffe..9f5461cd5b8f 100644
--- a/tools/testing/selftests/arm64/fp/sve-ptrace.c
+++ b/tools/testing/selftests/arm64/fp/sve-ptrace.c
@@ -158,7 +158,7 @@ static void ptrace_set_get_inherit(pid_t child, const struct vec_type *type)
 	memset(&sve, 0, sizeof(sve));
 	sve.size = sizeof(sve);
 	sve.vl = sve_vl_from_vq(SVE_VQ_MIN);
-	sve.flags = SVE_PT_VL_INHERIT;
+	sve.flags = SVE_PT_VL_INHERIT | SVE_PT_REGS_SVE;
 	ret = set_sve(child, type, &sve);
 	if (ret != 0) {
 		ksft_test_result_fail("Failed to set %s SVE_PT_VL_INHERIT\n",
@@ -223,6 +223,7 @@ static void ptrace_set_get_vl(pid_t child, const struct vec_type *type,
 	/* Set the VL by doing a set with no register payload */
 	memset(&sve, 0, sizeof(sve));
 	sve.size = sizeof(sve);
+	sve.flags = SVE_PT_REGS_SVE;
 	sve.vl = vl;
 	ret = set_sve(child, type, &sve);
 	if (ret != 0) {
-- 
2.39.5



