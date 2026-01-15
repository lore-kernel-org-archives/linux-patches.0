Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3E43BFE53;
	Thu, 15 Jan 2026 17:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497967; cv=none; b=B2K/n0AqMjynmBoO7eID5cL5wfwXpRkdT4QeoDYaG7s7OiCxkOkUxWz/Uo5r6T3PN0YWHvGHGcqIrmnySyOTKZWzSiO1W3LZWlc5gExeisXOp0bDc8ZY8W9nt1W1cDby57ccsoUhh/SnsEaE7FVTuxlz4oulR1MgZO6Rg1/taF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497967; c=relaxed/simple;
	bh=jKqln8d3K+wKYymmugF0BYpwKxrMIy/DvNxFiZvCMmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6QvRTBd9eCLAdRPWmTvIGRO3r/hhg5Qh/ODVyFMgBLlBBBxAEIyYRhRje66dAfdlny4yqAinfp6lhxZt9q8dzdRFKM/eyi1mnGY1i0D5gupGmBWsqwzsw/oTeF6P0N35z6/yYz/bkQXhW1sk4MjWAjdofiukp/DIGl4AcIWTAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Piem1hLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Piem1hLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091AFC116D0;
	Thu, 15 Jan 2026 17:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497967;
	bh=jKqln8d3K+wKYymmugF0BYpwKxrMIy/DvNxFiZvCMmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Piem1hLqae9yDeGm5dieozr2vATP6ssFU+fDXdtF+KM+/4FshnLyC2Ju5tjnJ8pCe
	 Sn9xUyFNkLR1xjZxMGToxQfSbj5MG+LYODG5VpWHsZVVClbmiSbbWwD14f+5yqFDY2
	 DR2glDgUpTPzByIKAqJ8hzv4PqMV2o15cfmbL+wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Troy Mitchell <troy.mitchell@linux.dev>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Encrow Thorne <jyc0019@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 266/554] reset: fix BIT macro reference
Date: Thu, 15 Jan 2026 17:45:32 +0100
Message-ID: <20260115164255.858782625@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7bb583737528..23abb90398ad 100644
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



