Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3A03ED5C7;
	Tue, 17 Mar 2026 16:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765810; cv=none; b=uifUoM9IgLpbPkZgLFfuWSF1hBQgnkbZliMMGP1b2E7se9FO5FLxAbT3SeEAPeF6WbZU9uuNpdtKT47rc0pOX0PgNZZatDDS0H/k1Z8+Cov3ZbLik6s+Dwwiq/+eXl0aozywlzKOHjvpDIdAUj5AiEbXVS7lhX3oU6JQUWE6WHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765810; c=relaxed/simple;
	bh=5XR+5QMgDlrFVy4zZI0zR4MYe1alQ5bIThSP/4Qz/nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swNxVXrVlbQ8GObfbH9eiy6AyLKK26ZrEJxkq4tSeuOMe58caOyPN3fAkLFKvwpr8akj91A6fsOtq4l+Vt4bvWh7JLUdiSZfNuJpltSzIgz7QofJaWVH4oKLlrxiFfg2KDTj7gdQp2lSyAJA4QrkXMruF0eOUKaJVhZMcBs4JcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yI88WakS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yI88WakS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6582CC4CEF7;
	Tue, 17 Mar 2026 16:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765809;
	bh=5XR+5QMgDlrFVy4zZI0zR4MYe1alQ5bIThSP/4Qz/nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yI88WakS3/2PKG6zmYe3IH2zpTAfcL287b6WjjlAvfv0q0QLjlDDwGjb/o5hu6Qhu
	 jj6vMR8HWC2iyqwtCVQ06gs6E37PpQxcHTUEiYT+NbS4+2CLl+OwrFzUZ1eBZrkB43
	 BVw1UzWh8Tqbt3a9BcEToOWwmrpCJ9dZ7+rFRXyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 092/378] ASoC: codecs: rt1011: Use component to get the dapm context in spk_mode_put
Date: Tue, 17 Mar 2026 17:30:49 +0100
Message-ID: <20260317163010.403106398@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 30e4b2290cc2a8d1b9ddb9dcb9c981df1f2a7399 ]

The correct helper to use in rt1011_recv_spk_mode_put() to retrieve the
DAPM context is snd_soc_component_to_dapm(), from kcontrol we will
receive NULL pointer.

Closes: https://github.com/thesofproject/linux/issues/5691
Fixes: 5b35bb517f27 ("ASoC: codecs: rt1011: convert to snd_soc_dapm_xxx()")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260310065350.18921-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1011.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt1011.c b/sound/soc/codecs/rt1011.c
index 9f34a6a354876..03f31d9d916e6 100644
--- a/sound/soc/codecs/rt1011.c
+++ b/sound/soc/codecs/rt1011.c
@@ -1047,7 +1047,7 @@ static int rt1011_recv_spk_mode_put(struct snd_kcontrol *kcontrol,
 		struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
-	struct snd_soc_dapm_context *dapm = snd_soc_dapm_kcontrol_to_dapm(kcontrol);
+	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
 	struct rt1011_priv *rt1011 =
 		snd_soc_component_get_drvdata(component);
 
-- 
2.51.0



