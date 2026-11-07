Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060842;
	b=pcWoBbYQtuCO2AvTFqhJSxSrXlbyoMHEPrXqra1MOk6nTXLXvmTcgUVh/mK5ZTtWTbk+
	 cj5ZT+KhlRM/3N5T73D3NYnwRdjqMfbONoHLq//rYyC62EuzGV5KwX80VRxeIMWQ1O9rp
	 jW+1kIqQHsceYpGtmrfq3bqGm+2sKzVmBWdDatuP2wyATOPGD7+VSu5E06F+i44VA0Iem
	 vafzAWq5biBXemEeYLRAdGtYV42dxHID7KWzW+Un2E0e4Uw/VjCydt+V+NHZwi2UcAilx
	 BtZeMHjuB281PHM+oKwlKZjVZfqp3vhDLUu6Ci9Vbj06bguBsgqZIVOfvB5zULkW59Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kZV88CUtB/0El29Bzn/b4nee4LY3BQEFst5wPmiBDDU=;
	b=boXhDO1gISt2DSfTb2rzufHkNlGTVJazVhR4mizD7hM0DgixJ/DWWw0mGGYLCten7Lqg
	 lXL+XYou2UMa/Arm01HaBPDEjUDM8V/b0zmQe4H/CNRRbQ9jbCp80BLhkpqo2AD0YJyUd
	 DREwdJBlLRWzu0cm1kY9ZmqT9DVnEgo8sNITrKbAT/mxkArdTEqNMwS9b6DtqI5FGc3xF
	 wc7jf3+c1qRHUlMx3qF7yDKh1kpAmNp2bkdSFlsVcQ6xmryKJcmtXiPUJ1jgaPRCWCFfL
	 rxclqh2ZpY3FTuzp8i5Km9oLZWgbWyTNIvm6qx24IHTX3XmZgE0jriOk2i7E/MTNxMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sFg6AjuU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B37606A330;
	Sat,  7 Nov 2026 14:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sFg6AjuU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D4B1F0089F;
	Sat,  7 Nov 2026 14:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060841;
	bh=kZV88CUtB/0El29Bzn/b4nee4LY3BQEFst5wPmiBDDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sFg6AjuUljMGUHlvQGDQHP8AJ00BI2S/XfNbg90L4kAnirdoVtv2UCSaqP6dNq5Fc
	 PZpY3q1SGccb4ZzS7C9XO8KcTC9jkr3n2GOr73Fj7VUJTWOZffO6IoFuKMlFGrEAj3
	 +43wnERk5NhSshLKW5GW9z+jAeJzCxbQPOxx+x2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0231/1536] exfat: free new directory cluster if zeroing fails
Date: Sat,  7 Nov 2026 08:37:27 -0500
Message-ID: <20261107135004.158904871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit ce12a39bed483008683438962b3a605374e6f803 ]

exfat_alloc_new_dir() allocates a cluster for a new directory before
zeroing it.  If exfat_zeroed_cluster() fails, the function returns the
error but leaves the allocated cluster in use.

Free the newly allocated cluster before returning the zeroing error.

Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/dir.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index e624fc7c2788b..b34cda85ca7ed 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -329,7 +329,13 @@ int exfat_alloc_new_dir(struct inode *inode, struct exfat_chain *clu)
 	if (ret)
 		return ret;
 
-	return exfat_zeroed_cluster(inode, clu->dir);
+	ret = exfat_zeroed_cluster(inode, clu->dir);
+	if (ret) {
+		exfat_free_cluster(inode, clu);
+		return ret;
+	}
+
+	return 0;
 }
 
 int exfat_calc_num_entries(struct exfat_uni_name *p_uniname)
-- 
2.53.0



