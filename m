Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEB9209693;
	Thu, 12 Dec 2024 15:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017011; cv=none; b=tCvMJjnCZk32gvg6ixo1+6E+QWGaK+kvgFRHwECAGpQYSM0askdmTungRospv5WtrcPWpVkZFWXSQIgnCEPbToyJ3ZA9Do8k7ziZ5R7BxB4adVrXzm8hbG6i5bwVqObIDVtajCFcLHfcia+oU/7G3J1V8l7MkE3h2xsA+ie/FbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017011; c=relaxed/simple;
	bh=XmFcFj63zSGG3wYCSF4r0D6KK0q6J/KytaZen57rN4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/8yceiGbATfudA4qgqT/0C8Wiwv+8sfRMwtK8awmLxYtydPHWmQ/qg5JkcqeASxPlW78mHTz2psv0X6SKn4HIeb645JHDiNxCU9pJQirkx8ibOl4rY5t/aQPocFmmVGUB6pg/9BvAORSdaA0caam5fnG5w8nzyNJhGMpstkJl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CbLMdezi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CbLMdezi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADF6C4CED0;
	Thu, 12 Dec 2024 15:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017010;
	bh=XmFcFj63zSGG3wYCSF4r0D6KK0q6J/KytaZen57rN4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CbLMdeziUvmPAvnH+ueld5GNvncHbX2DzqJVFCVP9sNJrr4719tVuacL9frm0TkQq
	 656en+LGdiDMHHmZHTUnHgJm1qieEvb2YUyeU/rsZRIE03WLRtWDf0m4hUkTEJMUma
	 TlAaEBw8CibRQ8XRWPDiH9ivQyN22ZvbNtplezgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 355/466] rtla: Fix consistency in getopt_long for timerlat_hist
Date: Thu, 12 Dec 2024 15:58:44 +0100
Message-ID: <20241212144320.810951011@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit cfb1ea216c1656a4112becbc4bf757891933b902 ]

Commit e9a4062e1527 ("rtla: Add --trace-buffer-size option") adds a new
long option to rtla utilities, but among all affected files,
timerlat_hist misses a trailing `:` in the corresponding short option
inside the getopt string (e.g. `\3:`). This patch propagates the `:`.

Although this change is not functionally required, it improves
consistency and slightly reduces the likelihood a future change would
introduce a problem.

Cc: John Kacur <jkacur@redhat.com>
Cc: Luis Goncalves <lgoncalv@redhat.com>
Cc: Tomas Glozar <tglozar@redhat.com>
Link: https://lore.kernel.org/20240926143417.54039-1-gmonaco@redhat.com
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/timerlat_hist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/src/timerlat_hist.c b/tools/tracing/rtla/src/timerlat_hist.c
index 829511a712224..f6aa83ff15659 100644
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -778,7 +778,7 @@ static struct timerlat_hist_params
 		/* getopt_long stores the option index here. */
 		int option_index = 0;
 
-		c = getopt_long(argc, argv, "a:c:C::b:d:e:E:DhH:i:knp:P:s:t::T:uU0123456:7:8:9\1\2:\3",
+		c = getopt_long(argc, argv, "a:c:C::b:d:e:E:DhH:i:knp:P:s:t::T:uU0123456:7:8:9\1\2:\3:",
 				 long_options, &option_index);
 
 		/* detect the end of the options. */
-- 
2.43.0



