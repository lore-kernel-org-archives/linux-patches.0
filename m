Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016170;
	b=fmFe427UOCzGXVNqqpIyUGGdwkoVPUomxqXU6Uv5tZ4HVs2EASrRoYaUCEgJ5Q7pBO+w
	 JXCAYMORLdokpxtDlX3a3e2zHcTAGGpDTHZSKa65jN5fK+1f3yUpK7aLw59tUdvhjcvcU
	 lCeYLMvV5sh19oHN44rqB6eX+rp94LvhLhILMCBmt6e8YsigKh5V5Jd0WqzO7hU3NAW3Y
	 HRA3mM8UECgwzDbggA65m0QezNO55sb0J4ZZHKGsSalFOlKOGkjy+pweXzSvj66Ki7wS4
	 QeV+iRKp4dQA8Hl0Pg5nbNYGQrUVy9cN8C6VqIehFxtDROgrCOGonnnufoqEX2UT8QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tCDSS0YaD08ZdUn1II89ByshfrY4JvWLcPmr8MCHuyk=;
	b=tjOgmtbSdMIRsrONPdf9NmLIz7xw2L7Y9akFrvwjpmRk8dixJvYKAd02OZL5WqjII2S2
	 rZdVloM65sW2m1KFX4LEHf5XBYXvHJ7R5LvfxA/8dhnJBctTQrdk/sY/TLE/hUDfoyPDD
	 4jW0nJbz0HK4HeLTOkUV/Ejwn1sCHTmUGZQ0p6y7T1eb/Oq1KxXLdThP1/23SImEr9wOk
	 xmDYQ2D3pkUbme513Lod5MOV9k2mNC8K9iVnsT/EWYaduEu97DX1sEc2/FylrxnsFSvhb
	 jHlOsvVp4WQgQhv8D5SyoZpYPXlp/9FJ0vV3nPCYBlTp6a7X4sMAy8wzSuxJbHoYGRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1pMxAyn+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDD3606A320;
	Wed, 18 Nov 2026 15:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1pMxAyn+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D6C1F000C4;
	Wed, 18 Nov 2026 15:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016170;
	bh=tCDSS0YaD08ZdUn1II89ByshfrY4JvWLcPmr8MCHuyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1pMxAyn+IgSevkUg5si7Fj+YSKWG+EOb1f62p1yfIqSbwNeAa58WnTmmrM4gIwRic
	 H9MPIZlMst7PSYR9dXMAgkP67fRyx+uC/R9oJVr9fYoCqlgcvmOLm+lWOStulA7fJs
	 FC+TGf9U22LyF/HDnBNIi4zHKxscbN0NdrpVznpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0435/2651] gfs2: Fix the return value in gfs2_get_link() kernel-doc
Date: Wed, 18 Nov 2026 15:27:55 +0100
Message-ID: <20261118150303.487896617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 700a0a6892f7c0c541d5d23837cfab98cc744d17 ]

gfs2_get_link() returns the link target or an error pointer, but its
kernel-doc still describes an integer status. The mismatch dates back to
when gfs2_readlink() was replaced by generic_readlink() and persisted
across the removal of nd_set_link().

Describe the returned pointer and error value.

Fixes: c177c2ac8c5a ("Switch gfs2 to nd_set_link()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index f361876c55833..d5e03ec891272 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1900,7 +1900,7 @@ static int gfs2_rename2(struct mnt_idmap *idmap, struct inode *odir,
  *
  * This can handle symlinks of any size.
  *
- * Returns: 0 on success or error code
+ * Returns: the link target on success, an ERR_PTR() on failure
  */
 
 static const char *gfs2_get_link(struct dentry *dentry,
-- 
2.53.0



