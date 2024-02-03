Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08133FBF2;
	Sat,  3 Feb 2024 04:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933509; cv=none; b=m6sq3gpjoiNWP+RA3NM8dygcdWOXmo3BY9U8rGgxnZjCblAKFD/Vy1moO/qdst1+AQzo/mkY31l5Ph+dAbP/aQxfjNnfSvIMNrnJ9q4Jc7qPOFlg3m/mQ7aERSV6gGopPA7vCVyC7B1oP5+pdCpBeVaIlm3sEMRaaZn3G7sDQDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933509; c=relaxed/simple;
	bh=j+dAXtRllpemG1/INySqTZ+XtUJBY6U+43h6IfZRa24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dyFtjRJ7hi52rNrQXO3xmpEpn2zsfAMLFtAXwuNwsvWJurjOQWI3GWfT+T4GRQ2alQ0p9nId4U7yJgfH6qRX0C7pa35Is9Hb78sqCDO6FKwLbTCwYnrVW+VdFR+Lv6c2ObgvHMIisyoX+lBkoBI+1yjf73B2N/UHeGAanBUdkCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xmgsVYNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmgsVYNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AEAC433F1;
	Sat,  3 Feb 2024 04:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933508;
	bh=j+dAXtRllpemG1/INySqTZ+XtUJBY6U+43h6IfZRa24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xmgsVYNWh1zJK4Dl/5vHZnfYth7meQspe5W00faknk5g+IfDllLz94oBq/i5XvLql
	 yAiKrOSR2R0+MDBlr0GahuI/uXjpbCz5tk0o6UQ5h6xyDS/veacXrxy7hTuirzVpiV
	 ieyjIP32mfmA2oqE6LsXoT6diRln0QpV5dSM3d+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/322] selftests/nolibc: fix testcase status alignment
Date: Fri,  2 Feb 2024 20:01:57 -0800
Message-ID: <20240203035359.702823999@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 07f679b50252dc9e3d0c19aca5801f82c230c527 ]

Center-align all possible status reports.
Before OK and FAIL were center-aligned in relation to each other but
SKIPPED and FAILED would be left-aligned.

Before:

7 environ_addr = <0x7fffef3e7c50>                                [OK]
8 environ_envp = <0x7fffef3e7c58>                               [FAIL]
9 environ_auxv                                                  [SKIPPED]
10 environ_total                                                [SKIPPED]
11 environ_HOME = <0x7fffef3e99bd>                               [OK]
12 auxv_addr                                                    [SKIPPED]
13 auxv_AT_UID = 1000                                            [OK]

After:

7 environ_addr = <0x7ffff13b00a0>                                 [OK]
8 environ_envp = <0x7ffff13b00a8>                                [FAIL]
9 environ_auxv                                                  [SKIPPED]
10 environ_total                                                [SKIPPED]
11 environ_HOME = <0x7ffff13b19bd>                                [OK]
12 auxv_addr                                                    [SKIPPED]
13 auxv_AT_UID = 1000                                             [OK]

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nolibc/nolibc-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/nolibc/nolibc-test.c b/tools/testing/selftests/nolibc/nolibc-test.c
index fb3bf91462e2..1fc4998f06bf 100644
--- a/tools/testing/selftests/nolibc/nolibc-test.c
+++ b/tools/testing/selftests/nolibc/nolibc-test.c
@@ -145,11 +145,11 @@ static void result(int llen, enum RESULT r)
 	const char *msg;
 
 	if (r == OK)
-		msg = " [OK]";
+		msg = "  [OK]";
 	else if (r == SKIPPED)
 		msg = "[SKIPPED]";
 	else
-		msg = "[FAIL]";
+		msg = " [FAIL]";
 
 	if (llen < 64)
 		putcharn(' ', 64 - llen);
-- 
2.43.0



