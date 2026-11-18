Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047450;
	b=rObnlxKChUkvkDuHG0k/qqceId41QciAPEp+CSqNNI0iz908pvoDnBLSg+Yl0MStbuRl
	 ZU4FJgMC5kgdj62zxzqKRY7yvNU0Bk6mmIvlfi3Tc8rL4USrnfbzR9dgA34rrnwj5NxpF
	 j4qrLut+jTUTPL4gGMLH4xcs79sEs6sdwXFTFBF73wfafraSskYCV9Vvcu1oqHsK3GA0s
	 9BzuU5f8NjsKO28QTFwdw8HDXaw3DSeWPXsAN5r8Ied0kgiSeCztcuQ0BZlZp6lsrQfaV
	 6ycIOMYm7St1UVKB+pOx5ASl/5xzHMaLM/u3aW95gb3DUBDfPKehnFk9uFXl3ACAjnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nIJjjU6QfaPOwCNIto6nkOoNxi+f0LXlsMdPeu1+8IQ=;
	b=iReYYBSkcGi2npBbUF2KYnqyF9st8uNGHrzWGFsKwuKw78/zDyZ7323gBo2QVcP9+FzN
	 bucsZk1w6AnwECeXBm3UuznRTfexUl935tKh5CWHb0P7lcvj44d6+SfmrQVBbDlyFtFDQ
	 0p+DUxqrpmExBairy0nkhwVXb/Ym9SdsUugbwXPxNeats8SFETQsVjPIS+flNvsIbcTIt
	 quKiXemqWDvi9crCnpfH3PoJtpIQCTeYgyjFPq+fQNLUZxzQXmXki4vqgEJeAUVsbuUWG
	 zRWhqZ6ZYYHIa/25RMFUgyvCanIy04CieKPaczGQ2463QIHiV/VUveS5Q94NWCUTEwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uY3XySKP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C740B606A331;
	Thu, 19 Nov 2026 00:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uY3XySKP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2856A1F000C4;
	Thu, 19 Nov 2026 00:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047450;
	bh=nIJjjU6QfaPOwCNIto6nkOoNxi+f0LXlsMdPeu1+8IQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uY3XySKPicZKDRagnNIkiIIWXkVin4upecBCg9nCsz1xGcNCNdpuSJeepajS0KvJC
	 0x1fSniLinqxc6lLyt1Jf6f4OiphZr38ljNMSTIIvSEvCEr32+HfJPTgS4WVasXHz4
	 VUjcPk22Kkx9ZerHgmqD2SbguYpwJhXWl6lxephU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1602/2857] splice: fsnotify_access(fd)/fsnotify_modify(fd) in vmsplice
Date: Wed, 18 Nov 2026 15:43:56 +0100
Message-ID: <20261118150259.051845628@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>

[ Upstream commit 7f0f1ea069e52d5a16921abd59377a7da6c25149 ]

Same logic applies here: this can fill up the pipe and pollers that rely
on getting IN_MODIFY notifications never wake up.

Fixes: 983652c69199 ("splice: report related fsnotify events")
Link: https://lore.kernel.org/linux-fsdevel/jbyihkyk5dtaohdwjyivambb2gffyjs3dodpofafnkkunxq7bu@jngkdxx65pux/t/#u
Link: https://bugs.debian.org/1039488
Signed-off-by: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
Acked-by: Jan Kara <jack@suse.cz>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Message-Id: <8d9ad5acb9c5c1dd2376a2ff5da6ac3183115389.1688393619.git.nabijaczleweli@nabijaczleweli.xyz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/splice.c b/fs/splice.c
index c6649cd36c21a..cf3d86d90bacc 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1260,6 +1260,9 @@ static long vmsplice_to_user(struct file *file, struct iov_iter *iter,
 		pipe_unlock(pipe);
 	}
 
+	if (ret > 0)
+		fsnotify_access(file);
+
 	return ret;
 }
 
@@ -1287,8 +1290,10 @@ static long vmsplice_to_pipe(struct file *file, struct iov_iter *iter,
 	if (!ret)
 		ret = iter_to_pipe(iter, pipe, buf_flag);
 	pipe_unlock(pipe);
-	if (ret > 0)
+	if (ret > 0) {
 		wakeup_pipe_readers(pipe);
+		fsnotify_modify(file);
+	}
 	return ret;
 }
 
-- 
2.53.0



