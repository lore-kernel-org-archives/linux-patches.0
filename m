Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043309;
	b=WxGaft12Ki8zUg/AMptNUWpI8r5ExBdRF00z+DMSPpxGPKVEsTbEZMfA9v2JeqwHKMjX
	 6w+27x5crXyTFJU7k5RvNh5OZfB3YO5bRhM21A+U5JRthtApSQdO2flhVPwMdPbceN0dJ
	 8gFgo4sVW+bDWgV6xstKM+l98BjsKOJl0z6caNnVv8U6UEBiM8qlXvcLMwNi5RB8htJjB
	 ByfQywplVCZXj01mBeIjD0X+o+Vqt9RtOHAQsGkTjOCk7It3MqIBy9ExI1a2ube/clpMA
	 WDC230fiuiLlnHNJnOvuI3dC13CcB8sjPQ78f+XdGk7LYWjwNi7IPNLb7QEhW09p/Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jYMNG3ZvxH3wzGcp1g9In/VhOwjHrJP8Lcn0XL1eBQg=;
	b=Ze5DhLySTdI5Czd1tOyd8l1VEIHE3mBX7PQ3D//2/jWganFPk5xBAbErMQvMTGy4oRb8
	 qsu54h+ElE00kLEw+haMvHwZ6fkLOYZL1ULG2EzY34ENt01Abplx82Um/0/DaarY69N4g
	 fgtnbNxlX8vw9XGvu0szfTjEhuvGiNSgMaxx8wG1Dw+9Mjou53T0btambP+yEveLBw6lI
	 suxOe24hHsrfHfuDNNBrFw3Dtdw/oYKcMjepZk+SyW05TKYp+CSrcPQj6IlTpK+/L2L7a
	 4kwADMjRvoQu5BYsFepQGaIUaLqmE2qw2Pya89mUS1mlqwhs7HP9koRvS4nscMX0awA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQcnLjCr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C36606A320;
	Wed, 18 Nov 2026 23:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQcnLjCr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BCA1F000C4;
	Wed, 18 Nov 2026 23:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043309;
	bh=jYMNG3ZvxH3wzGcp1g9In/VhOwjHrJP8Lcn0XL1eBQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQcnLjCr0YjdY/uU+33scagstqDI7Em+dDwsFiLjbkNLbH0VUC7lA7Z/OMrgI/q4+
	 GGFwzJ42iWkuQ/7l0wZ25w23w0yqj549nMhb1nZOowD36uJivZEZdsNI2HZbGLiDF9
	 2D2+0EJQIbeGilFZU5kEq+AOkKx50uzpvzbyA2TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0166/2857] exfat: free new directory cluster if zeroing fails
Date: Wed, 18 Nov 2026 15:20:00 +0100
Message-ID: <20261118150207.332863092@linuxfoundation.org>
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
index d8c789d768076..f95c0c623e974 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -324,7 +324,13 @@ int exfat_alloc_new_dir(struct inode *inode, struct exfat_chain *clu)
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



