Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9637E6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E0CC433C8;
	Sun, 17 Sep 2023 20:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981671;
	bh=pkJmraR0tRsuj1r/VF9+k9GRgfwQy7lB1GxGn1jKGQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOFlsHIIyeq7ozy2LJDSV5niNnI3UUMFGoWUokiIzAqXNch36p6crVGE71xLzzO10
	 xxw2GaVljYNgQJwrCQnus34j6Vfk/EtYufDTZYGcr3Wu7H184yyremJn8Ey4m29ZU7
	 MXYmGmWGrWYuCbhW6xpHLet+IFUAFv3MW/iDeteo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ariel Marcovitch <arielmarcovitch@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/219] idr: fix param name in idr_alloc_cyclic() doc
Date: Sun, 17 Sep 2023 21:14:06 +0200
Message-ID: <20230917191045.276096503@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



