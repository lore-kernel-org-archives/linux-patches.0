Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54A0319858;
	Mon, 29 Dec 2025 16:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025041; cv=none; b=H2z4hQDj0tU4oxt9EBewLkrK8GsEO4Degno/hQR54GUClAOpminNB9KhMebnEZHGct2RIf1h17+wHOuD3erM9B4b+6Cjp5bdlLCwD18YzyCXtSOpzcnwCxH3LagMOYd/+t/mW/98ckty6O/19rOgI1A9rKiMrTy2EthRuQX+fQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025041; c=relaxed/simple;
	bh=pbm0TSTOYB+HM1SIpEXzNcv1j4zM5N68H6VnE59QGGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h30aYOgyhy/oLXTFqqDZM5LFJsT5yoDCu5yOv2iFfHqhytcn1WJC5kqunRrGRdyRkokeRovfOOTC/cS7UC/2DtjbCCNl6I7WpaEaoL2c8QGcQRBjLQI9buqgIrlK9lXm9OU32Z8gsE7ag7VU/y20GPpabQ889EELg+GuNwdT/FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUhPYuO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUhPYuO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592DCC4CEF7;
	Mon, 29 Dec 2025 16:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025041;
	bh=pbm0TSTOYB+HM1SIpEXzNcv1j4zM5N68H6VnE59QGGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUhPYuO9ZXUXorplgSl5AqA3NtqM6eKigXRDSzjRdyV1oE/5dv2I9RE2uf5PSi1jv
	 jjowYAVi/dIuJgPgahX/rAGKRO9YrY9NYgdG5kBGMP7r3A39uRniI0LvaE52x9uwiI
	 3vilTD5VtsdG+d6/ttEkLGRFmwsv2FcIpcipsFmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 074/430] selftests: net: Fix build warnings
Date: Mon, 29 Dec 2025 17:07:56 +0100
Message-ID: <20251229160727.089309537@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 59546e874403c1dd0cbc42df06fdf8c113f72022 ]

Fix

ksft.h: In function ‘ksft_ready’:
ksft.h:27:9: warning: ignoring return value of ‘write’ declared with attribute ‘warn_unused_result’

ksft.h: In function ‘ksft_wait’:
ksft.h:51:9: warning: ignoring return value of ‘read’ declared with attribute ‘warn_unused_result’

by checking the return value of the affected functions and displaying
an error message if an error is seen.

Fixes: 2b6d490b82668 ("selftests: drv-net: Factor out ksft C helpers")
Cc: Joe Damato <jdamato@fastly.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://patch.msgid.link/20251205171010.515236-11-linux@roeck-us.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/lib/ksft.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/lib/ksft.h b/tools/testing/selftests/net/lib/ksft.h
index 17dc34a612c64..03912902a6d30 100644
--- a/tools/testing/selftests/net/lib/ksft.h
+++ b/tools/testing/selftests/net/lib/ksft.h
@@ -24,7 +24,8 @@ static inline void ksft_ready(void)
 		fd = STDOUT_FILENO;
 	}
 
-	write(fd, msg, sizeof(msg));
+	if (write(fd, msg, sizeof(msg)) < 0)
+		perror("write()");
 	if (fd != STDOUT_FILENO)
 		close(fd);
 }
@@ -48,7 +49,8 @@ static inline void ksft_wait(void)
 		fd = STDIN_FILENO;
 	}
 
-	read(fd, &byte, sizeof(byte));
+	if (read(fd, &byte, sizeof(byte)) < 0)
+		perror("read()");
 	if (fd != STDIN_FILENO)
 		close(fd);
 }
-- 
2.51.0



