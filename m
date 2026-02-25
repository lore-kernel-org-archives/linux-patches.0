Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6392D7D42;
	Wed, 25 Feb 2026 06:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002787; cv=none; b=LejeJuUvJUVfAQQex0/w04ZGKzcUF5BF4dM0fX/NxHXkIqdU7j6JyW9i2AupO6idDZ6OzVqUG5h+AE/NEMGA+0Zh+v2HBq7nGr26LrAd2Y3V9kCwjztAFG5vK0Gt6psmsnPR3+YGDPxZcvMBa1FP+ofLl9V6J4bvn6SfomeRWwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002787; c=relaxed/simple;
	bh=t7Hqr6q1PpUVWqKLEg8KOExdiKLGuemzR0rurO7htd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krpYA6TfDoimG5nkr9i9STCG0OZZGNiUOdATPD44vNqYj4158c+LHvAwyLjG+8FiCXuCGFKdnjFPIuwh4KCVzfee/efyzE5FBZVyp5KfUFu4+aUqk5lm729EaMhQe/w6NtHc4ANXaJ3qhMkhZEuX9/Got7zfwWazHmX98/F+BEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u34lq2qn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u34lq2qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B419C116D0;
	Wed, 25 Feb 2026 06:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002787;
	bh=t7Hqr6q1PpUVWqKLEg8KOExdiKLGuemzR0rurO7htd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u34lq2qnUfCtln2+hGWuKKYqY2PY5S67PHA1ucTRJfLWaiW8W0aPWAY69NozYLiXI
	 tQpoIdkr3lB7zloQSb56itjkcV9qeGGUR1xPDIhQF7Xq3325fLNaG4nBc7zq0Oq4UU
	 rmrwQxYlvmW/tYTyM1XI1HKVckN8ALta9NpPf9NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 629/641] ASoC: dt-bindings: asahi-kasei,ak4458: set unevaluatedProperties:false
Date: Tue, 24 Feb 2026 17:25:55 -0800
Message-ID: <20260225012403.744632592@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit 50a634f1d795721ce68583c78ba493f1d7aa8bc2 upstream.

When including the dai-common.yaml, and allow '#sound-dai-cells' and
"sound-name-prefix' to be used, should use unevaluatedProperties:false
according to writing-bindings.rst.

Fixes: 8d7de4a014f5 ("ASoC: dt-bindings: asahi-kasei,ak4458: Reference common DAI properties")
Cc: stable@vger.kernel.org
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260212021829.3244736-2-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/sound/asahi-kasei,ak4458.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/sound/asahi-kasei,ak4458.yaml
+++ b/Documentation/devicetree/bindings/sound/asahi-kasei,ak4458.yaml
@@ -60,7 +60,7 @@ allOf:
       properties:
         dsd-path: false
 
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
   - |


