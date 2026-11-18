Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016281;
	b=VSBITIl6xmc8mIkevZsIyossYzD4Fb49JOoQr5fWOxUX6QkdzWastnF5H70jgfzemGcZ
	 FPxfzGjbdH/ES4wHxxwEJrp7l35cVm/7pLLWP9Lb8AILVNZ1+/J5eYbeR+9q+O64ohaNa
	 8Ptj5P8sFcuvPujWy+esyaCw3U1AOpenLfIGByKyr1mhhnt2K3VDbb6K2IiMjKPNeIQPa
	 jcsdqg+/7U1W2ZVNm8x4B9+UNfY+SLvGBAox/AJ5DyrBRb4Rjf5E7iDkr9Um90G0sg6eA
	 WEYOLQQGmfDQ7Xz0PHrVCppv+fgM3TMspqpNzoO/kt64IHviO+llCSfAQ7eAC5NjAXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jqM0kBjdaarWkjaUy+XtrUxNVaFoLWsOLaw477i59iE=;
	b=eApuFhy9GdmfeIO3pz0urCpmRBe9tjWZU0S0r8hZTOobLE3jQMTuQ4AN3FAqDxZjxBBo
	 CFuFj0daRtIPFla06waIDJeUBj7Oys7CkhKPOg6xh4P2HkcSf89HaFZDeTF9wBV3jXjB/
	 i/c04tfM/l2FUwDUBf3LIecZGWEE1RW3szTN6WDSPwOUCI/MSb4+YoC0yv5ETVBIT696S
	 1zzd+wuOVORslEHod5CLx+M02c8ohIUq8GLBNHOIbPkFR1dtDKO3/mVgujjxcPDiUmxt4
	 GHHGjRHe3/0/32bPoRZ+nxMrFwWKFlEETCEFOK2d1jUNcY5Yi4QzoANlQlz5Bl29EcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JDo9AAq7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889EA60A380F;
	Wed, 18 Nov 2026 15:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JDo9AAq7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B201F000C5;
	Wed, 18 Nov 2026 15:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016281;
	bh=jqM0kBjdaarWkjaUy+XtrUxNVaFoLWsOLaw477i59iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JDo9AAq7TDZihOFjOUUpGLAKzpMAkp2iU6v4irZZc8p9cdK3B1wTrmCTW+koy3eg8
	 vt61USs2ggtrZ8cmEPwdWFbcMbGH+9MKSGtx2tLZBQf719rkODLRHZF++SshLZHOye
	 piI7CjsIhHnS4gqh93QT+/ARij9wfoNE09rdFXWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0432/2651] clk: s2mps11: Propagate OF provider registration failures
Date: Wed, 18 Nov 2026 15:27:52 +0100
Message-ID: <20261118150303.377048334@linuxfoundation.org>
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

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 276741aac3b56ba50bef59715ba18ba3f0b953a2 ]

s2mps11_clk_probe() ignores of_clk_add_hw_provider() failures, stores
driver data and returns success even though DT consumers cannot acquire the
registered clocks.

Return the provider error through the existing lookup cleanup path. Skip
empty lookup slots while unwinding because S2MPS14 omits its CP clock.

The issue was found by our static-analysis tool and manually reviewed.

Fixes: b228fad50c00 ("clk: s2mps11: Migrate to clk_hw based OF and registration APIs")
Assisted-by: LLM
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-s2mps11.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index fa5ac8f673f6e..94969d97d6e99 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -192,8 +192,10 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 		clk_data->hws[i] = &s2mps11_clks[i].hw;
 	}
 
-	of_clk_add_hw_provider(s2mps11_clks->clk_np, of_clk_hw_onecell_get,
-			       clk_data);
+	ret = of_clk_add_hw_provider(s2mps11_clks->clk_np,
+				     of_clk_hw_onecell_get, clk_data);
+	if (ret)
+		goto err_reg;
 
 	platform_set_drvdata(pdev, s2mps11_clks);
 
@@ -201,8 +203,10 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 
 err_reg:
 	of_node_put(s2mps11_clks[0].clk_np);
-	while (--i >= 0)
-		clkdev_drop(s2mps11_clks[i].lookup);
+	while (--i >= 0) {
+		if (s2mps11_clks[i].lookup)
+			clkdev_drop(s2mps11_clks[i].lookup);
+	}
 
 	return ret;
 }
-- 
2.53.0



