Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04641DE894;
	Wed, 17 Sep 2025 12:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112941; cv=none; b=TUHm/+8mOcAjTi6BsBG2MwHcZwAkWBpJc3AWAIUK9Hu3TiOT6dUsgwHaHgJE/l5+V9DNxeR26zUKKqol8rMf1dCjzPFgE9SVpgQ/7vs+H7RJcwJh5cbfZtMs0dIUt0FiHjInLj0Oiu+v2wO4zsnq42YJC5xClrHddLWH5BmTGiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112941; c=relaxed/simple;
	bh=Meglzx8el0fg/k6XUiaAp62HVZnNJGr0fIn1x0Ztu5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDUHjYE9vdNHhbaUKXOfVNUM0HxvFGXP0RypPZs3ulTFL7GeqmL2ncIywDfk+PKkjhByh0wPIKWdsrUP4EDjlBbXBBN609gjpXaeRaPq8UpPBu9gOJf/Ej0gT4P+01CnQZfE4Dx75shsDKzCnmQk/EoDDIC4lnr2e2ql3XXL0So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vkn6JKsm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vkn6JKsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D81DC4CEF0;
	Wed, 17 Sep 2025 12:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112940;
	bh=Meglzx8el0fg/k6XUiaAp62HVZnNJGr0fIn1x0Ztu5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vkn6JKsmwnL1TBVkgkvAWhuaq8YfTBoEwaxi0E435X+LJJGZZx/n21iuGBFaLhPih
	 vw73eVHdffV59ZrAQc8fWmw6x0+Ic56BwCvzAOfhZLIXvnBQcDMO38G/AZZTnjagis
	 F5MSqQJ76q7MwGBFmfvLioyp9H4e9pejnwizDmlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.16 122/189] dt-bindings: serial: brcm,bcm7271-uart: Constrain clocks
Date: Wed, 17 Sep 2025 14:33:52 +0200
Message-ID: <20250917123354.841258391@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit ee047e1d85d73496541c54bd4f432c9464e13e65 upstream.

Lists should have fixed constraints, because binding must be specific in
respect to hardware, thus add missing constraints to number of clocks.

Cc: stable <stable@kernel.org>
Fixes: 88a499cd70d4 ("dt-bindings: Add support for the Broadcom UART driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250812121630.67072-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml
+++ b/Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml
@@ -41,7 +41,7 @@ properties:
           - const: dma_intr2
 
   clocks:
-    minItems: 1
+    maxItems: 1
 
   clock-names:
     const: sw_baud


