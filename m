Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016983;
	b=n/vpLIqWA8Ruz6L8JszO2c4nUMYg59deeWHRTtAflSraXyVa+PIiNfeNH8uyS/Ik9+O2
	 x6yw7GLvjdwCsQKFfIN+oqNFEgN/wr6we/nRNj65RF+jKOaaTZWTJj9Ic+mOIi7SbEQ4F
	 SLRDbtRTlBfyBn2n+8Zc86OUhDml4DMKg+Kh7ycVK6K6QuoLFXtQBbuPOhBgx5n+Doh95
	 xoDgS5BHMoZmhqL96glO5/Ostu4ortpK0nzUPvx8ch+8jsK1LB6/3MCKGyqwUNq21op2i
	 Rwl2e4DRisj/zTdeYHjUZy8CpgJOdUhEHyWW2DkmVn3fQXuRZ34BQMARGnBSf6qQidg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ThjHrf9G9cr51TX4S5g+JzughSphxu39Y4iWNJbnTfQ=;
	b=fFWMT8Clo+NN0G6j0CSCOJkH2i0ovHKu6nX/II2C9M3Oj3FfmhbWWM3IbhqeEYUiAhdd
	 fs4+hXOOn24T3aHbnbSmhJQ1zwJwKrn4BkTS+zxvc94CmtxR67MijQzruT5kM1ymWSJiD
	 sWHUzpYmLiPcilFDtvJCcDUkfd3IyWZxhnXb0EDVjJiaxgvNIOsux52QTiwHI4d+uv1ao
	 S0+cmntFgy2UiLAwOyur3s8TmfejXTwKCHqSV5Air7slzy7y5zXZpd9Qzz3BwnuTWk1Ry
	 a3QsGkdx56Bx0iqgJkEdzhxJ4fLICIi7LF0BTtD+XIPbEYaERT9Lsy6ZmfCO+PR6UxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MxzEeLpL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A31D606A31C;
	Wed, 18 Nov 2026 15:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MxzEeLpL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636341F000C4;
	Wed, 18 Nov 2026 15:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016982;
	bh=ThjHrf9G9cr51TX4S5g+JzughSphxu39Y4iWNJbnTfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MxzEeLpL002/DqNP48umWxG2sdB5Mgl9xaNZp7XUoo9Eo3wjXuYq1RLP9knVSLvbH
	 Ecp7fOlcbWNn1KzEMM5/OIyfEfb0/74g2s7b0LJxYHoqz9InzsvbotYAipfi9rJGQ+
	 Z5sF/uRqalLUJpCINr+PBP9FeN89E5sFFr53K7pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0721/2651] swim: Revisit delays
Date: Wed, 18 Nov 2026 15:32:41 +0100
Message-ID: <20261118150313.830158472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit bbcd3e38a4f355d6b0320f3f6916df96c109f2ad ]

AFAIK, timing requirements for the various FDHD drive mechanisms aren't
well documented. But we do have the UPD72070 spec and secondary sources
like swim3.c and mkLinux source code. This patch is needed to satisfy
the requirements in the UPD72070 spec and follows mkLinux.

Change the LSTRB pulse to 2 microseconds, because this is what mkLinux
does. Inside Macintosh says, "Hold LSTRB high for at least one usec but
not more than one msec".

When a disk is ejected, pause before de-asserting /ENBL. Wait 150 us after
the STEP command for valid signalling. Pause for 1 us after setting the
step direction before sending the STEP command.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/af356248a1e6a4fd956f71acf17feead27ba4918.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 601ce79c96b25..a67ccd4504b75 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -290,7 +290,7 @@ static inline void swim_action(struct swim __iomem *base, int action)
 	swim_select(base, action);
 	udelay(1);
 	swim_write(base, phase, LSTRB | action | PHASE_PIN_DIR);
-	udelay(1);
+	udelay(2);
 	swim_write(base, phase, action | PHASE_PIN_DIR);
 	udelay(1);
 
@@ -337,6 +337,7 @@ static inline void swim_drive(struct swim __iomem *base,
 		swim_write(base, mode0, EXTERNAL_DRIVE);
 		swim_write(base, mode0, MOTON);
 	}
+	udelay(1);
 }
 
 static inline void swim_motor(struct swim __iomem *base,
@@ -355,6 +356,7 @@ static inline void swim_eject(struct swim __iomem *base)
 {
 	swim_action(base, EJECT);
 	swim_readbit_timeout(base, DISK_IN, false, 2000 * 1000);
+	msleep(1);
 }
 
 static inline void swim_head(struct swim __iomem *base, enum head head)
@@ -368,6 +370,7 @@ static inline void swim_head(struct swim __iomem *base, enum head head)
 static inline int swim_step(struct swim __iomem *base)
 {
 	swim_action(base, STEP);
+	udelay(150);
 	return swim_readbit_timeout(base, STEP, false, 20 * 1000);
 }
 
@@ -398,6 +401,7 @@ static inline int swim_seek(struct swim __iomem *base, int step)
 		step = -step;
 	} else if (step > 0)
 		swim_action(base, SEEK_POSITIVE);
+	udelay(1);
 
 	swim_READY_timeout(base);
 
-- 
2.53.0



