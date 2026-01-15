Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33DA3BFE34;
	Thu, 15 Jan 2026 17:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499394; cv=none; b=XfSjU9DICSCjOLg3FFmq3CWHUnr4T1ROKeXIaInNSb/aokkvXvre/bJJoEtovxIQNWmBXj1dRIAKKVmXGaNXNIwivXNZTf2wQOzp4c7wBXFLRNiH6dajF23t/SUyvY/BH/ooFry5cd3RhYqA9vIs0v1k3kkmgTax/JchKhBjRw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499394; c=relaxed/simple;
	bh=TSquhKlAcBp7MADidqjemx+6zILKs4M0NDWWCgP+PBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cod/ztwhgslNF/AkDtD9eTrKnqoIrkzXn2/xI4KMgZ64J0GFs7624pyUtv/JNh4NYToVaunsD85kC3J3uK8e4MByrz4lMGQ5jhSBIND9PBCSRMz8kl9zKKkHrNcM8DgnR3CguJKB3xN2a5e3hPhuOwIeMOP77FnBjxh60TxNZ+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6Jzgd4W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6Jzgd4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81156C116D0;
	Thu, 15 Jan 2026 17:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499393;
	bh=TSquhKlAcBp7MADidqjemx+6zILKs4M0NDWWCgP+PBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6Jzgd4W1DfV0UyeiAmHMX011RAIpII+lipK/y74xNhHxhI3evOUZmPLc1hJ5sruz
	 f+EiJu0PFakql4mBAgCZp+Vjo7Z20DNOeEti4rHRZldueLgEy20zdXbIGEKZkvaTzA
	 uiSEv5hIk0+EeMxH+sLPhUDhPQu6zRj3pKRNRIMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Troy Mitchell <troy.mitchell@linux.dev>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Encrow Thorne <jyc0019@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 212/451] reset: fix BIT macro reference
Date: Thu, 15 Jan 2026 17:46:53 +0100
Message-ID: <20260115164238.569421501@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 05aa9f440f48..f27026f52104 100644
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



