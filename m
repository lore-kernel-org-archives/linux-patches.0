Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C56C13D;
	Thu, 30 Jan 2025 14:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245682; cv=none; b=LevnWUZlOycrIQnQV9E7rcqFS8c2UzOvGU0uW9uHrCVoarpspXm8IGLUyA00td93jh9Xa3q5jirdgg01P7JkKVexm2N/Gmg/H0ln1OROmw1E5P8eA69sUli8XyEESwmN8qt+FYNOZqIvqHkMxFFWVf9rmv64tnbVIsvbwLpwsqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245682; c=relaxed/simple;
	bh=EYmn4ycpfh6GqeN1K0LNixs0Pkt9FJbPoP24lXqO6SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4Y7oSliqZRAbaF77KUBNF+eNe/thwPrAu2JJBp93BUDAB71zrnGfj69f4UG8cGHlTMoDftXAiE6pdpWnZzYhEwr7KI/Dz8iMcMoxKU5yBejA5fIQcCgPbIJyvYD2X7t9DZXDdmlQ0oIeoTDtUj82pNB5xtkEp2DBRlMQn15wp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KbkSvOkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KbkSvOkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BC3C4CED2;
	Thu, 30 Jan 2025 14:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245682;
	bh=EYmn4ycpfh6GqeN1K0LNixs0Pkt9FJbPoP24lXqO6SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbkSvOkbsDhIX3hiNeWWsKja2FvmXE58u6LBdKNpgUVYUQZGS5VXRh2wbnLJaYanx
	 lWvmk3pS50fik0KpGLFnTMjWXI3BnMaUZNEk2vLg9IVjqtzkHqrdUq+Nshn1GLE6Jw
	 h9F8lC9PKdWW+jBu5r5KZ9KCHwALcMD4a8ZRcuqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 05/40] ASoC: cs42l43: Add codec force suspend/resume ops
Date: Thu, 30 Jan 2025 14:59:05 +0100
Message-ID: <20250130133459.918061024@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit 8f0defd2e52d22eb994d7e770b1261caa24917d8 ]

This ensures codec will resume after suspending during playback.

Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250109093822.5745-1-mstrozek@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l43.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/cs42l43.c b/sound/soc/codecs/cs42l43.c
index d0098b4558b52..8ec4083cd3b80 100644
--- a/sound/soc/codecs/cs42l43.c
+++ b/sound/soc/codecs/cs42l43.c
@@ -2446,6 +2446,7 @@ static const struct dev_pm_ops cs42l43_codec_pm_ops = {
 	SYSTEM_SLEEP_PM_OPS(cs42l43_codec_suspend, cs42l43_codec_resume)
 	NOIRQ_SYSTEM_SLEEP_PM_OPS(cs42l43_codec_suspend_noirq, cs42l43_codec_resume_noirq)
 	RUNTIME_PM_OPS(NULL, cs42l43_codec_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
 };
 
 static const struct platform_device_id cs42l43_codec_id_table[] = {
-- 
2.39.5



