Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA9413D896;
	Tue, 23 Jul 2024 18:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759872; cv=none; b=fSd3GOEbUE6d70G9ntxd5RIgN+cmSUeiAn4jTHZ300LBMoKifatdt+7DNzOJCv9ESBAHve1y+nNkImNVy+z2WEzNU2BoayFqytYCu19DHclcmg7U7yPbNK7LfNGNS7nRITnJZRdmtT4oKvBBwul/iLhbjQeZCpmJOXADRfGgqdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759872; c=relaxed/simple;
	bh=7CjkepsWejqflumLrKin3q9VfmhbiOnsGHBcNPr2P0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fPGnxofoX6kphC/UG5kOEKbHKZhwFJINjgWby2lPXqquD1wMhhBl7VO4jL5kdW/B9g4RHZKjlO4E6SSjcXBkqwit8sI6LpI+f1YH52MwCOLXcE8leWp6AD8uQ4+2Kd+1Hby50t7lkEadpBnK45Cu/1Gi+NiXAV1LR+vOVDGI2ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDJZh4Gr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDJZh4Gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323BCC4AF0A;
	Tue, 23 Jul 2024 18:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759872;
	bh=7CjkepsWejqflumLrKin3q9VfmhbiOnsGHBcNPr2P0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDJZh4GrzbxGGUoe+4R7oUQkLe1jeN6hZi7yuJI36FIqmgaDldtio/TJXMsO1NMhq
	 iM+8xA4M0Ad8TvtgQncMpM84nyEH5OsVONeBg1hF04Zm+J0CGpH4N5H9LTIc3pxyQ2
	 huGdsJoY43lgtTnOSTh9AlpBi1unjluxe+OG6uxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 026/163] selftests/openat2: Fix build warnings on ppc64
Date: Tue, 23 Jul 2024 20:22:35 +0200
Message-ID: <20240723180144.483199901@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 84b6df4c49a1cc2854a16937acd5fd3e6315d083 ]

Fix warnings like:

  openat2_test.c: In function ‘test_openat2_flags’:
  openat2_test.c:303:73: warning: format ‘%llX’ expects argument of type
  ‘long long unsigned int’, but argument 5 has type ‘__u64’ {aka ‘long
  unsigned int’} [-Wformat=]

By switching to unsigned long long for u64 for ppc64 builds.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/openat2/openat2_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/openat2/openat2_test.c b/tools/testing/selftests/openat2/openat2_test.c
index 9024754530b23..5790ab446527f 100644
--- a/tools/testing/selftests/openat2/openat2_test.c
+++ b/tools/testing/selftests/openat2/openat2_test.c
@@ -5,6 +5,7 @@
  */
 
 #define _GNU_SOURCE
+#define __SANE_USERSPACE_TYPES__ // Use ll64
 #include <fcntl.h>
 #include <sched.h>
 #include <sys/stat.h>
-- 
2.43.0



