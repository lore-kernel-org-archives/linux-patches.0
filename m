Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982DE30CDB7;
	Mon, 13 Oct 2025 15:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369184; cv=none; b=YXHcIdARe2mTEYQ/m+O1P+Tv16VY7BEjbSv2gH8GWnZk23uRxNKGmwNwrM+yiQTfTSV7CoiuqAY3uTYrMxnutN1ogSevWuKr9qlFvVex/F+8S1Wup8SP2M/ful3PmdI91QwTtqQbFamcvf2dzPOejojKYdpkMxSyYUHT4byAAhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369184; c=relaxed/simple;
	bh=NzaMegead0bwEbYROQFYLJ6tYo867EvRNwuDSmsLF2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sj4mvas0SkCGf8wgRirmiKYVftKHDnt1PWHqlATInkq8TcppefzLXPP7f5qznmRPHXMzduez/nr9+cqbRnak73et7aaa2fJTsxpW42fly+iaZ91vFMkKGToxsXa0m3W17pA90oSeJZca1q1PmU81pABWYP1AM4yoizG3TT0GLro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZyOolsPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZyOolsPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E22C4CEE7;
	Mon, 13 Oct 2025 15:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369184;
	bh=NzaMegead0bwEbYROQFYLJ6tYo867EvRNwuDSmsLF2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyOolsPC27bHmmZ7PE1kih2QMpCIZN0Ive9c2QcXccMVhW3OHu0X9FiqP92Ct3o4i
	 yKLile5pnKULl06cJlKIOpyP4jy31Hv76SOIlg8Z7NHUeh0GZ8E8zL03n/fCQLg/rm
	 8lvcMdc4SuznP9tv/+jlMAXvKeoSA9MKA66uaqm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 156/563] pwm: tiehrpwm: Make code comment in .free() more useful
Date: Mon, 13 Oct 2025 16:40:17 +0200
Message-ID: <20251013144416.941600662@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 878dbfc12cc52b17d79d205560c0fafcf5332b13 ]

Instead of explaining trivia to everyone who can read C describe the
higher-level effect of setting pc->period_cycles[pwm->hwpwm] to zero.

Fixes: 01b2d4536f02 ("pwm: pwm-tiehrpwm: Fix conflicting channel period setting")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/4c38dd119a77d7017115318a3f2c50bde62a6f21.1754927682.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-tiehrpwm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 5e674a7bbf3be..a94b1e387b924 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -391,7 +391,7 @@ static void ehrpwm_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct ehrpwm_pwm_chip *pc = to_ehrpwm_pwm_chip(chip);
 
-	/* set period value to zero on free */
+	/* Don't let a pwm without consumer block requests to the other channel */
 	pc->period_cycles[pwm->hwpwm] = 0;
 }
 
-- 
2.51.0



