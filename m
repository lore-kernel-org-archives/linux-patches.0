Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023907;
	b=K3Q2EejgPy52/RDnTUAZk8owyOIpBjfLWCQaQ+iqWbOAQkdHDWxSXIoEbET9sIG6Xt6l
	 kKaANuBWCfHkQVKrxk9zasY5qbD+yO6CmC4j0kz9SDbTMKZSbO/WHQNGL90ju4jMGjekc
	 ctCmEfxoQcDDb1sUk2MU+cvyh8SNxaJQdS0b2aJfOw0paZsQtMe+CPk1wvlj5HRBBhqA5
	 Z/khyZsXZnlGYYSH6fvKmYdIyx5SA6mYudVLULROAFUTdhUpBbXxqcD8Vf9t970ekNT3Q
	 97nJwsBgxO1KF+IIdygltqPHQ+tWo50itOsB/YGFMDNWb2R6PfumY2SCMRmLoP/wzSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zvpGnXyoItOjbRPaPI6tuUTgPmSMYDUDN1xaD1Sm8qE=;
	b=AuDatj/Vd6YYM7Un1jl11cu46V8PNQ+MulkjvAhAFJr+F9S4kf/+YmGS8X+PL3lasW4Q
	 9RIHpEbeqKvGK+tavh3eXfQQO5i4xc/l3S9iUKy4wEi+YyTX8IPKQCkrllkfFXwXSefmI
	 TfeFiogtURljoxBhdidbwJMhxCu15e49YTPp+cEy2SVgvhW5hPZyxxh5i3z+IfWkn4SXp
	 ITVL9b6X5gZYyDH/n6AU7PLOswwQZ5jyDegxizztrmEHcqVNA+Ue8ukRhA00W17L2s1zA
	 XlKUxmtNvlhn9UtH/3f/r0EvdUDy/G38QZfsXGVCfN3gPmW5/BE6+8UgJO7jR2LdBqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wOhYFmkL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CC6606A320;
	Wed, 18 Nov 2026 17:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wOhYFmkL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B821F000C7;
	Wed, 18 Nov 2026 17:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023907;
	bh=zvpGnXyoItOjbRPaPI6tuUTgPmSMYDUDN1xaD1Sm8qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wOhYFmkLkpTz2PJ2+/VLQdC05erg4D3ojah+Jo5g7ADfG2foB3Vijz5t3j7GbPDAD
	 kNRndkQwdVED1oJ20oY9nJBONmklWHmDOYQg8mu+y2Qx7RWdTy06z3bqbY/G9+aPcl
	 YOJeS4yp1CfRSKrO6zRsdYuMPiIeDsuczHOpQ4Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0536/2151] spi: mxic: fix ps_clk leak in runtime resume
Date: Wed, 18 Nov 2026 15:37:51 +0100
Message-ID: <20261118150141.532781250@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 648e3c436032b675b339662ea9c0edd9221add76 ]

mxic_spi_runtime_resume() enables ps_clk before calling
mxic_spi_clk_enable(). If the latter fails, ps_clk was not
disabled.

Unwind ps_clk with clk_disable_unprepare() before returning
the error.

Fixes: b942d80b0a39 ("spi: Add MXIC controller driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260902-mxic-v1-1-76806325826d@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mxic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mxic.c b/drivers/spi/spi-mxic.c
index eea4a588e8a0c..9ab94a8f573b6 100644
--- a/drivers/spi/spi-mxic.c
+++ b/drivers/spi/spi-mxic.c
@@ -744,7 +744,13 @@ static int __maybe_unused mxic_spi_runtime_resume(struct device *dev)
 		return ret;
 	}
 
-	return mxic_spi_clk_enable(mxic);
+	ret = mxic_spi_clk_enable(mxic);
+	if (ret) {
+		clk_disable_unprepare(mxic->ps_clk);
+		return ret;
+	}
+
+	return 0;
 }
 
 static const struct dev_pm_ops mxic_spi_dev_pm_ops = {
-- 
2.53.0



