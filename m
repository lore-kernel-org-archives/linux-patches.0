Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550441170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD299C433C8;
	Mon, 11 Sep 2023 14:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441052;
	bh=7LRfqi/nKAQHm1j9G6/YmUBr3ugXtpoUR3rS+72uvDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkUQq5O+t2hxEtU8Stchvg/3w7miTTrdrVrngRZZ/1APckT1qz+u71PDM9srdqgKr
	 Vq+JLkvjHxYiiZluH/gwRQjbdn+KENsRTgnwfJQ5ZL7Fvi7ll2eE44SFltMhw+2RCO
	 McHr+oOGmxmCnWdFhXlEDTl/2uPgUFS4pCA9BXE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 278/739] dt-bindings: arm: msm: kpss-acc: Make the optional reg truly optional
Date: Mon, 11 Sep 2023 15:41:17 +0200
Message-ID: <20230911134658.888649703@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 7dc3ea5ea8e8df2a82a1e78bef2382fb2c982ed3 ]

The description of reg[1] says that register is optional. Adjust
minItems to make it truly optional.

Fixes: 4260ddfb6496 ("dt-bindings: arm: msm: Convert and split kpss-acc driver Documentation to yaml")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20230627-topic-more_bindings-v1-9-6b4b6cd081e5@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/power/qcom,kpss-acc-v2.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/power/qcom,kpss-acc-v2.yaml b/Documentation/devicetree/bindings/power/qcom,kpss-acc-v2.yaml
index 202a5d51ee88c..facaafefb4414 100644
--- a/Documentation/devicetree/bindings/power/qcom,kpss-acc-v2.yaml
+++ b/Documentation/devicetree/bindings/power/qcom,kpss-acc-v2.yaml
@@ -21,6 +21,7 @@ properties:
     const: qcom,kpss-acc-v2
 
   reg:
+    minItems: 1
     items:
       - description: Base address and size of the register region
       - description: Optional base address and size of the alias register region
-- 
2.40.1



