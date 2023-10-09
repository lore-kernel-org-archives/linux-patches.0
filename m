Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E6F339B4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAgwsPzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CCEC433CD;
	Mon,  9 Oct 2023 13:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858953;
	bh=IkBBfBHdIUb0IcnIxYaw4dhWoPL6i3nR2XwSqIpmdIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAgwsPzU1KxWQzpbMQU3FPeNR5Dqj1wRColfKPMwfp6prqyMBlaH/0MUmB6GOieBd
	 AJHFK0mqQJov6UlNnVk7BTABnI4EjLN0Lx6JGKadk3LXSs7bhpxhRL0xrYrlG89/vG
	 g7XlVLA/Q+HINdpCf6u7A0lUr3r2f/wpdSSdVOgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	David Hildenbrand <david@redhat.com>,
	Yikebaer Aizezi <yikebaer61@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/226] media: vb2: frame_vector.c: replace WARN_ONCE with a comment
Date: Mon,  9 Oct 2023 15:01:25 +0200
Message-ID: <20231009130130.016752643@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 735de5caf79e06cc9fb96b1b4f4974674ae3e917 ]

The WARN_ONCE was issued also in cases that had nothing to do with VM_IO
(e.g. if the start address was just a random value and uaccess fails with
-EFAULT).

There are no reports of WARN_ONCE being issued for actual VM_IO cases, so
just drop it and instead add a note to the comment before the function.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reported-by: Yikebaer Aizezi <yikebaer61@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/frame_vector.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/frame_vector.c b/mm/frame_vector.c
index 0e589a9a88012..1cd81d38ad2d0 100644
--- a/mm/frame_vector.c
+++ b/mm/frame_vector.c
@@ -29,6 +29,10 @@
  * different type underlying the specified range of virtual addresses.
  * When the function isn't able to map a single page, it returns error.
  *
+ * Note that get_vaddr_frames() cannot follow VM_IO mappings. It used
+ * to be able to do that, but that could (racily) return non-refcounted
+ * pfns.
+ *
  * This function takes care of grabbing mmap_lock as necessary.
  */
 int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
@@ -77,8 +81,6 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 			goto out;
 	}
 
-	/* This used to (racily) return non-refcounted pfns. Let people know */
-	WARN_ONCE(1, "get_vaddr_frames() cannot follow VM_IO mapping");
 	vec->nr_frames = 0;
 
 out:
-- 
2.40.1



