Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015359;
	b=sICI6379UtFkdybYqTyb8TyWwzpfnJ0gjI7P+Ha9/uSTBOyHCQjWQlIgJBqSva0X9qf0
	 UiyL/LOP1ZJKJgap6bXK1YaqJwjS9tqXYB9X7S4RvMOA+VyvmeHYDT9cTF7LDZ+f254k4
	 VhBkREkjJVR0U16tq/f+jlc/dPkaWGOoicPE/A5u7AvCc02ka+TaCKBtH/tTqpmkQUYG3
	 zN2M7Mtb33mArVnnUvTWxMVlo3rp4IX80nkYL8Ir3zUDa+8Mj16M8qLUND/nL1newtVP2
	 HjtRU54v9BXYmh9N2zxzGRj0FktSE7hSXiZQ2O88RQxVIhZYFoj+XHRb9Un0hRyfF3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3aVbPCsrUYzZzcqHox8wpAgIJxSODUk7k9MUC8d28Vg=;
	b=KfdtRqo1l/Jo9W3M5ZHIrJCBm4Q5yrQ7qISUGrGtKJnOpteAclhUvfEKMnx9/zhEfYCm
	 QXTxLPRa0BqPRJjL4iiwY+053OExrYXHSjfHsnmEkqE8xETlNY6+psa3WpuuU22jjpYgK
	 tWnq9rqAzUFMRoKIkqnQVMM4GKgrl2+LtjE11KKCoAALYLrWmVNjyKs6B2btRUlidN6fs
	 Q4tYTzeHBIdGofCpE1HiBZcnN2Wk0gL4U5/ynb/AXo3rHpC2Tgy9btuCVQ6u2Fmzr//Rx
	 b8lDKo8fdULczLr6f/++oZHB5n/J9aAzFO6OLSZLDnLXC2CKY2d5pEDfL/U/3Bo0vSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y8pIFPX0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAC3606A33E;
	Wed, 18 Nov 2026 15:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y8pIFPX0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7477C1F000C5;
	Wed, 18 Nov 2026 15:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015359;
	bh=3aVbPCsrUYzZzcqHox8wpAgIJxSODUk7k9MUC8d28Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y8pIFPX0Hb/oqKqQ0aCkxzkFqPMKQBYv/np+xDefbnONvBWcBeoVumf2hc5TGz+eG
	 /+oB3ZGJogSXMzAsmS7EhMUDtzyz+v5TCh3TZN/jNmeayybHHkO1MDTdLx97EN6K8u
	 Lef0r1wh5+k6Swa/dgl5Jrz2Yxs38cH8WB7Qk21M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0118/2651] dt-bindings: display: panel: samsung,s6e8aa5x01: Allow common properties
Date: Wed, 18 Nov 2026 15:22:38 +0100
Message-ID: <20261118150252.122432621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b271de575e150..f04702de1101f 100644
--- a/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa5x01-ams561ra01.yaml
+++ b/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa5x01-ams561ra01.yaml
@@ -34,7 +34,7 @@ required:
   - compatible
   - reg
 
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
   - |
-- 
2.53.0



