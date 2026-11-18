Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043544;
	b=HTAoHO5yjcfNqy1pLsGlq4LNBGFBlOKaPo/i9YLVru6zW/cilu0wyeGPzcx3J7PLlC27
	 ms6QGZW0hb4AI+I4WI36GVPsA847/atlMK0oEPiAJ42qvC8sfP1nqatS5nXojrqM3DnnD
	 IoWZiXX2u+mvQ2XzglxNq38DKSmaoTCsADFHlf5vc41U3jmsIm2xD5ljv8luk4HefHcKN
	 SK2ehkGoewvTXnY9r7k1OFbydVpw8PxNcQBGfMjSppX7hPDW2fhzsBH6WCz4AAvzeG36a
	 3MCPU4DiaeYVipEuFX9ty74ZRaDFWMwy/IWJWncZmazSvV3oub63ayKGQJvFPQCF/sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y3k/yFk24kuaOG0sMfxmAtMpka/qw7eQZ8IkD47hplw=;
	b=4r/AB7GK1k0vdr/+qDN1vqTR8kvZGIC4079AewvFsH+eq6XNlgpVeIRObxhh8POeFdf8
	 4WDECGpD2wesN1r9BPlOvPpRoCk9ew3+EhefcVW+AZ5eb1V4kaRcAswL9TSYoLYSJ1pgS
	 waZY3abXAmKH8FYMDoE9gfd1LT+zyJRkkywgbBrBdZuEFzLceU84BRO6OTKKeWmg7lhZp
	 QOWVyv4wDoQeUuGsrzv2TgzGe558Xkuqzcm/2Yvi5m2+lyX5WKtbMyw5SRD+LgBxIelDB
	 T2hHBZ9UIo8J9zsb6w04UCDafMe8BNds3HnJCC1gZmc6KqyoMXnJ6eyLhfwn2Y2897g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ps7yIOxi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E107606A31C;
	Wed, 18 Nov 2026 23:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ps7yIOxi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6A01F000C4;
	Wed, 18 Nov 2026 23:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043544;
	bh=y3k/yFk24kuaOG0sMfxmAtMpka/qw7eQZ8IkD47hplw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ps7yIOxi5uACE6R024e4B2cekwTzqtv5Jmo6ID06GtqT/POZLGSRkAKVOtYNATNtZ
	 oM2C9fBcKRaed7fyyNuq3lFybg0DfhnTnDPdoZ4qnkOtLDEbmmQZysdnaYwEJLUJrk
	 zfYVdbcLfv19aHeMMVAnUxMNIR3H5WdV26T4gqvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0249/2857] ksmbd: allow FSCTL_SET_SPARSE without input buffer
Date: Wed, 18 Nov 2026 15:21:23 +0100
Message-ID: <20261118150210.408062166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 86c84cc760080929b7be44bceebe5854957b99da ]

FSCTL_SET_SPARSE without an input buffer sets a file sparse.  Treat a
zero-length input buffer as SetSparse=true and keep rejecting truncated
non-empty buffers.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 0ad2e442e78eb..2b5adba9c25a8 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8105,15 +8105,21 @@ int smb2_ioctl(struct ksmbd_work *work)
 				rsp);
 		break;
 	case FSCTL_SET_SPARSE:
-		if (in_buf_len < sizeof(struct file_sparse)) {
+	{
+		struct file_sparse sparse = {0};
+
+		if (in_buf_len && in_buf_len < sizeof(struct file_sparse)) {
 			ret = -EINVAL;
 			goto out;
 		}
 
-		ret = fsctl_set_sparse(work, id, (struct file_sparse *)buffer);
+		*(u8 *)&sparse = 1;
+		ret = fsctl_set_sparse(work, id, in_buf_len ?
+				       (struct file_sparse *)buffer : &sparse);
 		if (ret < 0)
 			goto out;
 		break;
+	}
 	case FSCTL_SET_ZERO_DATA:
 	{
 		struct file_zero_data_information *zero_data;
-- 
2.53.0



