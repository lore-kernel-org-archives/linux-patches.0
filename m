Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FB033C53A;
	Fri,  9 Jan 2026 12:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962273; cv=none; b=Ugc3RRD8XDKLdK1StJHxTon9U6+dFs1DzVBY6v/WdQ888TVIQv53f8widagxE+Ff0v41oklQq3ln8C6VsusP/N/PLlNbhScfIRQE8GwUavSItyd8TUXSfywMFk+fT8PVvMFudHSVh2uvcvOlfV7M7YI7sA677f6bFebpzRUGKTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962273; c=relaxed/simple;
	bh=qZt/JDmhjNzf2/WoH7uxxo1yUU9uXZO7wuzs5Q7mhdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUhT0X5/WvHQ8dhN6/e8LQFhNL1hHmI/I9Ev0Mb9/eK++4Y+JsE9k3mmWRt2Esn2HWQggDwnnpPIaUNJEXQfMSxqkh5Rq3hBHgtN49PTXIsAgJ1MVGIOX5PnKO7yKv22m+yma5109K1pmTWh9plDEduA6+YfF0T9gfcyU+2oFOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m32igkbk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m32igkbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7BBC4CEF1;
	Fri,  9 Jan 2026 12:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962273;
	bh=qZt/JDmhjNzf2/WoH7uxxo1yUU9uXZO7wuzs5Q7mhdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m32igkbkaw4PQ8W+MuItJxP1VnvVASmaopKLR270XvdTtYqIvpOAKfEScFN2xpKWL
	 SS3jPpvizCMZ7ZKoZ6dK0o9DaU0zJdDMU3QXlAaAC3KYIUg8Ht9NQET2BPS76BobZm
	 GP8ahFsQ2epndujWAgfM8JYsUXlsk+M4Pp7ofxLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Troy Mitchell <troy.mitchell@linux.dev>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Encrow Thorne <jyc0019@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 306/634] reset: fix BIT macro reference
Date: Fri,  9 Jan 2026 12:39:44 +0100
Message-ID: <20260109112129.048360653@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Encrow Thorne <jyc0019@gmail.com>

[ Upstream commit f3d8b64ee46c9b4b0b82b1a4642027728bac95b8 ]

RESET_CONTROL_FLAGS_BIT_* macros use BIT(), but reset.h does not
include bits.h. This causes compilation errors when including
reset.h standalone.

Include bits.h to make reset.h self-contained.

Suggested-by: Troy Mitchell <troy.mitchell@linux.dev>
Reviewed-by: Troy Mitchell <troy.mitchell@linux.dev>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Encrow Thorne <jyc0019@gmail.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/reset.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/reset.h b/include/linux/reset.h
index 514ddf003efc..4b31d683776e 100644
--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_RESET_H_
 #define _LINUX_RESET_H_
 
+#include <linux/bits.h>
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/types.h>
-- 
2.51.0



