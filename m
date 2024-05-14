Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BF42D60A;
	Tue, 14 May 2024 10:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682836; cv=none; b=tWfB7/pQ/iGIm6R5oUmSmSJjRC8ql+ZLPPIPJYqw1HHZ8yoIlUaCUkAsXszC/+3dPhYXKQzAegoSPiGhvl0jJ0GtlNJxhlV8qOgyOgY7NJlfZry0EcI+4sQSeZyUgcLk/CfXhmUtRNrhE0VCFerdDwI+I6XSETjQmoIKMaRLWng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682836; c=relaxed/simple;
	bh=+OFs2eWCdI29s5dq2kPIky8xhAQxoBqLkqZU39Zyq7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ctQrUogu5y/WwElAsPdhIuYp5YDe0eLpWDgYxC3LyLFfbJa+GN+W+d5EGT/nGb5nKWBYpT7E3Js9A71smrzy8ElJhCB6xi7FFgyjt+hm48AM9ZU0xCqPg8o4ZoF+JeAVA7mvpyvcqAJq/NJmUpfw3bK8w37YuEI821X9jFVED9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZVZelqg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZVZelqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43204C2BD10;
	Tue, 14 May 2024 10:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682836;
	bh=+OFs2eWCdI29s5dq2kPIky8xhAQxoBqLkqZU39Zyq7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZVZelqgmD8dbjiMWcQ2hPAwz5EGfG9B8cA2k9nWcQp8c0Pqr+YcTt+IsjsFRLWHM
	 FYhtJJSqZ0hvZdRqqpV0Zl2loh9jULjnRr3hZMlyM1BoxIpSVAwn9BZ06GUPJHGThj
	 KrrQ+1PT1g9rIW9VepSwrKybOJqUx5DZTlG9l9lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Apitzsch?= <git@apitzsch.eu>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 121/336] regulator: tps65132: Add of_match table
Date: Tue, 14 May 2024 12:15:25 +0200
Message-ID: <20240514101043.172718531@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Apitzsch <git@apitzsch.eu>

[ Upstream commit a469158eaf8f4b10263b417856d923dfa38ae96d ]

Add of_match table for "ti,tps65132" compatible string.
This fixes automatic driver loading when using device-tree,
and if built as a module like major linux distributions do.

Signed-off-by: André Apitzsch <git@apitzsch.eu>
Link: https://msgid.link/r/20240325-of_tps65132-v1-1-86a5f7ef4ede@apitzsch.eu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps65132-regulator.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/regulator/tps65132-regulator.c b/drivers/regulator/tps65132-regulator.c
index a06f5f2d79329..9c2f0dd42613d 100644
--- a/drivers/regulator/tps65132-regulator.c
+++ b/drivers/regulator/tps65132-regulator.c
@@ -267,10 +267,17 @@ static const struct i2c_device_id tps65132_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, tps65132_id);
 
+static const struct of_device_id __maybe_unused tps65132_of_match[] = {
+	{ .compatible = "ti,tps65132" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, tps65132_of_match);
+
 static struct i2c_driver tps65132_i2c_driver = {
 	.driver = {
 		.name = "tps65132",
 		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
+		.of_match_table = of_match_ptr(tps65132_of_match),
 	},
 	.probe = tps65132_probe,
 	.id_table = tps65132_id,
-- 
2.43.0



