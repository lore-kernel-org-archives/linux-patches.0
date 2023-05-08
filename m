Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310F813AF2
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D03CC433D2;
	Mon,  8 May 2023 11:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543714;
	bh=SpOpKVv8DDz0fgrpciLmpc0hAFRgh4wAcDV1HpjQDTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cljp7dl0ZrfUZo7JYZl9LoFQBTydjgeJnXLibwsUULaxYuv/SldbSUaqO8yTfMxOe
	 GDDgumluBsRIdblNMGTji49H5KwmNJ+o/EPdVzbg0jLWzoex7mBB1h1uyWhYAPJa+L
	 KMwP2sbjnsWuAMXXdzVRqbDWZnk93RJexndnecHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Tobias Klauser <tklauser@distanz.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 146/694] selftests/clone3: fix number of tests in ksft_set_plan
Date: Mon,  8 May 2023 11:39:41 +0200
Message-Id: <20230508094437.190359374@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tobias Klauser <tklauser@distanz.ch>

[ Upstream commit d95debbdc528d50042807754d6085c15abc21768 ]

Commit 515bddf0ec41 ("selftests/clone3: test clone3 with CLONE_NEWTIME")
added an additional test, so the number passed to ksft_set_plan needs to
be bumped accordingly.

Also use ksft_finished() to print results and exit. This will catch future
mismatches between ksft_set_plan() and the number of tests being run.

Fixes: 515bddf0ec41 ("selftests/clone3: test clone3 with CLONE_NEWTIME")
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/clone3/clone3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/clone3/clone3.c b/tools/testing/selftests/clone3/clone3.c
index 4fce46afe6db8..e495f895a2cdd 100644
--- a/tools/testing/selftests/clone3/clone3.c
+++ b/tools/testing/selftests/clone3/clone3.c
@@ -129,7 +129,7 @@ int main(int argc, char *argv[])
 	uid_t uid = getuid();
 
 	ksft_print_header();
-	ksft_set_plan(17);
+	ksft_set_plan(18);
 	test_clone3_supported();
 
 	/* Just a simple clone3() should return 0.*/
@@ -198,5 +198,5 @@ int main(int argc, char *argv[])
 	/* Do a clone3() in a new time namespace */
 	test_clone3(CLONE_NEWTIME, 0, 0, CLONE3_ARGS_NO_TEST);
 
-	return !ksft_get_fail_cnt() ? ksft_exit_pass() : ksft_exit_fail();
+	ksft_finished();
 }
-- 
2.39.2



