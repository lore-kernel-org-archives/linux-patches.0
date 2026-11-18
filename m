Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058100;
	b=A9NnM98w0Dg08ys6BViKRRnHURpeBdG8z+2Z/iqpotflEz6GkR4pj3eRz4Qr/ftOKfMd
	 LsirodX2WYb+Uw3XyCMmEroczSStQ4SFWx0BwzN4hlbsGGirbAQxwmiw9eKmt4Pratcpy
	 u0JpXORuUZw8911x7xxyZEsjOUiU2nTCz3j+emU4exKb4eKx55UeUGz3S0ImpUtncAfA0
	 5jngvJzcJJAi1CsC1W0KznQvHC0YYGBuIuSNXgMEJdgndIAyaH7mZNSQHSgNYyl0yg7pp
	 OHxQqnC7EdlPNoRrRLaJ8y1wC7AbgxKl3cTKxAmlwqs4vEzpBAh8JQfY8tZtpdB0S5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058100;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=InbVjpW6FYZ1wx3GZ/mPFXQdg3MAK/z8JABtZ9Z/4iQ=;
	b=Fa7ArwYKXBDzkTTFFfyIGJ3kymtnJs4hkFJvDANu188PQHmSmr/pIuA2mH00GkKf6PZs
	 aYNjhGFZHTToTGV35fF7uBNubOogzQxCClpifOHLS7YHygJHJRf/it0Rw2/BEmtac9D9h
	 UrVX0mF0+5sPL0be918TerTfKZ58hsMEbSJJw99uVuQQCj9c+bDY/Rlsa1o1reJCcOY1Y
	 liQtNdEtnrZe6OpumT6wyd/RH8wPA0VhX+jWxTHIyEKduBdezTgZE1Sx5PBus0pLrm9pR
	 oKPwpyKmm4bA16XV0bfNstaVT1XbFWoPwCb5nmXUPx1id5YKHjbL+zFayU/J9B1tffg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l0vwwNfX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16193606A31C;
	Thu, 19 Nov 2026 03:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l0vwwNfX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622471F000C4;
	Thu, 19 Nov 2026 03:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058099;
	bh=InbVjpW6FYZ1wx3GZ/mPFXQdg3MAK/z8JABtZ9Z/4iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0vwwNfXnsgSumab9/gORzI+Url+HmTdrpukU5nzz20IE9whoYB9vfGDwks2Xwdgq
	 nXUrLj8vatulLa5LJ9HPctD3+6JDX5Xkz6+SO05o+BktL+AyNpt4D9Cm1rqdxXsFFq
	 eHljPWuoBK420U7/GTGuDJOniRtVi9F8qT0/E120=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0366/1848] media: i2c: tc358743: add missing color-space strings
Date: Wed, 18 Nov 2026 15:40:04 +0100
Message-ID: <20261118145928.583586369@linuxfoundation.org>
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
index ac0d3076d1124..06d54d8df450e 100644
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



