Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B06C611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB91C433C9;
	Mon, 28 Aug 2023 10:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219193;
	bh=cHpTtQphDdmCUiYdjgL1CULI+lrs5oE1wsQg8+PFfk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzWMiDqVThckY/oN28WbUG9ukcLD8UgDKEYIOkEyBLW2O9FRL9zXyGLRvnJrgnbjN
	 M0l9M4/SNZSUaEc8TmhhJBTyrBVexZbcTLwjM4gaF/cA8/+hCKrWgNgEIv1PJhHSzr
	 uZ66xSsjBvugpv8dm93o5DpV9p73NupuJ0k8jqWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 107/158] dm integrity: increase RECALC_SECTORS to improve recalculate speed
Date: Mon, 28 Aug 2023 12:13:24 +0200
Message-ID: <20230828101200.916825067@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit b1a2b9332050c7ae32a22c2c74bc443e39f37b23 ]

Increase RECALC_SECTORS because it improves recalculate speed slightly
(from 390kiB/s to 410kiB/s).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Stable-dep-of: 6d50eb472593 ("dm integrity: reduce vmalloc space footprint on 32-bit architectures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index d7911c623edde..12b086b14cc4a 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -35,7 +35,7 @@
 #define MIN_LOG2_INTERLEAVE_SECTORS	3
 #define MAX_LOG2_INTERLEAVE_SECTORS	31
 #define METADATA_WORKQUEUE_MAX_ACTIVE	16
-#define RECALC_SECTORS			8192
+#define RECALC_SECTORS			32768
 #define RECALC_WRITE_SUPER		16
 #define BITMAP_BLOCK_SIZE		4096	/* don't change it */
 #define BITMAP_FLUSH_INTERVAL		(10 * HZ)
-- 
2.40.1



