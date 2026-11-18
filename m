Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044954;
	b=S6FsqujH2GqVest9Rp6M8MaemdX61RTpZnN55MRN6u4O2EP32T1wOfkVSMAMj2KSJnHR
	 c7JTa/QLCCGlJIpB8QiWn8RJ03BWsXszTDnKzjtb5Ikyxy2+WcWEeaXAWs35Ok+KC7UkO
	 3ej+UYoQpE5AgK8em6mH2ug5H1Io1nDYi8m/ixe5mlmdUTlZq/hRdKFbpIN8/8eCg+fqx
	 k2g+7vAU3/6TPDiZf/v+kMpIOu5m+vpqLhDYSndXsihC8NFZpdfcutRI5fiRIxtlaIekQ
	 dVk2KEUlLstuKr2EM5yxovkH7biGRMBrQdwbix8wtohP8Lzc4UOqF3AFiyU8UEMqiwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hnnSP4OF9mG3Lzx0WIKoGTn5bwzZwApb7PPxlsRVhP8=;
	b=2iVMKSejTiC7wLUrRl83RyEzyyWz1aGYtWAYxb983EoVh7XLdn69RV9iwNeNLGQGh2S2
	 B4HczTG7AG9wDsnCrd6C7Udgmz7hpkpd0TWB9HUoJkWEfmGtNrByilB/VY++ThoeVMokA
	 Qx7CMRJbNMRtdVaPNv50adfThOUH07iTjuzLlvA77wHqAXTmwivSnqxynsLDSTnLQ/+w+
	 Nu3ASWpPx9GgkKKPTbE57aXT2QUBvDl++Qn0Vp5s4bSP1eJiFc7Hyx+WnR9zy5bI/vODp
	 cEgb8MC+4mNQV07Y0N+QwvELiYouB/AYcIfCls9ih+9/rWbas1067IL+y5fbPDEeB9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kXxTm5MV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3353B606A32C;
	Wed, 18 Nov 2026 23:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kXxTm5MV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C94F1F000C4;
	Wed, 18 Nov 2026 23:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044954;
	bh=hnnSP4OF9mG3Lzx0WIKoGTn5bwzZwApb7PPxlsRVhP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kXxTm5MVtxOO7gfTKgXwjvV4n89I5EvR6DtP7Gr2SDoETkSl5wtZ9s7Sm02Dzmlhv
	 71p9FDMPxWPoni+fzaD15sKRxvki7tlbEdqbIeLUbwmNa+rR77MoQEDPFrubxSeZ+Z
	 sZvFtBFCGpuM4ZgjmYiVMuvIodyRzE+S0NG63Dx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0751/2857] media: adv7604: avoid negative array index in log_status when cp_read fails
Date: Wed, 18 Nov 2026 15:29:45 +0100
Message-ID: <20261118150228.592462163@linuxfoundation.org>
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
index 1f6ac602ad5a7..ae7e4dbab0146 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2634,8 +2634,9 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
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



