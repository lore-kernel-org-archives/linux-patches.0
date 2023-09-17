Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADE94A3F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986E2C433C7;
	Sun, 17 Sep 2023 19:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979630;
	bh=4WNUlBiYvV9MvXKchhYxmqnf7vClpOYmHhaOkqqvWdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w9TAZwvRQ+GlcJ92L85T/6eAaIVyHstsN4GbxT6VRMsXGPh0vhQmR6i0GSm53Edmk
	 IFo7B4d/sH0by5uG4p84bNL8Ob4eOB1ftdpcs1CEcL7PMF9Mi50jNRfrdtaD+LdpDK
	 oyVy5VSgf1x83q/tnOYV1EVsic/Rq8w+Mp65mtsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ariel Marcovitch <arielmarcovitch@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 361/406] idr: fix param name in idr_alloc_cyclic() doc
Date: Sun, 17 Sep 2023 21:13:35 +0200
Message-ID: <20230917191110.806232110@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ariel Marcovitch <arielmarcovitch@gmail.com>

[ Upstream commit 2a15de80dd0f7e04a823291aa9eb49c5294f56af ]

The relevant parameter is 'start' and not 'nextid'

Fixes: 460488c58ca8 ("idr: Remove idr_alloc_ext")
Signed-off-by: Ariel Marcovitch <arielmarcovitch@gmail.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/idr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/idr.c b/lib/idr.c
index 7ecdfdb5309e7..13f2758c23773 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -100,7 +100,7 @@ EXPORT_SYMBOL_GPL(idr_alloc);
  * @end: The maximum ID (exclusive).
  * @gfp: Memory allocation flags.
  *
- * Allocates an unused ID in the range specified by @nextid and @end.  If
+ * Allocates an unused ID in the range specified by @start and @end.  If
  * @end is <= 0, it is treated as one larger than %INT_MAX.  This allows
  * callers to use @start + N as @end as long as N is within integer range.
  * The search for an unused ID will start at the last ID allocated and will
-- 
2.40.1



