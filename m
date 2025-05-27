Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744F727F737;
	Tue, 27 May 2025 16:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364826; cv=none; b=ePn93H4ov94ysfEvjSJlia7XRff1IP8qcpm39iDWJ72fSLe1mae/nXfGdc+zm/vUuIBwH7tcssK0EC5sJgp+O3YGWvh7024L7lJbu2jXv0mH91irslr33VFgGqmsLecs+i5VeXCXTAZJ7FyBqacpQpmDkgSOGi+V/DSuJkzd9jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364826; c=relaxed/simple;
	bh=ZpteNH8DkMwsABoeg06nTbKDl3sPG2b/lyPcWy+7mXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uj5yJv943vDyNZXJa9BR0zLXNR5RjEQ8z5STfbYxD6S2PWNhGh3cPYN24XCElPMZFawB1MTPaW0nbgS57oeRrtGo6ZxRybjM6ejik9417/t8bapfo2X40omt6vKXZNSgS0uI1P+I05Z2tdNzT1tl+tQP2NXr+NYrfgfW8ye+kmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9x1e60Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9x1e60Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5490C4CEF1;
	Tue, 27 May 2025 16:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364826;
	bh=ZpteNH8DkMwsABoeg06nTbKDl3sPG2b/lyPcWy+7mXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9x1e60YxH4uIDlcMT6A5M/QrsXjSDOyobhXXitH9LTT90emjW4Qk8VcNc2DUte9H
	 bpSDf+VzHWqc2nECNV0uV2gLX8czv7iSoAUGCtRMHaLnDncD9pWNWdRC4673S8k/i3
	 fttOelnOxYy9aU+ikO9H/aFULHxY8NwYTqIuQHhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/626] ASoC: mediatek: mt6359: Add stub for mt6359_accdet_enable_jack_detect
Date: Tue, 27 May 2025 18:20:41 +0200
Message-ID: <20250527162451.041363974@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 0116a7d84b32537a10d9bea1fd1bfc06577ef527 ]

Add a stub for mt6359_accdet_enable_jack_detect() to prevent linker
failures in the machine sound drivers calling it when
CONFIG_SND_SOC_MT6359_ACCDET is not enabled.

Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://patch.msgid.link/20250306-mt8188-accdet-v3-3-7828e835ff4b@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/mt6359-accdet.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/codecs/mt6359-accdet.h b/sound/soc/codecs/mt6359-accdet.h
index c234f2f4276a1..78ada3a5bfae5 100644
--- a/sound/soc/codecs/mt6359-accdet.h
+++ b/sound/soc/codecs/mt6359-accdet.h
@@ -123,6 +123,15 @@ struct mt6359_accdet {
 	struct workqueue_struct *jd_workqueue;
 };
 
+#if IS_ENABLED(CONFIG_SND_SOC_MT6359_ACCDET)
 int mt6359_accdet_enable_jack_detect(struct snd_soc_component *component,
 				     struct snd_soc_jack *jack);
+#else
+static inline int
+mt6359_accdet_enable_jack_detect(struct snd_soc_component *component,
+				 struct snd_soc_jack *jack)
+{
+	return -EOPNOTSUPP;
+}
+#endif
 #endif
-- 
2.39.5



