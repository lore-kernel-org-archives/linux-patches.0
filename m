Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261562D63E8;
	Tue, 31 Mar 2026 17:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976616; cv=none; b=k+78ytRsiaWGZk4AddXolavRKC9roj9n3ik5TlCgURhmTXbpXnDrVSR5RXXMzhv7Rwfx3wgh4rpZALM6IP7WUOb9mjuY2TQSJ5xzGNU2K7KAw8k3Hi0pNVGxzGfmo410V13by5LKwmVGmSrprGdL57lE0v2x1fIiw4yWYeUO1NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976616; c=relaxed/simple;
	bh=5VzuBhB4I4uhHeLAYW4PvlJNiqVHQ+vJ6ZRir0LBYBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5n39WVUpns5hD3SHqqVCTb5YovQ/TMknXrFEhD+zvVxOtuQ85atb5hwCs31tVi6jlarnfN3lvmanqlnrkVbVTV5PQ+lopp1YJ4Sjz8nB04P3voh/ROvEsDSoG8bN4ZH3LKnFtSOyTioBnEM0S27jtmUGEW0baUJa42QRpl9hHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1ioXUMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1ioXUMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B33CC19423;
	Tue, 31 Mar 2026 17:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976615;
	bh=5VzuBhB4I4uhHeLAYW4PvlJNiqVHQ+vJ6ZRir0LBYBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1ioXUMBt3Qrb8BzHhirvUlIp1AcjVYc2uRNJBVRkcgOcyRaNPk7lGftzslXxcE4N
	 Cq9y621Msk9CMr3ayQGt7yZqiXbTduqpZR2hFIcu3qJyFBSgbXzo/Hfv2YmZi0JMNn
	 kdpmcMBftWG+2Z3IxqUQwRb6Tkq3HCBE27SxAlWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 160/309] ASoC: dt-bindings: stm32: Fix incorrect compatible string in stm32h7-sai match
Date: Tue, 31 Mar 2026 18:21:03 +0200
Message-ID: <20260331161759.356483919@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit 91049ec2e18376ec2192e73ef7be4c7110436350 ]

The conditional block that defines clock constraints for the stm32h7-sai
variant references "st,stm32mph7-sai", which does not match any compatible
string in the enum. As a result, clock validation for the h7 variant is
silently skipped. Correct the compatible string to "st,stm32h7-sai".

Fixes: 8509bb1f11a1f ("ASoC: dt-bindings: add stm32mp25 support for sai")
Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Reviewed-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://patch.msgid.link/20260321012011.125791-1-jihed.chaibi.dev@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/sound/st,stm32-sai.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml b/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
index 4a7129d0b1574..551edf39e7663 100644
--- a/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
+++ b/Documentation/devicetree/bindings/sound/st,stm32-sai.yaml
@@ -164,7 +164,7 @@ allOf:
       properties:
         compatible:
           contains:
-            const: st,stm32mph7-sai
+            const: st,stm32h7-sai
     then:
       properties:
         clocks:
-- 
2.53.0



