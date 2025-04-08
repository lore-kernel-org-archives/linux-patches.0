Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73548267F4A;
	Tue,  8 Apr 2025 10:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109886; cv=none; b=q296GfsOUxoutPsUcokltgVRjF0EwxWXYZYr+n+AejGrhjZshSiwfAbctqn3rjTWH75rjseKnGREQ/T/4YKjbmrnfFPTuo6aA8tPkRP0HpfAnKvQq8xdgtZLcH7BzXkIQbnvYvoCZLOXIf4IydHaWcvHziN/XwgnoLojLHFBhf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109886; c=relaxed/simple;
	bh=x6BtPaSivcRk3t4dHOTgDcP6Vkvw1zgZVz6/q4hp0ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+D8A0HMkLhgFiU2M6l+3tx9g2PFADXZUyPCPD41cDoK8bnEBxswZIE69zxhBbUs+kX333l6g5tpYDROXejFj4e/Hv3q9niBWwM9H+1n2rKJQovY+OaQ3bMXGWeFrTfly7Bie6o5kLgKbGdbQ3j7wvCMRAHGnSy89uCpXj06mTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=miG6W5/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="miG6W5/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35D1C4CEE7;
	Tue,  8 Apr 2025 10:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109886;
	bh=x6BtPaSivcRk3t4dHOTgDcP6Vkvw1zgZVz6/q4hp0ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=miG6W5/mguHLOR8C0h+NXJ+jAio6eAt9Ir51+aXjD7h0xmPrLwSojt1W2Ig1BIIPM
	 AXJPumCrGQaFsRWQNnC19IhMcTa1K+Tq7aAKJ5ebG3XNAFzP7eVCNAgVFIpouNntya
	 EpyJgIqDWrSsvtsS3XjIVDBJWGc0K/d9hhOHTTXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Hector Martin <marcan@marcan.st>,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/227] ASoC: tas2764: Fix power control mask
Date: Tue,  8 Apr 2025 12:46:58 +0200
Message-ID: <20250408104821.609513580@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Martin <marcan@marcan.st>

[ Upstream commit a3f172359e22b2c11b750d23560481a55bf86af1 ]

Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: James Calligeros <jcalligeros99@gmail.com>
Link: https://patch.msgid.link/20250218-apple-codec-changes-v2-1-932760fd7e07@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2764.h b/sound/soc/codecs/tas2764.h
index f015f22a083b5..b18a637bd9fa3 100644
--- a/sound/soc/codecs/tas2764.h
+++ b/sound/soc/codecs/tas2764.h
@@ -25,7 +25,7 @@
 
 /* Power Control */
 #define TAS2764_PWR_CTRL		TAS2764_REG(0X0, 0x02)
-#define TAS2764_PWR_CTRL_MASK		GENMASK(1, 0)
+#define TAS2764_PWR_CTRL_MASK		GENMASK(2, 0)
 #define TAS2764_PWR_CTRL_ACTIVE		0x0
 #define TAS2764_PWR_CTRL_MUTE		BIT(0)
 #define TAS2764_PWR_CTRL_SHUTDOWN	BIT(1)
-- 
2.39.5



