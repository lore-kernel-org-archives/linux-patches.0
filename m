Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CD21E5724;
	Wed,  8 Apr 2026 18:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671987; cv=none; b=eri91ZuwAdmihNvSOZrJfmsOBfPXpn/dSHdopxSsdSdTo8tGfDza2ti0lY1C5dk+NMae1/6bke+hrWYPjCl3d4ut33iHuCc7aOZ7wQnDPcYhWv0OofPuaLe9dLuzwyTUSqU88ectwLMjJ7SOT5USzlnY4LmIgNVT4yhbY251K/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671987; c=relaxed/simple;
	bh=hRS2EN3O2fkj6o1eds54mNq+wEQOHp7nXjgnNCH0vjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zt7fbtqSBjWt5w72LEtobm3b90RepSWfSLbn4Acjeyllaa3PmMQPM2l+wj6vrsNtbz7Cu+JXs0ajv0+2ufCr+vfLueIVbbmhnc6sHQ3FAkecnojRk6e+SDroCer1mZq4x180TdWkNqJuXe6YVLV5g45a7DXbAhhB+kAHPfOzVms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtNITgVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtNITgVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E233C19421;
	Wed,  8 Apr 2026 18:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671987;
	bh=hRS2EN3O2fkj6o1eds54mNq+wEQOHp7nXjgnNCH0vjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RtNITgVhs1c8+SHzIoc9eKZL1rWK3ISMXKF1XCZ2S5xFjpPIT3RN25CYO0LKAQuVX
	 GPuwCC3W2rPXNZjseGsfmGT9wec8BDNyC+/EDzu7HrP8BnMoVSyhKdmPGOfINig2KF
	 kpcuZlNAL06MFfWTsCdJxUdjr2vfGIg4hwLS6IOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/312] dt-bindings: auxdisplay: ht16k33: Use unevaluatedProperties to fix common property warning
Date: Wed,  8 Apr 2026 20:01:02 +0200
Message-ID: <20260408175939.186136200@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fc4873deb76f3..8f4759030a8ca 100644
--- a/Documentation/devicetree/bindings/auxdisplay/holtek,ht16k33.yaml
+++ b/Documentation/devicetree/bindings/auxdisplay/holtek,ht16k33.yaml
@@ -65,7 +65,7 @@ then:
   required:
     - refresh-rate-hz
 
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
   - |
-- 
2.53.0



