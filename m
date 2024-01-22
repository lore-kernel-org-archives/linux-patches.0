Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3C51292EC;
	Tue, 23 Jan 2024 00:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971004; cv=none; b=caHMJtM78AWVvChnuk9vx7PA7nXb+6r7n4Q0vcwADZQdaKYqWiKXwF+5p+DdbNed7quMC3myxJFSHTVViJ2kBhaJd+UEe6xk3749qTOy2dcb+4owFKrLPyiirJcymPnXZpYX+1myDLSWz6kmWOyBZ6B6nmNzUwHeBlvZan134mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971004; c=relaxed/simple;
	bh=q4pB6jV+6BBGt6nKwg9FV9TvaF0xZlht6JGFmk9KGqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjSZNXdp3u/FTAa9QUBUCVLtPJVs9gaQH2o+s9kZgPu6e0CfrMUAChWyLEc7XbWNGnDEk6/WXkj/zGV0s9PCXyOO64xvv2qD4k1l2tJDYmaQwwvQaTMV0bO2K49eUBZPR9pX+FJ0Ec3wayB0Y7/SsrmJrXtxjrRUmJ8LnwI6t98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/GlNQki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/GlNQki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2B3C433C7;
	Tue, 23 Jan 2024 00:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971004;
	bh=q4pB6jV+6BBGt6nKwg9FV9TvaF0xZlht6JGFmk9KGqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/GlNQkiThq04zXGMgslF18ow6pnPqmxVBNs88S+yxL2bHR7xGrFTSgTHkhuWwqe4
	 HyqNRQgxzWfI8E0OacnTAEQJm3icRSSaE4jei+Xpfrp9wnjxEZVvIAvoDB+2+3b8Ec
	 qZ0D7umgxu5CCBrRgcRrko5p0HH09RbUJZtoZNsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 161/417] drm/panel-elida-kd35t133: hold panel in reset for unprepare
Date: Mon, 22 Jan 2024 15:55:29 -0800
Message-ID: <20240122235757.416716453@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit 03c5b2a5f6c39fe4e090346536cf1c14ee18b61e ]

For devices like the Anbernic RG351M and RG351P the panel is wired to
an always on regulator. When the device suspends and wakes up, there
are some slight artifacts on the screen that go away over time. If
instead we hold the panel in reset status after it is unprepared,
this does not happen.

Fixes: 5b6603360c12 ("drm/panel: add panel driver for Elida KD35T133 panels")
Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Reviewed-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Link: https://lore.kernel.org/r/20231117194405.1386265-3-macroalpha82@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231117194405.1386265-3-macroalpha82@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-elida-kd35t133.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-elida-kd35t133.c b/drivers/gpu/drm/panel/panel-elida-kd35t133.c
index eee714cf3f49..3a7fc3ca6a6f 100644
--- a/drivers/gpu/drm/panel/panel-elida-kd35t133.c
+++ b/drivers/gpu/drm/panel/panel-elida-kd35t133.c
@@ -112,6 +112,8 @@ static int kd35t133_unprepare(struct drm_panel *panel)
 		return ret;
 	}
 
+	gpiod_set_value_cansleep(ctx->reset_gpio, 1);
+
 	regulator_disable(ctx->iovcc);
 	regulator_disable(ctx->vdd);
 
-- 
2.43.0



