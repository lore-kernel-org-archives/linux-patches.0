Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51843C0093;
	Thu, 15 Jan 2026 17:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499593; cv=none; b=hkj6wHgPyJ2UvaF/mR5tAnAmLQvwd3tno9AntPD0rih//eu4RasGTMNdLZr84NHeMhwHrM+QeJF0dGF3/Ga1iCfjsM3E3wk8+EJPo+cHY/bAZcL4xAQyqBIh+EC+0g+ECjHfTDFcyMoOg3hKFt/HgmNsN2uy27XcoLYKxTA7QqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499593; c=relaxed/simple;
	bh=SIUQoIQWlgTCk2qt9L1hczeKedkIz6aO7mWiyQoaOvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oX4ejP2qgPbShKBuFGinaHMV4zgenKFOIrzeCoN6PH3aEjrfqiXd3RTMO7FTNa5DMwwXlVPD034x0PBsxaN/Tbh+dTobcsnboE7Maqy5eRJdocfKvsPiKUx36Xw3q+mQ/l1UMwNyQQVwnwLAlAcXqTRtV0mXYli+v792EVYGABg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EMcjICTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EMcjICTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCD2C116D0;
	Thu, 15 Jan 2026 17:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499593;
	bh=SIUQoIQWlgTCk2qt9L1hczeKedkIz6aO7mWiyQoaOvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMcjICTsq7X2IGS84dO7UGRVFxWNEBPlUEKGKWST/twt82zBBG6beCzYtUS6G04Ga
	 /P+Z2RD9boI9kEAUdHJmXTgmsNKdTEXbKp4bwu4ou4c+PvCo3dsOKesHo7DkiW1l0U
	 kYq5PD+23MVVAdOcaAhQHEjJIV4xWYGmAT4a7+q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Randy Dunlap <rdunlap@infradead.org>,
	Alexey Skidanov <alexey.skidanov@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 282/451] genalloc.h: fix htmldocs warning
Date: Thu, 15 Jan 2026 17:48:03 +0100
Message-ID: <20260115164241.085968968@linuxfoundation.org>
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

From: Andrew Morton <akpm@linux-foundation.org>

[ Upstream commit 5393802c94e0ab1295c04c94c57bcb00222d4674 ]

WARNING: include/linux/genalloc.h:52 function parameter 'start_addr' not described in 'genpool_algo_t'

Fixes: 52fbf1134d47 ("lib/genalloc.c: fix allocation of aligned buffer from non-aligned chunk")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lkml.kernel.org/r/20251127130624.563597e3@canb.auug.org.au
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexey Skidanov <alexey.skidanov@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/genalloc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
index 0bd581003cd5..60de63e46b33 100644
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -44,6 +44,7 @@ struct gen_pool;
  * @nr: The number of zeroed bits we're looking for
  * @data: optional additional data used by the callback
  * @pool: the pool being allocated from
+ * @start_addr: start address of memory chunk
  */
 typedef unsigned long (*genpool_algo_t)(unsigned long *map,
 			unsigned long size,
-- 
2.51.0



