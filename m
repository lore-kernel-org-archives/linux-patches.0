Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213178;
	b=ziY29JEhtiPAUE7uLR/zo0OVGpF3VmKHQ6gTUC468YTEXvCrlbKcFJ2F2DPTbAxm1Ib7
	 Kfi+cDAfKMre4Nc8d7fsi/TY+8/LBtdBVFkilfs8BfJQKzr4nnviLv3qdOMvYMrYF2TEW
	 gg/T+Q+z2lWKxJUMs0obCYkJvKpY3Csb6/pNrNF3T7K0fBxbdOZIQ5byAjJN6Uy8ylyQA
	 1WCYsGaZtW3xrWMRahOD+u7CeJHvHZdQUvbNo46D+ftSJh8xCNsgXStuObr3ivJqUXtsW
	 AK1VY5Z5tZoVRNI74PA7FIGEWFqsKM7cDpr897IKp9nNUpltys7sV9s1LLlQVYGGy+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RRooKVu3X92KOIekoQGSDlQt/2Iwkqk8ld2lPzvxldQ=;
	b=XjKe8KRzE174fvP8+na9XC1FdOTNBRUrCp40qpIzO1o5Ntv+3ZHe4ogbNTGTnajmnsKo
	 258gBBr8NUhq+szRj1rZ2di6PYQBvr09XSxgicl+W0FGLU8mVAZWHrSpNAN6aW+9h08B4
	 vaEs5/IyCYEevnygpB22VGww0aV5YVFUxoOlm2cdsvlJ3KGZYHJD6zONWEMFL/SdBJc10
	 P8y8sApkb+WUj2pFdxeLR6SWpJVKQgOcO/mc1ghyWLlMr87vo9Rwss7ErF/0iniKtMNBA
	 n05oESaIRCAq0pqCe7jUNiQquVrnz9CwA9BQLz7TsyUqfxpIw2s21zKAgyFzF/+Fkpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HpzyD6JP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DF3606A31C;
	Wed, 28 Oct 2026 18:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HpzyD6JP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1261F01825;
	Wed, 28 Oct 2026 18:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213177;
	bh=RRooKVu3X92KOIekoQGSDlQt/2Iwkqk8ld2lPzvxldQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HpzyD6JP9EhT94pQMWW/9l6IihE096wcryBzeQcEZTomqSBm7mxatj4T97ojbeOjk
	 Mc51kWiLTzu74ToVhbtrM9bEZmBx7Q6JAsEz7fZ+c4FYlgLD5I8gbxGXnPQZIOtlJm
	 bacHMxQrhwTQnoSBaS18oMg8Rg5h/4eraxntPS8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0414/1887] iio: adc: max1363: sign-extend bipolar differential channel reads
Date: Wed, 28 Oct 2026 17:41:50 +0100
Message-ID: <20261028170508.657608252@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Cong Nguyen <congnt264@gmail.com>

[ Upstream commit 91908c0a78baddc8572aa3ab69e62ee2eb496ba4 ]

MAX1363 differential channels are bipolar, but max1363_read_single_chan()
masks the raw value to the ADC resolution without sign-extending it.
Negative differential readings are therefore reported to userspace as
large positive values (e.g. -1 as 4095 on a 12-bit part).

Sign-extend the masked value from the resolution bit for differential
channels. Single-ended channels are unipolar and are left unchanged.

Fixes: d1325cf45077 ("Staging: IIO: max1363 ADC driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max1363.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iio/adc/max1363.c b/drivers/iio/adc/max1363.c
index 875f5ff202082..bbb2336006a98 100644
--- a/drivers/iio/adc/max1363.c
+++ b/drivers/iio/adc/max1363.c
@@ -408,6 +408,14 @@ static int max1363_read_single_chan(struct iio_dev *indio_dev,
 		}
 		data = rxbuf[0];
 	}
+
+	/*
+	 * Differential channels are bipolar and the device returns the sample
+	 * in two's complement, so sign-extend it from the resolution bit.
+	 */
+	if (chan->differential)
+		data = sign_extend32(data, st->chip_info->bits - 1);
+
 	*val = data;
 
 error_ret:
-- 
2.53.0



