Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA99F2566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DAE8C433D2;
	Tue, 18 Apr 2023 12:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821235;
	bh=wzmQDfNKTv0VFuShfuXDQ3CMxFViahBXUkJvsNOXfkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e54QG+TDjO80H1b17khcD1CftvikEI+s+lbHi8BDCUIdeGUMT5H8Pw1Wk7vdz0XQO
	 7WNGts59v57ttaH7nQKnqR144/WWm80dIxZ4lQaMvTGMR38l+AL0VQD+9rv8sRJzE+
	 BEr8gQ7gXXOPSwaxtImQ8dNGmShVB3pYT2zrL5Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Pundir <amit.pundir@linaro.org>,
	Robert Foss <robert.foss@linaro.org>
Subject: [PATCH 5.10 049/124] drm/bridge: lt9611: Fix PLL being unable to lock
Date: Tue, 18 Apr 2023 14:21:08 +0200
Message-Id: <20230418120311.622865442@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robert Foss <robert.foss@linaro.org>

commit 2a9df204be0bbb896e087f00b9ee3fc559d5a608 upstream.

This fixes PLL being unable to lock, and is derived from an equivalent
downstream commit.

Available LT9611 documentation does not list this register, neither does
LT9611UXC (which is a different chip).

This commit has been confirmed to fix HDMI output on DragonBoard 845c.

Suggested-by: Amit Pundir <amit.pundir@linaro.org>
Reviewed-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221213150304.4189760-1-robert.foss@linaro.org
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/bridge/lontium-lt9611.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611.c
@@ -256,6 +256,7 @@ static int lt9611_pll_setup(struct lt961
 		{ 0x8126, 0x55 },
 		{ 0x8127, 0x66 },
 		{ 0x8128, 0x88 },
+		{ 0x812a, 0x20 },
 	};
 
 	regmap_multi_reg_write(lt9611->regmap, reg_cfg, ARRAY_SIZE(reg_cfg));


