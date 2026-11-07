Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062802;
	b=ax532NQuCIY6xvRnQTa0e/1NQQiBDZ5LCu2CihQ3kp7CcgNA0n09O4BHqdHwk2v/8WCt
	 CM5DfTymkGU1hGr1afH1Wm3khVjkO7H2ds3pyILEPLoloxR3BAgb8Tvy0vLXsqVlCHF/i
	 LjogvieLv1Fc6dmCKW3vgaKepL8bqZ/APCTd5cn9ADZlJ6GrkklX9kXzDv3uChJh2ltYd
	 brjKgQBw5Ur3JPpwLmT4h4TQEOnmnnehOkJgdDwKihaZL2j9zjnGhD1umXKkKq3o+r53z
	 i0r7jQyEeVUo8bTjL7kTW5ly/OBZkVxEZv3NT95isRbG8RXyymrnjpm7195/+UurK+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oq/+KJPepMoQwwMp+vUGxNsWXCDIIyVR35SlWK175Yw=;
	b=Ws+nlu5oUC6VudsltF41IQSa1nfXYh1jiJbeZ4LZN4KJZlIlXATaU0n/Qi8x4IB/6Wg7
	 QSCw9kNPVkMthmqTYUrXX3asplSZp0VxCLuLomfXFkwxlyeu6V1fPfeQCsKYhs7iMAdmN
	 gXDoDwJsbyv4hqp15hp6n6ZdZK9AaujQT091r5SMWp+LGV7ytd003QGVKk43G0fg/ivZn
	 RuQONzk8uaMMsAYrQHr7kqIbLQERtmSHveNnSaTaNl3dNJQE0GiBkQUSDh+t8fmyfix0B
	 euEDcVbJsBgxRayyk3zCgX9SrdGeTQsXwlDca4I5eCPDoW94/RjDQ6NsSqG/qfeXJhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U3rWERWV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E360606A336;
	Sat,  7 Nov 2026 14:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U3rWERWV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9301F0089F;
	Sat,  7 Nov 2026 14:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062802;
	bh=oq/+KJPepMoQwwMp+vUGxNsWXCDIIyVR35SlWK175Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U3rWERWVXoQU5WniR4CX16xKjXK9pUVDHrWzhkOdccbxFfc4EFNiN3HDy2OTLXOpc
	 9zif538S86oBQWJBNWcL/Hgk0XSd8AN2exBR3ks5NwzLMOQHxoyDloEuPVQpMS3KoH
	 tBumUbwfxsEFlz/bEcPagHKqGZOXx1vY03gD4UwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 104/869] media: adv7604: avoid negative array index in log_status when cp_read fails
Date: Sat,  7 Nov 2026 08:46:26 -0500
Message-ID: <20261107134856.154000146@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 10d8dfda1c08f6788049aa100685e223d857f901 ]

cp_read() returns the negative errno from regmap_read() on I2C failure.
adv76xx_log_status() shifts the result right by 4 and uses it directly
to index csc_coeff_sel_rb[16] causing the right shift of a negative
number to result in -1, reading a negative place in the array.

Commit 8163419e3e05 ("media: adv7842: Avoid possible out-of-bounds
array accesses in adv7842_cp_log_status()") fixed the identical pattern
in the adv7842, so do the same thing here.

Fixes: 54450f591c99 ("[media] adv7604: driver for the Analog Devices ADV7604 video decoder")
Cc: stable@kernel.org
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv7604.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 516553fb17e98..cfecfff4c3aaa 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2641,8 +2641,9 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
 					"(16-235)" : "(0-255)",
 				(reg_io_0x02 & 0x08) ? "enabled" : "disabled");
 	}
+	ret = cp_read(sd, info->cp_csc) >> 4;
 	v4l2_info(sd, "Color space conversion: %s\n",
-			csc_coeff_sel_rb[cp_read(sd, info->cp_csc) >> 4]);
+			ret < 0 ? "" : csc_coeff_sel_rb[ret]);
 
 	if (!is_digital_input(sd))
 		return 0;
-- 
2.53.0



