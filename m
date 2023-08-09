Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E6414A8D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEFAC433C7;
	Wed,  9 Aug 2023 10:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578267;
	bh=ldIHsHWBIL20Eu1g1t8jASQBmtybSnCfPApNXoURqq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzrG2M483MPu3R/oKI0D7TG1HQQ/2FvzhgnBRfaCBBZaf9dgcWTbi7ixzjYoqBY9a
	 cl8XFjNIoBqmMbHNs1zlbpg6y06Dqlp+1zVZjwHX8yRGHyAV6WKjt2DNyns9JkB7l+
	 Y4IRdFH/zxalC34x81//DUdjQSRpqgeA2dw5IgWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+89dbb3a789a5b9711793@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.4 136/165] fs/ntfs3: Use __GFP_NOWARN allocation at ntfs_load_attr_list()
Date: Wed,  9 Aug 2023 12:41:07 +0200
Message-ID: <20230809103647.268671233@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit ea303f72d70ce2f0b0aa94ab127085289768c5a6 upstream.

syzbot is reporting too large allocation at ntfs_load_attr_list(), for
a crafted filesystem can have huge data_size.

Reported-by: syzbot <syzbot+89dbb3a789a5b9711793@syzkaller.appspotmail.com>
Link: https://syzkaller.appspot.com/bug?extid=89dbb3a789a5b9711793
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/attrlist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ntfs3/attrlist.c
+++ b/fs/ntfs3/attrlist.c
@@ -52,7 +52,7 @@ int ntfs_load_attr_list(struct ntfs_inod
 
 	if (!attr->non_res) {
 		lsize = le32_to_cpu(attr->res.data_size);
-		le = kmalloc(al_aligned(lsize), GFP_NOFS);
+		le = kmalloc(al_aligned(lsize), GFP_NOFS | __GFP_NOWARN);
 		if (!le) {
 			err = -ENOMEM;
 			goto out;
@@ -80,7 +80,7 @@ int ntfs_load_attr_list(struct ntfs_inod
 		if (err < 0)
 			goto out;
 
-		le = kmalloc(al_aligned(lsize), GFP_NOFS);
+		le = kmalloc(al_aligned(lsize), GFP_NOFS | __GFP_NOWARN);
 		if (!le) {
 			err = -ENOMEM;
 			goto out;


