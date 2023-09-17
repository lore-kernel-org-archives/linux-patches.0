Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B4D63B8
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E51FC433C9;
	Sun, 17 Sep 2023 20:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982629;
	bh=/+nX8+GJy4HODrREw66mN3OhhcACy+UPE+GsGu7wK+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USarMYlAjuOpa1vyT+4nTM7KuSMxZdC+1/7Xc/JxGG/qHCyK7Jm55HmE4p6bw4IP8
	 Dg8n8Zf4NBNhl2ErHFZWdDiUAufbf7LcJEwuNvVASk1XttEyzzkhmRz7majI/imr4B
	 s6Z9lLGLmVK8oD/OdQlHtCsV0B/aD5BK0KQyWzXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 276/511] media: go7007: Remove redundant if statement
Date: Sun, 17 Sep 2023 21:11:43 +0200
Message-ID: <20230917191120.501921296@linuxfoundation.org>
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
index 38339dd2f83f7..2880370e45c8b 100644
--- a/drivers/media/usb/go7007/go7007-i2c.c
+++ b/drivers/media/usb/go7007/go7007-i2c.c
@@ -165,8 +165,6 @@ static int go7007_i2c_master_xfer(struct i2c_adapter *adapter,
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



