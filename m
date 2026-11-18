Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055051;
	b=jry+jC1CBx2xdsVf7OrdkvWtNs3o79X4Krv0SBqFFK4rxzWWapHFdVxBhiIs9dhCeSNy
	 P1MV+qcxxytXmQh0WD356x5+kdGz6/Vkti2Z1vA4coSn9hd85S7r0zEXLk2Vhqb2fbQSj
	 gKhnyyAylsqgl3FHaEzxUSDqHd/IQatFvf97BkfdkAkOlR91G6qZQeaYDu+OGJuYmzs76
	 GWsa48k5HJwF7EY56LFSEhp1YOkd/bFeAS74zLws+PwHLxxr0zl2okMHTqlDwW2mnhjiU
	 h635tI8U0H+mU7H2AcZf2LvIlPvE/uxnFooHbEi3Q2O/vpN96EBO65hf9j4ho62CCNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G4Fe4NDIk4NSfuH4BDh2O60tPKO+vCvc2VJFCYtADcA=;
	b=VmWy0J91ggS8rG+3Xbmimxs2bhKOlKo9kFb4xXbDIIRdxHrOfqJZa1E6isjHVXIjIoEY
	 Mokxt/tX+CKHo88QgLu9uiO7f5efDSR7zUcvEHGIHLVqdyPpX1QInWM1EMYSVuaE4SmCT
	 5BZG+RPItFRkI5xs+yiKLStPsw/KYzPz8eHp7EvBgK4L9a1zX9pxyOszQRFZZ/bOqXq5g
	 l7Oy2taebaknK9bTGP3893w8FxKmK4aS8XmitzEnvGe3cubIKG5JOF/2+z0cyRM2wp+n1
	 wop/eFVlMX4fUuM3uH9Jvu8r+PGSH8dADK9fhBrVBy1DdfRckV4oMeuEK5ToEaAV1xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XdzSI88N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91444606A320;
	Thu, 19 Nov 2026 02:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XdzSI88N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC251F000C4;
	Thu, 19 Nov 2026 02:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055051;
	bh=G4Fe4NDIk4NSfuH4BDh2O60tPKO+vCvc2VJFCYtADcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XdzSI88N4fxt2xTXGJ8NP/yqaqy6VqB1k/qU4Tg3j0dUtzREZGgziRNZZWM3Ui01T
	 U5L9UQ6jTV7iljNBq0cMastkTy94k78jJvVmFItUznp8918eekRLA8fch7YIcLgvvu
	 8ARxZOpaAc2o6t8yrHlJxBV/W/ovFFJLO5rG7wVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1492/2214] gfs2: Fix the return value in gfs2_get_link() kernel-doc
Date: Wed, 18 Nov 2026 15:52:48 +0100
Message-ID: <20261118150111.091800166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 061372f84a64c..883592c7287be 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1783,7 +1783,7 @@ static int gfs2_rename2(struct user_namespace *mnt_userns, struct inode *odir,
  *
  * This can handle symlinks of any size.
  *
- * Returns: 0 on success or error code
+ * Returns: the link target on success, an ERR_PTR() on failure
  */
 
 static const char *gfs2_get_link(struct dentry *dentry,
-- 
2.53.0



