Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059669;
	b=jlDb7kmBchYJ2nRKn/bXyBidrzEe0yoqfhr5vcKbB8klfa9YrtF+G5Jwzn6rcqUvcNdw
	 wmGfAlr236I9V75MARRAne8NKebbMz1PSA7VRstxkEof+AQK41RIBd3WTSCiiXIuN4XoY
	 0PkvOtX0hp/SUH5O10t9QQho3Z7NaKIy6cTF7bY9963rnhbiAU1hDGtSnMTLPqyKoGqAz
	 krwHm6AwkYTejEgTpiW36ZJOLlAxIVvTEzUFJ2NVS9NF5yKvo6dWIz9ZgqBdBUZVFD5ac
	 txbJHQzr4rSWrkseWN1CVMq0ZORYX0cabsoDfcrwJ6aQr81FFAAwQgIqcpb6q4Eqn8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4hagmGjD6dFG7xxEkxa1wbEy3oLcIRcLOLeG74NObS4=;
	b=lgZeIHJUtgYb/O02GVTGSDrw66ZGpNdbguqxxEq0UZ6Ew/+yBeC45ZRDF0K1DcdleGjm
	 s7ZQY70QMuo6ECpRXHlwZ6GWyUFfD8o5E8yN6l1QHFuYEuZLFwwGNjQ7VSYVKg7kwpPpC
	 DroRrBbtrPplxTawPDb2oYY1HhuGGlIjjf2oIZzW1Lz2JePJMEE/dQsGKUoQ9iijVilIp
	 qRj44ZBZHzPoSQg770T75Dm97AA4ArbAnUrbEK1L9lDPIo0UnNN8eb/pYUXs2yp/TWTUO
	 1bOW9L6ZnnBAiwdKqI+lDqNkYyIEQAYlLwXNJCSE8FZEIRgqGSLTB5fQ6CXQgFrzAMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ufda8ns9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCFE606A325;
	Thu, 19 Nov 2026 03:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ufda8ns9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEA11F000C4;
	Thu, 19 Nov 2026 03:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059669;
	bh=4hagmGjD6dFG7xxEkxa1wbEy3oLcIRcLOLeG74NObS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ufda8ns9551jYr4WqMfYgXRcsOVwcN/IoJAhrnL2gd0Yt7DGKvwTnESArDTHcXwP0
	 RYtlQiCak3G7oGtGzfpryfCVokeNuGvnNmwwslkKUvdoKawzwK2oeHRKn9Q09aKTUA
	 0ErDPUu5k3QXp/x4ZKWrdeENzK4VZB5qjIapifBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Yiqi <yaoyiqi3@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0923/1848] fbcon: Retry rotated font allocation after failure
Date: Wed, 18 Nov 2026 15:49:21 +0100
Message-ID: <20261118145955.446575336@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted the par->rotated.buf check to use ops->fontbuffer. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon_rotate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbcon_rotate.c b/drivers/video/fbdev/core/fbcon_rotate.c
index c1beb4a837081..d5ef2babc2bc8 100644
--- a/drivers/video/fbdev/core/fbcon_rotate.c
+++ b/drivers/video/fbdev/core/fbcon_rotate.c
@@ -27,7 +27,8 @@ static int fbcon_rotate_font(struct fb_info *info, struct vc_data *vc)
 	u8 *dst;
 
 	if (vc->vc_font.data == ops->fontdata &&
-	    ops->p->con_rotate == ops->cur_rotate)
+	    ops->p->con_rotate == ops->cur_rotate &&
+	    ops->fontbuffer)
 		goto finished;
 
 	src = ops->fontdata = vc->vc_font.data;
-- 
2.53.0



