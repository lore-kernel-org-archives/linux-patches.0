Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048493;
	b=NhKtjol5ti4rfI8lvCtCjlEpCRWuEWostXf2sDiAWtgmIpms/EjzMWjTNIuW8+XcaVQ7
	 n+w09PQsfGC8RYT78rf3bmv1DhVMCiymaO57uTqEtCoS/5/aWqjvS8oz8v5sWKItF4aql
	 wMwyFYmz8yRs+IC/jWsKn1107iqYB9P3sdc/0x1AoTSk5V86viPzxNUi6Tgk4FaNk01aD
	 tYk/I6jb0svGCC0K7G6qRP0Zq0+7ZT1/e9LmOsKQfFSkQzATzhfVQ7cEY+p6FRIv2ZPvk
	 NiDggG3bN51LS7LpJcOiwqJLVr5hJbJMSWcRu55K1RxyBftDzuHKZURHmGd6zLJ0axQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8SCSzPVWGb4Ro2la8127cxFjH+R1V/17ZMsYy8wYHHU=;
	b=x0rAK0oaJvT5gcjQg6uJNCEG7PzQBneIFvuO2h1D9YG6y9DRBnPIcV0yGDnfQcImRrTc
	 sfK+vTAk3UrTmQtseKrc09DyXNiVR/dAF9cE6yq/n5LT/TO5+mfqKTv2G6h+ggd7cldk/
	 1syAKagTPlDEO/OCzM1DCLu7zf6XjV1H+al+mAASunLhbHY9+7gc9RnjJmj9Ne8T8RUX6
	 T/kO4etUkYBIunQakxK8MJ7KAVlgzO0saKQ4dSc6ZVNMs0lytZWUM+TqrmN/oFmJcLmXm
	 LGK3NcIXKa9fjcptXWBmWZ015io20WPsouC5eBW/rKddZqtRuuIKwtsgah0S+JxYA1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QSc5ZZ3+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69774606A31C;
	Thu, 19 Nov 2026 00:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QSc5ZZ3+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752921F000C4;
	Thu, 19 Nov 2026 00:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048493;
	bh=8SCSzPVWGb4Ro2la8127cxFjH+R1V/17ZMsYy8wYHHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QSc5ZZ3+HCffgl3WASYA3wNqeT2sTfVvlTgKpzS76P/iNedEXmTDI/KZeFlRGCwpu
	 j1LjKtWYcos5x5oAYFi6d6V5IPcgNijevg8XE70/YP3o3OkllkVadIYXvm7ijX4Nmc
	 auhthLYOalBatDBM3HsYKr2jHD9z8QMUnWPUBRj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2014/2857] swim: Perform ISM/IWM mode switching according to specs
Date: Wed, 18 Nov 2026 15:50:48 +0100
Message-ID: <20261118150313.915218678@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 52981bb358d1b5c38040b00f81e2cf973f9148ad ]

The SWIM spec says, "MOTOREN must be low to switch modes" and "after
switching from ISM to IWM, the very first command must be a clear L7".

The ISM spec says, MOTOREN "must not be cleared until after the Action
bit is cleared". Perform those operations in the correct sequence.

When switching to ISM mode, the Mode register has to be selected with a
particular sequence of bit flips. Set q7 low then q6 low then mtrOff.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/75714ecc9a12d59511967dc9e24163dc8f3bbdd8.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 12d883c8a3ae1..94da24a80dc8e 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -149,6 +149,7 @@ struct iwm {
 #define ACTION		0x08
 #define WRITE_MODE	0x10
 #define HEDSEL		0x20
+#define ISM_SELECT	0x40
 #define MOTON		0x80
 
 /*----------------------------------------------------------------------------*/
@@ -223,18 +224,21 @@ extern int swim_read_sector_data(struct swim __iomem *base,
 static DEFINE_MUTEX(swim_mutex);
 static inline void set_swim_mode(struct swim __iomem *base, int enable)
 {
-	struct iwm __iomem *iwm_base;
+	struct iwm __iomem *iwm_base = (struct iwm __iomem *)base;
 	unsigned long flags;
 
 	if (!enable) {
-		swim_write(base, mode0, 0xf8);
+		swim_write(base, mode0, ACTION);
+		swim_write(base, mode0, ENBL1 | ENBL2 | MOTON);
+		swim_write(base, mode0, ISM_SELECT);
+		iwm_read(iwm_base, q7L);
 		return;
 	}
 
-	iwm_base = (struct iwm __iomem *)base;
 	local_irq_save(flags);
 
 	iwm_read(iwm_base, q7L);
+	iwm_read(iwm_base, q6L);
 	iwm_read(iwm_base, mtrOff);
 	iwm_read(iwm_base, q6H);
 
-- 
2.53.0



