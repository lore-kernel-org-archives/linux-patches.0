Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065222;
	b=D4QUXK7ezvhGlKc5D/r1q5I1XtvAa6GyOszNlt+7TzHlbaocu13Li1/o6aKj7Gzlggj6
	 50/lZ8Lw8f4R0cE917P1/AanQ6FRvv8hhK2MsFQ42Sq7y3qOBNW3izVJIGX0Ez6PRUEL+
	 OKdSFzbFfch5lOpt+wwmn5uapPshtK6iLeXEzVxrTNUAQ4GvX7AcqWMF9TqVwZfLwtfji
	 PnEjujH2BolP9+EvqKDNBwFwAJRHKfigO/bCXXW/NscBu2GOmBxHrXficKnCEpZdJU9y/
	 1rQ4S3TEIAq7wM7fOCz2kLRnuJX3pEtCJwSy1bf9XUiJPzbIw5oDTIMMcl3Mv9zxBKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fqToHcLqPbi8CW45dPR9gF7Si2IddeeQzeyHgcVOx40=;
	b=rJVlE4DqtAKBX51xIQEVoBp9H+wpuovxvTKUuJTqcfTJxWGhUSRfNESnObE9dlcxSCQr
	 SwkFUn6EWs0Wdw9taTDe3tyHcK7PqZXyLMu3NnQpMvbRFHTdEw/V4ALYvCSUSPJsEJu3m
	 z2kezUXkXqbb7zgFKg9Le4EuwLM4A2BxyX6ZTfW+JmuMjd2iD4s3ONWdZRAuyx9J4NOvJ
	 BtX7jqcRIN5Rjl+GyPSFGBXpos0LetSwHXz7A8KyXffP3OjbHlNlvkqhVIYNrYuYOnZSC
	 VYdIZDQ1p77VSMbxb+kXHWhj4g0P0/m7SZ2vpYsCfUMfj0etbsZnb1vU9TeiMfgbwdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C3k6EI4D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CAE606D801;
	Sat,  7 Nov 2026 15:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C3k6EI4D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937B01F0089F;
	Sat,  7 Nov 2026 15:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065221;
	bh=fqToHcLqPbi8CW45dPR9gF7Si2IddeeQzeyHgcVOx40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C3k6EI4DLgZ9Sbxh5CCPmld7bh4joxxHfZ8YQmlmLVK0QXTjZP9b/XMosn1lhc3JM
	 Kg61J6pz4IHWRNiP/lEj9yDZXwB1X8/npVrZvln92lgb/GIPB470FMyrGxG2IkqsW8
	 rmCYcZSnDY//2OgeOxj6lUHoepKi8ta6wzVkLQmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Yiqi <yaoyiqi3@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0978/1257] fbcon: Retry rotated font allocation after failure
Date: Sat,  7 Nov 2026 08:54:34 -0500
Message-ID: <20261107135006.370542755@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Yao Yiqi <yaoyiqi3@huawei.com>

[ Upstream commit 7935db1a4a0f83a63590a222500e5016e2f6c85e ]

fbcon_rotate_font() records the font, its geometry and the rotation in
par->rotated before calling font_data_rotate(). If the allocation
fails, the error path clears par->rotated.buf, but the recorded key
already looks up to date, so the next call takes the early-out and
never retries. The rotated putcs/cursor ops keep returning early on
the NULL buffer, and the console stays blank even after memory is
available again.

Also test par->rotated.buf in the early-out, so a failed allocation
is retried on the next call: at the next fbcon_switch(),
fbcon_modechanged() or font change.

Fixes: e4ef723d8975 ("fbcon: Avoid OOB font access if console rotation fails")
Cc: stable@vger.kernel.org
Signed-off-by: Yao Yiqi <yaoyiqi3@huawei.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon_rotate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbcon_rotate.c b/drivers/video/fbdev/core/fbcon_rotate.c
index 660a3fa81baed..7afd63dcee7be 100644
--- a/drivers/video/fbdev/core/fbcon_rotate.c
+++ b/drivers/video/fbdev/core/fbcon_rotate.c
@@ -25,7 +25,8 @@ int fbcon_rotate_font(struct fb_info *info, struct vc_data *vc)
 	    par->rotate == par->rotated.buf_rotate &&
 	    vc->vc_font.width == par->rotated.buf_width &&
 	    vc->vc_font.height == par->rotated.buf_height &&
-	    vc->vc_font.charcount == par->rotated.buf_charcount)
+	    vc->vc_font.charcount == par->rotated.buf_charcount &&
+	    par->rotated.buf)
 		return 0;
 
 	par->rotated.fontdata = par->p->fontdata;
-- 
2.53.0



