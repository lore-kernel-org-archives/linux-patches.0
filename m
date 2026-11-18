Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022887;
	b=qzbAniswQu1qNAG4/W41thHimCc0mbm8knDlCahyPtwK0w0ejGelQBLBSRZzO7edHMQV
	 2qjId04/FGlZcj7ddhZq8hkaQTzVMS/EyynYLy93zXoFnQveSsMZgFHn/mrNrCOuDksPi
	 O2fCA+Gh7lpjvu0mwOMxnalN2VqdoUL3g/DCVGuWGaNGOwF3tERz/spSI8F5yIWJxH+uI
	 NplUDUbohZhHaGPJBwE6siHc2WEHAtihRVjcoyPcgLCA4Q6qzxbpU9HIEgdOPI+znvKW5
	 DFIe3TKoCWvY3hiHSZL/xWDcwmK5pO/YWrQDu5VaYlHBfjmUcnkGc+UVXznsTfkcJ3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7yZ8b37qjTHenNRy5g1/xm4aNQmAqRsqMgmX48qhstQ=;
	b=lWCplHgJ8fFeTpVMzs37hcJpscwJvVhhRcJiRo4u+SNvxNIuf2VEw3PxdDSr/LEtwIX/
	 wguA2m0o43pyTgpvxfOaWqDZjY3otFxbnRDZkU0OWxzjDL23v7EnBZLL0UmywxG2e3JXn
	 50t1HI5czBtOXM4UhIeDhSoe6me6jzBVESXxiTxvvS8ekHoLCmyAl23meOv5/Kqn8/4fh
	 1qbJeyBVyQi2M/Kor88x6MNHRrLyufWFqdsguvQAq34bxrzViO5pKDjBYLd4C/ObmmqnU
	 n+q0YSERa2HPk8OETm7gGX6PKi9/V7gKq11vNMbLv4hSDO6+rQaSXW9R4kD+Oa6bgtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GU7e5sl1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AA0606B5F7;
	Wed, 18 Nov 2026 17:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GU7e5sl1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C854C1F000C5;
	Wed, 18 Nov 2026 17:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022887;
	bh=7yZ8b37qjTHenNRy5g1/xm4aNQmAqRsqMgmX48qhstQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GU7e5sl1vNsbhswPWxZghgjXVYM9TIghNz2s9+gUZ37bKdXjjPaQxMbr7bu8cH+M1
	 7OPZOetE6h64ZrXrKyOhXHQi6biHD/ChqILWzG14YArJ6bvk68Yl4AQFuuk1nVfPGw
	 /+v1kuh0gJV9BcH2m4xlfDRy1XG2Q/VRc6heO8lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0172/2151] dt-bindings: display: panel: samsung,s6e8aa5x01: Allow common properties
Date: Wed, 18 Nov 2026 15:31:47 +0100
Message-ID: <20261118150128.012035590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit c3fd78f0f3624fff3dcf55d89326f90000367596 ]

Change additionalProperties to unevaluatedProperties to allow
inheriting properties from panel-common.yaml, preventing this warning:

qcom/sm6125-xiaomi-laurel-sprout.dtb: panel@0 (samsung,s6e8fc0-m1906f9): 'port' does not match any of the regexes: '^pinctrl-[0-9]+$'
        from schema $id: http://devicetree.org/schemas/display/panel/samsung,s6e8aa5x01-ams561ra01.yaml

Fixes: f3e1caef597e ("dt-bindings: display: panel: document Samsung AMS561RA01 panel with S6E8AA5X01 controller")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260818-topic-sprout_panel_warn_fix-v1-1-ded1e8d5f121@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/display/panel/samsung,s6e8aa5x01-ams561ra01.yaml   | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa5x01-ams561ra01.yaml b/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa5x01-ams561ra01.yaml
index eccfc66d7fe24..8401d067785e6 100644
--- a/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa5x01-ams561ra01.yaml
+++ b/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa5x01-ams561ra01.yaml
@@ -31,7 +31,7 @@ required:
   - compatible
   - reg
 
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
   - |
-- 
2.53.0



