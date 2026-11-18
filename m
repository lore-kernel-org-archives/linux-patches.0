Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054227;
	b=KfC7w4Kx0ckrJHfEpTY0jqUr0Hn0C/gZMJqIC9U+irI/VY2fIlpgNxH/mugKz0Lwrm9l
	 K/EVclOJtKQKgJMcxBPXw+YIBVg21DM0YsbHSX1mjoE5XgWBTObGDQV1UqqGRYrUWtbro
	 DLwFVUdKzuDXiqGrzxKLKTjupK3eY4MieyB4FDI5kfaaJehZ3J+6+PX0P2FqXX/9G9qUk
	 yr1/rBsMCV7GueBEINFFEDoPbqTjaih3d3LG/JdmrRZfJoLqirk18eNBAsJiHwwqQ4RDm
	 R0GCmh5TnJN6DkhFGXnuo9Ffmr8VCzDf5wuaYXKu3B23rNzA8GyT9ZLHJAJhSSc2KUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FYk5QrV9oTRvsSx/mfUsOy0awBUrVUklMkcB9Tf11K4=;
	b=zZBL+l5yY/eLA/8aQ9QksLUehRh2+O1FISuocjVUkbxKVGOqJazJoBovNEtyRwHibCpk
	 TiXSabe2af5yPg9MDGmFnUhHzhJuvXkuq5fQVBY+vu4zUV3LXklKTBfgqVfCaP6nmTs4j
	 neJQNa5HgShW+YHSX8ejd/zqg8wVWndeFx4ojx7wXkllWW9k+YSpXcvBtNPSf2PNQ0MF5
	 xfEgM4ae5Il/IvryEzvDg6W++DDq5Ae8fXsBiunI99zf3gebD+X8mLDwKHdVxLPCUqaLc
	 CaR324m1nCnZENbCDtvibP6J1+GsDRkQwBIdH4LqjD7pTImKTuQdjP7e2bvILxcvPrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P3Y/sMLI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EF2606A330;
	Thu, 19 Nov 2026 02:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P3Y/sMLI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0558D1F000C4;
	Thu, 19 Nov 2026 02:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054227;
	bh=FYk5QrV9oTRvsSx/mfUsOy0awBUrVUklMkcB9Tf11K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P3Y/sMLIxKoxCnAkvJkU9jnuoPF6103R5cPwdzsQH2aN6UuvDENl5Ltl/DCnr09NH
	 6T3ocp46gyxB7NxZWJU5hbZ2gzecz7YY6t4y8KT6StQ0ziwxqlC81Pcr/LHdZUZlrq
	 wfo9DVG+LWC9lMOJ4MDajBSPEMnIS0CPKITUYkBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1198/2214] splice: fsnotify_access(in), fsnotify_modify(out) on success in tee
Date: Wed, 18 Nov 2026 15:47:54 +0100
Message-ID: <20261118150059.803712266@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>

[ Upstream commit 576d498e0ac5caff2d9f6312573ab54d98f12d32 ]

Same logic applies here: this can fill up the pipe, and pollers that rely
on getting IN_MODIFY notifications never wake up.

Fixes: 983652c69199 ("splice: report related fsnotify events")
Link: https://lore.kernel.org/linux-fsdevel/jbyihkyk5dtaohdwjyivambb2gffyjs3dodpofafnkkunxq7bu@jngkdxx65pux/t/#u
Link: https://bugs.debian.org/1039488
Signed-off-by: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
Acked-by: Jan Kara <jack@suse.cz>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Message-Id: <10d76dd8c85017ae3cd047c9b9a32e26daefdaa2.1688393619.git.nabijaczleweli@nabijaczleweli.xyz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/splice.c b/fs/splice.c
index 3630fd18a12e8..1f4ed40a369df 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1727,6 +1727,11 @@ long do_tee(struct file *in, struct file *out, size_t len, unsigned int flags)
 		}
 	}
 
+	if (ret > 0) {
+		fsnotify_access(in);
+		fsnotify_modify(out);
+	}
+
 	return ret;
 }
 
-- 
2.53.0



