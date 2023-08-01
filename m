Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4881FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36554C433C8;
	Tue,  1 Aug 2023 09:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883132;
	bh=mtw/MHBNl9ETuwSFHKTtVsS0iNwUBSK6kVq4OwBqROw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGk+NrhZo3lZOj3Wcdgtxmf8en6C8jzE6cm3RLKRJn3iO/3SvJG+8dJh1OTY1OnE/
	 VOWuuMEobAJZ5xcRJwv9b9fjUzRhXoUV3FjUtkmyWErtfuaQiYBGLXG9cSuhW5I5M9
	 XmXfbzOfaCpgsCUev8FtrVxIQTJKLIUjqxDxg44o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 098/239] fs/9p: Fix a datatype used with V9FS_DIRECT_IO
Date: Tue,  1 Aug 2023 11:19:22 +0200
Message-ID: <20230801091929.261002571@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 95f41d87810083d8b3dedcce46a4e356cf4a9673 ]

The commit in Fixes has introduced some "enum p9_session_flags" values
larger than a char.
Such values are stored in "v9fs_session_info->flags" which is a char only.

Turn it into an int so that the "enum p9_session_flags" values can fit in
it.

Fixes: 6deffc8924b5 ("fs/9p: Add new mount modes")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Dominique Martinet <asmadeus@codewreck.org>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/v9fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 06a2514f0d882..698c43dd5dc86 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -108,7 +108,7 @@ enum p9_cache_bits {
 
 struct v9fs_session_info {
 	/* options */
-	unsigned char flags;
+	unsigned int flags;
 	unsigned char nodev;
 	unsigned short debug;
 	unsigned int afid;
-- 
2.40.1



