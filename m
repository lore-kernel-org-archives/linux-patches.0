Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB612BB1B;
	Fri, 15 Nov 2024 06:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653740; cv=none; b=o49t6+Jy56ku/VIbtE5ZLF3bgy0350I9CUIlwG5eE9vtQF2tijjJ4rfWUxUzvs47yEhKMp17Fsq/mUwOjOrvj6ZVOBKU1HrFYWPhzGoPReGfwp06BPvwe9gNGKLw4v4FAbjNTpyVlebDp8oEToYb/rISDaqHAfAvzj4NvzGK/lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653740; c=relaxed/simple;
	bh=EQYkC7XbndxLbezf3BC4RvOElCJuyt0/FMGYPAst+Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbffXKupRkO1cTR9whG7YPKbeBxKBjzfBRCSFSf3McCjIimFKEt2uSrZdPn6g8Gmyp23gOWTA9J2I1KN2zuEk/GosH7PKqC6y5frMloZ9gcn0JXS4gg9sS2zN5FXwIvgWUnI3anz23ql+KyZ6R7B5mNZW0LeusxFSw0wuGTuJwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJb9wiVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJb9wiVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F6BC4CECF;
	Fri, 15 Nov 2024 06:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653740;
	bh=EQYkC7XbndxLbezf3BC4RvOElCJuyt0/FMGYPAst+Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJb9wiVoldwztm2kJTrfALfwH9Q1yorxsGFefhCXU/O5d8G6vsSTymdJYIj1GeTk2
	 Ch14rUjUUP7HH8PjT/wHeeSwHj8O9BDijFI9ZEyIZvbwHwxuxcgTsm8Bb8QlwudU2J
	 dtkLRcFgIQPlJt1o+CSfeFyAzdqI+bYO8LsVs6uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 22/82] media: stb0899_algo: initialize cfr before using it
Date: Fri, 15 Nov 2024 07:37:59 +0100
Message-ID: <20241115063726.365191818@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit 2d861977e7314f00bf27d0db17c11ff5e85e609a upstream.

The loop at stb0899_search_carrier() starts with a random
value for cfr, as reported by Coverity.

Initialize it to zero, just like stb0899_dvbs_algo() to ensure
that carrier search won't bail out.

Fixes: 8bd135bab91f ("V4L/DVB (9375): Add STB0899 support")
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/stb0899_algo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb-frontends/stb0899_algo.c
+++ b/drivers/media/dvb-frontends/stb0899_algo.c
@@ -269,7 +269,7 @@ static enum stb0899_status stb0899_searc
 
 	short int derot_freq = 0, last_derot_freq = 0, derot_limit, next_loop = 3;
 	int index = 0;
-	u8 cfr[2];
+	u8 cfr[2] = {0};
 	u8 reg;
 
 	internal->status = NOCARRIER;


