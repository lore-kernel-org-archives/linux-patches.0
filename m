Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048761;
	b=iz0B/JHoWJ+5QSfTTXDcyrAoCfi5JRXxmnMwb55J2txp4QEyr/C5wW03zZ/SQk2sp1In
	 bQPn3ACXrubnJecPu9EZl0Y0BnNhA082iyMdZNp3Nix4aC4nzdno0VPM5wlJvcnVc/kiJ
	 XoMPXnOvBEQw+gngmhLaemrpm60uGGYSJWlU6PEOdgPX1I5INAwUSI4EpL18m2eWsQyUf
	 JynZlxJdLOPdZtC/f4rrDUnbd+Zl2fFU0o6aSeZ63DncM3KOEZmlIIKyuh+V76cG3lyNG
	 5Eum7wx+YVUHH4U0EUzR1mCwGnduwnCGBDMZ8YqOQSh5FLIykapUncnezoEdmtSmWIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bj9KaBfxqAOjssyNYbCv5u/x6AXeztHd3xBcSfv9qv8=;
	b=Wv2KaoZvFw5ADa+KoIAMLdyeFHNlBHquijgq6Hnk/zQpHdI6RyRFUjHEUFIfnAG1Gzrx
	 gzhKO8zOLPZSoveen5jDmpaT74rtxiXFxsMZ+eZbywVtZvZupV7ANqqXS0BMQT2zKUag5
	 OlNuKKJDF9UT5G/OB5HNYGO7L1hawHYWmMOhsNHHBengxGGYZOsocRUU5oQIoM7izdz/d
	 mmSxLyjT9zFd0jtrKBDSjPkvOM37UwVrBnPAnQw+ylJqYz7DKD7P5X+ovy95nuFzGxI5h
	 gRodEhTengNndgmneHt7hu88KKjpCsbQlFVxLc9DXjPooJQd0merG4VNCey6ddLaQeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J4SpEjwE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFF0606A320;
	Thu, 19 Nov 2026 00:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J4SpEjwE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B640E1F000C4;
	Thu, 19 Nov 2026 00:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048761;
	bh=Bj9KaBfxqAOjssyNYbCv5u/x6AXeztHd3xBcSfv9qv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J4SpEjwEXjnWZixbWEU7h6U2oEZ/zxrhTfHpCu3I4Cn/Yan9RjHOrcDm6RpF6jnfk
	 eCMNkQNCiUTcJmiQ7oHbH3URpAP0Qo0iEpetUM2hlovMN6uNqBILLz2hh6H/C/imaS
	 TeuWvMfDGVDVyszsT2OW1pO+XqlxypSQV05jwQtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2109/2857] ASoC: mediatek: mt8192: mt8192-afe-gpio: Use guard() for mutex locks
Date: Wed, 18 Nov 2026 15:52:23 +0100
Message-ID: <20261118150317.348680178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 14edf39daefbf7aa689ea2bb8811a85c498e0ff6 ]

Convert the explicit mutex_lock()/mutex_unlock() pair to guard(mutex)
to simplify the locking logic and automatically release the mutex on
all exit paths.

This changes the mutex release point from immediately before dev_warn()
to automatic cleanup at scope exit. However, the affected path only emits
a warning and immediately returns -EINVAL, without any further processing.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260610102021.83273-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 411be3902fa8 ("ASoC: mediatek: mt8192: Propagate errors in mt8192_afe_gpio_request()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-gpio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c b/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
index 165663a78e36a..88dca80cd69c7 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
@@ -209,7 +209,7 @@ static int mt8192_afe_gpio_adda_ch34_ul(struct device *dev, bool enable)
 int mt8192_afe_gpio_request(struct device *dev, bool enable,
 			    int dai, int uplink)
 {
-	mutex_lock(&gpio_request_mutex);
+	guard(mutex)(&gpio_request_mutex);
 	switch (dai) {
 	case MT8192_DAI_ADDA:
 		if (uplink)
@@ -297,11 +297,9 @@ int mt8192_afe_gpio_request(struct device *dev, bool enable,
 		}
 		break;
 	default:
-		mutex_unlock(&gpio_request_mutex);
 		dev_warn(dev, "%s(), invalid dai %d\n", __func__, dai);
 		return -EINVAL;
 	}
-	mutex_unlock(&gpio_request_mutex);
 
 	return 0;
 }
-- 
2.53.0



