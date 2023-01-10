Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7426FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1954BC433D2;
	Tue, 10 Jan 2023 18:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375004;
	bh=b3c2/6ILhMWcSkjdxUCpDRLkQ9+mcXz47Pzr94oZpqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7oPUfUc69u0Pv+PpHvkKnWfoI7E+EWrEmTYrDOIsHQ9/AYKIGZskRfPvn3zCSNGC
	 oF/DIRcB8BCwkzTNMf1adpCv5QZKjJwWk1HCUWBRjbHVPHTFz0WVjrZVe6LRdzsn74
	 PSz4Ccc57odBRX9gBJxqWNsgSyUo1SrVHRDIVFUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@denx.de>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.15 047/290] f2fs: should put a page when checking the summary info
Date: Tue, 10 Jan 2023 19:02:19 +0100
Message-Id: <20230110180033.225897777@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Machek <pavel@denx.de>

commit c3db3c2fd9992c08f49aa93752d3c103c3a4f6aa upstream.

The commit introduces another bug.

Cc: stable@vger.kernel.org
Fixes: c6ad7fd16657e ("f2fs: fix to do sanity check on summary info")
Signed-off-by: Pavel Machek <pavel@denx.de>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/gc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1033,6 +1033,7 @@ static bool is_alive(struct f2fs_sb_info
 	if (ofs_in_node >= max_addrs) {
 		f2fs_err(sbi, "Inconsistent ofs_in_node:%u in summary, ino:%u, nid:%u, max:%u",
 			ofs_in_node, dni->ino, dni->nid, max_addrs);
+		f2fs_put_page(node_page, 1);
 		return false;
 	}
 


