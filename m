Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618913;
	b=inkr0Eu1nF3sLCt1ZOyJR7wRet1PG21L+gMZYxBS5zuqD+tePPh25B8h5o0DQ+3DGuh/
	 e07FvNabnUXMvPWD+uGZZb5KMcvvczZ7+0NnxAlAS5T93agPDiE0zPwlh1+uYH0RFhVhf
	 SVSwmqjCXgIO/FzYtAT+azJRz8umn72apD4mxNAdVcHDiRde//MPlum/to0RManlangAX
	 m7A7Yvj7JmRz/zUxk+dEa/ZoqAp9egDKR8q55AM6yeeDapaNKV/o0ir5DPbgstl13pLo6
	 7J5xukca304wzhnBomn5Gxq31gkuvtYEhL17dA1DOG36oCnbW3QhMfqH0X78nrNIGyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2RejCoynzMreSU97mhHe8VbjUCbomVmKNhjbl8cbihw=;
	b=UBiucCv+JUaRCP8Aqes47MEdoq2lpTdPS172I0tRhEoHsAcoh91K1+vhDy+e4OYL8UlC
	 qZB9Q0BHRKinAiyKC1Ijrc0r8I3LPeIJMmHyRCXm4XMTH3tzzay2aliqxYjyXHPYJXcUo
	 t8jo2KoBMSY2+cO8r1j3BHhEF5HLHb/2thv3BHusygfJ2y1pWwOKatQA9FY6Yp988p5Te
	 kdPcFZncFqITjuMR4/3vsEWe6+lMdMRerEdQcHIY5ISeDkN5Td84PY02GXNZYXmJj+8W+
	 jI/6Yf/+D/uFKodhoqWhykJKBaoIYb1oPqj++kduxt645MpIY5F36j21p96NQk15/hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GyX5dtcL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3874C606A329;
	Wed, 25 Nov 2026 15:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GyX5dtcL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522F11F000D0;
	Wed, 25 Nov 2026 15:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618912;
	bh=2RejCoynzMreSU97mhHe8VbjUCbomVmKNhjbl8cbihw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GyX5dtcL9+giSEUGKCs1xcHZgfbTM2y3qhEQYw2/pIOpG8ECwrgNIg3s8JYUlAKh6
	 N+xfJDqZtpka18dFrmdtlVDM2MLCDMJAm0V1GtUoSut/rHI4meJhaLcjEsG7Rhq701
	 52v0VoDS9dmKUzwaISI7KAtG7cvRYdxWQ1XOk4m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0428/1005] NFS: honor UTIME_NOW atime with explicit mtime
Date: Wed, 25 Nov 2026 15:29:26 +0100
Message-ID: <20261125143831.779597477@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 2ffcf17d26dabef5793aeadf75a23c595a72be08 ]

When utimensat() requests UTIME_NOW for atime and an explicit mtime,
the VFS sets ATTR_ATIME but not ATTR_ATIME_SET (as it should). The
delegated explicit-mtime path calls nfs_set_timestamps_to_ts(), which
skips atime, but nfs_setattr() then clears ATTR_ATIME, allowing the
syscall to succeed without updating atime.

The delegated explicit-mtime path already updates ctime locally.
The VFS also supplies the requested atime value in ia_atime,
even when ATTR_ATIME_SET is absent.

Check ATTR_ATIME instead of ATTR_ATIME_SET to also apply the
UTIME_NOW atime value supplied by the VFS.

Fixes: aba41e90aade ("NFSv4.2: fix setattr caching of TIME_[MODIFY|ACCESS]_SET when timestamps are delegated")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 3022454f7698a..4fa6c5547ab86 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -644,7 +644,7 @@ static void nfs_set_timestamps_to_ts(struct inode *inode, struct iattr *attr)
 		inode_maybe_inc_iversion(inode, updated);
 		cache_flags |= NFS_INO_INVALID_CTIME | NFS_INO_INVALID_MTIME;
 	}
-	if (attr->ia_valid & ATTR_ATIME_SET) {
+	if (attr->ia_valid & ATTR_ATIME) {
 		inode_set_atime_to_ts(inode, attr->ia_atime);
 		cache_flags |= NFS_INO_INVALID_ATIME;
 	}
-- 
2.53.0



