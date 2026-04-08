Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA032DAFAA;
	Wed,  8 Apr 2026 18:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672447; cv=none; b=funKTfrzDa5ad/99yxCYoR2J+lwZV/Yl8xkWB+PXCaSXdwvzRdezACZ+q030pK3x+N1Qhhn/XPzxaAfwLRcyQbI8qZsL0j9J2LDuUJ74o4b6CGwO1tnD2ohkrKYeqbC53BRPyql5I45rhr93Y2tyT2OEzG9cf3kPVe47fV/0fWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672447; c=relaxed/simple;
	bh=s6qZbevNqzOeUs7Efvq8y5lzppGfgZllgSWxqTy/wEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ns18lHFZg7lwO5Z0sbrYuWljSxVSvJu1VRTZgAfK74CE9SgAqQNOeevS/6Rwo8RHw1NBK4rP8QoELLVvxx8ia270tPyjYWk+swasV0o8/MEp7vLPQTRUKtWxfRX3CxJgPww67/foklbEOa0XkXHzjtv+pE2ibUb2He0zKWF0nXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROsQMVBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROsQMVBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA82CC19421;
	Wed,  8 Apr 2026 18:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672447;
	bh=s6qZbevNqzOeUs7Efvq8y5lzppGfgZllgSWxqTy/wEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROsQMVBeIvpraNh3h6EjggJUJ/NFyZBVQWJQzUcd/iQR7OWmuS866nhx0zEFy3YNs
	 qXtCR/+KUIThWxDoWi1mg/Zh8sMDthyJGDVk/P6avYMeDH4X2HlNhMVhH9m68xjBOJ
	 BTcYzI8Twh2Xz6tcvpMedbvq9nXx0OjjcB7KsAr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/160] dt-bindings: auxdisplay: ht16k33: Use unevaluatedProperties to fix common property warning
Date: Wed,  8 Apr 2026 20:01:38 +0200
Message-ID: <20260408175913.609900482@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 398c0c8bbc8f5a9d2f43863275a427a9d3720b6f ]

Change additionalProperties to unevaluatedProperties because it refs to
/schemas/input/matrix-keymap.yaml.

Fix below CHECK_DTBS warnings:
arch/arm/boot/dts/nxp/imx/imx6dl-victgo.dtb: keypad@70 (holtek,ht16k33): 'keypad,num-columns', 'keypad,num-rows' do not match any of the regexes: '^pinctrl-[0-9]+$'
        from schema $id: http://devicetree.org/schemas/auxdisplay/holtek,ht16k33.yaml#

Fixes: f12b457c6b25c ("dt-bindings: auxdisplay: ht16k33: Convert to json-schema")
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/auxdisplay/holtek,ht16k33.yaml          | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/auxdisplay/holtek,ht16k33.yaml b/Documentation/devicetree/bindings/auxdisplay/holtek,ht16k33.yaml
index be95f6b97b41a..0c28292a5bb46 100644
--- a/Documentation/devicetree/bindings/auxdisplay/holtek,ht16k33.yaml
+++ b/Documentation/devicetree/bindings/auxdisplay/holtek,ht16k33.yaml
@@ -66,7 +66,7 @@ then:
   required:
     - refresh-rate-hz
 
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
   - |
-- 
2.53.0



