Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853BC3212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1E7C433EF;
	Tue,  7 Feb 2023 13:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774899;
	bh=KK8sJKIOmClHvWY61f9nqWgtbjl/md6WzbvYW/0qXMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8C6RvLtbJIgVWIPVE74tmnlTIaje13g2bWKPceQtSrb0E3GYu8rvzHrnBNhzSXGP
	 blkzilWqqtJa22kCE/rTRs5rXsOZtrbjm5Xj9YeCg+EvnBYsStMVow5H9L2URiSDq8
	 hpv+Lus1AHRThvCZsrQo3S7vr1yZLbWAC6tmU5Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/208] maple_tree: should get pivots boundary by type
Date: Tue,  7 Feb 2023 13:55:24 +0100
Message-Id: <20230207125637.493594695@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Yang <richard.weiyang@gmail.com>

[ Upstream commit ab6ef70a8b0d314c2160af70b0de984664d675e0 ]

We should get pivots boundary by type.  Fixes a potential overindexing of
mt_pivots[].

Link: https://lkml.kernel.org/r/20221112234308.23823-1-richard.weiyang@gmail.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/maple_tree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index fe21bf276d91..5bfaae60ed8b 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -665,12 +665,13 @@ static inline unsigned long mte_pivot(const struct maple_enode *mn,
 				 unsigned char piv)
 {
 	struct maple_node *node = mte_to_node(mn);
+	enum maple_type type = mte_node_type(mn);
 
-	if (piv >= mt_pivots[piv]) {
+	if (piv >= mt_pivots[type]) {
 		WARN_ON(1);
 		return 0;
 	}
-	switch (mte_node_type(mn)) {
+	switch (type) {
 	case maple_arange_64:
 		return node->ma64.pivot[piv];
 	case maple_range_64:
-- 
2.39.0



