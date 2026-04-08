Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39803D8125;
	Wed,  8 Apr 2026 18:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672881; cv=none; b=mZoKflbjTnz2sfjkbghwqEj7KuTgY86tpNoyn/1h8asIXNL8cg0lmgGR4cP/1SINsfqcqshiu5NahjCyy6ehDE2W4L0OFTO5eQyFIQLde/tsk2qfRuj0VU6zkDt0vZN+u+RLss/5oib4XGdgxgkoOKS/wQGnyAfTyLvwLgVFG8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672881; c=relaxed/simple;
	bh=PbCVjgtAXDpjMruXUz07bAbagSldPBYIl2nHYx3N5UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chyoSjJZBm72lkN/j5T8anIh3UUnWd35+cYQNn1orE43ig5rxAtnwqa1a2ebl7/faP3u0AqFHcR7yaRyjNqBTxPqCQeHEB2WHW3qp0fZDWjWiYvVlVfFE8irOJ1eUAaBfTfkFJ1JY+jSyaiGjI1MzXAKhv/Sw8zlNbvhVyvTyv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=unmb5TrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="unmb5TrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C23C19425;
	Wed,  8 Apr 2026 18:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672881;
	bh=PbCVjgtAXDpjMruXUz07bAbagSldPBYIl2nHYx3N5UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=unmb5TrLDP8FeL0p1UhoGZgdQKSWVHw4PQGYVFqLqfM+5f6mtR9Nf68S45+Ld9cRV
	 ez0UduhLaxN8hSh6bZ5WSCIVo6yjWComSZg43Pcw/X2S/JzBOJECkVtnL8vhcMDDXC
	 5dyV9TlF5JkU882E7OTls+parGUUhu0SIWdcP5/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 017/277] dt-bindings: auxdisplay: ht16k33: Use unevaluatedProperties to fix common property warning
Date: Wed,  8 Apr 2026 20:00:02 +0200
Message-ID: <20260408175934.492370700@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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
index b90eec2077b4b..fe1272e86467e 100644
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



