Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B38A154BF
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838A1C433C9;
	Wed, 20 Sep 2023 12:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211417;
	bh=wBxpB75ZvgVDbKn02UjRMMDeS54xZ0VV5RTRlLnYyXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNUdhg8Tm/IXGSxeyJHSUAwQfKSekjadyfXece5OI6Zuf2XX/UCA2Rfy0jq4HnyCY
	 HCoZPRyChdZWm2yYRTxIAp3Bx/kcVtCtqryfZfT4322HZBdGCx+pA3HJr9rd+uvec6
	 /soy1ZUbK119V4l197QWRArRinAWXjLNdI3ZHDhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 086/186] media: go7007: Remove redundant if statement
Date: Wed, 20 Sep 2023 13:29:49 +0200
Message-ID: <20230920112840.001274742@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit f33cb49081da0ec5af0888f8ecbd566bd326eed1 ]

The if statement that compares msgs[i].len != 3 is always false because
it is in a code block where msg[i].len is equal to 3. The check is
redundant and can be removed.

As detected by cppcheck static analysis:
drivers/media/usb/go7007/go7007-i2c.c:168:20: warning: Opposite inner
'if' condition leads to a dead code block. [oppositeInnerCondition]

Link: https://lore.kernel.org/linux-media/20230727174007.635572-1-colin.i.king@gmail.com

Fixes: 866b8695d67e ("Staging: add the go7007 video driver")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/go7007/go7007-i2c.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/go7007/go7007-i2c.c b/drivers/media/usb/go7007/go7007-i2c.c
index c084bf794b567..64f25d4e52b20 100644
--- a/drivers/media/usb/go7007/go7007-i2c.c
+++ b/drivers/media/usb/go7007/go7007-i2c.c
@@ -173,8 +173,6 @@ static int go7007_i2c_master_xfer(struct i2c_adapter *adapter,
 		} else if (msgs[i].len == 3) {
 			if (msgs[i].flags & I2C_M_RD)
 				return -EIO;
-			if (msgs[i].len != 3)
-				return -EIO;
 			if (go7007_i2c_xfer(go, msgs[i].addr, 0,
 					(msgs[i].buf[0] << 8) | msgs[i].buf[1],
 					0x01, &msgs[i].buf[2]) < 0)
-- 
2.40.1



