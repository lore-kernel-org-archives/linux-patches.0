Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7359A15CAB
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6064C433C1;
	Tue,  8 Nov 2022 13:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915337;
	bh=6ImvMZXhEhgyWhlAeBArjonfP1CNJg7qSdSHO26xB90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwQFEgajhoGvCJCRgXQXooSDpgUO0NgguR/kO/GgiZjIe1YY+1K2+cEhb0PIIJL8i
	 v/tLKS2uFdraXJrg2X9D4NY6juajVV6LkO6ZJDgKF7jKx/74NHm3rYjHGUDWr3r+T+
	 U42b7tfhRw5XodRMZzbYptI4PXhjYn7nu8ITdj0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/74] media: dvb-frontends/drxk: initialize err to 0
Date: Tue,  8 Nov 2022 14:39:00 +0100
Message-Id: <20221108133335.041652995@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 20694e96ca089ce6693c2348f8f628ee621e4e74 ]

Fix a compiler warning:

drivers/media/dvb-frontends/drxk_hard.c: In function 'drxk_read_ucblocks':
drivers/media/dvb-frontends/drxk_hard.c:6673:21: warning: 'err' may be used uninitialized [-Wmaybe-uninitialized]
 6673 |         *ucblocks = (u32) err;
      |                     ^~~~~~~~~
drivers/media/dvb-frontends/drxk_hard.c:6663:13: note: 'err' was declared here
 6663 |         u16 err;
      |             ^~~

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/drxk_hard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 0a4875b391d9..2dccc9d0be12 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -6684,7 +6684,7 @@ static int drxk_read_snr(struct dvb_frontend *fe, u16 *snr)
 static int drxk_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct drxk_state *state = fe->demodulator_priv;
-	u16 err;
+	u16 err = 0;
 
 	dprintk(1, "\n");
 
-- 
2.35.1



