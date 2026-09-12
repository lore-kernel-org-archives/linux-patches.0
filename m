Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D3F370D47;
	Sat, 12 Sep 2026 09:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206009; cv=none; b=ez/bNa1Y3I/YxheV6R9sUo+f2wm8bAgWqef5pqS8OIVhUac+3iBHPP89HDEl2llhxkBVaJU7e98BJch95S7KzkE3CTiPZvXlUxUkYrLq2eGGCwPL6cYqRM1kLqrKyhc72FGV2wm/3MF5Drpmggo7M0osJhN3nZFw06DIP3PrssY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206009; c=relaxed/simple;
	bh=Po1DcBNlPXD5T1rkaRYQA7VaJi33DLFH/DXTdSuItLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1rGAZrpRV+NVs03JD/iWE8ICfWzbHQXJ9Xlena8kFL8Xb3T+HGF1WfXIykAVZlNhcaK/1dfq7XG1HAHsgcLfdIdE5g0iMELr4vMz/zMszWRMNed5ho1eVjv3nCm0Urpqvzqv44SdCJaOcTuYjKaD6w8wLnPu9kKc+FrG9muzRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adbaLVBU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adbaLVBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EB81F000FF;
	Sat, 12 Sep 2026 09:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206008;
	bh=RtdWPUOaX3eE65WLLiN78DpsvGEsbJ/3s82i/JhjdHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adbaLVBUWqVrH8ebkq1ga3U92JpfCDZXetGBGMJ6y8YHDzHs4nu0TfrYPhOJmgoTw
	 drdQPDvd+E4p/JA6F+1WMYDq93Ag0Tu9NZG+Vw3fMPGOl2dfj9fATSNj+fsDxHVu45
	 UamaYsnwXPobAhOGCdk2njApGhbDoYPTO4vY9pgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amin Vakil <info@aminvakil.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0118/1518] selftests: proc: include fcntl.h in proc-pidns
Date: Sat, 12 Sep 2026 08:38:07 +0200
Message-ID: <20260912065626.158693163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amin Vakil <info@aminvakil.com>

[ Upstream commit 879b3353d04d043a9e01525c520d9b81339421b2 ]

proc-pidns.c uses open() and O_* flags, but does not include
<fcntl.h>. This breaks the proc selftests build with errors such as:

  error: implicit declaration of function 'open'
  error: 'O_WRONLY' undeclared
  error: 'O_CREAT' undeclared
  error: 'O_RDONLY' undeclared

Include <fcntl.h> to provide the declaration and flag definitions.

Fixes: 5554d820f71c ("selftests/proc: add tests for new pidns APIs")
Tested with:
  make -C tools/testing/selftests TARGETS=proc

Signed-off-by: Amin Vakil <info@aminvakil.com>
Link: https://patch.msgid.link/20260618151444.124739-1-info@aminvakil.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/proc/proc-pidns.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/proc/proc-pidns.c b/tools/testing/selftests/proc/proc-pidns.c
index 52500597f9514..f0fff6991d461 100644
--- a/tools/testing/selftests/proc/proc-pidns.c
+++ b/tools/testing/selftests/proc/proc-pidns.c
@@ -6,6 +6,7 @@
 
 #include <assert.h>
 #include <errno.h>
+#include <fcntl.h>
 #include <sched.h>
 #include <stdbool.h>
 #include <stdlib.h>
-- 
2.53.0



