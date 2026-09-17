Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D379D4F7CA4;
	Thu, 17 Sep 2026 16:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663926; cv=none; b=bCwFTHY71aJPeLcluSEFQ/fBY1iG+jsEdRpa0mQEDIjv9SsS8S/VTf88k+icGsJqoTRlzoqV77yhYYVzJ/E6GOoNfepwy5FQQaK1bSGffk/Uo0W0IxXBUpL+LKcuOUaXIeOBu/jAhtyO1nGKgjIZMWgkDGXahCnW9/USHFIpkDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663926; c=relaxed/simple;
	bh=eBYujbaqIGPM/PqG/CoR8Ivm3LU7q1K3qWeUsx/UnV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HaM4jlSKtGzJLRBpYsEgTtE0crSdSdxD5yizqAaKlZ1h6ph5DB48+xCDQLpUalq+riBcJa69PM571BItIzQvF3EXvVXKTz9UnHC13Qs9irAtglIThO7AHa7iri5ArrNLTLUst34m3uFGDYQWaYuwnN/FR0t9HKFSNcdSUukOn9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zb0Ri70t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zb0Ri70t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB341F000FF;
	Thu, 17 Sep 2026 16:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663924;
	bh=SKW7zO+T8QC0zYXj/3mu6SYs5cp3pIXEjN+9tTrgyJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zb0Ri70t/ZlU7Ddh4kZv+aBNqgr0MkqCDFukCFrblkhSBJl11qbjxoC7zYl9E/8Ur
	 fO9MlN/Jl1B3RsNd7ovOzHw3tNB3x+/gs04IBa2dkvki7XjBnfBPuZS+6/d1VqFo6G
	 NFTwA5V9RsHqtuEEFnSPfHYSm9AfZhoLo3rlA9dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiji Yang <yangshiji66@outlook.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0199/1250] pwm: mediatek: set mt7628 pwm45_fixup flag to false
Date: Thu, 17 Sep 2026 15:59:54 +0100
Message-ID: <20260917151557.512398804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiji Yang <yangshiji66@outlook.com>

[ Upstream commit 88c6c956fa310117638e41d4831b20074dfff2ba ]

According to the programing guide, mt7628 has generic register layout
like most other hardware revisions. We should not set pwm45_fixup flag
for it.

Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
Link: https://patch.msgid.link/OS7PR01MB13602B3C7E43A2E38275C73AEBC74A@OS7PR01MB13602.jpnprd01.prod.outlook.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-mediatek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-mediatek.c b/drivers/pwm/pwm-mediatek.c
index 4291072a13a7f..e87feda2e7831 100644
--- a/drivers/pwm/pwm-mediatek.c
+++ b/drivers/pwm/pwm-mediatek.c
@@ -458,7 +458,7 @@ static const struct pwm_mediatek_of_data mt7623_pwm_data = {
 
 static const struct pwm_mediatek_of_data mt7628_pwm_data = {
 	.num_pwms = 4,
-	.pwm45_fixup = true,
+	.pwm45_fixup = false,
 	.chanreg_base = 0x10,
 	.chanreg_width = 0x40,
 };
-- 
2.53.0



