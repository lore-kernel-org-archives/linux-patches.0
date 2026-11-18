Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052155;
	b=LbhgaYkFk2/K9Xr3KmOeqFHyv9Zru64QKR7teWOswxufxXDMYtG9/4GlA2Upc1IbLWuZ
	 sB+zyKTBzJShC+ANj2HJUUMXGSt45ZHKNLIT4GdCYJx8zsFlgFGWRSTlg3Ch04yiKTbfa
	 2v3Y1Ktbsw8usVjle4L64Cpf4FTP5KPwmP1zQhc+GSa0U6AzPycWAgH3eT+iNeLU53XoP
	 HLaG/AWdRedAgrziJu2givI5I4YPTU+58QKltitVRksxvJ013Gv1aG4MuphgCPJuLpr05
	 bkv1ax7f66RPaxUtPbYSnk/fjZGxTYlqOrCiXmTDvmHvTRYotr65wKmBakWI+sHIoxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mpP65SvV1kgv/lA0KW54qC8mFdtlzxqTMGoHEgVWg1s=;
	b=Ts3vpsVEp3ISbPeQNe0RLM2bufmxmpvSlfH7W+I+4I6Ly3ko6whSScxAZnLO1/jRCsLp
	 TQqTYMm5FTv+cwbWxQFOvw/brJalz+keB0d7JAcw+S+SwdhsV8SbSDF1U0XYQIP2vg2g+
	 b3OKvwcFfrnIqrewqSyj52MYfLhTiVhx8nCsPsbpRjm2DUV5aGaAMaNsujpYrufT3xVDm
	 nmd5LW2ig7Og3xHcpxXCalG/DNPUBJ3Cs3KaZ4N6p3szDGfUgJDofenro7lKAzR9AyCYh
	 jX3d6K0tdwiE6YLbBcEH+gGf2Ws9s40bkdHoZmuzVu6RpfxyBeQQe92YJdln4kLVc/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C4prS7HX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB57606A325;
	Thu, 19 Nov 2026 01:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C4prS7HX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9F61F000C4;
	Thu, 19 Nov 2026 01:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052155;
	bh=mpP65SvV1kgv/lA0KW54qC8mFdtlzxqTMGoHEgVWg1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C4prS7HXa+b/s/9BNA3dLm5ZrAq7PJO0JxCWomJqEbntFnMyFieMOavPlOmQ2HNmY
	 1ZVdu9ngBIgKT27UaxZ+ONz4S8KCB/YZul6Ge9M2hcelI8OUGlFEwxSWnaBC6auIhR
	 ZjEXdlA80P4nfYKlKBHFYElhujbovN3yqWGQJkSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0461/2214] media: i2c: tc358743: add missing color-space strings
Date: Wed, 18 Nov 2026 15:35:37 +0100
Message-ID: <20261118150029.662750103@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 48f6fe8f1cc92..6806b7e48599b 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1268,7 +1268,8 @@ static int tc358743_log_status(struct v4l2_subdev *sd)
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



