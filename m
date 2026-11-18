Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028880;
	b=Z21WNAb6ZDhRodM2TcYBlQfCgpw5lzb4oayJLek1sf7An/hPQghaQe3v4VVZXGw/QYsn
	 LFa4Lgd5E9UKlIy25hz4enpPbNRJGWyCzSNgnzxDhk6la2yoOO9nQaMtNfmFqIO0AmUAL
	 TVdPHQDpG/U5Baqz+OEAYQg0dF8TIWGGvou1/JtAxxdvgAqNKiF1Na5OjRKZGI7vKmupp
	 XjXwEqPDFWCOccHBgBxHvWq5p0ocGBO5MiAGtvbzr0s9rbZqtkZV5gMmB+0+FpeyCh1qG
	 iwJzpRjMok7xW3TSXa1gIKLI8j8VfZUkTOKh1QsKV5QwZJg6A4guF9wx855O7XLT2yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DI69oaMUY8nIA0DkkZfyHwIj2NUDNBNeYVZAtHk8xWI=;
	b=Jsq193Z6QjbVSTyhEcuHTyAsOJz0bqX2ggSW/zVW6gox1VJIg8e7ujkJ+qbAxjtMQc50
	 iIa+NeW1AGpqpCK1cV+lp94HoeT1l72nLUBiI3kezG6LXl9nU/Va+wPwv/KmB+8Z+Rmw7
	 ScnCfL7r6ZM6NcPQKz1tQh8pJLevPsN+XGNBtpSH4fyafGEEWbWQ9MnaKOAQMz+RoZMzd
	 ULBhMaej4RBQjgXrBu8ncRDXErGNnXSljvGnsAPDAY9xz3bKVqfzWU9rWr5Ojm1uGF6K2
	 a0NfT2cA4PxyxWicmNJpFsUL45Q+OYwnBbK1LXvtxMv+QoII8vFZXKMWkl6m04AnUNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TsaumGzB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AAB606A331;
	Wed, 18 Nov 2026 19:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TsaumGzB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54251F000C4;
	Wed, 18 Nov 2026 19:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028880;
	bh=DI69oaMUY8nIA0DkkZfyHwIj2NUDNBNeYVZAtHk8xWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TsaumGzB5upfRxMso8G6InL9aLnos29yEG/Iq8qhxU5yTwWxEzrD6wkKbmkb8fpBP
	 c1XS42paDZ7mDq7WT0RjPT9jqwPKHyPLUpGufP8n6HbZ/zXCxTXHstE/+jLMw0yf81
	 jvLaJhvUXaIPd41cClFr8EqUK+7+zaiq+YIpvDEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Esben Haabendal <esben@geanix.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0150/1756] dt-bindings: iio: light: ltr501: Sort compatible enum array
Date: Wed, 18 Nov 2026 15:37:57 +0100
Message-ID: <20261118150014.104514461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit 6c430006fbcb63dc8baee3c3bf356b264ba7f61e ]

Restore alphabetical sorting of the properties.compatible.enum array.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Acked-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Esben Haabendal <esben@geanix.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Stable-dep-of: 198ed7962e42 ("dt-bindings: iio: light: ltr501: Add missing ltr303 compatible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml b/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml
index c8074f180a793..480523ca37500 100644
--- a/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml
+++ b/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml
@@ -15,9 +15,9 @@ allOf:
 properties:
   compatible:
     enum:
+      - liteon,ltr301
       - liteon,ltr501
       - liteon,ltr559
-      - liteon,ltr301
 
   reg:
     maxItems: 1
-- 
2.53.0



