Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1731B26ED40;
	Wed, 28 Jan 2026 15:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614243; cv=none; b=giHzPNPnP2e7cPMVgoHhb7beiy9ySLYJfJLyL+uVlaLtptxqkes38aOmHK7kjulxf6XduX757vroiAurAzJcCmvpcUv/X/B3cqhkX3+i6lyRV7XumxfOdWoZs4HLx8vHc2AlB2vWI+ANYJ08IDhqMlPBYWyqPrP29IxKgexiMbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614243; c=relaxed/simple;
	bh=h8UZdqi+zDqL49nxiQ516CTF5LlXrcl6KH75Y0bsb+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qa9yPQweNxd59B0S8OJVWBohtqozM060fqofBOp3zs13hvCBfX+iOfBnL/j1Ccld4PHWpNkYxoecemXHnjaHshPifg8EPBge5JIUzJVuxnfiVMRVVcEx7I8lfq+jXUjxpdg1awZscv0gL2BTSpVqpXVL+glu5QSfMvWh/rE0XJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QcNe3ZWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QcNe3ZWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C704C2BC9E;
	Wed, 28 Jan 2026 15:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614243;
	bh=h8UZdqi+zDqL49nxiQ516CTF5LlXrcl6KH75Y0bsb+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QcNe3ZWobok/gv6Li6SWjhMrj1/tpGyQDpssU/npNAhxU5zsh8Bv/dORXdBiGh177
	 Tmv1XDzHmSReaBBmr2SIITCHAd92NXaDaj1Ba1bkDHsBu5y20TxaIPWEyixiLRbfol
	 HHCqccatP6gY1Bjb4MQ+1NbFLmVY0fUsGwoSCnL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Janne Grunau <j@jannau.net>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 078/254] dmaengine: apple-admac: Add "apple,t8103-admac" compatible
Date: Wed, 28 Jan 2026 16:20:54 +0100
Message-ID: <20260128145347.500874853@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janne Grunau <j@jannau.net>

commit 76cba1e60b69c9cd53b9127d017a7dc5945455b1 upstream.

After discussion with the devicetree maintainers we agreed to not extend
lists with the generic compatible "apple,admac" anymore [1]. Use
"apple,t8103-admac" as base compatible as it is the SoC the driver and
bindings were written for.

[1]: https://lore.kernel.org/asahi/12ab93b7-1fc2-4ce0-926e-c8141cfe81bf@kernel.org/

Fixes: b127315d9a78 ("dmaengine: apple-admac: Add Apple ADMAC driver")
Cc: stable@vger.kernel.org
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Janne Grunau <j@jannau.net>
Link: https://patch.msgid.link/20251231-apple-admac-t8103-base-compat-v1-1-ec24a3708f76@jannau.net
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/apple-admac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/dma/apple-admac.c
+++ b/drivers/dma/apple-admac.c
@@ -938,6 +938,7 @@ static int admac_remove(struct platform_
 }
 
 static const struct of_device_id admac_of_match[] = {
+	{ .compatible = "apple,t8103-admac", },
 	{ .compatible = "apple,admac", },
 	{ }
 };


