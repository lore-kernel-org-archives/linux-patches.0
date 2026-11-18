Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034766;
	b=A8Z4RvtGlUsWoZq7o7WoEvCxPH9JemW6HontZpk4xtefPckoeyuNsJplz4zB06SkvLfM
	 2Tlk7K/2K5uL+Af9U4fY0E17V7TymdWF13m6dPWm39aTZ+s0N5A+tzackVaXnFe2ypK70
	 14xK4psYsagudJ7R/wnuhNs41J9+WqNy+tdCDs0ncTZrXAl4I++R/2F2Qt1vQVQ2gNCYt
	 M9+fQf0vBTCQUHlOEXdW0ANxcI+Eu0LplL850H91ppwG6aXr6jI9BXnzY6BuElutyNJOe
	 P3d/dk8XwgIk7ero+YSQzBGDBZrmpTeyvC1ZuQqj4NaAEkBhoyblup1lu94yy0jquxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YuJZNPyyW6ltIkKqVY9YddvHxwDEZHDFN8NMauYAsBk=;
	b=lXoyPYI1SNM0nqCLREz5b5nhVmqpfeay9DEBOclVdefJS5iRCqrLIPsIfihPJwkbnGKX
	 Vz47z/acWLXMavt5Ji7Ct5mVpvuc7a55fR80yNnEUAkTnoQyV64tBLsf5Qg7s/vyo92qo
	 LpLUvTcNAbUcbTi9OH58BfvxbvJD/n097L/zw1C9JucZz4dUwegHgPFY+vYP3ZA2hWMP1
	 jqNGHCrM7Kjg3pH+CdLT40tv/hJIvW8r1/UD58cUwHMdZDfjWz6lrvk8yoMDdyx7QejqF
	 BDgIGoiY82ZrIPW+Np00th6VUVCD5N6Xfd9uB9ONTT+/GB1JCTMLp5n1crjHmfBaWbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YUBh+Sc8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3B4606A325;
	Wed, 18 Nov 2026 20:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YUBh+Sc8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10BB1F000C4;
	Wed, 18 Nov 2026 20:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034766;
	bh=YuJZNPyyW6ltIkKqVY9YddvHxwDEZHDFN8NMauYAsBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUBh+Sc8uov63ksl64iW6eKFE4rcr1mQ9B3qxUK77a3p/HKN27BfFwlv1h7SUahye
	 KiMpkXL1CsixF6Jz00tgoGktZ6RzFAqfT8lVu1Wv2id7EJ+rzQ2oqJF2NHXOJSAKY3
	 8o/qFiAxMIM9mpRTcAfE8gzoP7zmxTLpIxkcoXoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0436/3318] iio: admv1013: initialize callback mutex before registering notifier
Date: Wed, 18 Nov 2026 15:17:38 +0100
Message-ID: <20261118150329.748154589@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit baf7e43b7fb5afb777353bf265ddf9d909f72b9f ]

admv1013_probe() registers a clock notifier whose callback takes st->lock
on POST_RATE_CHANGE. Initialize the mutex before
devm_clk_notifier_register() so the callback cannot observe an
uninitialized lock during probe.

Use devm_mutex_init() so the lock lifetime is tied to the device and
cleanup stays paired with the rest of the managed probe resources.

Fixes: da35a7b526d9 ("iio: frequency: admv1013: add support for ADMV1013")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/frequency/admv1013.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/frequency/admv1013.c b/drivers/iio/frequency/admv1013.c
index 8b521f371e87c..3193bc4e15882 100644
--- a/drivers/iio/frequency/admv1013.c
+++ b/drivers/iio/frequency/admv1013.c
@@ -604,11 +604,14 @@ static int admv1013_probe(struct spi_device *spi)
 				     "failed to get the LO input clock\n");
 
 	st->nb.notifier_call = admv1013_freq_change;
-	ret = devm_clk_notifier_register(dev, st->clkin, &st->nb);
+
+	ret = devm_mutex_init(dev, &st->lock);
 	if (ret)
 		return ret;
 
-	mutex_init(&st->lock);
+	ret = devm_clk_notifier_register(dev, st->clkin, &st->nb);
+	if (ret)
+		return ret;
 
 	ret = admv1013_init(st, vcm_uv);
 	if (ret) {
-- 
2.53.0



