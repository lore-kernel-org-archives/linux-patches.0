Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875E7524C2;
	Thu, 30 Nov 2023 16:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFpFpS8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1487DC433C8;
	Thu, 30 Nov 2023 16:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361593;
	bh=JVk8OWsQZWl9BKzyax2z/BWlBWaUnswYhqeyIxggpLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFpFpS8r8xb86rMrz1sX/55K8T4cuA2ij3344JXJjDdI4hP6UENudQCRCPiDSObe/
	 29wdbSfcsBBbiiVjjm9wCNlvS3ZUboAMswyO4V5lR3YBf2sUdlC57rOi1ml5SOZoRI
	 641ZPdh2yCmEuV37/QwM/O82HsnnxCTjcTiBar7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.6 059/112] kselftest/arm64: Fix output formatting for za-fork
Date: Thu, 30 Nov 2023 16:21:46 +0000
Message-ID: <20231130162142.197815220@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

commit 460e462d22542adfafd8a5bc979437df73f1cbf3 upstream.

The za-fork test does not output a newline when reporting the result of
the one test it runs, causing the counts printed by kselftest to be
included in the test name.  Add the newline.

Fixes: 266679ffd867 ("kselftest/arm64: Convert za-fork to use kselftest.h")
Cc: <stable@vger.kernel.org> # 6.4.x
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20231116-arm64-fix-za-fork-output-v1-1-42c03d4f5759@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/arm64/fp/za-fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/arm64/fp/za-fork.c
+++ b/tools/testing/selftests/arm64/fp/za-fork.c
@@ -85,7 +85,7 @@ int main(int argc, char **argv)
 	 */
 	ret = open("/proc/sys/abi/sme_default_vector_length", O_RDONLY, 0);
 	if (ret >= 0) {
-		ksft_test_result(fork_test(), "fork_test");
+		ksft_test_result(fork_test(), "fork_test\n");
 
 	} else {
 		ksft_print_msg("SME not supported\n");


