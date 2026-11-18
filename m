Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059899;
	b=aSrlCjVLqsaoLPa9PYgzzuDtCZDf03A3xcNqAcRxdEh9m5FZD51zjncQ0FML9C6JSOVm
	 ZtsmriIjOKlEhuDVa9c1xhzV+4mIyg1enPILThfD/98x59oRMdJFp+B0T3PlBGCy6WaO9
	 DTEZLpDBhS+TMt7w/7JwBoi46AsMFF0Z9KJDdLe4+Q7a7gQYkNez5L31k4g9Dqov+m83y
	 c9uhMININhv4e7ZbdDdqF++vzM2dvSQpNBb3P89nB4Uwc/p3/Rw+i8GV45t2Ks8JyN44q
	 4BAGL3kbZQswlaEclIrNYULO2gACzUmPF0J/e2FHwoFajyAgJzp61uOTxjwuBcr73Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Ym+3XyBQkQeHE+7SFU1U67nPbmRCq06KzEYbal/EkcY=;
	b=UVgd4dt6DqaJBGJ59aVPprugFwElCraFNewAfGRSx0Q60m5K/9wa1qGRF4mOca+vSRek
	 3eeOitxDkjJmn8CVQ6w2+NGZLOljY+k40GoMDg0fEr/DxvPjI5Y5ieSgASLybG9m9gDi8
	 4Iy2ikEVavI06Rpq7s/bm/h+9MTl2/IYl9zgva1ynJA25/oE1MlVl1mKkNv506ZlCED09
	 UyO0UQkpQ7bBovjaTl78yCEJHsP0ZxeqUrRI1Sfc5qdAJG7ZT1jp2nmTWErlb+L7ZPrwO
	 DwdSO8Yzp7C7CRRn7OJ30niN/ACXrhX92IQOjcaGtDi1JREG6TZyLrAHsROK8bZWdUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+aMnEKl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CB6606A320;
	Thu, 19 Nov 2026 03:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+aMnEKl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD88D1F000C4;
	Thu, 19 Nov 2026 03:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059899;
	bh=Ym+3XyBQkQeHE+7SFU1U67nPbmRCq06KzEYbal/EkcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+aMnEKlifhdm+cmL65UfLtUJU7t/m0ZI/tO+PYUPqk/sSDRI6XanUYK4wtSrsLb8
	 YD9GFBfHwsVBwobJcARPt+OimFpV+/gy1vwYfuKdAgei0I0xCmYX7D1tHFY7abfoXn
	 HjldEd7heVR++7t7OraAK8yk7XKoUdlkaRDYdxj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1005/1848] splice: fsnotify_access(fd)/fsnotify_modify(fd) in vmsplice
Date: Wed, 18 Nov 2026 15:50:43 +0100
Message-ID: <20261118145958.856054478@linuxfoundation.org>
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
index 99917963118af..30502e226cad7 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1236,6 +1236,9 @@ static long vmsplice_to_user(struct file *file, struct iov_iter *iter,
 		pipe_unlock(pipe);
 	}
 
+	if (ret > 0)
+		fsnotify_access(file);
+
 	return ret;
 }
 
@@ -1263,8 +1266,10 @@ static long vmsplice_to_pipe(struct file *file, struct iov_iter *iter,
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



