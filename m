Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619881;
	b=lma5heNuuSkhYz9t4clvf7l2y3xYJAIn84XNKWZjDknmA4W3JQlGz+bVahUXWyn3z5Ei
	 O2MmEMuIW6zMbqC79KG9wJZ/qLDOkkeesH77Dep6zxxSTbVHqqMpSoI/e2JxA6bL0rTck
	 ecAjsX1iSLSyKTbqTiVPqqNC1y4zBbUabsZo7gl/80i24/v50X3V5mKnwWRUxqIdtK3a6
	 wrss+c0xXB6OwQEZ9GaAECNhzJ9U3UuyGiqwGZkQAxsutwoaczyaM/wmp4E4mCadJeaN/
	 UXOCW7s/Oo67bj3ZUkoRMJKW3uNe03dmWMQyTDG1HyZMEeYtkmFWxcnwYKUXISLHLtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SVPqftiYavmRGN6Q9iz9jSeWZ/uzwWDG1krk+lhK9AY=;
	b=QhneKi60eH410h04l+oRKYra37fcUuEfT3HgQlfTsEMqpT//Q9il6XQ9aGik8sgSZl9Q
	 hqZABx+bYNB1qSRIk8ig8GkLEcmZlHzhC0UllwYTX3DT5w3X9IKQg9iyRfpR9WX6U+EMD
	 b8pSuFUOQPj/by7BNwOx94jAeqMCkGRCtVdF+c+AIDCQGyKNe7Sj5DAn76j0BDGMe/DXL
	 j8JbiNYvJlbMN/UpvFiBSkfVgQuEOcx+wgppFUGdGjcWCl+TTek/OfDrkUMu8NsOa9ag4
	 ZmldxFZfTQuiaY8gAPFRrGKEYOsa4zN95MDjLtskUUORN3gG9xEfyggSbzPu1iYeG7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="R/NStexE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C729606A31E;
	Wed, 25 Nov 2026 15:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R/NStexE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B8B1F000C4;
	Wed, 25 Nov 2026 15:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619881;
	bh=SVPqftiYavmRGN6Q9iz9jSeWZ/uzwWDG1krk+lhK9AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/NStexEBjMxWxKeqoQ9iXtd7+1eR1z8kSgWgIh72sA7WOOJjMz4coiV1Xk1SNlw4
	 NIhYuwa7r+E1j7sQJKnpiqZP1pLYxBKgOSfcCU/8/sl3jONS9IOILca7pJ1BB56kTR
	 GbvCGWeqPCGQ1h0Sg+L8HQChmaTeYFeBmVVT7/Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.3 0735/1005] watchdog: rzv2h: Use pm_runtime_put_sync()
Date: Wed, 25 Nov 2026 15:34:33 +0100
Message-ID: <20261125143838.977784414@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

commit ca800e625d18a9f5b19f94ab837ceb3fccdca22f upstream.

pm_runtime_put() may trigger the idle check after pm_runtime_disable()
is run as part of devm_pm_runtime_enable()'s cleanup action, leaving
runtime PM active.

Use pm_runtime_put_sync() to ensure the idle check runs synchronously.

Fixes: f6febd0a30b6e ("watchdog: Add Watchdog Timer driver for RZ/V2H(P)")
Cc: stable@vger.kernel.org
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://patch.msgid.link/20261001165201.763882-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/rzv2h_wdt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/watchdog/rzv2h_wdt.c
+++ b/drivers/watchdog/rzv2h_wdt.c
@@ -174,7 +174,7 @@ static int rzv2h_wdt_stop(struct watchdo
 	if (priv->of_data->wdtdcr)
 		rzt2h_wdt_wdtdcr_count_stop(priv);
 
-	pm_runtime_put(wdev->parent);
+	pm_runtime_put_sync(wdev->parent);
 
 	return 0;
 }
@@ -268,7 +268,7 @@ static int rzt2h_wdt_wdtdcr_init(struct
 
 	rzt2h_wdt_wdtdcr_count_stop(priv);
 
-	pm_runtime_put(&pdev->dev);
+	pm_runtime_put_sync(&pdev->dev);
 
 	return 0;
 }


