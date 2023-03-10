Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891508821
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF26AC4339E;
	Fri, 10 Mar 2023 15:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460464;
	bh=y8ijsG2h02xzR2ry/W6aYhQ2DubvJ4bKezImAwMuvCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8gIbuBCSdphcLobgtNwj99uoQXS0No+c/UsboGFeK5siWLeuXdcs7QFIX3R1o1J0
	 1kDjgENCbtRa7zIEOC2fDuxQjw0EmiOt1kQ3U13M0tCrgFHr2mZvVzArwv67fUvZa5
	 oZ9hOd9emcGDHnZ00DRYI9Ms9r8dFADul7DsL/nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.10 342/529] exfat: redefine DIR_DELETED as the bad cluster number
Date: Fri, 10 Mar 2023 14:38:05 +0100
Message-Id: <20230310133820.858718064@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sungjong Seo <sj1557.seo@samsung.com>

commit bdaadfd343e3cba49ad0b009ff4b148dad0fa404 upstream.

When a file or a directory is deleted, the hint for the cluster of
its parent directory in its in-memory inode is set as DIR_DELETED.
Therefore, DIR_DELETED must be one of invalid cluster numbers. According
to the exFAT specification, a volume can have at most 2^32-11 clusters.
However, DIR_DELETED is wrongly defined as 0xFFFF0321, which could be
a valid cluster number. To fix it, let's redefine DIR_DELETED as
0xFFFFFFF7, the bad cluster number.

Fixes: 1acf1a564b60 ("exfat: add in-memory and on-disk structures and headers")
Cc: stable@vger.kernel.org # v5.7+
Reported-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/exfat_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -42,7 +42,7 @@ enum {
 #define ES_2_ENTRIES		2
 #define ES_ALL_ENTRIES		0
 
-#define DIR_DELETED		0xFFFF0321
+#define DIR_DELETED		0xFFFFFFF7
 
 /* type values */
 #define TYPE_UNUSED		0x0000


