Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0087221F2F;
	Wed, 20 May 2026 16:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295044; cv=none; b=cnubO+X1SmAtBjgD5CQr9Muj8i0tKS0K4TVDcK+H99tbk0IRVvbaHRJ7dFx8V8pJ+0FkEjha/EX51EJj3vdaTSEdNppRYQzXUr8O7C/TtYvk4AgtgZWuyY87+pmY46jq1e12UWN22BYKDn9UzPz6aQmEBV3/oPXiZXy9W9GjQRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295044; c=relaxed/simple;
	bh=dWv6+h6Ryge6YsuY64PSMRJgcqH+8sMJZjMmTNOsKqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfbCW5VAn9ehQojUVcZqMg8h8yuTsrc0IZ8b0OeSF7szi6XwePPym56h1VBnCJHMPP5FInNjo3HIWd0JBGDdi0F7gbDO8ttdL9Vty70sbt5H0RBVZDEyZHfdk9m/oyitBo2s7pkPeaIHaK+MJ7V18CKlbs/qgwqMK9y1XIWtE8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svFSCBwY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svFSCBwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228851F000E9;
	Wed, 20 May 2026 16:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295042;
	bh=ix2/USWYggCQyLCXLzPRBfFtnZLNspFVahaMRYj8Kzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=svFSCBwYmmhmERZX/Ooa40oTD9loTT3c2ZF+dinVj86F4dozzBT8ab/mYfWnNBoAa
	 oBBQKy6D9BfN3Q7/pyL9FycPxTygzC/3afC4+pYw5B/mwWCJ/skGLaAfN8w2km2Prw
	 kCILDXUUOeOH/gJnXyWvp+vg4dqhjxpH8xjFIcyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0270/1146] iopoll: fix function parameter names in read_poll_timeout_atomic()
Date: Wed, 20 May 2026 18:08:40 +0200
Message-ID: <20260520162154.332137213@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 878004e2852bc22ce0687c5597d6fe3909fb59f3 ]

Correct the function parameter names to avoid kernel-doc warnings
and to emphasize this function is atomic (non-sleeping).

Warning: include/linux/iopoll.h:169 function parameter 'sleep_us' not
 described in 'read_poll_timeout_atomic'
Warning: ../include/linux/iopoll.h:169 function parameter
 'sleep_before_read' not described in 'read_poll_timeout_atomic'

Fixes: 9df8043a546d ("iopoll: Generalize read_poll_timeout() into poll_timeout_us()")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patch.msgid.link/20260306221033.2357305-1-rdunlap@infradead.org
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/iopoll.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/iopoll.h b/include/linux/iopoll.h
index bdd2e0652bc30..53edd69acb9bd 100644
--- a/include/linux/iopoll.h
+++ b/include/linux/iopoll.h
@@ -159,7 +159,7 @@
  *
  * This macro does not rely on timekeeping.  Hence it is safe to call even when
  * timekeeping is suspended, at the expense of an underestimation of wall clock
- * time, which is rather minimal with a non-zero delay_us.
+ * time, which is rather minimal with a non-zero @delay_us.
  *
  * When available, you'll probably want to use one of the specialized
  * macros defined below rather than this macro directly.
@@ -167,9 +167,9 @@
  * Returns: 0 on success and -ETIMEDOUT upon a timeout. In either
  * case, the last read value at @args is stored in @val.
  */
-#define read_poll_timeout_atomic(op, val, cond, sleep_us, timeout_us, \
-				 sleep_before_read, args...) \
-	poll_timeout_us_atomic((val) = op(args), cond, sleep_us, timeout_us, sleep_before_read)
+#define read_poll_timeout_atomic(op, val, cond, delay_us, timeout_us, \
+				 delay_before_read, args...) \
+	poll_timeout_us_atomic((val) = op(args), cond, delay_us, timeout_us, delay_before_read)
 
 /**
  * readx_poll_timeout - Periodically poll an address until a condition is met or a timeout occurs
-- 
2.53.0



