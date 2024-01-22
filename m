Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93DD13BE9F;
	Tue, 23 Jan 2024 00:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968135; cv=none; b=ZeX0bPJz4hDJl8/8K+Cnj+XMd6amBMzr/V4BmLB1PYBzYpQOTYKaV96rwORDimX8jn0l8WSnruiUPY1Bg9Ja/J8Rr20WaihNsAxe7UA4dYvRdVQmEAQwZ9tJDqCz0vghI77bAFnwNp0OwsH+4yASyb2do6vPfIEWS3vls0vcHsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968135; c=relaxed/simple;
	bh=9C4BHFFK8M3vledS6/sAYw09Xw+KjAGsM/HmF4WXNVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+NbIwL0bh4MQeRYCAM7p5h8D1SUgY7bSnd2Ab5PU+HB/a+Wl2VnQnc5keFy7YohM6iteB4FAJp9THaUPnwSpc4v277Cd8qxBRQ0qwSGPymApAOw0+bhD3tP4GiagAfN7NilbdmRjFNu/wIw3xVv7KnzxfVlidFUGEdynu/skiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3pye5Xs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3pye5Xs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A5AC433C7;
	Tue, 23 Jan 2024 00:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968135;
	bh=9C4BHFFK8M3vledS6/sAYw09Xw+KjAGsM/HmF4WXNVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x3pye5XsTP2pCwpvrv0PuxE0AJ1qTY1JWJeNdmirSzuvjFQQBa0C8yzqP8npVnNHR
	 AAcYo4ChC+rzmwsQzb/1Tlk9aFIvxpXNuHGRXAmpXWiFrkOp+Kg3kG91pMpBWdBuk4
	 NbkzftTCjUe5pZ8DcJV/vY6wXdnH+XZ0Qr28H+mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 004/148] ASoC: cs43130: Fix incorrect frame delay configuration
Date: Mon, 22 Jan 2024 15:56:00 -0800
Message-ID: <20240122235712.612413847@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit aa7e8e5e4011571022dc06e4d7a2f108feb53d1a ]

Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20231117141344.64320-3-mstrozek@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs43130.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs43130.c b/sound/soc/codecs/cs43130.c
index 95060ae7dbb4..0ffd93564555 100644
--- a/sound/soc/codecs/cs43130.c
+++ b/sound/soc/codecs/cs43130.c
@@ -581,7 +581,7 @@ static int cs43130_set_sp_fmt(int dai_id, unsigned int bitwidth_sclk,
 		break;
 	case SND_SOC_DAIFMT_LEFT_J:
 		hi_size = bitwidth_sclk;
-		frm_delay = 2;
+		frm_delay = 0;
 		frm_phase = 1;
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
-- 
2.43.0



