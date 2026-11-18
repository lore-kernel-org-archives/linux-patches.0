Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025514;
	b=YipaquRdbpz6Z1QQSbvCCDMK/vNDABskZ4shEHHN+8M3o/8EbYOoyY/3WF9yzOLQiXOH
	 T/GYYCjQ4Vrfd2wy/wyRJNR1uw79xQRrXnQcJ6+FFfwfx6Wq/ILj3q6c+AeDFmVVwSpQ1
	 G7b75hvzfYRriNM3NRzpw9DQXXlA+lZOD2PqGLX+EUs5bQd5cSrZjMBHXO4Rc4eiKkCjS
	 JVt6BTpwydjyAKKoX7wYse8F/dai75VKAcFT3y9q7ttxayrgZxoPHJZeHGTbJBdAFOXNn
	 uVc87/zswsvWifV9GUDyslOsZf65C5ipKH+pwKA1NsZ52KIib9CbgWt+4R2U5+XXznw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TXk3CzrzcpClRYp1zx0vT+3hTiXMf+apM1J+uggRQPw=;
	b=H3n8hNDkMHlQCuTEFmCdWXzxVodo/L+edpcRYC7eytKKrb7A21rq3Mihpuae6G5F6Qwx
	 vU8G5qyj22JlTINVE5/Aj96ALGAJ4YWWaff92VGny2IHVTlP4jgrRZw/o4FBgZJFHxU/E
	 /aEJCnnY3PpCsussjDY/fbMt2nSBY6ctnL9Lajq0LOp6NgPJAT6uIJxjpyVCEdMbze8R0
	 vZ33FAmYtKtD0IOEpbctvcqjfmshvDhsjX19lkPhLTPBcG/q5LHvv4qYy+Ggj+NOMkV9u
	 iVDK4Ig5PtxhFUJ1YBw235dZSjeKszEcOQxrWMk+TbKoi1+W89+PltImaJCSR6O7zSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=djdShzCG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DA3606A31C;
	Wed, 18 Nov 2026 18:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=djdShzCG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F63F1F000C4;
	Wed, 18 Nov 2026 18:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025514;
	bh=TXk3CzrzcpClRYp1zx0vT+3hTiXMf+apM1J+uggRQPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=djdShzCGqKvxtPaAbBCnXwPL4F6wdEg2GU8yk59mOo1kHGiwUI1F5CDBVxL8nLv5J
	 ufwlePEV7Ya/PYkthDae/xkiQ8J4k2As6+igxxIoSJPVd3HgNr6yMewyLXICEzrMtd
	 S9kgM2DC7FHpVSf8Z4XVAVD/TbFYvUvSf0QNF2xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1104/2151] NFS: filelayout: calculate dense stripe width in 64 bits
Date: Wed, 18 Nov 2026 15:47:19 +0100
Message-ID: <20261118150202.463080053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 9ba13ef0e3ad033d3ddbaeb740b12d135a88363d ]

filelayout_get_dense_offset() calculates the stripe width from the
stripe unit and count, where both values are provided by the server.
Their product is stored on 32 bits, and can wrap to zero despite
passing individual checks. For example, a 1 GiB stripe unit (0x40000000)
and four stripes (4) cause the following div_u64() to raise a divide
error during the first read through the dense layout.

Update u32 to u64 and use div64_u64() instead of div_u64().
stripe_unit is a u32 and stripe_count is limited to 4096, so the
product cannot overflow a u64.

Fixes: cfe7f4120f8b ("NFSv4.1: filelayout i/o helpers")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/filelayout/filelayout.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/filelayout/filelayout.c b/fs/nfs/filelayout/filelayout.c
index 90924129b4e83..0c5b56e346005 100644
--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -55,12 +55,13 @@ static loff_t
 filelayout_get_dense_offset(struct nfs4_filelayout_segment *flseg,
 			    loff_t offset)
 {
-	u32 stripe_width = flseg->stripe_unit * flseg->dsaddr->stripe_count;
+	u64 stripe_width = (u64)flseg->stripe_unit *
+			   flseg->dsaddr->stripe_count;
 	u64 stripe_no;
 	u32 rem;
 
 	offset -= flseg->pattern_offset;
-	stripe_no = div_u64(offset, stripe_width);
+	stripe_no = div64_u64(offset, stripe_width);
 	div_u64_rem(offset, flseg->stripe_unit, &rem);
 
 	return stripe_no * flseg->stripe_unit + rem;
-- 
2.53.0



