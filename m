Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826964;
	b=VlZmx/okD2MUBUgRQ2ZPWVW2i/Ty7p/IrKk0fRZYzQ9UAP2+n0RfekBPmOAMdtr/OtEN
	 oRKUtwh6Qg340eG9y56CRUoC5qEt5KzqR02XbB8sJXB/7s3HXfZbgRxMrtU4Er81+IK1g
	 TjRwShJ2W6fGIvl/4BzugD8CQNPbz8p1/HTWbvyPKP5+mH+tWqqtDhP/E36oXrIjJztPj
	 ReH3veIR9VqrMg3/JxkdcyIxRKx8dY/k7IjFfsEEUvjU6ELZelGOfDau2wLf1flk7flSl
	 ZJDmDSU9mV+WcTCMSVNW3xDQ4x93nujWwNGCmkE/N0YcxjDeUj58aFAJfiChZbp2xww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gF/qiCw3ewFdXLBxi0Zmh22mFHH2ofoUcu4p5jmap8g=;
	b=Cif6Dq1T2MmcDrp7iFcy+/gLqxhRwBlFISw8xboaY/VF+QqkySBvylqbKuypTbup+6Ln
	 B2ZgJqGvJOWdxYmu5TYJzyHMMoNvFH+FFINXuConeMcJ/w8rH3NFtPT9rgE+WObaUflm0
	 LeWrHFjwqEddnJLch/nj3CWsh4nwZ28pNltTQ8IZ4t58fmPup0e+buP2ThUcDrgAMtOg2
	 y+EnpVq+lPf3YGfT6Pu27K05W2FuodyASyMmMvkkrAeEZjNsezS2FVulHwyfEXYmVbf1h
	 XXUAKBEbKqCsE5f9XfEKFi9+8CCfw8ykGG3WyqUzClD+oZ1KRhfWBTjgqLkMoyMvhTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LO6Mzov9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291EB607031C;
	Wed,  4 Nov 2026 21:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LO6Mzov9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A231F000C1;
	Wed,  4 Nov 2026 21:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826963;
	bh=gF/qiCw3ewFdXLBxi0Zmh22mFHH2ofoUcu4p5jmap8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LO6Mzov9O1/hpvS6pxswUs661cF4k8rHbXetr6lUguQSiBpUODXppa8bNFoEmnctF
	 I0+IDon3rSiCZ0uo+BTR/nDaKfGK2nqB8ytonMaMkNMk5jj77e9fLUClOHp9h+ingA
	 ZXkzaF8kcFtNb2WJAM5thZenlZrD1HYzx7ZNePLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 095/547] dt-bindings: interrupt-controller: gicv5: Relax IRS properties constraints
Date: Wed,  4 Nov 2026 16:04:39 -0500
Message-ID: <20261104211040.926872762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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



