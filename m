Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829692;
	b=WlLbVWghHH6cDxwAMRZ82VpLyhW7rpKPm7O+xxeDvN0Iuog2wW5RyVbQ9WkINSyf8G0R
	 jJVrbF2pFRxPGyzzdWNBHQgDqz5nWOL/lDs2Ykfo1UjzEyawXQdG6j4sOae5Q/hU+2gCK
	 IFKtt3aJJtR/PpIEn3ThdaLHEDtbAb9mTg3qRqj9PH1jFN9h8gyrceYKkzre9lCAoU+ca
	 qMUzIPKEZaOYgPxkh8Q1Z//KRgUxfAHlwYHJtLkBZwldtmNyyclhTKpiA0gZ7aKUTgxPQ
	 huZIZ8xedeyLgI//pQvFGMfNxHwypzHW1sNF6oSTcXZLJiDOTyZH8WgiQIgkksMB4Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S0OhB79JNe5Yy4em+1360slUSWQNrWWI7iopzGVt3nk=;
	b=0nGsCa7IZfbkqd79INoF6763ftTX0qRHFNFXsjaWexPVxSe7EVOidqy2sb6i2z0V4x0C
	 7LTrd0b1ho6IMYQHU0cp5SBMLdjJJ59zEkWWs5spd8ruHawNVH7mwSPI/RX33aNL1l623
	 UDFBpzCE7tAaIv2vcHircnpmnlFvDJxEJ+Ydwu2bn/q0IOlR0kxFBF2RAeFvXi+YP+DJX
	 puknCbYenp9KTUsSjikk8E6iLN5Nm7lCV5/zpL61LXw9/CuUdPmPqoPw29qPxdpvZFelt
	 cwhsTPe57J98VbtUI19ZKsofY5aisxcq62ypBQUKcxAekQFrh2YJ6tHfSALTGYRLVLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2HBksPux;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9173F606BA30;
	Wed,  4 Nov 2026 22:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2HBksPux
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1EC81F00919;
	Wed,  4 Nov 2026 22:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829692;
	bh=S0OhB79JNe5Yy4em+1360slUSWQNrWWI7iopzGVt3nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2HBksPuxzSQyf0Ssasu15yuV2+Ct5cuYzKPc5ITNObNOv+Kt2EWk97kZ10oEvgPnT
	 PlgiLavI9OZz5W86I++ObP0VTvz3y4eDHCvyVv0dawRzcaKmtWujfg3oG1QPdCIyhx
	 /lz3Fj0n2PDmnBBGu3dS85WlQkmxHH7QPP2lY3kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0283/1005] exfat: free new directory cluster if zeroing fails
Date: Wed,  4 Nov 2026 16:00:16 -0500
Message-ID: <20261104211051.822667083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1f6cb533a48d1..d82b48722ef76 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -310,7 +310,13 @@ int exfat_alloc_new_dir(struct inode *inode, struct exfat_chain *clu)
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



