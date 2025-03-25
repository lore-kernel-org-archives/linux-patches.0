Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8474258CC8;
	Tue, 25 Mar 2025 12:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906319; cv=none; b=FLX1i0zTyLqDAH/dMCaR8TaaW70eGYPtyHPnsncVOGXEHRMFsPPphhrgz377ONc/4Ok/vLNTI4BNiHG5W/goI/zyMyTRjB4HycS3w7J6yMSVWRJwmAwQTY6R/ROTclY4dzL4hgNwjVQa56klMTsw2uwt3QNOLi5Ujf8vI7CBMRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906319; c=relaxed/simple;
	bh=o/S+NrM2eI0WThpIzyfkbXOHRQMQvUB25EwvMqJoQZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tw6OhBXXZRTNepp8snNGJ/AS3PzLREN2EGOtV+xcJWBCRGnXuA+usQk+QiiYu1AlkHDWPcFsfj7YY3walBpSDOGZ4bTCr6utbdoFVVO7TnjrZ4Vjue9l4DQRcU0frYHBvRLy36bBqnE//G6WNCYagOHVb9IjpcF9/9i1yx5EqB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rr8ByTZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rr8ByTZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863A4C4CEE4;
	Tue, 25 Mar 2025 12:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906319;
	bh=o/S+NrM2eI0WThpIzyfkbXOHRQMQvUB25EwvMqJoQZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rr8ByTZFoRdrRqfLU7DnomRYgYLqx+bfiXwg4DlDle0kPg1V27bsaqzAGVBqNBxSR
	 VCMl3w+dqQDzBA7uD5ElwjZL3ec2CQzatSizoRVYDGQ/rMy6BIhoZZJ1U83l5mEfZh
	 sHpAiaIytEEX/msPN0AxBlwVxWSG9vfqq+m7eGN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 054/116] dt-bindings: can: renesas,rcar-canfd: Fix typo in pattern properties for R-Car V4M
Date: Tue, 25 Mar 2025 08:22:21 -0400
Message-ID: <20250325122150.589706293@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

commit 51f6fc9eb1d77ae5cacc796fc043dedc1f0f0073 upstream.

The Renesas R-Car V4M(R8A779H0) SoC, supports up to four channels.
Fix the typo 5->4 in pattern properties.

Fixes: ced52c6ed257 ("dt-bindings: can: renesas,rcar-canfd: Document R-Car V4M support")
Cc: stable@vger.kernel.org
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: "Rob Herring (Arm)" <robh@kernel.org>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20250307170330.173425-2-biju.das.jz@bp.renesas.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml         | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
index 7c5ac5d2e880..f6884f6e59e7 100644
--- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
@@ -170,7 +170,7 @@ allOf:
             const: renesas,r8a779h0-canfd
     then:
       patternProperties:
-        "^channel[5-7]$": false
+        "^channel[4-7]$": false
     else:
       if:
         not:
-- 
2.49.0



