Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0387F6FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51936C433B5;
	Wed, 30 Nov 2022 18:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832994;
	bh=4Dc3mtDjLsAU+eXtlVUKsNqFP7Cl4Fdeno/UpzoStPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIgGbE0axPolwo9G2kFMElxqXLfnXcbOffluqGqXMqHN6jZVXlnggT4fNojNXtooX
	 KQmWR+u8uomofIhIh98WvJfpdjz41VvwA/6Bny6P9z29y1OHoBZfwAOu5Q9lLlP4dH
	 uOnZbYt9v7Sc6m0QSst4pvMQs85KWHsVxb9diRrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Lee <klee33@uw.edu>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/162] ceph: Use kcalloc for allocating multiple elements
Date: Wed, 30 Nov 2022 19:23:15 +0100
Message-Id: <20221130180531.581338574@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kenneth Lee <klee33@uw.edu>

[ Upstream commit aa1d627207cace003163dee24d1c06fa4e910c6b ]

Prefer using kcalloc(a, b) over kzalloc(a * b) as this improves
semantics since kcalloc is intended for allocating an array of memory.

Signed-off-by: Kenneth Lee <klee33@uw.edu>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Stable-dep-of: 5bd76b8de5b7 ("ceph: fix NULL pointer dereference for req->r_session")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index ce6a858e765a..668be87ffee6 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2335,7 +2335,7 @@ static int unsafe_request_wait(struct inode *inode)
 		struct ceph_mds_request *req;
 		int i;
 
-		sessions = kzalloc(max_sessions * sizeof(s), GFP_KERNEL);
+		sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
 		if (!sessions) {
 			err = -ENOMEM;
 			goto out;
-- 
2.35.1



