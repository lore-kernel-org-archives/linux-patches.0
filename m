Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FAD3358AF;
	Wed, 21 Jan 2026 18:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019786; cv=none; b=Sj2oMkNvL9RL6y+5uW1EnlSZCN4eiKlpHJKtTLZnRVFSaDnuZUSUCtDxmx5s1gK+D/+3gS+iY5nc+9Lio0MHIspbZrwI8kHG17JmxusZDunBT+QGLRZg8NzmFXeldrHMjbrn/Yq5yYd+i9WASE9POAbqocHiMUi9jqJmsyydVNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019786; c=relaxed/simple;
	bh=UBb+QfW7fmVhm5Spra9x16fBWTAqNcbSrAgqHGk2t5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCRDLGHlsCdp7HduZPG9zx0D2hVBN+gHRD2krs6pkOms9T2Cyd6HqvemTCOekB284JuEUwoEGb+nLNhN5zLOyh6fuI5JgsUy6zdavc5Qmu+PaUMBTE1D3xGLI5XWUa4VKQemafmSCybmEki6PIplerbgROmeY8bl8Q46i23YhUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlIftMi/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlIftMi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFE3C4CEF1;
	Wed, 21 Jan 2026 18:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019785;
	bh=UBb+QfW7fmVhm5Spra9x16fBWTAqNcbSrAgqHGk2t5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zlIftMi/ElWKhH24KM3tOdLbrHKSwQCZvUJ3qRh7qT2IAm32EjjN+MHeRpSrtjmWZ
	 29OBZB+f5GXl9DvKUXgiWNx4E0VIZgYMXXrev+4o8bo0AUTVgZCPh3njWWS91cZTpK
	 mik0xz1rqFyLWUnBeeltE6JF0T61P4PXUuGQN/9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Janne Grunau <j@jannau.net>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 108/139] dmaengine: apple-admac: Add "apple,t8103-admac" compatible
Date: Wed, 21 Jan 2026 19:15:56 +0100
Message-ID: <20260121181415.334396691@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


