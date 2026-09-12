Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3522D35F61E;
	Sat, 12 Sep 2026 07:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196927; cv=none; b=NjDY5rlhhj+ytiJCCAACtWgMOth+PzM/srJcFgyc5SLY8D4fXmJf7+Wl3ScY4vmhwBjgctCROQykwMfY3ak0SqTbdXyeGlriZ9aw9i9z/6YwIbZKHtShiv7DtOxdqxxOo5ugGoohAgOo/dGb7zSW4G1hPL3rMSGTG2IFpCPp424=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196927; c=relaxed/simple;
	bh=RIUtmvNcqGtRg2keY3OwDNeuXIj4T473mq8AG9LWwMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECv2Nc/fgYeyJ58ujBajiPMtXBquYYJhRHfRYlS/JvvZj1ORq/JsaLtDnCbnBXN5ZY70hrlgT3vy94YKEPmEzFMeEAKY2FZo2/Woh9Bpmc/fiv1NVlJpurmD0zaEXunTi/7+VPOcBmkv+Q78J7GBWAjKvEfHabYXdEf2jn1i9Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSA5ydnv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSA5ydnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB291F000FF;
	Sat, 12 Sep 2026 07:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196925;
	bh=6Pb7qTOiPIzGM3aDQ3Pbf8zCU0iSpdRujpXrPzhFXnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zSA5ydnvPBLks0Bfgeru/f2g7lL/iufzITfwbFHxrTf70iCk8YPI+enshJLbKa6au
	 mEp8PY8a4sfWcomQUAREodqeRA/n/vL+HZ3ea6x0PzuYeCR3hxCgid7QE0LYcTmlig
	 NyI5cGtcXT6G17N8oYixPr4Z/TfYStoZNAsoLbmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amin Vakil <info@aminvakil.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0065/1815] selftests: proc: include fcntl.h in proc-pidns
Date: Sat, 12 Sep 2026 08:30:15 +0200
Message-ID: <20260912065650.534104634@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 25b9a2933c456..6f7c10fe97b30 100644
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



