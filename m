Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026980;
	b=ApxgYPhqxvsSGIBwymdZTRPakJy/YMf/vRqzRMnQkipbn3BOMfyoVGqjKa4GNpQgT8q7
	 Icr3Hms2Hc1MKNOgp/D0JP0qYEOuZbF66RIp0QOihofE7zUnK0G/4vP5+vFRk/mz/xipB
	 lpNsFejlBPidHvAq+hhG7kOJEGHwhL3pxKLX32yRwPIIWvvInW9P/tJVHceezjwCejmZC
	 z50wXoHFrFkaKJ8/qKy+VW4fP1SHfQEmEBfMJF62lqioqKYlTqv14vyaWnXKvVvMgX/XA
	 O7SzeRZvaAK3Uotk33BDeyZDdmbkpM/9nIhcZzmshSCPtSfdn9TLWeW8DbJM0ug1+Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dx/SwNFaVPkW+2ySA4Db1vycoNWtpJXGNfXUyu+i7hA=;
	b=fhX8Ms3iasU7BDAGnmIFFIT3zPch4BYXozwysnwMjt+8uSG9ioGWLlZfpZ3X9R2wlgb2
	 49WBw+w7k9lDNFEHF0aMGmovMNlxBUAJpDePUT5b60Tj8eemTrn13in44XW2fpbOaETzq
	 TFva1d5oBCE8XtsMBBxuIUvLgbvAhgkM3Si4DrArVR+gf/8v2ImGxtS99iTxaG9DGj3DX
	 8fy1trMTQxoVHPN+6tPGv+cEDhNs+yW+y4MMSgTcanfGOylm/5hwzhT5fbvqiCJD4Pgxu
	 l/SvQ/jJFPgneozMii3zOdL47XACgQuyNv/m05gPosJUjUvQ7l/zd9qZlqUVY+tUBWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2d/r68lN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97DA606A338;
	Wed, 18 Nov 2026 18:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2d/r68lN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413E31F000C9;
	Wed, 18 Nov 2026 18:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026979;
	bh=dx/SwNFaVPkW+2ySA4Db1vycoNWtpJXGNfXUyu+i7hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2d/r68lNmHF1KCoX0jv01HHewuPDf90hN1Mf8rpWo5MMONnWZY4rY3EfLlLzs3K0b
	 fJfi27qyq+ybQgyWDHMr/5wmu2wzO1/QyDyCEj6gMH5rY+nlbLZLhxP00F4+o3Y2EB
	 hI4BQmleE0ip1dJvXe33uaZVM17rogc5S3sEb2qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1627/2151] ASoC: soc-topology-test: Check return value of kunit_device_register()
Date: Wed, 18 Nov 2026 15:56:02 +0100
Message-ID: <20261118150221.141938383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c8f2ec29e9703..464aefe24df07 100644
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



