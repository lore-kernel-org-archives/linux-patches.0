Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B4A155351;
	Tue, 23 Jul 2024 18:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759627; cv=none; b=jqFazjzxJx6bj6Xuqq4PbtZT5dt9vrtZwsq0TwUWlC3L9xpWULOYogxqwT/lb3vqkePyAm8xFiBD6MtIZGEdnth259WztIxXI8HhzNtigcBSv7C9CjqgoRDyywm/qJsLhink25AmkWtYbcBRs2xwrKo1HMQyOvqc+t/GHPbup74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759627; c=relaxed/simple;
	bh=tqZ/NR+krWymbnlfnaej8lcqflbl9aPQwEPJsvjhPsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cP5/zihrg003sPppP+2E1j0S6MRI2kB2LtmtlJ3vhEWo5dIk3wQ3xI3m9iMOStHRfjKTt6pN0XN6Oi88QYIa7qd9zoSpybkJl9tbtjky1k32ynAm7kpZ7rl3HjGW9eGFRgGzbT+NPOgW30g16YBeNkyrrwqdsGp/2Eg7SOSNQwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgGIq1RW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgGIq1RW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23753C4AF09;
	Tue, 23 Jul 2024 18:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759626;
	bh=tqZ/NR+krWymbnlfnaej8lcqflbl9aPQwEPJsvjhPsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgGIq1RWNlwtnT4y6C70/RyKpd0bRUv7tOafKhM2eu14u5MgP3msADqg2KDAlFJTo
	 2b2OIxC5ShI9CNfVhG3LqWKtmqcf33IW8gq94hNyk2sL+765CsGrpaJXVwIryy0fmc
	 a64AQLtyJFFpZYPi6pdIZVHnu4ZY+VzG1qNcH+3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/129] ASoC: rt722-sdca-sdw: add debounce time for type detection
Date: Tue, 23 Jul 2024 20:23:42 +0200
Message-ID: <20240723180407.643092606@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit f3b198e4788fcc8d03ed0c8bd5e3856c6a5760c5 ]

Add debounce time in headset type detection for better performance.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://lore.kernel.org/r/7e502e9a9dd94122a1b60deb5ceb60fb@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt722-sdca-sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt722-sdca-sdw.c b/sound/soc/codecs/rt722-sdca-sdw.c
index cf2feb41c8354..32578a212642e 100644
--- a/sound/soc/codecs/rt722-sdca-sdw.c
+++ b/sound/soc/codecs/rt722-sdca-sdw.c
@@ -349,7 +349,7 @@ static int rt722_sdca_interrupt_callback(struct sdw_slave *slave,
 
 	if (status->sdca_cascade && !rt722->disable_irq)
 		mod_delayed_work(system_power_efficient_wq,
-			&rt722->jack_detect_work, msecs_to_jiffies(30));
+			&rt722->jack_detect_work, msecs_to_jiffies(280));
 
 	mutex_unlock(&rt722->disable_irq_lock);
 
-- 
2.43.0



