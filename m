Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062837;
	b=2CiKGtK8BQl+H1oDLZ8RcDnZPZZWGth2bYp57omuBZgWyQEwRLFP6hD+ikrCXoIhigJH
	 VzUCPoGlRFB0IheKdy57aYdTftOe3mqXi5gO7VTwWUciASaFAiMfr1oKTjDs6uhhVauLn
	 pG/Vdm+FG2bWe3yi7Mq71AowDtSOuGcL8AYBjdN8NacVC5Ad05wgcrmI2XWbaJX6wT3hI
	 lSo5+IDMiVPvWh6OciTfUFI6huV8enQ2UDgk4IG3SBdZc8WY5l8Z9AxT22MYhR5fGMj/2
	 JEzOssZnUISrnwvpaiBL5X3S1fMLos2BDeY4Lg8qnQc1oqGd+G+BnKRjnZ9Ht762Omw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=65p+Z/aWqm3OxwldLEil50aVgF9fhTP5coD1Q0dDCtk=;
	b=EBFtdFiSVL039T9raEdzbZ+sohVgAz8fFyoyzb622tfQ68RZ0hm1pmUj3AZuz7443Nkw
	 5pRuVTSTO7uSRactZ0aonGd3KAvTXzVxEkGIK+6zw261NPRk15jkYSg4oVUJOvjg0/eZj
	 YdTTBENguADx7WQ6sbMkt4W9Tc3KomJR6a+8dRiJkc6zUHgQ2rWaTL72FmDzDkdqy4gM2
	 jsocHn6rEvhBnUKmPUDzAgiDugPWOfO1QR4XgZCUztkozppMi60LqB3Rt90s41+eKfhwB
	 byVzL/zVWVtM07sAAmpZsE/+P5GV8Kc1elE6fnYFIEjvTj/yTLyUOClhzNIbCwoKVXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+52gJUM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8363606A326;
	Sat,  7 Nov 2026 14:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+52gJUM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4799C1F0089F;
	Sat,  7 Nov 2026 14:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062836;
	bh=65p+Z/aWqm3OxwldLEil50aVgF9fhTP5coD1Q0dDCtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+52gJUMTEOf+W3hXIZe5oNBCjth6kA6ZuPGRMJUlIdjUGs/DknynoLmHUWYF6Sfv
	 Fs34R1DmTqvx+sixBewp1H+MNGC8OWJaGqpjmcCY8JnCdaHzVqRDctZz77gt+Bdcer
	 uM8KNOgF8xRoCOM6PfhaqsA3bKSk6Q93F3q8zEQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 081/869] media: i2c: tc358743: add missing color-space strings
Date: Sat,  7 Nov 2026 08:46:03 -0500
Message-ID: <20261107134855.460672893@linuxfoundation.org>
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

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit cb37e83f1bbdf0964ed0a9524ce45a0694f98205 ]

VI_STATUS3 S_V_COLOR is four bits, so the index after the shift
is 0-15. input_color_space[] only has 14 entries. Add the two
reserved values so log_status() cannot walk off the table.

Fixes: d32d98642de6 ("[media] Driver for Toshiba TC358743 HDMI to CSI-2 bridge")
Cc: stable@vger.kernel.org
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tc358743.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index a0ca19359c431..aefc442b5737c 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1373,7 +1373,8 @@ static int tc358743_log_status(struct v4l2_subdev *sd)
 	static const char * const input_color_space[] = {
 		"RGB", "YCbCr 601", "opRGB", "YCbCr 709", "NA (4)",
 		"xvYCC 601", "NA(6)", "xvYCC 709", "NA(8)", "sYCC601",
-		"NA(10)", "NA(11)", "NA(12)", "opYCC 601"};
+		"NA(10)", "NA(11)", "NA(12)", "opYCC 601", "NA(14)",
+		"NA(15)"};
 
 	v4l2_info(sd, "-----Chip status-----\n");
 	v4l2_info(sd, "Chip ID: 0x%02x\n",
-- 
2.53.0



