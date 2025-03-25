Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496ED2690FF;
	Tue, 25 Mar 2025 12:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906006; cv=none; b=nLKh5ZCilVKXKObVjLSx43TguphFiR8AaV+N9CE02UiOy2bUYqz7AZ5R0GQef/KBA7HdqcyPU2vmx09kL0Fnn1C8+YCRKCiNfa+esJ6eM5/fLVd3hrHqZVqxMPB+my25nXzsy3sJr9xy3vRvkgTyqnDz32M+Ng1iRpIZr5O4oq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906006; c=relaxed/simple;
	bh=AI4m7FcNGF1eW9R1qWPUN2Q8Ptvp5OttdcIwa+DsAz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/56btZCl459SVQYMY68sODFVq+g7Atw+D9TbZEsnnN+vnN0//Ye90siIFwRR36MDyzBgYGJpIcMotg6vQ1SqFS6+DPw1GddiNNi5ANoTkPbZxnDJzMRYM+yEIPOU2zidzyuX+lep0c+zEhQU1pNFSka0rt208Yk4JIpescDkQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMzaLYqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMzaLYqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F017AC4CEE4;
	Tue, 25 Mar 2025 12:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906006;
	bh=AI4m7FcNGF1eW9R1qWPUN2Q8Ptvp5OttdcIwa+DsAz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zMzaLYqXcTnKElKDu+x6WXmbOEZ2uj2c9erPKIKSoouYGrcozK2kPItY9PjkSAfAY
	 CeFQtaYnkX7Ch62HQ+5/JGiZdsw/M8zkZyp66uRj0s3z97xQHmWr+kFrq5lIQIW3YT
	 SDYBcQ0ScO6enOrnkqEz4AlJLccTH+kcswQRFN9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.13 056/119] dt-bindings: can: renesas,rcar-canfd: Fix typo in pattern properties for R-Car V4M
Date: Tue, 25 Mar 2025 08:21:54 -0400
Message-ID: <20250325122150.485552724@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


