Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688843BBA04;
	Wed, 21 Jan 2026 18:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020471; cv=none; b=nNCINN2mbL/mtgHQrWmfJmzMzTBtJAqEa1b7YoR+5uEz2D3m21aQgThsIRRaIXo5OPHn9eSUbRxGatuEkTiIUbIaH9RteoYTF6dwN+X9SUBWeExnx0Hq8pSSFM/oia6ht1YDZyJ2A/LO1JSsQ13+n5C3rr1NLNwnX0L/E2nd7F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020471; c=relaxed/simple;
	bh=tX7bKJ32q7Jqj6c+TaZ6IOsk3jJIGDeZpOyqeLsLei4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkJU37OqVDXtXvsx6EitMuexKp8SJg/wnx4rFCxPG6ahdPYBxEaMMeHXpC7yARVEswEnz8ZGlzjcRMYEBazR9BZ8N5ZdK8qvAAxnqfnf+VqEHw3LRlwrL0fXCXf8tS+iokZIB5kNf6VTIxxWbDHpnYdtB/r4V/K0W4MX4Wb72ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2jlfF7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2jlfF7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06BCC19424;
	Wed, 21 Jan 2026 18:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020471;
	bh=tX7bKJ32q7Jqj6c+TaZ6IOsk3jJIGDeZpOyqeLsLei4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2jlfF7tZR1/pzbJWobi27l2284isx68nwB/azQUogZgaypXizO2QrJ8z7KKR4Tid
	 CoGq5buf4eut6olCcSJrJHC0Mz2enLg/lp4xKhxyl3xieSKLHhN8CtmQELKW+vQEFw
	 4PZkyVfvsYQ1v0ezA8O/zgLwJDa9Yv8Hb2+Y7VHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Janne Grunau <j@jannau.net>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 167/198] dmaengine: apple-admac: Add "apple,t8103-admac" compatible
Date: Wed, 21 Jan 2026 19:16:35 +0100
Message-ID: <20260121181424.556437659@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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
@@ -936,6 +936,7 @@ static void admac_remove(struct platform
 }
 
 static const struct of_device_id admac_of_match[] = {
+	{ .compatible = "apple,t8103-admac", },
 	{ .compatible = "apple,admac", },
 	{ }
 };


