Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020544;
	b=JYjdqvq8nx6rkObrDcdu+1DJQTOuuhRaaihCDVqo3+yX68D9lvjgcDxxjyn113pqLvTj
	 lguGLuFWrrxrKd6WfWH0uW6FxJXy1EQqXaI95zp9QvHluWSWrXcqb+jNM/BeLaQqdySDk
	 NkFWHGAfz7W6AIep5kQ2FgJZ7yR7uj5x19BSvFJ7fEM27twhTK8rLS64pnBymjs5aq+P0
	 8m3Di9X3ob7lJY7f5TxixHUNhX3wdOU11YXFqwBHRjVRBofDoLSZeP2CUuJIiDNdkXfI3
	 f0XpezDaLSPrblrmzPeW1EZMuJTGL9Chwyz9WgKXq9RzcW2xmUJPBtyGPu5WHq5BW3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=GhR7u8QOolvJ8Z5RuOs+nfY39zxA6Q2O5ekAPFpJ5yk=;
	b=duxY8dHnoA3u2EwJh+242sKiKn80YqU2j2FyZpTY2B/+6yyjz1mnIr+TIcSbLi242SNW
	 m9bSdecIzo8bWJqzbhHjBhmMzjZHTh6+zlmS9QXxu/j1y+mTOoxqutJuWimw49/C20zln
	 +/Hny7uShGf0OxcIBtsLXXoUKJIHqBkHsXSFOJyLJrg4gDrROdiO5Fzemr1nNW0CXJKk5
	 Fl6ABuAllH36sZEU62l4gzqfJ9ut7H7MH7BivC4rvnHG+Y31svhqw1G8B9jrDipAYrwY5
	 iRyWM3heSNtEUzQv9lJR4kh4MKcdewR5DeZ/GXYclfhH2lKemzWqIn2QPf52+/4eiiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b4QBNMTb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52320606A325;
	Wed, 18 Nov 2026 16:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b4QBNMTb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09D71F000C4;
	Wed, 18 Nov 2026 16:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020544;
	bh=GhR7u8QOolvJ8Z5RuOs+nfY39zxA6Q2O5ekAPFpJ5yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4QBNMTbk8jwWdXM7dpd2T8eQPkz1yePuUqzTWjFR4EVMfHSTPq+yd2iy3KkfHe5q
	 qYIFevl6N74PGWjqTKHWpNXBjwcta0bcjhofpIHtFVSlymZoqtEUC3BpAOSD+iqSSi
	 d0UUJ4krJl09UIdkgqTBf13XTpXhv1rPRcuFM7Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1989/2651] ASoC: soc-topology-test: Check return value of kunit_device_register()
Date: Wed, 18 Nov 2026 15:53:49 +0100
Message-ID: <20261118150357.971748942@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amade@asmblr.net>

[ Upstream commit 1641c1ba27abcd3ea3bba1232d9d817092f1b757 ]

Call to kunit_device_register() can fail. Check return result of
register call. While at it introduce helper variable so that if it fails
put_device is called on properly initialized variable.

Fixes: e57cdff0ddc4 ("ASoC: topology: Replace fake root_device with kunit_device in tests")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Link: https://patch.msgid.link/20261014200608.118770-4-amade@asmblr.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology-test.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-topology-test.c b/sound/soc/soc-topology-test.c
index 346a52d3006a6..fb7e4d5690cd7 100644
--- a/sound/soc/soc-topology-test.c
+++ b/sound/soc/soc-topology-test.c
@@ -24,8 +24,12 @@ static struct device *test_dev;
 
 static int snd_soc_tplg_test_init(struct kunit *test)
 {
-	test_dev = kunit_device_register(test, "sound-soc-topology-test");
-	test_dev = get_device(test_dev);
+	struct device *dev;
+
+	dev = kunit_device_register(test, "sound-soc-topology-test");
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
+	test_dev = get_device(dev);
 	if (!test_dev)
 		return -ENODEV;
 
-- 
2.53.0



