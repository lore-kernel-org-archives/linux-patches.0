Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6133359F9C;
	Fri,  9 Jan 2026 12:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960768; cv=none; b=NrLw6RY91k6EeNjBjx4JE+uZdczKyBEeA9JYnYu06kwjDNo3TRlIX7+Cj2AWmxKaNTqR0moh9qdduX3Xe+oeF6C1zXPBDpwcEae3FYb2GJgyW8FWlCw9hIsZ/n96RdCouyXrTz2RwS7V5Iea1TO7hVz5cS+wqMKQEfl2+zcAE2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960768; c=relaxed/simple;
	bh=8wFMjN4tzUOqpRASMy5OmJani+TlatEMYCaS4U/hUXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tf5RJEdBOSxrfv84MNtqsGixOWcz6hLoddheBC92XcOKxFVmEfMoRleKm+VCXwCBt7Slxilg/WJdpSY4JvYNGza5FV/sN5efDSvFL8Mjy1XdmVjW+Ec9mg+hkhWJ3RtKu5RqiekTqBYz32+8Xne8VE11B06/B55TI7FcauAvECk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afJrIw8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afJrIw8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3494BC4CEF1;
	Fri,  9 Jan 2026 12:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960768;
	bh=8wFMjN4tzUOqpRASMy5OmJani+TlatEMYCaS4U/hUXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afJrIw8gPyJkTJXhq06Fa2oe+xlXUhQy/tPI6h89K7P6l6SU8VKxMHGUq5yrblfHw
	 ZbSt88iliPfJ4KCo6/CEo9ZgXSIcAyj7m7YJqu5bobWpegarHVydUbLNijNlzW0i79
	 J/kRGsZhNc5wydTO2Tfc4NNQ7y2Kep5RJcRax5GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Randy Dunlap <rdunlap@infradead.org>,
	Alexey Skidanov <alexey.skidanov@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 518/737] genalloc.h: fix htmldocs warning
Date: Fri,  9 Jan 2026 12:40:57 +0100
Message-ID: <20260109112153.486190396@linuxfoundation.org>
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



