Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8595779C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060B0C433D6;
	Wed, 30 Nov 2022 18:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833218;
	bh=xIMnQIS8Er6JS+vkVx92DutyVRa0EuYxw8XLi7K/Nyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GsuVuK90/2MfH9ZrKdz/ogEiriqSKDj2Gen8pL+KTVn3idSulCBxn2r+OyZC9rzGu
	 2mFl+Ap5uL7UmJul6e1hiwwILIQhq6v59KJHpbBpJK9fl9JFgx3Usfp4dXHITa3HSs
	 GZo8VIFURp5A3ZN/Kd+33iNRJb1rwp0iKh/IiNas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Lee <klee33@uw.edu>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/206] ceph: Use kcalloc for allocating multiple elements
Date: Wed, 30 Nov 2022 19:21:21 +0100
Message-Id: <20221130180533.736266090@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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
index 883bb91ee257..a6e2aaff17dd 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2255,7 +2255,7 @@ static int unsafe_request_wait(struct inode *inode)
 		struct ceph_mds_request *req;
 		int i;
 
-		sessions = kzalloc(max_sessions * sizeof(s), GFP_KERNEL);
+		sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
 		if (!sessions) {
 			err = -ENOMEM;
 			goto out;
-- 
2.35.1



