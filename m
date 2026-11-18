Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059897;
	b=BDUnsqZv6YBvYyl3Q64no8nK2SeppZLFxmxMiWxEHkw+MQhbXSUtvwBdR0S8R7R+m95g
	 zTNgmMf77khVY+eKs0YpuktoCEdRao89k+GOyxOcBPL0B0q2lpvCuVn+3NiFncjO9keaq
	 NlMuI0WE7N4V9H/xeEDMmDDdwG8WBmlXsqF8ZflDrTEHp4bUiEhsAFGDHn+cx1gWboVvJ
	 V9aCLxqFAgy+QOKTbyzksIuV92LB64cCPduWa5GnWnU+3S3LAXzlqIuCTKdN/GJRwI1ex
	 eV+4a/ZDp5HdVdm/8jAEkdQGw1b8vwHTbZ5O5UqECbVFp36vhYIooLIWYh6gwYAot4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=I+Yoi/UHYWZ9h9iyzmOQtUwFEvirx7BnB04Sy1Kh9hQ=;
	b=vus6heXJ1PkcJw7JNRSFhSTpuP+j+p2k5KJctc/GAKLUNamqwzvHbOYX3+AK9bW7WJuU
	 nYbFiBLq2IMw7b2NMe6T3EAfJh7XVvb6Ad1tZKeyHwQ2T8T2l2zLgyry7qMBdguK9bZOv
	 PmPevuUbsNtyv5wN3cWsw1/Vcgz+/3KwyJ09U0hxLXpQXgQNk+ac3QlwHZDu4O2TmcVPe
	 RBXAGv8VS7Sxl72evX8GN7c0CdhaKysE3IaX8D1bBXS1ZU+dX0mfX1dnPMDfvdt6K/2L7
	 GRcb+1Nu8MLSV0QqOj55nwukoTlJ7Zxp4KvuUEgFnRs8syPps2iP8cIJtcW2uR5MFgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SqQ4k1UL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051C5606A325;
	Thu, 19 Nov 2026 03:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SqQ4k1UL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BF91F000C4;
	Thu, 19 Nov 2026 03:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059896;
	bh=I+Yoi/UHYWZ9h9iyzmOQtUwFEvirx7BnB04Sy1Kh9hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SqQ4k1ULaxtFIMs87LYfkDSXlqBEU1NKLTXQa9R2JeNVn8Ko9yZ4ijMjjHc4671pX
	 cCEwIEz2oHFkfxCuyfzmi/fg+sHuLUSuSFNZqO4GUD2ILUDvrxLoNz0yuV+9s1rnAF
	 5Ga7tME92WqfWr1+Ofi5TQD0+ztMt+XJnYbYcUY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1004/1848] splice: fsnotify_access(in), fsnotify_modify(out) on success in tee
Date: Wed, 18 Nov 2026 15:50:42 +0100
Message-ID: <20261118145958.818463943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 300302969fb34..99917963118af 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1698,6 +1698,11 @@ long do_tee(struct file *in, struct file *out, size_t len, unsigned int flags)
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



