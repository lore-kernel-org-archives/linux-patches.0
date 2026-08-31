Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B752E44064C;
	Mon, 31 Aug 2026 13:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183499; cv=none; b=XKK1W4R/EkGlNS9iie6CJF3gGOgz/MvreRLH23ShWEa/uiUwNPeZhHRiNocRXRa3uOUnhmBWna6rkupUhmUh+Rq6kmZLgdG6yu9m3kPShCxVGvpiuAFIhzZVnNER8zeWtCVDsg4nEKBqEam6QfwonkzPY/I2qLkqvkCWkXNy/A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183499; c=relaxed/simple;
	bh=6zY+2KicO2UddEVWghCev2abWOaKy9oBTzCCtqwaIcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rmf4sfxf4U2Vg+5kQvn1/f1U1QhvBYTHou3233hbQDjRNXzwssIr8euuGiTk1sebfeaMBroGu3yti98rGsnueY0FCInrgvDAPbOBBwc2Cmlyo5aVO6vhFEd1Yn7B6IBj/JsFD37HdMRO4PIYbQS0vXYYsglijSF3Mu7CZQ7kXX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oi6MuJ+w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oi6MuJ+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80341F00A3D;
	Mon, 31 Aug 2026 13:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183497;
	bh=bkZBGL3+X/dmTn+dHtMqjPuxZkeGcZsaEzpahc7J6NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oi6MuJ+w4tU9XFxdn4p536mjNt458n6I80+ma4Cd9pnnvIKQuaCTiNhjdP6ytYG7U
	 chSPYJY9Jsz9vmm6CQfh3ayD9c1FbfY3UKRJYAHCTn/W4X6YbhTP1A+JLepztO/0fZ
	 xVgudL8qmcHadFAPufHmemEsaPdeUaJ7Lw4a4DiSLWD8yD/iITK7JrySpJRtzmMjqq
	 qQ8HbNX+46DNn/gbTqs4PieU7nWZ5Z8sqcNNVEibYe1PAD8zhf6sN6g04yBhYSfOxg
	 4hGXOi83H4/nDpLsE9m1X+vdMr46gQxlYzwS7PMdTmT9SylVXkF9G5x6JusTHVYC5a
	 BW0tWHV+ir4YQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: guoqi0226 <guoqi0226@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] spi: Add NULL check for spi_get_device_id() in spi_get_device_match_data()
Date: Mon, 31 Aug 2026 09:22:40 -0400
Message-ID: <20260831133314.4125787-132-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: guoqi0226 <guoqi0226@163.com>

[ Upstream commit f1b061b4d4c6cbf861319ba954caa80145cf018f ]

Prevent NULL pointer dereference when spi_get_device_id() returns NULL,
which can happen when using driver_override without matching SPI ID entry.

Signed-off-by: guoqi0226 <guoqi0226@163.com>
Link: https://patch.msgid.link/20260616103018.105612-3-guoqi0226@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The author search finished: there are no commits by `guoqi0226` in this
v6.18.44 checkout, so the SPI NULL-check patch isn’t in the tree yet.

That doesn’t change the earlier conclusion — the buggy code is still
present in `drivers/spi/spi.c`, and the fix is a small, low-risk
backport candidate.

**YES**

 drivers/spi/spi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 6ea9ac2931cde..abb9e873e3f9f 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -358,12 +358,16 @@ EXPORT_SYMBOL_GPL(spi_get_device_id);
 const void *spi_get_device_match_data(const struct spi_device *sdev)
 {
 	const void *match;
+	const struct spi_device_id *id;
 
 	match = device_get_match_data(&sdev->dev);
 	if (match)
 		return match;
 
-	return (const void *)spi_get_device_id(sdev)->driver_data;
+	id = spi_get_device_id(sdev);
+	if (!id)
+		return NULL;
+	return (const void *)id->driver_data;
 }
 EXPORT_SYMBOL_GPL(spi_get_device_match_data);
 
-- 
2.53.0

