Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030031;
	b=AW7VGmsnffWk9ltbAjiOu3hvUl5WmRg2aW+D2/b4uakF54gQriB2dlLrT89YWcTCxymE
	 QTvNcjTxXcot7b6zyjdqHgvg9jAEkfBtjiNRN2x9E/5/7GQqwJ+ZHnK55smscBJHqOiVa
	 AGlIS/HDK3gtPZmJVvYB1Id88Io1o7RoPvD9Ybxzk00m1/e/cYMFl7l+Kq7TCmbjslLpM
	 hba/VflE/8+mOEK81KGltsUvyVq0V6k8y0GCgdi08kLD2CNnaopWm49+qWV/b3tmpnMg0
	 4BScAp7JTrl0lhIzOpQDquujiclredlGRKcN/+t6+NcQI5x7b4UaMWMJoG8a8KmabyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AyBvaVVLRwnHwtGz1IM6WB5RN3MmwxsjZp4Oi9o/2rM=;
	b=aS1OyxiINg7wXH0WuJTiBa1jAmK8CsA7SAbeWXCssh/BfWEeY0GzZjhqWAdLZgHgvub0
	 7VcDJMhnPuG0x7pbRfpYVKNu+XoEfVdKGFHg3ltRaCyuGdi9HMQ1lJMwSiRf9ty+Bn7Jq
	 P+CLqARyNNc3c0QGLyp29SnU5SLX/T7GR9oH3S3vj/aDukOlzT+gY3rmNydWmF4+ITv+V
	 tjsBYf/XJdmieLPTL0Ejiqm4RzGwQH6NnuZMvb80G/ppcBNOsPHxHNqRiwLVZQoLG3smS
	 7VhcsIJRQS9rcz8Ur9tWGV1rqTXBYKu+Qou+ed2uylx6fg5agNbUoNK4glWRBryXFkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQWIKSxG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9C2606A31C;
	Wed, 18 Nov 2026 19:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQWIKSxG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7BE1F000C4;
	Wed, 18 Nov 2026 19:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030031;
	bh=AyBvaVVLRwnHwtGz1IM6WB5RN3MmwxsjZp4Oi9o/2rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eQWIKSxGOjhATx20Rijh0lhaBLT371aG6+b5LYRmyL9fU2r4AF6swXgvrTa91NGqY
	 v3n51PeurPAOJd2l8OxTr9/TS2hND8uNFy9ODwRfvZhm+Y9l2d3QIHzua51m186Dcg
	 abQIFJoEQCMGT52BgIlDDOWCTWvfiawWBBksZvp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0518/1756] swim: Select appropriate drive once only
Date: Wed, 18 Nov 2026 15:44:05 +0100
Message-ID: <20261118150029.782486337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit a2d22b3f25c388f9fbce7bf36a45a8900dce4aa3 ]

Before turning off the spindle motor, call swim_drive() to select the
appropriate drive. Remove the swim_drive() call from swim_add_floppy()
because it was already called by swim_floppy_init().

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/370f73fcceb53ce4860904ce6cf4f06ade0e43d5.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index bd619c57ebc96..83842dc667374 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -679,8 +679,10 @@ static void floppy_release(struct gendisk *disk)
 	else if (fs->ref_count > 0)
 		--fs->ref_count;
 
-	if (fs->ref_count == 0)
+	if (fs->ref_count == 0) {
+		swim_drive(base, fs->location);
 		swim_motor(base, OFF);
+	}
 	mutex_unlock(&swim_mutex);
 }
 
@@ -752,8 +754,6 @@ static int swim_add_floppy(struct swim_priv *swd, enum drive_location location)
 
 	fs->location = location;
 
-	swim_drive(base, location);
-
 	swim_motor(base, OFF);
 
 	fs->type = HD_MEDIA;
-- 
2.53.0



