Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A023118DB2A;
	Wed, 25 Feb 2026 01:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983157; cv=none; b=c03zfwMgi7oeFJ5GqctOEx9uvPjz10/NN8Ldh5sICdK/7W1rg1LlTuGzovuVslTZp8vBUKUjGfEMp+O74S7ebYgZ4TVqYbTBJUt4j98ffeGZNI7NSh7v/NjQLeWngjUErIUpkSnryfv4kX8hjL3jKJWLsxHqHqPtfEW1jJ+cQGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983157; c=relaxed/simple;
	bh=VxmejqpAnFj/o8ykQ8wRUt7QC45hvyW+/1YSMup0MBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8ozeZDxxiMhlMphnHZ+HoEV6tFa/+aS1o4t9ZNmDxOfyvo3YXsA/9fVj2H9LeKvU3JwgcwwJe7l2IEMqK5DVufCLGpTms/vMt3UqF2920dyydqX23eWRkLq8yc+6nZmS3LAKeccLWNYHf3Wkzvo2z3hOepFzfPH8SVV7dtZXd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqxQv3SO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqxQv3SO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6045CC116D0;
	Wed, 25 Feb 2026 01:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983157;
	bh=VxmejqpAnFj/o8ykQ8wRUt7QC45hvyW+/1YSMup0MBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqxQv3SODF1ON6dgsxf0KCeVQO3DZNeOG0xCHN1cVo+/E/+aK823RD9CsBkGOy6Rc
	 tl5lR9KRS8fGyfTsMu2g+8BpJfza1FEQEfJ9bJ5+Dg1i5cKzJj1kPzklTNwRXQnVHj
	 T+DuG2h1jgiKAwuY/GQz9HOqdDZlV00dBo6KXLZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 311/781] ALSA: oss: delete self assignment
Date: Tue, 24 Feb 2026 17:17:00 -0800
Message-ID: <20260225012407.332251491@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit ee1afacc356c84bba4b89e0655ffdcfa84d4f714 ]

No need to assign "uctl" to itself.  Delete it.

Fixes: 55f98ece9939 ("ALSA: oss: Relax __free() variable declarations")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aYXvm2YoV2yRimhk@stanley.mountain
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/oss/mixer_oss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index 69422ab2d8086..8d2d46d03301b 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -792,7 +792,7 @@ static int snd_mixer_oss_get_recsrc2(struct snd_mixer_oss_file *fmixer, unsigned
 	struct snd_ctl_elem_info *uinfo __free(kfree) =
 		kzalloc(sizeof(*uinfo), GFP_KERNEL);
 	struct snd_ctl_elem_value *uctl __free(kfree) =
-		uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
+		kzalloc(sizeof(*uctl), GFP_KERNEL);
 	if (uinfo == NULL || uctl == NULL)
 		return -ENOMEM;
 	guard(rwsem_read)(&card->controls_rwsem);
-- 
2.51.0



