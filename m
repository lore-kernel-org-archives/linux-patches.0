Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16952BDC0E;
	Sat, 12 Sep 2026 07:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197731; cv=none; b=hhw3DsoJX9Zca7iaO0lcbAvzaBrwBh13GabHJrKJ38bGk2SFYCFpw2kfjjikFZGAiJNboI90qgPhXMNVVYOKFwYYIpY87V5PsIVKp3HLwWZ7fDozM/u8ymauw9DoLNUvPt7zG45X7DR7DjnSw9oQbp2cO7Usvsw8pX5TC5X0BjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197731; c=relaxed/simple;
	bh=I9ueSbrJf0mJh4rSqfiVy64MCJz9/AaflFAb0kHQsR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QYlEJmzDhAcSG4szPpm5XHpFGRHZc0cX/RfOFhj8eqztz2j6u5h4gPFF7np8lZebbsrAOCpNG2a5ZZOuZZLFC6CjHvoDDhBGmRp9NMQq6IE3Dpp6DNLMr/93s67QdpDFeP/Zrskyq5ioBfeGG3WT6IXABtHisEZMW/agryGeFNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNWdNpTQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNWdNpTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AD71F000FF;
	Sat, 12 Sep 2026 07:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197729;
	bh=tOur8k4h0o33Lo3cmMyhVP7SfS5vZplVc7nY7t99ueQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XNWdNpTQ0wdk9GWg0c6eo8oIoBIk+pfkfw50HlUxyfp6swTnnXFYB4L6yU3eDWDIX
	 uEpKxTrODd3rXVb7nw/8HVyvELrKSw7oNGMN3JpuHTMdFzyfbxBxLiWMMrCvieNNwg
	 zlUokxSbcbUL2NdDOhAMXwBE4QJ7KxM/G/FLJ1l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zelin Deng <zelin.deng@linux.alibaba.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0236/1815] kbuild: unset sub_make_done before calling kselftest build system
Date: Sat, 12 Sep 2026 08:33:06 +0200
Message-ID: <20260912065654.532121598@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit e77f165d26f72c280654cff248f5106cb9a53951 ]

The kselftest build system may recourse back into kbuild when building
test modules. In that case kbuild needs to parse the new flags passed
from the command line, instead of using the ones inherited from the
kbuild invocation.

Force that command line reevaluation.

The same was done for scripts/install.sh in commit 14ccc638b02f9ec
("kbuild: cancel sub_make_done for the install target to fix DKMS")

Reported-by: Zelin Deng <zelin.deng@linux.alibaba.com>
Closes: https://lore.kernel.org/all/20260525083721.27857-1-zelin.deng@linux.alibaba.com/
Fixes: c9bb03ac2c66 ("kbuild: reduce output spam when building out of tree")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: Miroslav Benes <mbenes@suse.cz>
Acked-by: Petr Mladek <pmladek@suse.com>
Tested-by: Zelin Deng <zelin.deng@linux.alibaba.com>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20260703-makefile-unset-submake-done-v1-1-6899248f3d6a@linutronix.de
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 408e8512b7134..ad446f35634cd 100644
--- a/Makefile
+++ b/Makefile
@@ -1605,10 +1605,10 @@ tools/%: FORCE
 
 PHONY += kselftest
 kselftest: headers
-	$(Q)$(MAKE) -C $(srctree)/tools/testing/selftests run_tests
+	$(Q)unset sub_make_done; $(MAKE) -C $(srctree)/tools/testing/selftests run_tests
 
 kselftest-%: headers FORCE
-	$(Q)$(MAKE) -C $(srctree)/tools/testing/selftests $*
+	$(Q)unset sub_make_done; $(MAKE) -C $(srctree)/tools/testing/selftests $*
 
 PHONY += kselftest-merge
 kselftest-merge:
-- 
2.53.0



