Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EC12F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E432C433D2;
	Wed, 12 Apr 2023 08:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289551;
	bh=7dKDgcGJtTOo5/LJAr61enMxkUxsY7O9Sv8OXzmIO8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pd69kfXBIjT2NNAOOO5+ogadu4V5wnlIkASbWGW3M606lwlXQZRaJZKoPf2qBK2At
	 LBib3DcBvk3g1NCHlrp202n9BK0w/LrS7etcf+ni+WXovuqH2DeuejJJjvjLLud1He
	 zxj+3j5fO1jkTY0rmjaCOxC6xWu6Xu19WWq9rbt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 142/173] zsmalloc: document freeable stats
Date: Wed, 12 Apr 2023 10:34:28 +0200
Message-Id: <20230412082843.840290359@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sergey Senozhatsky <senozhatsky@chromium.org>

commit 618a8a917dbf5830e2064d2fa0568940eb5d2584 upstream.

When freeable class stat was added to classes file (back in 2016) we
forgot to update zsmalloc documentation.  Fix that.

Link: https://lkml.kernel.org/r/20230325024631.2817153-3-senozhatsky@chromium.org
Fixes: 1120ed548394 ("mm/zsmalloc: add `freeable' column to pool stat")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/mm/zsmalloc.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/mm/zsmalloc.rst
+++ b/Documentation/mm/zsmalloc.rst
@@ -68,6 +68,8 @@ pages_used
 	the number of pages allocated for the class
 pages_per_zspage
 	the number of 0-order pages to make a zspage
+freeable
+	the approximate number of pages class compaction can free
 
 We assign a zspage to ZS_ALMOST_EMPTY fullness group when n <= N / f, where
 


