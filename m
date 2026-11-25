Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618599;
	b=Jy7ViAkeu7+AZpqIh9Ru4A6KpPKC/5SYjbqJUnfGBvhofoLuuvkTS2tVhPlRdIEx2Wj/
	 BjuuYuryVWWsJ0s/3djQvmEsJtUl32irw1nxbLSiqCPAOu+Tg2w366xNP8kxwJg1zLrB5
	 cbONcybg+s7OniNU26Rb7BmtEHDh0m3Rj9crOgaL3SL8GPh8IfOQxDEUbaam4Q1vQ70JA
	 PjYeHGurtaj5YLcihequfPMlb22/0xos1p+MtI9GRV0DHFT8H3iDsj6l2V7wNAjuLWFZj
	 kpswkVY22Iw9/8JGiJGoLKfVrILJypFQCcV9JgVUV2rxLHL/UAfn6iGKb4FBFAwNYFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KbJ3/DYu2/w9oksCRgLbYtuBhZsxsacl9MQK28uD0fs=;
	b=QRjTjEx+AOHB1+Ed/Ib7TlwumFcn/XneuXFifaZTipYWkjlKZArusZjFjj8DzaZsrL6p
	 kbW3DL61PSBTroq8zrOyFe+BbU3/UWcXVgNVpGxs1f4/jIHzzqpppnIV1ohX141qjMf5a
	 mjGC0aW+uHAFa/9tX27ulIgaaZDhdVlHcOm+kFVXOkudMkGx8XyjECD0dwM8QkY0VuUkR
	 i+16Gok08VaSu2mRPcXkT6ENYlqQEFcIrJkp36flkCvthA6H0LnubGcS+mvdT9A6D77OV
	 jjm3TrJz9LJ4u2vwcXz8VstjDkpp4FeM4WFYKEVQKWjKvpoUBPL9iXDVw2XSgtXot4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l97npegt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F980606A31E;
	Wed, 25 Nov 2026 14:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l97npegt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEE51F000C6;
	Wed, 25 Nov 2026 14:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618599;
	bh=KbJ3/DYu2/w9oksCRgLbYtuBhZsxsacl9MQK28uD0fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l97npegtp/TGLTO9GInq+ePNzAWRxP6STwJi0OGxuKPtspLVSMLy3u70AZ7Utr1vL
	 BQRETyOFvCB2fo6/KIbQbZDy3sJOvdEQ7y/XVb7dfMINbTAcqnMeUeM/b67wpzdvCY
	 0fgmvOqexb2BHxJemNoYqgzGvWJcxbJHkxO7XS3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0330/1005] libfs: end offset readdir at positions past DIR_OFFSET_EOD
Date: Wed, 25 Nov 2026 15:27:48 +0100
Message-ID: <20261125143829.466065258@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 45eb9737058fa78a73f17a5da55c8cb482c6d5bb ]

offset_dir_llseek() takes any position up to LONG_MAX but
offset_readdir() only skips the walk for DIR_OFFSET_EOD itself. For a
position past it mas_find_rev() starts the walk at the highest offset
in the directory. So an lseek() past the end makes the next
getdents64() return the whole directory again.

Before commit b9b588f22a0c ("libfs: Use d_children list to iterate
simple_offset directories") the walk went up from the position and
found nothing past the end, and dcache_readdir() returns nothing there
either. So only walk for positions below DIR_OFFSET_EOD.

Fixes: b9b588f22a0c ("libfs: Use d_children list to iterate simple_offset directories")
Link: https://patch.msgid.link/20261101-work-libfs-offset_readdir-v2-3-c621125b56d1@kernel.org
Reviewed-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/libfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index fa6cb2b012046..b88a27815a85d 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -518,7 +518,7 @@ static int offset_readdir(struct file *file, struct dir_context *ctx)
 
 	if (!dir_emit_dots(file, ctx))
 		return 0;
-	if (ctx->pos != DIR_OFFSET_EOD)
+	if (ctx->pos < DIR_OFFSET_EOD)
 		offset_iterate_dir(file, ctx);
 	return 0;
 }
-- 
2.53.0



