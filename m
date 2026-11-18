Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037753;
	b=DV8Rnt8kSxkvEChYaqPWvZ6+WtHNrn76Om91r6XPLQso0S8UG5p5niiMHs2LtjmNFa/D
	 5rhkf9mmhtE2zaMgScGq/7Fo2fXiggZJP2ENMJ+TkA5e7aURdwJQhUBvxHTD4LZjhjUpC
	 vLkYkut3cJj9rJo2cnnUqa+O3zyJZTHIHPfPsFeFAIpbfvq612/iL97xxoAFFwOF/srjV
	 dvPTcOOnylB+aaLFEZ7TrqG/jBcs5QqN4f5iX2O1rkh7wguMP4uojmAip2DmiqAEY54/k
	 02KHcvs1z+ulT71vqaWL3NSmUX7ElVvB4cZN0s2aw+paadwICoAwh427Mm5i2U0/Fvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OCwcpsoERXdoeFfmtRXGL/uQMGGBTSIJBPePG2lUndk=;
	b=kMyOnXeAbb1FtOiUU7lVARaGLJ5XzsFXHk8Gx1vM2U1yGUuuT6jYDjkgCPk2z8BM6z9B
	 DHdb0cTbg14zMl5cdGJBRVggiDDPr1F6Y/G+Jfzqb+tC9Wwgway59Sy/Kc+oEjzdg3zX2
	 X2p+bNcXlrwNgtbqFDIKl4Mgal9c7rPNX1/yFGt0LEneTdWlJow/ClyeUJw89ztOLcTZS
	 FHzjy6zyB3sRuxp4s2IQbSdjPvapxLptWDr2OqoK95hOXZDbEEx25e+YOB1YqQcN9aesr
	 4Mt2E0jBNsWiLea1BSGiuzIMGykkN82TtHgk/Jmw4f504EBpkKWnkO+v+/oSuRz7HEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U9Nhjsak;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFCA606A32C;
	Wed, 18 Nov 2026 21:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U9Nhjsak
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D701F000C4;
	Wed, 18 Nov 2026 21:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037753;
	bh=OCwcpsoERXdoeFfmtRXGL/uQMGGBTSIJBPePG2lUndk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U9NhjsakaFyVC/XDi3vbO365d5UJwGGjUAGWWxnrCF1W1RQvVpGahAUZNxueXKtsM
	 J6jzk7YBw7ZWZwzw7OHRyUpb5i3mVc2OcQyTtcIxzILlj4i5tcARFLV/8y79wh6Al8
	 M7jsowZq5+nE9jS+ak1VovQrXfwv70UuXeiVZ690=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Daejun Park <daejun7.park@samsung.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1506/3318] xfs: cap the block count of xfs_iomap_write_direct() at one extent
Date: Wed, 18 Nov 2026 15:35:28 +0100
Message-ID: <20261118150406.108301522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit 66d1ce09ebd72709f8d739630c39f440445173fd ]

xfs_iomap_write_direct() reserves blocks for the whole count in an
unsigned int. For a pNFS layout the client chooses that count, and an
RW LAYOUTGET for 16 TiB wraps the reservation and shuts XFS down.

xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks here, so cap
the count at that. nfsd asks again for the rest. The other callers get
the same mapping as before.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Pankaj Raghav <p.raghav@samsung.com>
Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_iomap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 40d02a1450d3c..f7c10a8e254a2 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -253,6 +253,14 @@ xfs_iomap_write_direct(
 
 	ASSERT(count_fsb > 0);
 
+	/*
+	 * xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks in one
+	 * mapping, so don't reserve blocks for more. A pNFS layout range
+	 * comes from a client, and its block count may not even fit the
+	 * 32-bit reservation. The caller maps the rest with a later call.
+	 */
+	count_fsb = min_t(xfs_filblks_t, count_fsb, XFS_MAX_BMBT_EXTLEN);
+
 	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
 					   xfs_get_extsz_hint(ip));
 	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
-- 
2.53.0



