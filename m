Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C98014BFA2;
	Sun,  7 Sep 2025 20:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276472; cv=none; b=GGeidulCyejVt5vFEQS5OinFwTpG2CySZV6nRWAhdjVqksJjTXxC3U443OfKRFNrSvm3UIUD4srxDXks4ab028dmbnqrtWJ5vg35KFte9q6UFycIHTcfnAbdBaHBA9vMpf3cm3oremWl1ZeFVlqcpWdXCTO9L8bymrPcd6imKW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276472; c=relaxed/simple;
	bh=L1b/rinwP5r9jFAHWTc2DC6B4u34boWC4kj+WpVuUGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcdCW1AlPET1UmjvxXUYboI5Y28yuAe6oWI3KGBeQwsHDPJjZgrOOo0Ma8/AZEoqpJr2eI1cksNa0xmDa4JMrth1LxRHLcbpQC8NIOz/FfA3kFm27Cq29oTY8DNMrFowus/saC4MOZZww+6Cyvg7Zz0Xmmx/EJXMYGTm58P4ioU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiYLfIdN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiYLfIdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64074C4CEF0;
	Sun,  7 Sep 2025 20:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276471;
	bh=L1b/rinwP5r9jFAHWTc2DC6B4u34boWC4kj+WpVuUGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiYLfIdNWUZHQJ3yC6lG76Mwl8gwYZOUSfRx68goWjkGKOjaDU0B730eZ3hyzIils
	 kc6uB56X2j6NsHG3zNGyUjOVPpM3ma4dZyjyTEPfTWKcZRZCp3TW1S0j/xa82/KOGz
	 +XA1CMXHnPSygS5tClnlwg0SlUWi27q42cHj9rkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinji Nomoto <fj5851bi@fujitsu.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/121] cpupower: Fix a bug where the -t option of the set subcommand was not working.
Date: Sun,  7 Sep 2025 21:57:27 +0200
Message-ID: <20250907195610.103771049@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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



