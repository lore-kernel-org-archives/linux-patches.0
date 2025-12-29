Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78335202F65;
	Mon, 29 Dec 2025 16:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025381; cv=none; b=KeTXpxi96eGTuLNYIWVajC/b24vMykhI3GYUxfwX5EZUXMq0f8+hPVIy3vUbYt+pdT8HmnsEGLoVNIs+L2uHhSUrf4tHq1o0+3U+iZ/0mM4EyhZwV2ZAG3AmvMEKWUI82JlpZWaZYGEyxjgemP+LlJuZ9oPdO0LP7VfVVn5jMKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025381; c=relaxed/simple;
	bh=7vRwcrYE8wSno3fejF+fsUyilnmuDQMtRLJ1+3tjJlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxBcDFlxg1WTlHjdzbXdMdvTUVjVYS7txJMtKcA30htccPRah81i5gfuIvUgk3KmeoZ4A7HGOBc6VKtVfnxmptseqUZ6SNi0u+moaXeXz4wyy6EvSbqmvIbvBTZnOG3auWWPqZRr8+WHOBem0BEbBn4LLW8E3BIcdM8wcWTUzSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/hnbtpm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/hnbtpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF730C4CEF7;
	Mon, 29 Dec 2025 16:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025381;
	bh=7vRwcrYE8wSno3fejF+fsUyilnmuDQMtRLJ1+3tjJlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/hnbtpmWkhG7/hA9abo4+ljxDlpGWDXfx2cVkdOqT/umBxF2e4docU625hLIb5jd
	 AoBMG/q43gTciSXdS4byoAhlu1YYBmKVdbnNqWFWGdpeBzKrp6Aqtm++ZvJKrQhnL6
	 b701mhak8EoaSvAfjqNKfeBoo4PI5BL1bW7AClgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Troy Mitchell <troy.mitchell@linux.dev>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Encrow Thorne <jyc0019@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 193/430] reset: fix BIT macro reference
Date: Mon, 29 Dec 2025 17:09:55 +0100
Message-ID: <20251229160731.458029569@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
index 840d75d172f6..44f9e3415f92 100644
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



