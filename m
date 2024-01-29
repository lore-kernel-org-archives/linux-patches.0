Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA9C73732;
	Mon, 29 Jan 2024 17:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548534; cv=none; b=B4SlAOEEnXJmu/gMzj8Zf330Vwmer8P9c+5YTDTyQKdOd+cPb37JDdtJa6BvLn/+b+ptWHQOCbYMI9qI+i/k0fQ4Mn5V0RRouvn29/CHxB+XpfOP5p3LTNAFVze4+IsDheF4YU994bvfLUZIbr0+/kw2JDOAgD3htE2+81VpoDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548534; c=relaxed/simple;
	bh=J1G2JV9vEDvDuL+EHiWLaoFL8ZFF3VCvcK3kS69H3a8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UF2ctgyIlD8RrBV8lh2zKXRTqhi/7stei8s0O4IEVfffdk8mQ3usYj9ZjDUtRf+omCdptL/jLCGn/33XE14d8Knybwl+T6dFyKZPCHPE49enlAShJZ5LS5KGaFmw35ZDPxJwBQsgzvjfK4B/LaeLQm8zfSXMoIQjqtwdqflZiB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qL2R3dc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qL2R3dc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F012C433C7;
	Mon, 29 Jan 2024 17:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548533;
	bh=J1G2JV9vEDvDuL+EHiWLaoFL8ZFF3VCvcK3kS69H3a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qL2R3dc9cTKnwxK4KSYiHciTgyJ7w9nerKctTDAdD9AqVPVp96Y/biS7DuiqCFafP
	 Q25noCUsWbaWmrZ3xNWwVgm01fjLrwOq10dGdXB7MbQ9CZgOcuNF4s/JyNQC7qRFI5
	 fxo8E0I/gUFgeGXJ1xlxlRwZkKIUfLd7a7rZEbHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan G Thomas <rohan.g.thomas@intel.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 145/331] dt-bindings: net: snps,dwmac: Tx coe unsupported
Date: Mon, 29 Jan 2024 09:03:29 -0800
Message-ID: <20240129170019.174526925@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rohan G Thomas <rohan.g.thomas@intel.com>

commit 6fb8c20a04be234cf1cfd4bdd8cfb8860c9d2d3b upstream.

Add dt-bindings for coe-unsupported property per tx queue. Some DWMAC
IPs support tx checksum offloading(coe) only for a few tx queues.

DW xGMAC IP can be synthesized such that it can support tx coe only
for a few initial tx queues. Also as Serge pointed out, for the DW
QoS IP tx coe can be individually configured for each tx queue. This
property is added to have sw fallback for checksum calculation if a
tx queue doesn't support tx coe.

Signed-off-by: Rohan G Thomas <rohan.g.thomas@intel.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -394,6 +394,11 @@ properties:
               When a PFC frame is received with priorities matching the bitmask,
               the queue is blocked from transmitting for the pause time specified
               in the PFC frame.
+
+          snps,coe-unsupported:
+            type: boolean
+            description: TX checksum offload is unsupported by the TX queue.
+
         allOf:
           - if:
               required:


