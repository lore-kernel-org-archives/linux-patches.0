Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F4527979A;
	Wed,  8 Apr 2026 18:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673488; cv=none; b=uDlp8o+uFR1/Skvl99l8iW3FWPlDtTO+rwGv2SVp7Bb3ThD1jAuD+V/3zw7NOAeEJhl/3HWAsbarUwztyIfLIVou5E7xOi5kFYzG4UhK85Dl5sMGXpxyZqva79uvV95XY4WAAEvV/0b8P1Oh79he2dG6mJZ5cq8TEK9k7SnfWhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673488; c=relaxed/simple;
	bh=u5uJK5ABzO8uX780ArYwKUJvdiZdb3avnuPDri9RWM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQt4KdYBoeovcZGwpxxg+JtGTlggsSxxrtdfWTB4YDcfpQLEVbclIL6sh8tRza2f1BCayXMuSM5j+A9rNKy9trH7qBCU6NqnF31JIii1nziosqVuqZLEoOepowGB6iYPx4ZWHtzpv0LylZCTrNavEmHByMykae3qCAtNYSR2d0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgV80PxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgV80PxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE490C19425;
	Wed,  8 Apr 2026 18:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673488;
	bh=u5uJK5ABzO8uX780ArYwKUJvdiZdb3avnuPDri9RWM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgV80PxM/DiJGpgxNSxEq0gUZ0drQXPJ3Xdxi8NR+ZAn9RN1YtYBmnGPODobxTzpr
	 T2f7VZq4gL9pTeKAnKezfvySeuwgKL+5CnJ1e38ci+4cOvVhIhaDSNdROHVt97kxn+
	 UsuUSny/KlQWKuWL4yEi3bgJ6saqiinJt8Gbsty4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.18 219/277] dt-bindings: connector: add pd-disable dependency
Date: Wed,  8 Apr 2026 20:03:24 +0200
Message-ID: <20260408175942.034911415@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

commit 269c26464dcf8b54b0dd9c333721c30ee44ae297 upstream.

When Power Delivery is not supported, the source is unable to obtain the
current capability from the Source PDO. As a result, typec-power-opmode
needs to be added to advertise such capability.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://patch.msgid.link/20260330063518.719345-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/connector/usb-connector.yaml |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/devicetree/bindings/connector/usb-connector.yaml
+++ b/Documentation/devicetree/bindings/connector/usb-connector.yaml
@@ -301,6 +301,7 @@ properties:
     maxItems: 4
 
 dependencies:
+  pd-disable: [typec-power-opmode]
   sink-vdos-v1: [ sink-vdos ]
   sink-vdos: [ sink-vdos-v1 ]
 


