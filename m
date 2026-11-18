Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020051;
	b=hNpDWQD0u/FHY7HoU8t1U3wNIkCnuQy/nTx76/11H2vifvLO3QhFlOeni521QJAERIqx
	 burcgvM/h56uCnjsndKNZO8y+SKChIPjX3x93fOL29uVRFl0kbdeT9G5CjrJuAUU1ZcCl
	 FjMnJsej3jKJiE656YM5oGAApSyuBy9O+ZOWhQLTl+7zI3JdfhSHfPfjsxV5N5u3R4Mjl
	 p2JgLR7yQSK7dt8JIK4kPB6YxxlmZb0912KNVL9GT6hatL0vEfAqkX6v2x02H00cpH5A9
	 6cTpUEEWrYE7Ui8gqEDvrMXZdvlXmQibVwDCODHzqAjrXzPry6quf9iyrwfhLD4wRhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=onxbA+0H6gmzirEYnTtltPQJ7wRm8ioBGWt7KhbQePM=;
	b=TPvbCy1X6wGTmJm+cNF73gr2q7i8kikQrKnVeHXaLyVIq/nDaVtsQsnTClfBFEoR5JAf
	 aN3GckYUKIsuMFUGzRRv4lts+kV2qoWGpbQDYFukBkIzG9x9yLwE1HmLGCAF2chY3aOpj
	 nYgEMvWHvqc7XVDbXrmM0iNDevo5KdMBM7Hwm5qL2sHRBmdFairUfPzTYPxVCMALHQCZJ
	 wg4jzVdv0lAY6j07tozhidn63H/3jqe/mguFdkHG93I3N/LLKsGbkH++j+iYpOHjNWjPk
	 KKJV4arj8+F8bvg/k5mTrXKUPgUzlpcu7Ghhguz5A/qbl4aZvEdUM5q0s5UYFBHbaCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yMCGOqr0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBE3606A335;
	Wed, 18 Nov 2026 16:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yMCGOqr0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E29E1F000C4;
	Wed, 18 Nov 2026 16:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020051;
	bh=onxbA+0H6gmzirEYnTtltPQJ7wRm8ioBGWt7KhbQePM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yMCGOqr031yUE9DG1iTGbLvdov/XfCi/V4ONAIxBku3CSnCmO68Q9n7qf2wP69smD
	 rfwEtIX6h1lVLTJhTZ4BFBP3Dg52iRxviiUWtqJrn9AMpgQo4uTAMgwisGl3Iqc28r
	 XkZojVYK/PAHIVj4eMuM/sEAYjcLFonCBXF0s6F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1814/2651] kselftest/filelock: plan for the five ofdlocks tests
Date: Wed, 18 Nov 2026 15:50:54 +0100
Message-ID: <20261118150352.525317960@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit d05de2360a3e25aa3ec24f460802755a95e8e6e9 ]

ofdlocks reports five results but plans for four, so even when they
all pass it ends with

  # Planned tests != run tests (4 != 5)

and exits with KSFT_FAIL, which run_kselftest.sh reports as a failure.

Link: https://lore.kernel.org/20260925205502.115327-1-danishkhateeb03@gmail.com
Fixes: 33d5b13098fb ("kselftest/filelock: report each test in oftlocks separately")
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Shuah Khan <shuah@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/filelock/ofdlocks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/filelock/ofdlocks.c b/tools/testing/selftests/filelock/ofdlocks.c
index 68bac28b234b7..0ab484cb075bc 100644
--- a/tools/testing/selftests/filelock/ofdlocks.c
+++ b/tools/testing/selftests/filelock/ofdlocks.c
@@ -40,7 +40,7 @@ int main(void)
 	int fd2 = open("/tmp/aa", O_RDONLY);
 
 	ksft_print_header();
-	ksft_set_plan(4);
+	ksft_set_plan(5);
 
 	unlink("/tmp/aa");
 	assert(fd != -1);
-- 
2.53.0



