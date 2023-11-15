Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2E328383
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Xm+HQZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4D0C433C9;
	Wed, 15 Nov 2023 19:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077493;
	bh=bhi54GEzpEzBNGooHN+np6cR5FwR6jgWsectex5oBOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Xm+HQZ7uY9lHxDcMy+IC3lWnTCRtB+nxJChWFYDSJcXbR3Be2xYuxFhSIqbivWT4
	 lXF3pxfgoQJlqdcvyG8Ut7jKmGJbPkti/IzHRdjCRRm93Y3JMQQqh6No23CQa3xOJv
	 J/4JL5jnvGLjjqzUCgogeLPfxgtWeKXouTkTFneU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 337/603] KEYS: Include linux/errno.h in linux/verification.h
Date: Wed, 15 Nov 2023 14:14:42 -0500
Message-ID: <20231115191636.849131882@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 0a596b0682a7ce37e26c36629816f105c6459d06 ]

Add inclusion of linux/errno.h as otherwise the reference to EINVAL
may be invalid.

Fixes: f3cf4134c5c6 ("bpf: Add bpf_lookup_*_key() and bpf_key_put() kfuncs")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202308261414.HKw1Mrip-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/verification.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/verification.h b/include/linux/verification.h
index f34e50ebcf60a..cb2d47f280910 100644
--- a/include/linux/verification.h
+++ b/include/linux/verification.h
@@ -8,6 +8,7 @@
 #ifndef _LINUX_VERIFICATION_H
 #define _LINUX_VERIFICATION_H
 
+#include <linux/errno.h>
 #include <linux/types.h>
 
 /*
-- 
2.42.0



