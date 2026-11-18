Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017235;
	b=xocOZJ7qDbapKzgzYn6Hl7k+ny4FHjjQX8SrFIBlv7ZDOFbxcN79YCbamg/5YUJMhfl1
	 3ICHXrIrzkowYC/kREY3V4kE3zgoIFSheuzH2EqGjJ1vyJ3bs3FzUh9xhQ9SfJ9TDQlGd
	 QMUimVgqEb6+oaRnbMMCq0FkKMyAVZUKC6jpBkvZGJKQnvTN3CF4p6GZcOZQ4wKl6P6ad
	 WqZu0vp9VT9jFV1dlQJM79Ic1q6KE4d6iiDwkjdUc7lZKZ7XvC3cCJ16clDHOvf2dA8w9
	 NWyIj9dAaKm0ISDY9wXnva0HwpDLyFcbL8RIVXjk4zd0KTyL27f3VnL6MwvePzni/Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h0wgRijA3IfuGbx/d9zkXSSkpcTdTppgiUUMyOnfH8E=;
	b=IAjJsqnFfZ2POVX3CqgymcZQqVEt9LfzGIW076ieBqdjlrqDr0P8vr13E4PRXkRscOMe
	 7OKRi2IDMqedg//pxC5RyD53oMMUkoQLXMlisNfYnNt6P/VaJqmrNhCefYm8aFV85aaOo
	 CiJa7lGqK42MtbgkhiUqR13SpDBBdccmtJfi8+QbRWYpJvIl0xjh6brud5iWobwrAttx+
	 XEH+s3+4UhPR7lGGsuMG4bImyRaVHlAk6Q2bxzfIObe9T/o0qL5oZ7EpPmeMuXOlucIXs
	 IZLXTVYTwIHEifkGfHSQ6iyzET+ntV+LO5og7CgTA5l+tMAYcbQqRwuyqTWnvI7oQ0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dhmqnxzf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79C2606A325;
	Wed, 18 Nov 2026 15:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dhmqnxzf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F101F000C5;
	Wed, 18 Nov 2026 15:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017235;
	bh=h0wgRijA3IfuGbx/d9zkXSSkpcTdTppgiUUMyOnfH8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DhmqnxzfMTgUukDZYwXSs+qcj5PYuqgz8goLPWLpxglwE33Pi9884Mb/d3Au6tnoX
	 egtmYY5tf19VqmoxQPFc0fK3DUE5QFUUHUq9gFuWTlawRADWYx5EQ2EyYQ8meZxBHY
	 eN9KtOHYI72jBtQqhPrh6BpQz/K+cU0zGfaOi9GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0811/2651] ASoC: fsl_asrc_m2m: fix pm_runtime usage counter leak on error
Date: Wed, 18 Nov 2026 15:34:11 +0100
Message-ID: <20261118150317.094075094@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 5626653a4bdf32812d66b970860677cd9d7a2190 ]

pm_runtime_get_sync() leaves the runtime PM usage counter incremented even
when it fails, but the error path in fsl_asrc_m2m_comp_open() does not
call pm_runtime_put_noidle() to balance it, leaking a reference each
time resume fails.

Use pm_runtime_resume_and_get() instead, which automatically drops the
usage counter on failure, fixing the leak.

Fixes: 24a01710f627 ("ASoC: fsl_asrc_m2m: Add memory to memory function")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260917121136.32527-1-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_asrc_m2m.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_asrc_m2m.c b/sound/soc/fsl/fsl_asrc_m2m.c
index 4bc40f328f587..8bd2a144dbf91 100644
--- a/sound/soc/fsl/fsl_asrc_m2m.c
+++ b/sound/soc/fsl/fsl_asrc_m2m.c
@@ -320,7 +320,7 @@ static int fsl_asrc_m2m_comp_open(struct snd_compr_stream *stream)
 	if (ret)
 		goto error_alloc_out_buf;
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to power up asrc\n");
 		goto err_pm_runtime;
-- 
2.53.0



