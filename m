Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023816;
	b=4PvTxNVa5OTrqJAkfhapmrDR1DygaGnoDcIOw1MPt12KVuVQCjdNuERDkgSeGEWpZRzo
	 Rmf1RYgw9fKwSLegFFPq3D4hW5aahCwdlHtokwj9GhFvrxBrG5Cd9I7g0eu0WGqX7mkhY
	 wkictD/xt6WJ2j+3arS44FaGPBiCOFR9cF9y/gr92AszYV9sw2e7puo2PGE4zW0VoJPMH
	 /4IO5jouyfhldny9l53T/5xZnNcA68+OeeOOJrAQmzcvMyvHSQ+dUq9KmFwSOCKhziYFj
	 fv8/Cc1oWAQNhGXDL+s+uWBgAzSCnz2KAXC/eU/lnPZgEN6j1mTyO8HqWUPWmR6qLyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2vfI2nxhFhm9mA+lLG0Aiey6ObTvBZGyUVrI/INCbyY=;
	b=POsNdZdX37sUFP3ixdTVN2rhGG2cVcSAQhqWc20uIJTZVYahmKbdbjWWLRWTW2ZR7Ez/
	 Qg/H26ncpSB6FFAFc+DRRujJNwhBy5aG1ZfB6thjdlLjBLm5iOcl8BJaDoj/QUnfi3Mpi
	 wU3apFKrG+PJEKpXJd7p68gkqPqksJtjK5TV2KLPKr/IvZfITmQC7gCLaZF1+Q2obRK+n
	 X4wS9ESzUETJsgte3Suk9CfAM+NVKM7IdbUlUcp2xv426t8ALONYdzMfuT5BQ2mvL52hM
	 cCKPdhJQrxAXpvDb5qV+dcqH+mSYwFwJ86GpfKHgb3TYb2Yt6yMyZ5lA5wwlJD/mB4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=chFmXoHH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB47606A332;
	Wed, 18 Nov 2026 17:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=chFmXoHH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682411F000C4;
	Wed, 18 Nov 2026 17:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023816;
	bh=2vfI2nxhFhm9mA+lLG0Aiey6ObTvBZGyUVrI/INCbyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=chFmXoHHVRS0QzLEoMGjBHV4iu1PvOUdyN2592FJ67di8o3PXU7wg8ehpLEuOq0kg
	 Lyk00HyPd82oKrEiQs9IO84jSBcrFzQbg4h4ZFW0ivgFSGtjUKs3SKQ7iM++2sADtp
	 geWn82AQ9W+7jpUh8dCMkVE+UK3Y9ua0kcCkyXlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0503/2151] dt-bindings: interrupt-controller: chrp,open-pic: Fix dangling reference
Date: Wed, 18 Nov 2026 15:37:18 +0100
Message-ID: <20261118150140.374339509@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 2fb6f1a87cba099b2921fc3e777bf399d4153a39 ]

The target of "[1]" was lost during the conversion to json-schema.
Replace it by an inline reference.

Fixes: a241f1a1b338b714 ("dt-bindings: interrupt-controller: Convert chrp,open-pic to DT schema")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/86dd3544f7286fc117dc7ad0f6d799761283ec54.1788426169.git.geert+renesas@glider.be
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/interrupt-controller/chrp,open-pic.yaml         | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/chrp,open-pic.yaml b/Documentation/devicetree/bindings/interrupt-controller/chrp,open-pic.yaml
index 5363f4c6ffbcf..294af57a7c372 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/chrp,open-pic.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/chrp,open-pic.yaml
@@ -12,8 +12,9 @@ maintainers:
 description:
   This binding specifies what properties must be available in the device tree
   representation of an Open PIC compliant interrupt controller.  This binding is
-  based on the binding defined for Open PIC in [1] and is a superset of that
-  binding.
+  based on the binding defined for Open PIC in the Devicetree Specification
+  (available from https://www.devicetree.org/specifications/) and is a superset
+  of that binding.
 
 properties:
   compatible:
-- 
2.53.0



