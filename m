Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831173;
	b=VySmNbrdltbZRB1VCoYicJz7jqn+ugfsIgrJjwnFF2AnUzV6j1VY6KWQi6dQIhqA9eAo
	 YvYuZgujfMvC/dGI0gxp6kFfQIHTYm1AZmO6O59FltReL9rZ/wy+evEQIJk2fwqsYLy0k
	 78EvYM0/I7xnT+rb0qgmQPdoW/ZRkhtf9eYcn+uFaudn6qPdEKqVtMLnST8yJucBBGsm8
	 CESPRdrDzg6Rqsw7WzpRg78hpJsPW17Y/f4Rw/EA0Mp8KApcj9IkZcH2fbzFc9w69ZCWD
	 QxWCcQUCqkjQqU41/hfpPIM4koPbFs7qCulDcBhHdOMJ3QCJGX+e3RXXt6xbcF+KiMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PYlsUF0lPop6cHdkBrr8x8NT76DrqD0Mq9rNNhd0nxc=;
	b=tD+SSioiwrpQPuMGoPDARzcyMK/22K4eJ4MlwASKfvpuGl/bMLsh36lyaIZS2r+LjiXB
	 S5IR7+KCTFB1TGwpANBJhxoNPasooIMF84YrTAOwMygAhEozez5JVvJ9JdubtVUsc3kDr
	 qoXs+pil5zwiYXlIamjlpmAFu9y04R3uo5hL0Xphz+8fCbphoInl3e0HPjZ41W2/8PUUW
	 EgkMOXMukb2ZBzv5jJyysYGIL3JLov+mhT43gnoxQdMlua90D2BFeOG/tDZuFTasjH4IA
	 9vJbqYfwKP4awWrjv6SOCJh3a+/VYG/iRviyj1Kq3OzKBx9EZJ8GAfzxKm/Xm7QftxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JbgcYPua;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110C4606A33C;
	Wed,  4 Nov 2026 22:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JbgcYPua
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25AD1F00A02;
	Wed,  4 Nov 2026 22:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831172;
	bh=PYlsUF0lPop6cHdkBrr8x8NT76DrqD0Mq9rNNhd0nxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JbgcYPuahc2SgpGiXThPyg5nGRIPThKlazX8f4WRrB74LNjywmhD+Lq0wsXynuW3e
	 81+v9Xasvy+B5SEIQv6Di5kTtTkMZ0merc8C5dCgXmOnWmHZcxUKCxmPGyDikmEXel
	 cNSgnvhQvuuErXSkE0FNI5GmBGiZZz7GGpj83l7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0541/1005] dt-bindings: interrupt-controller: gicv5: Relax IRS properties constraints
Date: Wed,  4 Nov 2026 16:04:34 -0500
Message-ID: <20261104211059.043231508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

[ Upstream commit 1d77e79d62cfe46ad3619d42ee0d1ebd3f0f79f4 ]

An IRS is architecturally allowed to be stand-alone (ie with no direct
CPU connection).

Relax "cpus" and "arm,iaffids" properties constraints allowing a standalone
IRS configuration.

Fixes: 7d7299bd07c6 ("dt-bindings: interrupt-controller: Add Arm GICv5")
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
Link: https://patch.msgid.link/20261015-gicv5-irs-no-cpus-v1-1-d4b337b7f000@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/interrupt-controller/arm,gic-v5.yaml        | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v5.yaml b/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v5.yaml
index 86ca7f3ac2810..b901e4288816a 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v5.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/arm,gic-v5.yaml
@@ -120,13 +120,14 @@ patternProperties:
 
       cpus:
         description:
-          CPUs managed by the IRS.
+          CPUs managed by the IRS. Omit it if the IRS has no associated CPUs.
 
       arm,iaffids:
         $ref: /schemas/types.yaml#/definitions/uint16-array
         description:
           Interrupt AFFinity ID (IAFFID) associated with the CPU whose
           CPU node phandle is at the same index in the cpus array.
+          Omit it if the IRS has no associated CPUs.
 
     patternProperties:
       "^its@[0-9a-f]+$":
@@ -210,12 +211,14 @@ patternProperties:
           - reg
           - reg-names
 
+    dependencies:
+      cpus: [ "arm,iaffids" ]
+      arm,iaffids: [ cpus ]
+
     required:
       - compatible
       - reg
       - reg-names
-      - cpus
-      - arm,iaffids
 
 additionalProperties: false
 
-- 
2.53.0



