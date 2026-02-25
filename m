Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA14279907;
	Wed, 25 Feb 2026 01:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983690; cv=none; b=O6dmskCUB5zKJBP0DRu8Px9PdCmXjMF9ZO1lmFnCXgKm8GlbH4fBbFd7oetbLU/vvTZP0vCxfp0eafRD7dh7CTsfnPaWkst+r8Fen0R8VSIZeSPzlwJdOMfO7oYxiILmKdK21fw6iTtGFXWmBEeYecFa/JLuY+KhFNkNStN0nK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983690; c=relaxed/simple;
	bh=Nqbo5oYXQhz2T41c5x45s9f/+wCd/LiCsIXbNLvB5xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3xerzsSfpN3xvH7VVhChC9vGNrR4gzWjobRrwDjvCuq1hwyOTG19+fJ4tDZ7P9J9xxbKpmseuda5v/HRZquR03QKQpgt3fJCdPGsZCVyYITEYrZDvmfhZ7d6XF1eQatCwZCPtoY5lwsD8kuC+7JwQOdwpI44tcRVzR/MZlrY6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8jK8syO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8jK8syO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D84C2BC86;
	Wed, 25 Feb 2026 01:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983690;
	bh=Nqbo5oYXQhz2T41c5x45s9f/+wCd/LiCsIXbNLvB5xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8jK8syOhqFPqHveAX+zicFYki4jSt8K9BI5xB63eOFakgCL904fP7SZtAzl9fI6I
	 tGUthmLb542qfCdW/wSSQF9bpziS3tZyMJNvftgGLo3Imt19KoGnHdRd0JrAfAxfDb
	 zXjIweQmBWY9Q9jYx+pwlT+mOKovh4ZyzdDPfO3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.19 772/781] ASoC: dt-bindings: asahi-kasei,ak4458: set unevaluatedProperties:false
Date: Tue, 24 Feb 2026 17:24:41 -0800
Message-ID: <20260225012418.650425060@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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


