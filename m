Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121B4746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77719C433C7;
	Sun, 17 Sep 2023 20:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982438;
	bh=jbMY2qKCzfU3pGNUhjzeKZo6/bfBOZ0ql6wHZAGQAlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OZVfeOy3mr4pDHreXgzy7VxTLpGAOlVnQ+2LYoH++J7BGKaP9/yO3evOLwO+fImW
	 aumIeayozqBUdfc3S3VdGUW6jqR5sI9+5Pmz8xvVRF3M5ZajiJmJHn2sPg+9eAHVG2
	 oaUJO+ssQzLMYx90IgTmMdCgqblrx+0KVRmnmXMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 243/511] media: cx24120: Add retval check for cx24120_message_send()
Date: Sun, 17 Sep 2023 21:11:10 +0200
Message-ID: <20230917191119.685519189@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniil Dulov <d.dulov@aladdin.ru>

[ Upstream commit 96002c0ac824e1773d3f706b1f92e2a9f2988047 ]

If cx24120_message_send() returns error, we should keep local struct
unchanged.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 5afc9a25be8d ("[media] Add support for TechniSat Skystar S2")
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/cx24120.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cx24120.c b/drivers/media/dvb-frontends/cx24120.c
index d8acd582c7111..0f778660c72b8 100644
--- a/drivers/media/dvb-frontends/cx24120.c
+++ b/drivers/media/dvb-frontends/cx24120.c
@@ -973,7 +973,9 @@ static void cx24120_set_clock_ratios(struct dvb_frontend *fe)
 	cmd.arg[8] = (clock_ratios_table[idx].rate >> 8) & 0xff;
 	cmd.arg[9] = (clock_ratios_table[idx].rate >> 0) & 0xff;
 
-	cx24120_message_send(state, &cmd);
+	ret = cx24120_message_send(state, &cmd);
+	if (ret != 0)
+		return;
 
 	/* Calculate ber window rates for stat work */
 	cx24120_calculate_ber_window(state, clock_ratios_table[idx].rate);
-- 
2.40.1



