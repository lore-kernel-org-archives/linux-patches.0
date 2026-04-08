Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F76331A44;
	Wed,  8 Apr 2026 18:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673384; cv=none; b=UpRxPbKQQvCbFREhxR3Oe1kHiKn6IkACTvNlK+93mU3PhWsYDikGcT1jsJVJNJHXmEO47oOLD7jjgHorQqb4OzgYwhXa5OslGzQmirPufj9mLJJOfxKGOdUfjzfbQopvWCsWkXeqbHNYoUvrovOGxqX55BT+9ahKReYY0x5EqJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673384; c=relaxed/simple;
	bh=Spw4T/w+tPZSMEIF0WiaWkxAjYPx7uqs41eJGloytcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKaUG/tIsMJ+GIl314U2TCjWDk2iZw7GWoH9KHQnTAJzOyuk8/wOscx3AdpxJY7Ykv0Wdy8WateBGikJxNi9WXufQ8VBXmwXzKaWZjwAVj5CF72Ng1TxbCIISI2ifEfN7LH5RJw4wDiuc6UXdQYHc7cpWwlkmzp82X1j8z1eaK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJBrZb/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJBrZb/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC04C19421;
	Wed,  8 Apr 2026 18:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673384;
	bh=Spw4T/w+tPZSMEIF0WiaWkxAjYPx7uqs41eJGloytcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJBrZb/7i9vTS9svMHH97Noh3O+CRRRePfx3sOT/NBuQynd+RPuKDLzqr3jzqLLYe
	 iWolU0rfbf/pyNveJvAmQZN2kj1rY5ChEChLzQwOSNAdZB1eHEFOhX4ZZfkW8myf5Q
	 /yGu2HGId6u5fOGujjIioPH3UnIjRmr8TVn9wdjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Xilin Wu <sophon@radxa.com>,
	Sasha Levin <sashal@kernel.org>,
	Steev Klimaszewski <threeway@gmail.com>
Subject: [PATCH 6.18 210/277] ASoC: qcom: sc7280: make use of common helpers
Date: Wed,  8 Apr 2026 20:03:15 +0200
Message-ID: <20260408175941.703845163@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit 8fdb030fe283c84fd8d378c97ad0f32d6cdec6ce upstream.

sc7280 machine driver can make use of common sdw functions to do most of
the soundwire related operations. Remove such redundant code from sc7280
driver.

[This is a partial backport containing only the sound/soc/qcom/sdw.c
changes which add LPASS CDC DMA DAI IDs to qcom_snd_is_sdw_dai().
The sc7280.c refactoring changes are omitted as they depend on
intermediate patches not present in 6.18.y. The sdw.c change fixes a
NULL pointer dereference for lpass-cpu based SoundWire links.]

Fixes: bcba17279327 ("ASoC: qcom: sdw: fix memory leak for sdw_stream_runtime")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Tested-by: Steev Klimaszewski <threeway@gmail.com> # Thinkpad X13s
Link: https://patch.msgid.link/20251022143349.1081513-5-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Xilin Wu <sophon@radxa.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/sdw.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/qcom/sdw.c b/sound/soc/qcom/sdw.c
index 7b2cae92c8129..5f880c74c8dc2 100644
--- a/sound/soc/qcom/sdw.c
+++ b/sound/soc/qcom/sdw.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2018-2023, Linaro Limited.
 // Copyright (c) 2018, The Linux Foundation. All rights reserved.
 
+#include <dt-bindings/sound/qcom,lpass.h>
 #include <dt-bindings/sound/qcom,q6afe.h>
 #include <linux/module.h>
 #include <sound/soc.h>
@@ -35,6 +36,16 @@ static bool qcom_snd_is_sdw_dai(int id)
 		break;
 	}
 
+	/* DSP Bypass usecase, cpu dai index overlaps with DSP dai ids,
+	 * DO NOT MERGE into top switch case */
+	switch (id) {
+	case LPASS_CDC_DMA_TX3:
+	case LPASS_CDC_DMA_RX0:
+		return true;
+	default:
+		break;
+	}
+
 	return false;
 }
 
-- 
2.53.0



