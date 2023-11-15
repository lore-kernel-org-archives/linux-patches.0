Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A2D3A8FA
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgPs1Q9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8B5C433C8;
	Wed, 15 Nov 2023 20:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078482;
	bh=zizf2F2b1K1J427Um8CN4lRqvxahQWgqNDj2iHUbtGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgPs1Q9l1L39+HKw9Pj+XZsbRxZ3ig/jkh66XFMadIK7PmzOB4J8S6oFs/mp6K71o
	 EmJOqWME2QlKjPMj3Yrg9vq3kc8YaeH33M2oNA2/+w62VKCT/wkGj4TW4srQbniPW0
	 aJEJ4p1Y3op6zzE5e/oR4XGh4NK7P+BTbAxt6ffI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Po-Hsu Lin <po-hsu.lin@canonical.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 348/379] selftests: pmtu.sh: fix result checking
Date: Wed, 15 Nov 2023 14:27:03 -0500
Message-ID: <20231115192705.735342861@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 63e201916b27260218e528a2f8758be47f99bbf4 ]

In the PMTU test, when all previous tests are skipped and the new test
passes, the exit code is set to 0. However, the current check mistakenly
treats this as an assignment, causing the check to pass every time.

Consequently, regardless of how many tests have failed, if the latest test
passes, the PMTU test will report a pass.

Fixes: 2a9d3716b810 ("selftests: pmtu.sh: improve the test result processing")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/pmtu.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index dfe3d287f01d2..0d705fdcf3b76 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -2013,7 +2013,7 @@ run_test() {
 	case $ret in
 		0)
 			all_skipped=false
-			[ $exitcode=$ksft_skip ] && exitcode=0
+			[ $exitcode -eq $ksft_skip ] && exitcode=0
 		;;
 		$ksft_skip)
 			[ $all_skipped = true ] && exitcode=$ksft_skip
-- 
2.42.0



