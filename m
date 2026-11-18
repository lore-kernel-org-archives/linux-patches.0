Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050512;
	b=Kk7TtAsD7Fi9WXkr4CVZnuLsl7N0Z9BSbyxpllVbIxqj4pISPkR9V/4NvJ6YS4aWTYDb
	 IaWxwCgpai9F38aseFHg51BWXIFa6IQH/iIrgLTIypSPrJ8tA/T7cYMwQshyq7BFbK4NJ
	 o9Xd3Oioay5QVwwwzqlVfIc6k9hnoi4mcmT9oMhQ6rihlQ1iV3rx1c27iBlWvub4SsUer
	 DGf9ZQfL6YYiwhtbVFacRgr0E76JSAXQEMGNpJKQktT3s0pVuMz8h/qnFQ0iNbnfGRimB
	 m6DEMNUjr7vN1654xceVFu27OkhAwI4bkf09XvlhN5AJgpnH5h0GazELyji6/O4YSrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2TqZVc2to0x1bZDS9zPjuAVpoxKUeXAmtXMJ7rFfAtw=;
	b=OfpCpVcB4OxriGJvV7orHRHacsHYmq4uKZWEwUyF1b/oDWPuzsb5K/e6FZdMBI1ZKimH
	 esaote/8ZGagyLPmLddXkAA3+wKORdHqyVJF+M21L4X1SS6pKN8HnHA0folIO8afsFyV3
	 0U3WHHUr0DSTkcCyYWTct6P38soCfsDCf2ZNIgnFf9uvpqEDUt8/zY9lSrBLOIDBRvcXX
	 tW8J9sO20e1Nxx7OqQmdEuwDgvBf5izlP924LnTJsoYW1aNYLsb1EK5sHZ1+GcATVHIr2
	 /O2HulwFlbDTobmkckn+rLUlgFfAxeLLxyzSpvLbs8+tnfRcCb6DRIUglar43BZby0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEntPLiG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F34606A325;
	Thu, 19 Nov 2026 01:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEntPLiG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DBB1F000C4;
	Thu, 19 Nov 2026 01:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050512;
	bh=2TqZVc2to0x1bZDS9zPjuAVpoxKUeXAmtXMJ7rFfAtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEntPLiGViT0Z2DLGBBXpo11vdQ9WuXYAuTcQ0AuV7lRMvahb8cYJ63209dOPzle7
	 EuTSNqYtWwv4jtsipXRZE/pVuSVg8jvbUKnHyfUj244Ef3QCXwHwT6xF6iIVlhwBgR
	 oILJ+sfar0j/Mp1zfkkOEH9N6wULI22DdHv4zqSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2734/2857] ASoC: codecs: wsa883x: disable runtime PM on unbind
Date: Wed, 18 Nov 2026 16:02:48 +0100
Message-ID: <20261118150340.065813316@linuxfoundation.org>
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
index 94ac6729cb016..8b50a0b351884 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -1449,7 +1449,9 @@ static int wsa883x_probe(struct sdw_slave *pdev,
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		goto err;
 
 	ret = devm_snd_soc_register_component(&pdev->dev,
 					      &wsa883x_component_drv,
-- 
2.53.0



