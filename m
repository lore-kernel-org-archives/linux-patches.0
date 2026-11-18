Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054230;
	b=QZo1dLyX6Kih+KqNtB8soWkA49ZRVIMOT1Lm5r9vsy2/XSFRtrla9D7WrNTkyOHL70hU
	 aTBHyTJ1dinCzJ1Cxed7wuKF1lZm33tVNE3wYcVgpipazG7h+cbypTTHXuElwruMasElD
	 BWmLSkoA/xBZiy+cH075Z7/p1KsCRwvIq9DSLD4FH2gwOukbkaWZSaopHJ9L0YyjK72ac
	 h3WCkyc7H3F5LeXCcXf0rhshDWL2AWi+oab46MsVCzLUT7f7Ls9i9qDdbEFYNL4+q2OB9
	 x4sh8YcpLa4Uaoi4iODKv+DX/isma1/yGXgiGBawRczAKK7agZjFjSvmkwTnfO72zgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=OUayZXscP16yzjJj0cty8Zwt90B0/TZJtsgOROENjiQ=;
	b=UlQlp32wEre9wuT63ErBWoA31MYmdDlfWu04rUaHEhZkIqPb6lItIhWVYMDIX1+y+Cj2
	 JJPT6gh63gHfBJv0PZ2cMGvvR+gvi09OZkKlSur/D9y7vu7tv13U/DvYbijhbdWVOx2do
	 vln6YtwKW7235bGLko2XrdMThD8G4BEhiEKGRVDn9EasnPHXX27tQ2sVMEQwj6TpEiO0D
	 w72RLMDzmfdhg7RoWMPsNqYsi1pXpHEjR4yDv5MBcsMaf1J8mOjmQ2ivsnzAG1VCfVtHF
	 jnMvYO6eT5NxmVaRZq+mOSO21Hz5lRlpjbRMuDC6ECOU9IBmzowMnikBukxaZi9Iz5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=twWAySIS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FC2606A325;
	Thu, 19 Nov 2026 02:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=twWAySIS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56771F000C4;
	Thu, 19 Nov 2026 02:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054230;
	bh=OUayZXscP16yzjJj0cty8Zwt90B0/TZJtsgOROENjiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=twWAySISz1O6D9SBvdo4hxPrHul37gTt1DS+WktGTvqn6YFMJFEOq0Iw2oBlu2pv9
	 LBaub7l+8BIOhbdhezaWEdLwkA+hhZriIgmlHv3nw6XNNCBs7LNDYLdCVJiicPZjO9
	 J1creohetpErKG5vVSLkAYVIXwPrM4q+AL7H3wFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1199/2214] splice: fsnotify_access(fd)/fsnotify_modify(fd) in vmsplice
Date: Wed, 18 Nov 2026 15:47:55 +0100
Message-ID: <20261118150059.839142448@linuxfoundation.org>
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
index 1f4ed40a369df..4c18d161cfa8c 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1265,6 +1265,9 @@ static long vmsplice_to_user(struct file *file, struct iov_iter *iter,
 		pipe_unlock(pipe);
 	}
 
+	if (ret > 0)
+		fsnotify_access(file);
+
 	return ret;
 }
 
@@ -1292,8 +1295,10 @@ static long vmsplice_to_pipe(struct file *file, struct iov_iter *iter,
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



