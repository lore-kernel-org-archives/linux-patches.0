Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5D633B6F1;
	Fri,  9 Jan 2026 12:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960511; cv=none; b=adi1F1BqAUzzR25Jirj144DCW1zI5eYyz2zmON1Oj7h/j1KykbX+yJyR1LMS/fWm5MeAn6h74xh7xL/XxAeET58b4/mOrj2Ox7TI57235DGnKcLn01QoRufz3y/OyBlC8Vxedi+/wGJDYzmaOz5P+1T0UJpTPfAAiLFwkWa9lM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960511; c=relaxed/simple;
	bh=+YaKkBfovf0IrNKU7DrDwcyjzc2Bh2e8fmTg6aForvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRPCsTWb6uTaI8kHSdv6H7c4Z5CuG9WAIF5rog4TfvLztra6KYRzdisvxAlBPc8z8oN1YG+HVViLNrHzIKxnOKPBpSLju2wrteIs2XCrXjsiQR7GSTC44QehMiB0/+BoNQGctMb2zWcaCGWbLpcY3m/tWT8fC1WYTnpRRoTZowo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4Q7OJE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4Q7OJE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE4CC16AAE;
	Fri,  9 Jan 2026 12:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960510;
	bh=+YaKkBfovf0IrNKU7DrDwcyjzc2Bh2e8fmTg6aForvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4Q7OJE7i5Dpz5QbK0unn2NXEJQjtcrev73N4GHuyDJ8uphs7us4EgX+8STPVXPkg
	 /a2YXOc3LAMTKaN6OwkdfHciB8k/6oL1zYoA2q2Aele7tFkZIn6awV0VZFxQPX880U
	 JuOoYBU1vsxgvNwl0KR0QWdGQNljZ/p1w3c95jCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Troy Mitchell <troy.mitchell@linux.dev>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Encrow Thorne <jyc0019@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 397/737] reset: fix BIT macro reference
Date: Fri,  9 Jan 2026 12:38:56 +0100
Message-ID: <20260109112148.936082475@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



