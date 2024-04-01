Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B3B481C4;
	Mon,  1 Apr 2024 16:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989408; cv=none; b=FZvOW3wKt6oNgaAcHQWn3/HJgdCxO6SEI8NW/xZy3zqyleeCI397qBYwX+mBrQELmboKEAc7kjtuAkEhSRrQ0+IsGPb9ep6T7ZhtAIgVdplhHwb0mv+as4j7t3p5W+xCUPSys50XoznaJnExAq08Stf4AId3Kq76jTLB8SSkC4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989408; c=relaxed/simple;
	bh=0y0MT5zOjJS+CQrsgRSAZG3Q95KTGMk0Oo5B47fKSSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QzhOBcskGcgtAzrRVqMFTQlpnM94KyjvWoV/k7N5yYgndzWQNlRr9yvYx9CY3bjG0omDgSnfjCHIB/8Qybna66zSvIziCo/2u3a8hqyp/vyySurm1PWmG9y479bTTsaN0+AF5acKdBd3QyYgdfDY70ZAHkxW2gMmQqijCTV/Gh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z360XKDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z360XKDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C7FC433F1;
	Mon,  1 Apr 2024 16:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989408;
	bh=0y0MT5zOjJS+CQrsgRSAZG3Q95KTGMk0Oo5B47fKSSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z360XKDMxLDescfHu05DW/uTquOqBbdquXT2t1L1iIgHkJfbmzd5wNrWD8pAlhZmK
	 1X6eWr866It58PL1dpTCyRh6FNBumuW2xq1zkcYP6rymHdFw/dmB8pDr5YoLfNt3Gs
	 UZew5N283annRwozis9LhoJUjm+nPRtx9wypDzYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/396] selftests/mqueue: Set timeout to 180 seconds
Date: Mon,  1 Apr 2024 17:41:29 +0200
Message-ID: <20240401152549.124143616@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



