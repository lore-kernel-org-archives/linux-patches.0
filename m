Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7F71BD51B;
	Tue,  2 Jul 2024 17:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940079; cv=none; b=Jw07EKmzktplwc842n8szXCDohDx+0/gdbF9VrntUl6B0661Vh4pwDgS827dSKoHz8/FD1m6YArp8ma70wiOxK0LjuW6DUvLRQWgl5BoDnce6QJ8MPhr+fvllFphBiiZwYjoHrJ1GHyLTgo6S07/Q3Rnnm62AXynecXohmayvSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940079; c=relaxed/simple;
	bh=J4tV59TfLx04wl2g0R1AmfHnY3p3fLvtJccEfl/3ekc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIVF6p1cgogVul/ol4Ta9pJ3pDIci8C//4HrAPC7DoS+DZdVW0iRChMgB2a2bPeBVl2hCrCUMi+Q9gO7ajafCdjxnDI9ZmYEOkGlrc6uy11CTgKfncOXZmAL/HVqkeXUWSZPO8xjlEaPFRuYiYVMsHD63J7zNEKq9wDOqSr1DfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEC6TiU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEC6TiU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296BDC116B1;
	Tue,  2 Jul 2024 17:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940079;
	bh=J4tV59TfLx04wl2g0R1AmfHnY3p3fLvtJccEfl/3ekc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEC6TiU07zKWb92VkOqqTspfQ08Gz88dqF91xDZj0A9E3RWkIMeW37SRyjyOgsZNV
	 9hkaOpGjfcHZIss3l+E3atz5MEobneX3D8Iptc84kwVRYUgewVcd+rgDzN8S1kGcXU
	 fISzT0SYOvHdyi4p0ZMIC0MzNgfSaJU5WKzGbKiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 015/222] ASoC: cs42l43: Increase default type detect time and button delay
Date: Tue,  2 Jul 2024 19:00:53 +0200
Message-ID: <20240702170244.557016477@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit afe377286ad49e0b69071d2a767e2c6553f4094b ]

Some problematic headsets have been discovered, to help with correctly
identifying these, the detect time must be increased. Also improve the
reliability of the impedance value from the button detect by slightly
increasing the button detect delay.

Fixes: 686b8f711b99 ("ASoC: cs42l43: Lower default type detect time")
Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://msgid.link/r/20240604132843.3309114-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l43-jack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs42l43-jack.c b/sound/soc/codecs/cs42l43-jack.c
index 901b9dbcf5854..d9ab003e166bf 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -121,7 +121,7 @@ int cs42l43_set_jack(struct snd_soc_component *component,
 		priv->buttons[3] = 735;
 	}
 
-	ret = cs42l43_find_index(priv, "cirrus,detect-us", 1000, &priv->detect_us,
+	ret = cs42l43_find_index(priv, "cirrus,detect-us", 50000, &priv->detect_us,
 				 cs42l43_accdet_us, ARRAY_SIZE(cs42l43_accdet_us));
 	if (ret < 0)
 		goto error;
@@ -433,7 +433,7 @@ irqreturn_t cs42l43_button_press(int irq, void *data)
 
 	// Wait for 2 full cycles of comb filter to ensure good reading
 	queue_delayed_work(system_wq, &priv->button_press_work,
-			   msecs_to_jiffies(10));
+			   msecs_to_jiffies(20));
 
 	return IRQ_HANDLED;
 }
-- 
2.43.0



