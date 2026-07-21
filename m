Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66A4436BC6;
	Tue, 21 Jul 2026 20:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664012; cv=none; b=WSp3J3qTaFyDSd02wo815MWpipzO3bLPW9Ypz86Xt8+GQMaZ+FkbkkD6P5hONXL0+hB2pYDxHK3Cx+kU0fRL9K45Ikb7+mr2hWq3Nz2uPxeji0nSz+0o7s3PQTHbYws+NsyJQoDXSDH1Vpx0diPNh/fiyO+jC7pDuCXPtWIlsn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664012; c=relaxed/simple;
	bh=UQElhNXIE/ncPM2jkxOkamXkchDarTZ6lNjyOPWAKwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8g0CiX3kj9XMOfJAG864uw9/1sAAwanznMVhIP8UWChqWxyPjnCoEfe5k65pOYXeZJSNv1ufv7xNE1ZsaizBjiD8NNfJMmcv/3XUucBL+/sYFlPmnVXRyxVHPPFzganLH4D0Um5tEQEsmeWFQpv0Wu1cj1EvfNHgcNoMJoa/dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9a2DCa+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9a2DCa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF25C1F000E9;
	Tue, 21 Jul 2026 20:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664011;
	bh=Rf8o6LGF9mnlAFrL+fk8elfffW6fyQw7Fd7j7VScx9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9a2DCa+hjRyHrOioHAS4j/hKzoSnlnQS2WSrIx6ZVuCFkIyNOxGLWZLescBd2HMS
	 AlwR5Z34waD3lrRNl5C8bp9/LCWGN85VAqlxFV4Uk4W+uAkM71d1FC7tGywbXIUcaV
	 pr6gtkTr+El2BYZ63ZlYLQ7mjkvC/wpkPazCdg0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Ruichuang <create0818@163.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.12 1039/1276] selftests/ftrace: Drop invalid top-level local in test_ownership
Date: Tue, 21 Jul 2026 17:24:42 +0200
Message-ID: <20260721152509.238257059@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cao Ruichuang <create0818@163.com>

commit 808c447df2fe234eb7d9e08ecf53159d291c104c upstream.

test_ownership.tc is sourced by ftracetest under /bin/sh.

The script currently declares mount_point with local at file scope,
which makes /bin/sh abort with "local: not in a function" before the
test can reach the eventfs ownership checks.

Replace the top-level local declaration with a normal shell variable so
kernels that support the gid= tracefs mount option can run the test at
all.

Link: https://lore.kernel.org/r/20260407102613.81419-1-create0818@163.com
Fixes: 8b55572e51805 ("tracing/selftests: Add tracefs mount options test")
Signed-off-by: Cao Ruichuang <create0818@163.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ftrace/test.d/00basic/test_ownership.tc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/00basic/test_ownership.tc b/tools/testing/selftests/ftrace/test.d/00basic/test_ownership.tc
index e71cc3ad0bdf..6d00d3c0f493 100644
--- a/tools/testing/selftests/ftrace/test.d/00basic/test_ownership.tc
+++ b/tools/testing/selftests/ftrace/test.d/00basic/test_ownership.tc
@@ -6,7 +6,7 @@
 original_group=`stat -c "%g" .`
 original_owner=`stat -c "%u" .`
 
-local mount_point=$(get_mount_point)
+mount_point=$(get_mount_point)
 
 mount_options=$(get_mnt_options "$mount_point")
 
-- 
2.55.0



