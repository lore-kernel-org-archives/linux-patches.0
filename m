Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077AE2D8782;
	Tue, 16 Dec 2025 12:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888194; cv=none; b=OP/9M0T/SEgU71BsFQH1ZJcTihMQQbGnS5T1AX0F15y2Y/D6lUE3Qps6hRldPBPYT3+WwLeWGHgqpxjiZl/Bl+Hf78DFAKL2Wm1zQw21WTsHEN/R4G3xhSI86pjCJEJ6wfmg2uQxNwf7b3ROPsDiNzeualVxl5am2HRHqayIPQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888194; c=relaxed/simple;
	bh=Ox2eQ77NBe5Bjpa6ijwuhM/aKlRidGvxgTV9tNj4qP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k/R6+RyH2rswLsU3nenLugW3k0TDsOXWt8Ka8Z5dqK9EKRuiAinZfP/ZabBrq4VbZWi1lgNxEE0NIFZXKMdI541s70Ct7tauEQ9Qp1T/w6TxAZAUfG9d/Iw1Q7fC5QjheceJyXU/pwuKUxK/rJudUNdFIrf1/TAVGSdzcwrzln8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxvyCruA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxvyCruA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BC9C4CEF1;
	Tue, 16 Dec 2025 12:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888193;
	bh=Ox2eQ77NBe5Bjpa6ijwuhM/aKlRidGvxgTV9tNj4qP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxvyCruALQRfwQ5R00sm5klRJjJpYWQBr6NJmGpCOJ7Glkd68RUaYhzPe4k41/MgA
	 aVt/Bd+u5e18zqb8muYT5LCkvtLmcc653Tuz8t0Qh/lPJBGcPxnO8/gwasoXMnuuB7
	 rkv1fG7M0hqS8u4ur28o8rcI3WMMv8nMYjYkKCo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Buffet <matthieu@buffet.re>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 453/614] selftests/landlock: Fix makefile header list
Date: Tue, 16 Dec 2025 12:13:40 +0100
Message-ID: <20251216111417.781370366@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Matthieu Buffet <matthieu@buffet.re>

[ Upstream commit e61462232a58bddd818fa6a913a9a2e76fd3634f ]

Make all headers part of make's dependencies computations.
Otherwise, updating audit.h, common.h, scoped_base_variants.h,
scoped_common.h, scoped_multiple_domain_variants.h, or wrappers.h,
re-running make and running selftests could lead to testing stale headers.

Fixes: 6a500b22971c ("selftests/landlock: Add tests for audit flags and domain IDs")
Fixes: fefcf0f7cf47 ("selftests/landlock: Test abstract UNIX socket scoping")
Fixes: 5147779d5e1b ("selftests/landlock: Add wrappers.h")
Signed-off-by: Matthieu Buffet <matthieu@buffet.re>
Link: https://lore.kernel.org/r/20251027011440.1838514-1-matthieu@buffet.re
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/landlock/Makefile b/tools/testing/selftests/landlock/Makefile
index a3f449914bf93..044b83bde16eb 100644
--- a/tools/testing/selftests/landlock/Makefile
+++ b/tools/testing/selftests/landlock/Makefile
@@ -4,7 +4,7 @@
 
 CFLAGS += -Wall -O2 $(KHDR_INCLUDES)
 
-LOCAL_HDRS += common.h
+LOCAL_HDRS += $(wildcard *.h)
 
 src_test := $(wildcard *_test.c)
 
-- 
2.51.0



