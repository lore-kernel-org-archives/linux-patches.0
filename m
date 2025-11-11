Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01D9304BDB;
	Tue, 11 Nov 2025 01:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823859; cv=none; b=Y5ETMeIuoskuUMO3gZtN5WtqkDePf4LoDA84hSG4PHQgym3NRPq7QGi2zLCfjV4YM+i7VF5PVP45vSR6RCZp7JOseJn3rHvwSQEJsbwW1JhhtMtU9/h9CzWQNALse/Csp1pl33xk1eCb1bnqwJIu5j1Sbsl3c1ZHDQLyPvg4PME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823859; c=relaxed/simple;
	bh=hwj8P2HJb/11c4ZAhtto6MFp2Lo/G/85tJbiTXSAAoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKZJB6jFOFwZX3LPzgX/BQ1uImxsYjC4+RzVwCarZkivhAnPbwx1ETDdRIrIcovZ2EBrG83UplopM4YsXiJ36TYuzdDdhB9o4+bXtpVDYsQWRPcsVCIKyh2+yX4SK9nn76iA9y4R3z9viBSoN9+//QmaFO2dUaL40NBMCPzBh5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FWotgtdZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FWotgtdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83017C19425;
	Tue, 11 Nov 2025 01:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823858;
	bh=hwj8P2HJb/11c4ZAhtto6MFp2Lo/G/85tJbiTXSAAoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FWotgtdZGFaQwmiwQPT7bcA0BSXE8+9d7h9VIN47C27kLjwWkNapTlyBtTP5M37pq
	 BXdqF2UraxP/YcmS4xNDn3aLz1dBLNXM3+4Si5iNOLN89t8G+E9nTqxjIkxZQ/2IVk
	 LA1ZjIc5XxtkHxjwGflU92NiB23d6Gcq3YhCv1T4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 338/565] selftests: traceroute: Use require_command()
Date: Tue, 11 Nov 2025 09:43:14 +0900
Message-ID: <20251111004534.484913214@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 47efbac9b768553331b9459743a29861e0acd797 ]

Use require_command() so that the test will return SKIP (4) when a
required command is not present.

Before:

 # ./traceroute.sh
 SKIP: Could not run IPV6 test without traceroute6
 SKIP: Could not run IPV4 test without traceroute
 $ echo $?
 0

After:

 # ./traceroute.sh
 TEST: traceroute6 not installed                                    [SKIP]
 $ echo $?
 4

Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250908073238.119240-6-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/traceroute.sh | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/net/traceroute.sh b/tools/testing/selftests/net/traceroute.sh
index 282f14760940d..b50e52afa4f49 100755
--- a/tools/testing/selftests/net/traceroute.sh
+++ b/tools/testing/selftests/net/traceroute.sh
@@ -203,11 +203,6 @@ setup_traceroute6()
 
 run_traceroute6()
 {
-	if [ ! -x "$(command -v traceroute6)" ]; then
-		echo "SKIP: Could not run IPV6 test without traceroute6"
-		return
-	fi
-
 	setup_traceroute6
 
 	# traceroute6 host-2 from host-1 (expects 2000:102::2)
@@ -268,11 +263,6 @@ setup_traceroute()
 
 run_traceroute()
 {
-	if [ ! -x "$(command -v traceroute)" ]; then
-		echo "SKIP: Could not run IPV4 test without traceroute"
-		return
-	fi
-
 	setup_traceroute
 
 	# traceroute host-2 from host-1 (expects 1.0.1.1). Takes a while.
@@ -306,6 +296,9 @@ do
 	esac
 done
 
+require_command traceroute6
+require_command traceroute
+
 run_tests
 
 printf "\nTests passed: %3d\n" ${nsuccess}
-- 
2.51.0



