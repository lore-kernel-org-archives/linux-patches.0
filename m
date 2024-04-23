Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B3A20B3E;
	Tue, 23 Apr 2024 21:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908485; cv=none; b=Xnb060nZVG6OQzPQUDf/OYDNswB3DhUsr5y8asGWffnW8brXBGDw6rOYfT96x3iNhybYwxoaFzPKAi9VEVpLb/IU8FzY2UtpLOlJ7yYJFPBGNYBVl0r7fhQ7NjoBVBcXlnHMl0DW4EoNW5h3Zi9Nrrum4IQ0KtDT+yuDUNuczQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908485; c=relaxed/simple;
	bh=S6Wf6uzcxaZ7fVrb6odZqKJGUvyKkH1u3HsKaHSo/cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tzqrk8NZxXwQ6OVBJQHhWMU8jbUUMXnXRUdKJemm7h3Fm2LzK8dIjXC2SaNRoNfNRBDAoxZE9ophaMfq1mlOBeF3FaEISwlTHTQata8DjWnV3xR8fmHiiq/pX2J3tX45oV4waPTh4+avdFZJXQYL/arCt6rsPheZcaLAu8k/Zmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+AWf3u5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+AWf3u5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF6EC116B1;
	Tue, 23 Apr 2024 21:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908485;
	bh=S6Wf6uzcxaZ7fVrb6odZqKJGUvyKkH1u3HsKaHSo/cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+AWf3u51rRnZsj5U9RwIRgtNSqsPY/6LAyfRYTVaQQ4n5hCLhMeJsQZkHShOB0WA
	 xpboymUAPl6CFpvbDWieTChMUsej/MJ1+SinCuuThllT3P9nHbyroCei1dGhzJ9++k
	 uwUPsrtyImlI0JZ0WqRbCvsAqDyBmipgR9PLhPvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 033/158] selftests/tcp_ao: Printing fixes to confirm with format-security
Date: Tue, 23 Apr 2024 14:37:35 -0700
Message-ID: <20240423213856.969336317@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Safonov <0x7f454c46@gmail.com>

[ Upstream commit b476c93654d748c13624f7c7d0ba191c56a8092e ]

On my new laptop with packages from nixos-unstable, gcc 12.3.0 produces
> lib/setup.c: In function ‘__test_msg’:
> lib/setup.c:20:9: error: format not a string literal and no format arguments [-Werror=format-security]
>    20 |         ksft_print_msg(buf);
>       |         ^~~~~~~~~~~~~~
> lib/setup.c: In function ‘__test_ok’:
> lib/setup.c:26:9: error: format not a string literal and no format arguments [-Werror=format-security]
>    26 |         ksft_test_result_pass(buf);
>       |         ^~~~~~~~~~~~~~~~~~~~~
> lib/setup.c: In function ‘__test_fail’:
> lib/setup.c:32:9: error: format not a string literal and no format arguments [-Werror=format-security]
>    32 |         ksft_test_result_fail(buf);
>       |         ^~~~~~~~~~~~~~~~~~~~~
> lib/setup.c: In function ‘__test_xfail’:
> lib/setup.c:38:9: error: format not a string literal and no format arguments [-Werror=format-security]
>    38 |         ksft_test_result_xfail(buf);
>       |         ^~~~~~~~~~~~~~~~~~~~~~
> lib/setup.c: In function ‘__test_error’:
> lib/setup.c:44:9: error: format not a string literal and no format arguments [-Werror=format-security]
>    44 |         ksft_test_result_error(buf);
>       |         ^~~~~~~~~~~~~~~~~~~~~~
> lib/setup.c: In function ‘__test_skip’:
> lib/setup.c:50:9: error: format not a string literal and no format arguments [-Werror=format-security]
>    50 |         ksft_test_result_skip(buf);
>       |         ^~~~~~~~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors

As the buffer was already pre-printed into, print it as a string
rather than a format-string.

Fixes: cfbab37b3da0 ("selftests/net: Add TCP-AO library")
Signed-off-by: Dmitry Safonov <0x7f454c46@gmail.com>
Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tcp_ao/lib/setup.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/tcp_ao/lib/setup.c b/tools/testing/selftests/net/tcp_ao/lib/setup.c
index 92276f916f2f3..e408b9243b2c5 100644
--- a/tools/testing/selftests/net/tcp_ao/lib/setup.c
+++ b/tools/testing/selftests/net/tcp_ao/lib/setup.c
@@ -17,37 +17,37 @@ static pthread_mutex_t ksft_print_lock = PTHREAD_MUTEX_INITIALIZER;
 void __test_msg(const char *buf)
 {
 	pthread_mutex_lock(&ksft_print_lock);
-	ksft_print_msg(buf);
+	ksft_print_msg("%s", buf);
 	pthread_mutex_unlock(&ksft_print_lock);
 }
 void __test_ok(const char *buf)
 {
 	pthread_mutex_lock(&ksft_print_lock);
-	ksft_test_result_pass(buf);
+	ksft_test_result_pass("%s", buf);
 	pthread_mutex_unlock(&ksft_print_lock);
 }
 void __test_fail(const char *buf)
 {
 	pthread_mutex_lock(&ksft_print_lock);
-	ksft_test_result_fail(buf);
+	ksft_test_result_fail("%s", buf);
 	pthread_mutex_unlock(&ksft_print_lock);
 }
 void __test_xfail(const char *buf)
 {
 	pthread_mutex_lock(&ksft_print_lock);
-	ksft_test_result_xfail(buf);
+	ksft_test_result_xfail("%s", buf);
 	pthread_mutex_unlock(&ksft_print_lock);
 }
 void __test_error(const char *buf)
 {
 	pthread_mutex_lock(&ksft_print_lock);
-	ksft_test_result_error(buf);
+	ksft_test_result_error("%s", buf);
 	pthread_mutex_unlock(&ksft_print_lock);
 }
 void __test_skip(const char *buf)
 {
 	pthread_mutex_lock(&ksft_print_lock);
-	ksft_test_result_skip(buf);
+	ksft_test_result_skip("%s", buf);
 	pthread_mutex_unlock(&ksft_print_lock);
 }
 
-- 
2.43.0



