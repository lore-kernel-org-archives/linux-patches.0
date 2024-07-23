Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FA142067;
	Tue, 23 Jul 2024 18:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759474; cv=none; b=GFqr0Ff0m80sqoGyBTcoXNOAEh2+bDJktzJoqKq1H1t6fEgN1j5uF0/3bGX94K2Km6dsQmqTSAFXachfz8g9Da/vKY/Vs/LGsxZQ9zbEJ5FsnFhjKHND5Z5lInRUjdNBtNQ3llapsCUZvuhKrDfNZVOHudlMgOkQP1l/5J2HMaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759474; c=relaxed/simple;
	bh=BQsg0jRFQKh4ymDePvb/S4gnqHGU/lXinqLaAIdlvc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qawPPqdE13Bog5NSaFp1u1zn8zkLs0tOBx6HIyKVQt4JLFCLhT36AUm+2lp1NdAYTEX/oXG9A38z9AicHOc+PCK7I5UrDxlpSH+HiOG3+h9K5unn+RDDdJDDpb2pbS+JbysFUBQbuKqr46PsTMhP4ZDKc/IAHzFTcnrI/cMubjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E14Z01Bl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E14Z01Bl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8337BC4AF0A;
	Tue, 23 Jul 2024 18:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759473;
	bh=BQsg0jRFQKh4ymDePvb/S4gnqHGU/lXinqLaAIdlvc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E14Z01BltniXKBFJDWYwFhUimB5vL27q2NqmYfkLBSdakS+mMRljMI+C/MRnJZWvh
	 pY5N0Yzoj9pz1wOjFfN4V4Fe0oYirK3XHcRx+AVWBFaiMlCo4HsNInmH9c4+zEgIHc
	 gSB6kmjHQHDzF6VqbJIViS23b/81mHoUEufmM2J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/129] selftests: cachestat: Fix build warnings on ppc64
Date: Tue, 23 Jul 2024 20:22:50 +0200
Message-ID: <20240723180405.647531815@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit bc4d5f5d2debf8bb65fba188313481549ead8576 ]

Fix warnings like:
  test_cachestat.c: In function ‘print_cachestat’:
  test_cachestat.c:30:38: warning: format ‘%llu’ expects argument of
  type ‘long long unsigned int’, but argument 2 has type ‘__u64’ {aka
  ‘long unsigned int’} [-Wformat=]

By switching to unsigned long long for u64 for ppc64 builds.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cachestat/test_cachestat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/cachestat/test_cachestat.c b/tools/testing/selftests/cachestat/test_cachestat.c
index 4804c7dc7b312..ddb70d418c6a8 100644
--- a/tools/testing/selftests/cachestat/test_cachestat.c
+++ b/tools/testing/selftests/cachestat/test_cachestat.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #define _GNU_SOURCE
+#define __SANE_USERSPACE_TYPES__ // Use ll64
 
 #include <stdio.h>
 #include <stdbool.h>
-- 
2.43.0



