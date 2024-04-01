Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546A2446D5;
	Mon,  1 Apr 2024 16:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988057; cv=none; b=uTxXJwZi2rcf7w8S1WDQMeb4w4whjwyY9mdCaeaTvH1UEolYXysFdltfy0CEO4l0ZDdGcKE37hXprdevGrWCb5aaH3YydBJF64ZgJz1/NZKDxbtSzr/zpgr6ko5Sui7vnrPM+DPJ9o/f6FqDiwdlrKr9MVCErPR09v3FBzI0eLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988057; c=relaxed/simple;
	bh=gATdBHeyOfdv+grs3NExuCETA7l30VqRdilFShvsDJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9h20SZHs0Qrzcbu5ierqxT9ILD5NGOxxBnZUA3DLEhC8u9cp+2Nu3gXPrmAw8oNEeTxjTjsHnbQ6166THIgsXQM/8I/QaSa4N9+O1q9zRPIoCFsFpBJMev/tOtUhfsBxQWi2XX1iAaSQvVhdfFNuTgoU9JXbay1Q41xM1BhlvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mAfR+Wxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mAfR+Wxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6566C433C7;
	Mon,  1 Apr 2024 16:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988057;
	bh=gATdBHeyOfdv+grs3NExuCETA7l30VqRdilFShvsDJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mAfR+Wxt2rki+BjuoOeAzuni5/5Ps+kZFOfvUurVF1kz42r0dltuNRYh4J1tHKJYP
	 N/FTxxMXsUu4tmCwo0d+gldNc0GJva1LT69xD3qpuxSMiyOc/n35322Yg/FyrRFe5t
	 LdfJ5wPT94RgG5IkjaIQc6ifxKk4sQmytfpms5Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 042/432] selftests/mqueue: Set timeout to 180 seconds
Date: Mon,  1 Apr 2024 17:40:29 +0200
Message-ID: <20240401152554.384901100@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



