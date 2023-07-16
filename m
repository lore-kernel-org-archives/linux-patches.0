Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98B98F75
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E4BC433C8;
	Sun, 16 Jul 2023 20:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538836;
	bh=tOFIa/fxNLcAu6h6GuVST2YWjk38g77k1sRQ6RyZxeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnUZ661c/oJnbifH7xrtHtM5goSERGB0nTrQjWqs1P1bRmhLFx0d+p0MtuEJufVdq
	 oFEkMzPgeDYvDMxlv33lc51o+tdgX0CLYV6BV4jN7O2mmzvyspPhwgrwI3YXBaikUN
	 uXc8yFps5weT2pWTjyDe0N3i4PUfd306tQLqvHmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 565/800] media: usb: Check az6007_read() return value
Date: Sun, 16 Jul 2023 21:46:58 +0200
Message-ID: <20230716195002.211825895@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniil Dulov <d.dulov@aladdin.ru>

[ Upstream commit fdaca63186f59fc664b346c45b76576624b48e57 ]

If az6007_read() returns error, there is no sence to continue.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 3af2f4f15a61 ("[media] az6007: Change the az6007 read/write routine parameter")
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/az6007.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
index 62ee09f28a0bc..7524c90f5da61 100644
--- a/drivers/media/usb/dvb-usb-v2/az6007.c
+++ b/drivers/media/usb/dvb-usb-v2/az6007.c
@@ -202,7 +202,8 @@ static int az6007_rc_query(struct dvb_usb_device *d)
 	unsigned code;
 	enum rc_proto proto;
 
-	az6007_read(d, AZ6007_READ_IR, 0, 0, st->data, 10);
+	if (az6007_read(d, AZ6007_READ_IR, 0, 0, st->data, 10) < 0)
+		return -EIO;
 
 	if (st->data[1] == 0x44)
 		return 0;
-- 
2.39.2



