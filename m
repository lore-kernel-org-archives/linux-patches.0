Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EB6222560;
	Mon, 29 Dec 2025 16:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025044; cv=none; b=o6dCyAPThYLrO0QQEiAOioP+xWWjySs3I9dSVaqKWki1LD/4nhxGV08UCiYli/bLbNvPuIgbYUtZIGVCMrzOU5JBR5jXaipkqS8faydv8kSviBE3+mEyl2EEeEG88L2ttgNuDOtEGtIsSsSNvbdOEO/5bg2bF/Je2pCOL5srfWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025044; c=relaxed/simple;
	bh=iMl2jm0P5QSET3t//QRbRTrWh2j0Bfx44exy+ixfK54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g3KMKQmD6LJU6s82nCNdonOl1vgzG+ophm84oI7JI+muKynluV5JPy2k4/ZUgX1DLKAsRpkHvsMwp1enZo7iiujqtr4ib3WYGLqqC7I+75g5tckbEWeK77YrnfSKAlgxohpho1AQsGUN+S9YoMOMNIhueRtyaayZn+g3Dq9TE4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWHDGXnV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWHDGXnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D46FC4CEF7;
	Mon, 29 Dec 2025 16:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025044;
	bh=iMl2jm0P5QSET3t//QRbRTrWh2j0Bfx44exy+ixfK54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWHDGXnV9Zq52iHpRXEZy0Www/MSjuv+vhY23d/bvlO9U74KfJS81i21aYbB6SUXL
	 +NEOxnluJilWLg6mg4OLJtvcyGuxPzUdN6K9hieas9Ufw+sK+OrTVSFlw1bh8QKbgW
	 6/grApC5peAb5Q/Rk60GLiRW0+e6dvAat36bR9AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Guenter Roeck <linux@roeck-us.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 075/430] selftests: net: tfo: Fix build warning
Date: Mon, 29 Dec 2025 17:07:57 +0100
Message-ID: <20251229160727.126113950@linuxfoundation.org>
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

[ Upstream commit 91dc09a609d9443e6b34bdb355a18d579a95e132 ]

Fix

tfo.c: In function ‘run_server’:
tfo.c:84:9: warning: ignoring return value of ‘read’ declared with attribute ‘warn_unused_result’

by evaluating the return value from read() and displaying an error message
if it reports an error.

Fixes: c65b5bb2329e3 ("selftests: net: add passive TFO test binary")
Cc: David Wei <dw@davidwei.uk>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://patch.msgid.link/20251205171010.515236-14-linux@roeck-us.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tfo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/tfo.c b/tools/testing/selftests/net/tfo.c
index eb3cac5e583c9..8d82140f0f767 100644
--- a/tools/testing/selftests/net/tfo.c
+++ b/tools/testing/selftests/net/tfo.c
@@ -81,7 +81,8 @@ static void run_server(void)
 	if (getsockopt(connfd, SOL_SOCKET, SO_INCOMING_NAPI_ID, &opt, &len) < 0)
 		error(1, errno, "getsockopt(SO_INCOMING_NAPI_ID)");
 
-	read(connfd, buf, 64);
+	if (read(connfd, buf, 64) < 0)
+		perror("read()");
 	fprintf(outfile, "%d\n", opt);
 
 	fclose(outfile);
-- 
2.51.0



