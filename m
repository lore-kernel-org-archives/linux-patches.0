Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058127;
	b=Jn7oveZnyK6IskyOa7gsy/94BSTVZxhpM/fV1u9yqxPrn//v/mSL07IzIf7U0g/0/y/2
	 js4Lvb7sAZWNqjiqMwRi6IQ1soZos4TPqQQo2mrBf5X7IsaR3IpcRbc6PiD/ik1x5djeh
	 n/jWlGJyrceF2AVRvx8s3UKSLeeCihIp3gj6UTuoWCr412dzUZzzcQSUNXrwrntSQhhlQ
	 gHX3AhaCprTuirR4vGsgcs0SGSnmBLbOytaGAFeXvR6YiBwONL5i/4RktgmDEJxaKAX3A
	 9NF7Ev9Qjgqaq8eX2VnYPRpR2KWYNq0UF1ZbdZ8fbDZe8L0f8Io0bprZMIr/2gB/7nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ILpBM0FUoU3OsfyenK2LVEFUKnMZVJUBQ0a2xZGAmCA=;
	b=AnBHE+qfCH/pxCvdMvf+8rTYx1D8YXfTB+0C3yGECvF3N4//0UvfVfWCqfRSgvD0nKe2
	 skASPfpWeTB6cA9hj1vy0HxIGlPNoz3/j37Sp4WWADBgpzXru3png88WCT0HiZtsom9fp
	 ATdjeSf+HF3qFNYLA86FX8BgGSuZJzk/nvGRwoX1MEh5GV+sqrwiz87GpdI7iu/9Jez/j
	 BrVSCi1Usi3uOiF7cALoTgvYRC9ifqdezBj1/LYk38CWeSdS/b1RuDEeWvzpoHQVvQdir
	 AER9WMrrx4C0gUUzebXOKnSOV2EVlfI+uNHoXi/OVVNesz6Nsz7L7/9UeWvjOHsm+ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O19CXZV3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82A8606A320;
	Thu, 19 Nov 2026 03:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O19CXZV3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AEA61F000C4;
	Thu, 19 Nov 2026 03:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058127;
	bh=ILpBM0FUoU3OsfyenK2LVEFUKnMZVJUBQ0a2xZGAmCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O19CXZV3Mkvxfk1owMeVjcz4wWeUs1CXUM0aeD86zeWd9OtYBBFJQ6viyjfSzFyJy
	 v7FkxcY082OSyJ+DXtywX7TTAIuehUimbeYJJYUSMO/ZNteQjE6qnHAKkBY2W8MRg7
	 gAadCxYu7RmcjsVsqWG3Yb61U/dvFOzyj4Ktd0+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punnay Sharma <punnaysharma805@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0375/1848] staging: media: av7110: fix corrupted BER reporting in sp8870
Date: Wed, 18 Nov 2026 15:40:13 +0100
Message-ID: <20261118145929.169442721@linuxfoundation.org>
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

From: Punnay Sharma <punnaysharma805@gmail.com>

[ Upstream commit 5764f9bd7b7a72c6df49db6c8c00d4f9994a55ba ]

In sp8870_read_ber(), the 14-bit Bit Error Rate (BER) is assembled by
reading two I2C registers: 0xC08 (lower 6 bits) and 0xC07 (upper 8 bits).

The current implementation masks the lower bits via `tmp = ret & 0x3F;`
but subsequently overwrites `tmp` entirely when processing the upper
bits using a direct assignment (`tmp = ret << 6;`). This logical error
causes the lower 6 bits of the BER hardware metric to be silently
discarded.

Fix this by using a bitwise OR (`tmp |= ret << 6;`) to correctly merge
the MSB and LSB payloads before returning the metric to the DVB core.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Punnay Sharma <punnaysharma805@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/sp8870.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/sp8870.c b/drivers/media/dvb-frontends/sp8870.c
index 9767159aeb9b2..f68479e75e462 100644
--- a/drivers/media/dvb-frontends/sp8870.c
+++ b/drivers/media/dvb-frontends/sp8870.c
@@ -384,7 +384,7 @@ static int sp8870_read_ber (struct dvb_frontend* fe, u32 * ber)
 	if (ret < 0)
 		return -EIO;
 
-	tmp = ret << 6;
+	tmp |= ret << 6;
 	if (tmp >= 0x3FFF0)
 		tmp = ~0;
 
-- 
2.53.0



