Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029787;
	b=LfqBLRFj9NtZ0ae7VcfBz0qhkptywQ2fZKxfoklJp3MHVaqKlH2QOC9ERCnBVGBoOE8N
	 wiOhdpDZYyprzjeFyRN+nJQyjXExGRzXvHWWG8UakWBMvJ5v4ViShBDAj1RzdOqEG8S++
	 g2NU3nJV75e4JXZhPHp/WTTMSxywlOIXQgDq7SFgGcaTq/iBVlfLG/W2sLwgWSL6jvx2u
	 ArqVD12QqXhDuwoLgrcsrxetPTXZAKB7PLlbJ8Jf8N2JYEZLY9ywSDwpwT5SYy8pNcAg1
	 1gi+EaIpjVj6gEjhe8lCPduv9WzrV8pwxB5pE2mls7bN88eybQowP2nOrDuCBVLFQnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rrSDxoJGR7YWU3dnFMUkDph/+UzzOk/exRefuOjeXWc=;
	b=OYZRfNe6LYRZSPZLDahR9MaByLKh7u8Uuv9p/L5jTgAz6TF7zgexCqP7jAlGSK27Dado
	 yDJYLJE9aZy+d5rEPi3l1sNKqZkwBmwuXF9NWVUgsjjNBtrjMjrbIkVwNTLMt4lXwkumk
	 S8Nan7V7Nv5dmwG1tjcRFMZyshbd2Vv5LTqfrrsD4txmJhGaBFftb8zeCvZFPIz/1eR1u
	 XZsDeDU6qozH2MF1aG3Vs2nmchy3y3tqCteCCzMIlqEbYMiJ3gMYz4xOIAyf4MpjgyHpk
	 xCecbMtJn9qhqaPHfMeasGLCImZjZObF2jACRNdAf0SZY4i4x7QjoECw7jzweJjtvww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tHy4JcRc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1BF606A31C;
	Wed, 18 Nov 2026 19:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tHy4JcRc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A441F000C5;
	Wed, 18 Nov 2026 19:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029787;
	bh=rrSDxoJGR7YWU3dnFMUkDph/+UzzOk/exRefuOjeXWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tHy4JcRcGI/KynkOVmKIho6vyaZY5AddEHYGsusRLdXIS8HPNIsqbge66kwlASgL5
	 OxpE1E8aO3CRzboeoLVLu6etGCd7afZUh7kF41w9c5pX1wC6NkUWFzQmNQXd5hZz6Y
	 30dCXD/dRGW8fePB6pSTFsOfr6UwWTPKyW2RUUbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0467/1756] spi: mxic: fix ps_clk leak in runtime resume
Date: Wed, 18 Nov 2026 15:43:14 +0100
Message-ID: <20261118150027.432569564@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7f88bf8d3764c..5a7d2c674252b 100644
--- a/drivers/spi/spi-mxic.c
+++ b/drivers/spi/spi-mxic.c
@@ -734,7 +734,13 @@ static int __maybe_unused mxic_spi_runtime_resume(struct device *dev)
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



