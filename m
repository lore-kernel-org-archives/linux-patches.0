Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619185;
	b=XRWpFL/G4L9rPjkMK7efHmC3VGLPgMKavfjqgA4Zni5obRLZP6l7gS62HGG4oGGmJyCB
	 eF84NmgarSJs1xzhxXl6Rn7myYlNvPTojZicgTsLTustYDbI8enkVCAzF7eU9utp1WS/S
	 xg+/7gRsr/oGvdAEgmoPrN53LGhLxv/vB058b0rtKmFnWCAqAn++SvEmlgWkONLi1EBgA
	 NRI5cf0hGOj41NUJnl9rMxtebGZBKJv4rrq8nAb4FpPO+9jTiORyyCKCFHMCKUy6TFIvm
	 ZcM0gLNdApKPxb7ptFEFuoM6biZnuUYc9kq8sELm1Rwhs4/wum+aAHtKAk/3v/+ssgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SiTyMQfFHwY4DJ5y4pWd8yj3eWh5wOW/jo4d3pEnQe0=;
	b=PJpinMGA63q9n+uAT+P0JkdNf+QhMdGhdjS8cYgXfdjWjAzdL9Ti48hSVvNKXYat6wve
	 HVAG66s4usFCqqylLwKpjRp2ys7Y0QGCWuZVvMpmS5cihgh1VsEoSuFWfTzsbuGSDd4nc
	 CZDmsRCVaUAuhb0TSKn8ud1Mr1YFxXB6Ko5QIh6HcGGD5bjjAHmvx+7QH/e19USuTMOX0
	 vA0NMZspdxs9E/sjOEHgXYCFA4hp6oQ1tmynyhSaNbqH8yZH5OZq8W6NdHYiUaEOqE/Xv
	 T/dYALNsGg2G7riAl7U740pA2OQHZWS85uYTUPvBPc4cAUcBuo767ZQbHeAdxoPOkMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1xAG/jRt";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE257606A321;
	Wed, 25 Nov 2026 15:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1xAG/jRt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6861F000C0;
	Wed, 25 Nov 2026 15:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619185;
	bh=SiTyMQfFHwY4DJ5y4pWd8yj3eWh5wOW/jo4d3pEnQe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1xAG/jRtJu/Vjf83Y907o3ELugj613OHKci1k1QCZS8Xx9SXdzIp5A45BY88RkQMm
	 WEp1LrMvSObCk4sRdbkDfr0UQ7qOxSHwf41IeZDAd7GnGCELpv9v8+hrzKwBPnj6jI
	 zccF0d72oDk2eVLPoYr7UMKw7s4aBTm+ePZgVh7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0518/1005] erofs: reset buf->off in erofs_init_metabuf()
Date: Wed, 25 Nov 2026 15:30:56 +0100
Message-ID: <20261125143833.880005305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

[ Upstream commit 8b4ddd28ec5bdec14cefc57f8bf792cb4764d724 ]

erofs_init_metabuf() sets buf->off only for the block device and keeps
the old value when it switches to the metabox or the managed cache.
erofs_bread() adds buf->off to every offset, so the result depends on
how the buffer was last initialized.

getxattr and listxattr init the same buffer twice, for the inline and
the shared xattrs, with in_metabox taken from different places.  On a
block device mount with fsoffset=, if the inode is outside the metabox
and COMPAT_SHARED_EA_IN_METABOX is set, the shared xattrs are read at
their metabox offset plus fsoffset.  The same image mounted file-backed
returns the right values.

Reset buf->off on every init.

Fixes: 414091322c63 ("erofs: implement metadata compression")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Gao Xiang (Docker) <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/data.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index a726be5e27ca6..67052e98ef44e 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -60,6 +60,7 @@ int erofs_init_metabuf(struct erofs_buf *buf, struct super_block *sb,
 	struct erofs_sb_info *sbi = EROFS_SB(sb);
 
 	buf->mc = false;
+	buf->off = 0;
 	if (in_metabox) {
 		if (unlikely(!sbi->metabox_inode))
 			return -EFSCORRUPTED;
-- 
2.53.0



