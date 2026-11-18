Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033628;
	b=Az79CmPWWxyGMu5kbH9ornsSqp/P6O6iIG3uzgZODPHUimoauRt/EnKpM7vtJHeSrv76
	 5QXPEzdAv6OARg/RCqoGdpY+JeTmjXQkWFXMOJmy5IejRQhN8KUm5782Y6sYa8+oO4w70
	 JYSnCyn8CN6JM5RJxYG7vhwTeb+TZyyzJjx3oYy88NUCjgjd/js7B7/zkat28lgFWRo+E
	 mePWbIlUkTW0KJLQC/Y4bZThao0EQNperkzHxNF5bNghcA5sNk/8wHBpepseryv2ZXijw
	 XWFEI7QKGarA5xuFywGlJKS00zTDfHwZEgUF8fn225P06lKJssbiaUuvwktOdfVna0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PWYYjNalMDZxUD14naz8I30ilUiPRsDr14YF15E0bQ0=;
	b=3hlUVb+Ksbpk/LVJEXr+1dZFGe8cohE+0mESG0KAodvdivoCUrttBaPcyNkY1rsz1sPN
	 XhaUxvspOO/2UmF2MCGnGuzN1UL2htRD8cxG2j3n18WFd87C7Ir7Nncp+BMFO9f7oM3HR
	 Z4l7TK5x/8Tv0TGe3Afv6UqJUPv46Z7qcqy7srwbtft4VadR31b1HMk+/zTTUfHl4cYI1
	 A/BPY1Fh61lJ+u7E7UMi6dKF+OFpyvotkv8G0Nqja3hwEKFeCmIn2x4jZpkY47LEJDiEL
	 /18/MGlDFe9FSIduUfzm7YSwOStvtCHwztXZmlFld+869u0Q2kSikXCjkHfr/iMJVLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IkDwgMDc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C38606A325;
	Wed, 18 Nov 2026 20:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IkDwgMDc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD14A1F000C4;
	Wed, 18 Nov 2026 20:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033627;
	bh=PWYYjNalMDZxUD14naz8I30ilUiPRsDr14YF15E0bQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IkDwgMDctbEWJR8p+a3dyEkp3tC73tccEAihs0PIy5ORsqkqm3MpamPHfB7YeeM9e
	 tf3A9gpZD2spyMHmp4DotsfFQBzd6X2DyHHXZCTTCUp+HbR9Ff1MIZ1+kmJNttp8mO
	 LSsBhi6cXHaM3iXwP9lLnclvC4A7mePWNUkfonB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0083/3318] ASoC: codecs: max98396: Unwind supplies on resume failure
Date: Wed, 18 Nov 2026 15:11:45 +0100
Message-ID: <20261118150316.592909476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit d20de7409dfa8e3341af7f157cd42130bd4ba3a7 ]

max98396_resume() enables the core, pvdd, and vbat supplies before
leaving cache-only mode, resetting the device, and replaying cached
register state. The function currently ignores regcache_sync() failures,
and the optional pvdd/vbat enable failures return without unwinding
supplies that were already enabled in this resume attempt.

Rework the function to use common error labels. This propagates sync
failures, restores cache-only/dirty state on failed cache replay, and
disables each supply acquired by this resume path before returning the
error.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704040651.47558-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98396.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/max98396.c b/sound/soc/codecs/max98396.c
index 3a1d8c211f3c7..ac61df2549646 100644
--- a/sound/soc/codecs/max98396.c
+++ b/sound/soc/codecs/max98396.c
@@ -1603,19 +1603,37 @@ static int max98396_resume(struct device *dev)
 	if (max98396->pvdd) {
 		ret = regulator_enable(max98396->pvdd);
 		if (ret < 0)
-			return ret;
+			goto err_core_supplies;
 	}
 
 	if (max98396->vbat) {
 		ret = regulator_enable(max98396->vbat);
 		if (ret < 0)
-			return ret;
+			goto err_pvdd;
 	}
 
 	regcache_cache_only(max98396->regmap, false);
 	max98396_reset(max98396, dev);
-	regcache_sync(max98396->regmap);
+	ret = regcache_sync(max98396->regmap);
+	if (ret < 0) {
+		regcache_cache_only(max98396->regmap, true);
+		regcache_mark_dirty(max98396->regmap);
+		goto err_vbat;
+	}
+
 	return 0;
+
+err_vbat:
+	if (max98396->vbat)
+		regulator_disable(max98396->vbat);
+err_pvdd:
+	if (max98396->pvdd)
+		regulator_disable(max98396->pvdd);
+err_core_supplies:
+	regulator_bulk_disable(MAX98396_NUM_CORE_SUPPLIES,
+			       max98396->core_supplies);
+
+	return ret;
 }
 #endif
 
-- 
2.53.0



