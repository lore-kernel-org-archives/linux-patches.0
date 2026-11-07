Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063939;
	b=Zw+i8vYmBQH0YsMRXJ03ILJO6jNv2DHHlaME3OMdqmqvJQKXt7LKBEh/mVOpImQbMLcb
	 4QZVNFYWi9tbdop5wfFdekBjsfmYv6JaDWpuvCkwV1Az8Y/RTWRlIQ9ZzO6EbSo45SkS2
	 gqQyWQYXRnDLXe3g+UPbG21msqd8yw0pWY+z2WUY0QwrL6x8PMTVvUn8vSSBrmX5Yrvmm
	 43olbxIG1/Fzo47W89wS2lm5cNC0wGeN4xkGjl4Xicm4BguYYPsXWQBhYBtop+J2UMsLV
	 sP+vGGiV+HSlHf6ywmFKp9HJ75lmhwed0WDi8xpnelkcZOzuPGk5Y+S0OORCJrgtcrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M03vKcEwBvpIglhI6LhZ7JxdViuucNpyYLMRHV2a2Mo=;
	b=QdDvbwIwgAhCfRbi7ZWE4KWS4XyIrZ4gsEQq6xcaBybfFyk5zJhx17w8QXP6Zh4+cfOr
	 2q6I20tX6eAt+pQYJKTho4vF8L6jDdAjIxojgZZOSkhwpWmc9vqBfrslh2/DpVcIdhr9V
	 tIMo0B3XduVBPZrzavHBIPxDJ77k6jTBKz216zINijpG9p9y5GybwDHwW3JaeeQNWKNPy
	 leJ1ah9TWbeuzde2atXt71sh3ud50AweDvyMaMuLiO9ujHO35kxq7Ym5lqp29j3d5dPHF
	 wGunc+67pGR9OSnXAIwx58mn+br4MyoiJEZqxPJOP12BB39aTLPdqjsqjwOzLptc65g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qujwTEhD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C6E6082BC0;
	Sat,  7 Nov 2026 15:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qujwTEhD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082101F0089F;
	Sat,  7 Nov 2026 15:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063939;
	bh=M03vKcEwBvpIglhI6LhZ7JxdViuucNpyYLMRHV2a2Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qujwTEhDTHoSfXfSSWpzrsOp7pc5M7acUNo18FLekLLoPZkn1Iv8fDipPRJfC8a+q
	 MuMyjMSwAQceU0FJ8FiOXSQVYYrnAwMIGcrIiK1vlU1W5kqGnsjPmdoDVWIYmRmH6B
	 lWgSTci/s0AyQmtVKhR+wiJiY4hJ/98CunyxR9CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0092/1257] media: i2c: tc358743: add missing color-space strings
Date: Sat,  7 Nov 2026 08:39:48 -0500
Message-ID: <20261107134941.903692851@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index fbd38bbfee038..ce75812cbf72b 100644
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



