Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0056D528;
	Sun,  7 Sep 2025 20:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276858; cv=none; b=TPsaNGS8EwXzjrf2p70Bt31vThs7rYpnRb97G8k/eShSNRMbv1X49SyjMIGvlZ8Y0tr35qR9UEmmudTCir407VgeuavY3440CZZE5MrifwfufLghqnXobJHHGykMsBFYxsCWmimVw2aqscuwgKX+yyEjd/Fszyog4jTMMMr+n9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276858; c=relaxed/simple;
	bh=bh3TodQmUVGdF1b6emM7/A3cD3DA/gH/OExI/DBezE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xhk8lfA6kxrKBdgNXMAkZHB3XhtdnCIpTWYDofU+xaD4lFLPe2uJOU5ss0yfgoqbQQ6Xn0IQC0zk9yWrnwjUsmZcNaN54cdVWJXOhzUV/DxdDTzi5EInkBx6l2b/MT8k3u/iGI+0VRCysZdJ/Zg5usuRLiN+o5nd2VDkE1oTUnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RdI9hHXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdI9hHXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84EAC4CEF0;
	Sun,  7 Sep 2025 20:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276858;
	bh=bh3TodQmUVGdF1b6emM7/A3cD3DA/gH/OExI/DBezE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RdI9hHXHSIi/ornuRA+0meA8bBmxU7a1kR2rKiW1DMcK4z3HqcTV2SVbsTz2A2frN
	 UsIMvrEVLMfrt9xwREAzdmXLaW+y6WLe+nXTo4q6vLr69tsGbtXjS14mAxGSK5awFd
	 zu7oKVMJqhAL4rl0FWLivR2+o+vNZkezFYWwfPl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinji Nomoto <fj5851bi@fujitsu.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/175] cpupower: Fix a bug where the -t option of the set subcommand was not working.
Date: Sun,  7 Sep 2025 21:56:46 +0200
Message-ID: <20250907195615.158223280@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shinji Nomoto <fj5851bi@fujitsu.com>

[ Upstream commit b3eaf14f4c63fd6abc7b68c6d7a07c5680a6d8e5 ]

The set subcommand's -t option is documented as being available for boost
configuration, but it was not actually functioning due to a bug
in the option handling.

Link: https://lore.kernel.org/r/20250522061122.2149188-2-fj5851bi@fujitsu.com
Signed-off-by: Shinji Nomoto <fj5851bi@fujitsu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/cpupower/utils/cpupower-set.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/power/cpupower/utils/cpupower-set.c b/tools/power/cpupower/utils/cpupower-set.c
index 0677b58374abf..59ace394cf3ef 100644
--- a/tools/power/cpupower/utils/cpupower-set.c
+++ b/tools/power/cpupower/utils/cpupower-set.c
@@ -62,8 +62,8 @@ int cmd_set(int argc, char **argv)
 
 	params.params = 0;
 	/* parameter parsing */
-	while ((ret = getopt_long(argc, argv, "b:e:m:",
-						set_opts, NULL)) != -1) {
+	while ((ret = getopt_long(argc, argv, "b:e:m:t:",
+				  set_opts, NULL)) != -1) {
 		switch (ret) {
 		case 'b':
 			if (params.perf_bias)
-- 
2.50.1



