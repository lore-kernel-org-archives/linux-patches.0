Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F96481A6;
	Mon,  8 Apr 2024 13:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581379; cv=none; b=ntLjYcltWgo4wxNnSjU5Lm0OCCzqdcp659tX5DvAztmb34yWQgo7Sr/QGqaEnCvKRkoX2MoTJDjfaKcWNU/o3TEqnjmziGRXWMN1MAmaF091yrrqqjcO80tL3hcWCiUeorjbaP4NvD2awvagltxsKPOIc3SdKEq0mIwHu/SGGk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581379; c=relaxed/simple;
	bh=hOAhzQFz2ZVVzqNXdcLQfqO4hxnGMZZnQbzHRtcFuTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OrSA0vedNqdk74YfhhKgi/zi1N+TkD+hKQIGSAThXCm/+MroVJbrgdJznQ/DlDD/OBRmX9ZB4rIhCK1hgTb/Re1aIUdiTpxq2YLS7OAfZGLsESHBjJ2gHDmNtsqcZQsj9oAn8Y91onaDrW25m5uQY4tSuAQ73TDwCMe0J3bCgy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=feI4vfVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="feI4vfVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80437C43390;
	Mon,  8 Apr 2024 13:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581378;
	bh=hOAhzQFz2ZVVzqNXdcLQfqO4hxnGMZZnQbzHRtcFuTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=feI4vfVFbN1LABYm/k84AoLESbixCNj+6nU7nIEiqwsIVFIjeny8Gy8rUvau5sV+6
	 b2Nmd0DmjykrJAUyZsCR/QOR3IFqY5cGVzFCAeu4Vy4/5/FAjuQK3F+ehtgMHb34WB
	 0KaYH0aTxS54udR8SvFwbxyVdu9m6Kup507GWmy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/690] selftests/mqueue: Set timeout to 180 seconds
Date: Mon,  8 Apr 2024 14:48:10 +0200
Message-ID: <20240408125400.448755158@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



