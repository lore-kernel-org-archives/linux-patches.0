Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021808;
	b=HGrRnI9SePay/+/oFSVsO2Oo4JZBB0ar+gz3j1sDaaxOmaWOuJnsED/bwAl91EHU9vAA
	 FY/kwaBQat3crn2P5zBx3CWV4nS2b/J+1RL5nj+b1SQ298mTc6gpnPlXX2KnfPQvbiVhu
	 YYr+If5FCt8PI3+5YG1xdW1ek5sKn0X30F9/70g30b2CaN9dKz6DPRvt4TqPimssbowRh
	 FchbtTw1DsWAxPK78Cs3GFjSNkuu5Oqc1CeteV3U8tDUMXf6sQiy14jxoT6TC9igSL94Z
	 I0TZOjo3EWnXkIeBINqNX4o1Nt5/xvuzmdFFKiYKgoU2uUxjFiMtDYAsj/34UK6lBZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4RF63g/UhnAV6o70MfI3abV1XHZFkug2vTrf3DneYI4=;
	b=5DW+T4ANQWszBzDSJq5iqBZ4cQj34BfSVgISOQ4s2xLo0fLVGR0dXeGFwAInz+i0pxUs
	 U6VjbG96fRFwl3ghuDfQxv6LExNAC6RVdUpvLO9ReY4Eqz74Rfv8fdlKJPr18nEx9VS5g
	 Vt4DPlIuoxBTXFznSoc0iRSnce1iW4gS5VaHKlJKeuQyWsYNfaAvgm8zdiEIfHp+PVXC1
	 QiBdpaEKxQ6HkCRACRi8NXdCxdKuFpQrfP3EZ6ZKmyCXBqYNH6qrveqbc5u//Il3K/asn
	 9HiMZS6L5DcsQOLT1hmz4544ahvZLDbCJ4rr0/Tu2aLXzLLsEcB4nMefpcxvNjZfABQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KoxPF07h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB5560A2628;
	Wed, 18 Nov 2026 17:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KoxPF07h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824361F000CA;
	Wed, 18 Nov 2026 17:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021808;
	bh=4RF63g/UhnAV6o70MfI3abV1XHZFkug2vTrf3DneYI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KoxPF07hARNfAQgW/qzpiVNS85XEEeeUeDsNUvp1MmO3X6l+UisxOv/WSB2zpk66v
	 tU+WjJnxXYP8UbAzBHKphde60N/psXFUl+pqn8ok7IHvlwqowkLReTHBaJwZ78RkVi
	 vu/PApz6UCmivdjbJ4vH72I09AObn3/jh+7GpvzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2437/2651] ASoC: codecs: wsa883x: disable runtime PM on unbind
Date: Wed, 18 Nov 2026 16:01:17 +0100
Message-ID: <20261118150412.921262972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit ea63182d71956dc33c6f08dc4171f1052f8409a9 ]

Probe enables runtime PM but nothing disables it on unbind, or when
registering the component fails. A pending autosuspend can then run
wsa883x_runtime_suspend() after the devm-managed regmap is freed, and
dereference NULL, as seen on wsa884x.

Use devm_pm_runtime_enable() so runtime PM is disabled before the regmap
is freed.

Fixes: 43b8c7dc85a1 ("ASoC: codecs: add wsa883x amplifier support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261023171316.819857-6-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa883x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wsa883x.c b/sound/soc/codecs/wsa883x.c
index ccd4404c1644e..b09ee3db7ed58 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -1669,7 +1669,9 @@ static int wsa883x_probe(struct sdw_slave *pdev,
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		goto err;
 
 	ret = devm_snd_soc_register_component(dev,
 					      &wsa883x_component_drv,
-- 
2.53.0



