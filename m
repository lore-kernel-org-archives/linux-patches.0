Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016519;
	b=hkXpLJcc48VhJeRvtlJP5s39MXoU6PQmAKLm1RZPzAH3nZnd6RgqRmvFF2wjZzZW1R8H
	 DGzh4Qt6WMmp6RVKJzy1jvZ2Oq7snY6OSm51b151Cgq1c5v/TnOhqf5Stf+ui+Ofv8ZV+
	 VsChr6TUjz0oivzr0dEC54prXCa3oFS9xOyvZX8DJ4R4u1weXAIllTzA6kpcQIQLvDiHt
	 MHYblVRH5wqppHOtrFmXLa5rN+ziEaa6g2DzpZkyDzV9FXQ9RHB75vczCTmBvksyR065u
	 qOpmo6QuU1TgOYPZHq1vEj3TY6IKzk1b4tlAR2tiJw2pT2wLiduwfQlyorGgna2S1AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FDImzFdj3agR5ZGKBQIHbUL/1CiZ1PG/I8OE7/lzHR4=;
	b=Z5tkT/OjRpkz1Ni93TiDrL+cv4QWGwmfRzxwQA5d1mqpswcsQlJnfJAUyMS1xYJon3Y+
	 6RmALVnBWI3WrXEQLP+u4QkUHgj6zZuNqFHNplaRFYQ9lUIocYcz6tBMi+JtLx+jnQFQk
	 c3NbxJBzXG5L6qAF/TWuL0hUxfEZX5ooX92hHGGakov5zGib+gBMMHvBO9OkQ9t8wMHWI
	 5HD6VMPKOK4O1uRqUWGp1etR/j1/2fXXD6jUD5QVTSwJw9XUiXfFPVt12BBOkoCTnm/iI
	 vcvRSW6I7O2daiHX7bEDDgdqwEdHVP57jKiN1K6255RX2RYIY+sO8XQmpmfP3y90IlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="B4z/a2sq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3844E606A320;
	Wed, 18 Nov 2026 15:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B4z/a2sq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A961F000C4;
	Wed, 18 Nov 2026 15:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016519;
	bh=FDImzFdj3agR5ZGKBQIHbUL/1CiZ1PG/I8OE7/lzHR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B4z/a2sqFC7/o0ogqAWakjqKjluzUNUWj/+SsgHwBtpTz8ZoclZuSe5Gt5GpbRgOA
	 IjbB3lBG92LWPmxoTjd2QMZXe/S0U26JNV3/wMJ0Uxb1RtHOn8C5V8j4aoEDAKi+RC
	 ++CR5TXlHD0UY9iUSRGz/XUvFkpXmdkwMCNL9PH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0555/2651] dt-bindings: interrupt-controller: chrp,open-pic: Fix dangling reference
Date: Wed, 18 Nov 2026 15:29:55 +0100
Message-ID: <20261118150307.725066382@linuxfoundation.org>
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



