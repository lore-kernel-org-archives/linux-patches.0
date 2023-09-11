Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1EA1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF658C433C7;
	Mon, 11 Sep 2023 14:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441932;
	bh=cERlT3Bj+A+c3AS9SgJk6L1YMS5ZfHb9KJ6XdRIV7AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7jSMjUO/CctOLVzVz4ORf/QRjUxlEzSfxsvS/hf0unEo4DjLPUhZX0YaEwg/X4f1
	 Wb7eXVPGTLw0rsCKSZRYN+U49rHRpsavLyJ8La3mVwqQUl43u9N2H25L9S4zreEKud
	 ZX7QzYUeCiOQFx9mjBbEzG97REMVEtw3yf36Tjc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 549/739] media: i2c: rdacm21: Fix uninitialized value
Date: Mon, 11 Sep 2023 15:45:48 +0200
Message-ID: <20230911134706.426548374@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacopo Mondi <jacopo.mondi@ideasonboard.com>

[ Upstream commit 33c7ae8f49e3413c81e879e1fdfcea4c5516e37b ]

Fix the following smatch warning:

drivers/media/i2c/rdacm21.c:373 ov10640_check_id() error: uninitialized
symbol 'val'.

Initialize 'val' to 0 in the ov10640_check_id() function.

Fixes: 2b821698dc73 ("media: i2c: rdacm21: Power up OV10640 before OV490")
Reported-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/rdacm21.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/rdacm21.c b/drivers/media/i2c/rdacm21.c
index 043fec778a5e5..7a71bb30426b5 100644
--- a/drivers/media/i2c/rdacm21.c
+++ b/drivers/media/i2c/rdacm21.c
@@ -351,7 +351,7 @@ static void ov10640_power_up(struct rdacm21_device *dev)
 static int ov10640_check_id(struct rdacm21_device *dev)
 {
 	unsigned int i;
-	u8 val;
+	u8 val = 0;
 
 	/* Read OV10640 ID to test communications. */
 	for (i = 0; i < OV10640_PID_TIMEOUT; ++i) {
-- 
2.40.1



