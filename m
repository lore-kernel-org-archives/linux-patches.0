Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD8B42AA0;
	Tue,  3 Dec 2024 16:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242313; cv=none; b=TFBD8NEtKFoEk1TZWmVtNfxCdkWzyrjJNgIADjVIluzO/wmP+DmZmUBFLNnveylMpyM9C5BmBpwL+FJc7+06h5orFdU3W5f2Qzn9m2jxHDgR/CdTZ9xERDTaQu4dbqAu/+FM/OxlpbLy52R1zCK0FiW6s0nYoR3jE8k+vOBQmN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242313; c=relaxed/simple;
	bh=omD8nCok6nUQTykL/MDO5rekyosDkG3RLDLXcyop2po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okIqVwR9rQtfwdJ4QVBXiljxkIokHhHoPsiwnn1SDJxkOOP5Ewg69xPeGYeiWD7TEP2zJFTr1mkEHFr+0vxbxYRf3PWlxHE7uJ8i5nSbP5VaPu2l5Hja3ORm2zSoNxKEGUNejDDcJmw9EXeQMHZDnpnkQGGJ7GzmZNqsNOMoNyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lL2KYoea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lL2KYoea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB8DC4CECF;
	Tue,  3 Dec 2024 16:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242312;
	bh=omD8nCok6nUQTykL/MDO5rekyosDkG3RLDLXcyop2po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lL2KYoeayMFh2rNxAhGFwSDUyiza2qswencKVlCiB8OHufh3oa7IenorftmWdNpZW
	 js65VadECkeCqq4HQ6qGzDNNHu6026PoMvw0oUwZpA3CasBBwOzhkOx2IA/meN3dpI
	 NTA0AsWFegr073RTmtCxuCBmC8uAYAcLDuW5d6i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angelo Dureghello <adureghello@baylibre.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 669/826] dt-bindings: iio: dac: ad3552r: fix maximum spi speed
Date: Tue,  3 Dec 2024 15:46:36 +0100
Message-ID: <20241203144809.851433951@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -30,7 +30,7 @@ properties:
     maxItems: 1
 
   spi-max-frequency:
-    maximum: 30000000
+    maximum: 66000000
 
   reset-gpios:
     maxItems: 1


