Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABE5149C6F;
	Fri,  6 Dec 2024 15:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498119; cv=none; b=ClOWaE0cI5CukksEZwS9gmYMV62keEJ7JuDpiK8PPzyZs5XBoyM7eZ6crnPcs2eq0PHuzskIP0IRi2/Rb1alKHZ4o6vGdjjC4FcpAijx9Qd+R01P2LhojBHyOugTC/vP8m3U98ElAEk+FkjVl1hlzlt7P/dkjXk9dVDpauss2I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498119; c=relaxed/simple;
	bh=++ZUuiR7MU4XB2MNVXpHi1iAZ93JVDnjkHuQRJVmZLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuLSC71DtqnbUOCD9I4Nrv5U275jKtsGEO7y9qlrQCKXHCPOMQ/RKNMhCIo9vQOd43DFj0+d7+PBKs/sTZauYQRweySSrxbSfTUh0FDC76m233FoHR0C5Lp4O+sxiEH217gI//UruYd1x1hMH0ZcDL9UuJhQCFmT/iQnlybYlkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDxwjExN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDxwjExN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E05DC4CED1;
	Fri,  6 Dec 2024 15:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498118;
	bh=++ZUuiR7MU4XB2MNVXpHi1iAZ93JVDnjkHuQRJVmZLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDxwjExNhIUK6YfibXkE/8v9f5y9AVwECUfQ4rpDxawEs4IeVhheA4t30ubQbM80B
	 D8K5IQCELyBAfVQIbs0vWpGI3VIzcobR0WcImOpovzXp5Ien7lmEX1ul0Dk50ZaAYE
	 DIgmUWTT24VohSv6LGOg9A1LREaoxSVwAmOrNC80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angelo Dureghello <adureghello@baylibre.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 492/676] dt-bindings: iio: dac: ad3552r: fix maximum spi speed
Date: Fri,  6 Dec 2024 15:35:11 +0100
Message-ID: <20241206143712.578217726@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Angelo Dureghello <adureghello@baylibre.com>

commit d1d1c117f39b2057d1e978f26a8bd9631ddb193b upstream.

Fix maximum SPI clock speed, as per datasheet (Rev. B, page 6).

Fixes: b0a96c5f599e ("dt-bindings: iio: dac: Add adi,ad3552r.yaml")
Cc: stable@vger.kernel.org
Signed-off-by: Angelo Dureghello <adureghello@baylibre.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20241003-wip-bl-ad3552r-axi-v0-iio-testing-v4-4-ceb157487329@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/iio/dac/adi,ad3552r.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/iio/dac/adi,ad3552r.yaml
+++ b/Documentation/devicetree/bindings/iio/dac/adi,ad3552r.yaml
@@ -26,7 +26,7 @@ properties:
     maxItems: 1
 
   spi-max-frequency:
-    maximum: 30000000
+    maximum: 66000000
 
   reset-gpios:
     maxItems: 1


