Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045055;
	b=f170uCMJarh5V4OvYU+Vd9syiHtZ6tMT1V2mwecdcCHNi3j6SrFZynhXCtmYTAVuqeh4
	 bf50LlFQ/3BIALsxkakH+GbD5Nwg2vMNafByhQrgz9FVwgwg4zs+3PjHZm+zQbz3t1kUQ
	 QCKhJBIGCvkp3OkfiidVmpDHmYgRHyHru6LQYnWJum8Tf7Nm3p/mvgAQArk8ARzdrh2+2
	 YxpH6iFp7gtIxBb6bDnwSYQYcPZ0OfW4Mtj2x0pdAhTmee3Bi3zmL3+mDxxAJkWm5J3zo
	 PpY6DYa9ekgaSnhDdtkJtvIUVtE1kO6h4GWeRlvIbtrpOiDJIdSrjJOiT8Rf0C7ngZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I2vuC1aIOYZgEIEj2PpsnNFHO2BXUbvpDX8N5N+GY3s=;
	b=uRIoNeBnA+w5TENWGKWbxN1tPLSGvIRzjI3ko08YVIyqAedEPLCx5ANnZbkbST+9vPia
	 cVEPAzjVcQjzW1sn0xk6vISRObPZHO2ijhYoa0mGUuIjLqVxAPnWhd7W4PaQaeSp+Hsvy
	 CtkOeNvcrk3BlC8XKoJn6FTc4M7zXsa2FZV5J279/YewPp0HSxqWLYH0M/OjYxzwfICjB
	 DQCcypmjkX7npzZiIFGr9XlV9DFTB/GrSP5Y4rl8lqJyezBrLZ6YJYJxhDnijGDUK3fB4
	 WMwuUMkem9zQTvmzw7iCPwqBckZmvhi/HGNlDJEOUrcg45He+o9d+KwyZfB0Haz4yfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d42OqW5q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C5B606A31C;
	Wed, 18 Nov 2026 23:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d42OqW5q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0231F000C4;
	Wed, 18 Nov 2026 23:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045054;
	bh=I2vuC1aIOYZgEIEj2PpsnNFHO2BXUbvpDX8N5N+GY3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d42OqW5q5VjcRvuV3cr2VhF2VCjYaeW7l0jHrRY7NQ6glRcfLQwgOMmE5FAnHkmma
	 xwqeO6CaLE4a/9tFSP6CM5/wKOjPKrfkMupwY9urRBBf3k7t5s7tn/vwoYIx3LQDaf
	 RL36QyyTQYf6L6VTNf6E9oXWUtY5z11L2x4CTSNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0737/2857] media: i2c: tc358743: add missing color-space strings
Date: Wed, 18 Nov 2026 15:29:31 +0100
Message-ID: <20261118150228.087892917@linuxfoundation.org>
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
index d7d93ba390b25..3607bac0f2596 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1266,7 +1266,8 @@ static int tc358743_log_status(struct v4l2_subdev *sd)
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



