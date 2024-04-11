Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8981448EF;
	Thu, 11 Apr 2024 10:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830496; cv=none; b=unbkPihi9xvqFWk4zvyyNCMcLwfo5GP4jjmyo+x1pN1wIhWRCKt4dDGEz65z+5Wd4iHlY7+E4oYuLo2piTG9Fgg/U7R0LlBkp5JqXa01dkDigZHn6tbW8gkReIGAsSROzyHEwJBSClrbHptxYwnqRxZIWSADmtOuQWlxwmhOWUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830496; c=relaxed/simple;
	bh=WcLYLL14vt0U1+7Hu7z32w+iVdlZqtHZfI7YkIQwCTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0U9s+BRCd8HQBu2V9gPY8ySC7TGwQWKYLw2bYYViYBN0KigA7Y8EoEnUulMQ1CysefVjbSbl3vEcJynozdisvE9tjK5lZWq9X6j6B76YXW2yeTVQzNoKNRV6l+veicy/Q2iUJWrHi3IEdv9AnsBp6nhpqRlTvPVsGcqkETJ49c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmEJG/c8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmEJG/c8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0BBC433F1;
	Thu, 11 Apr 2024 10:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830496;
	bh=WcLYLL14vt0U1+7Hu7z32w+iVdlZqtHZfI7YkIQwCTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zmEJG/c8CEYoBK10wv6i1Xd3i1JQf2p5GohKLUS/FS/W4KK2eKl39O+o8bzZ0Nv7h
	 56xYZ6mtmorhPbnIXjSifvMy6OUyci7VHD2coakExLP0MmfnjeKZaq6hQLb86KcYSD
	 GW9q3V56Nm5UU2ifNqreVEifQ9OYsX1yw5+8jbO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/215] selftests/mqueue: Set timeout to 180 seconds
Date: Thu, 11 Apr 2024 11:53:50 +0200
Message-ID: <20240411095425.521368835@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

[ Upstream commit 85506aca2eb4ea41223c91c5fe25125953c19b13 ]

While mq_perf_tests runs with the default kselftest timeout limit, which
is 45 seconds, the test takes about 60 seconds to complete on i3.metal
AWS instances.  Hence, the test always times out.  Increase the timeout
to 180 seconds.

Fixes: 852c8cbf34d3 ("selftests/kselftest/runner.sh: Add 45 second timeout per test")
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mqueue/setting | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/testing/selftests/mqueue/setting

diff --git a/tools/testing/selftests/mqueue/setting b/tools/testing/selftests/mqueue/setting
new file mode 100644
index 0000000000000..a953c96aa16e1
--- /dev/null
+++ b/tools/testing/selftests/mqueue/setting
@@ -0,0 +1 @@
+timeout=180
-- 
2.43.0



