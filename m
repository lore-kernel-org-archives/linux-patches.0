Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210854;
	b=enRRYkbmeJJVQrVC7++Hicy36JC7t15M0d+T1iAxNIm5cKbaC2r0otZj6wbHMnFX7XJb
	 lhHKqqYBUhmbsKDv9zeAxdlJBLGQEjl7mXwKhSjQIRCDEkTL6qD7fGOXn/G6wPxIZt3G1
	 02JcBjZ43215sctNlwcckZvqLLkYIjaXMqYr0AR44yFyE5kzLrkCrhUi/SXdt1NvOwYWO
	 1Yh4n/brvY5/lzIt/G1BuFEKDEb4wXg/Zc6gH0lboZhSgqLJWoOj/yikNAbaLeeRqA4fo
	 rCsDTa6xQCq1f5IVzLeNoi8zVyNC6bRRDsr4LCEzi5Yiu52L7rodGPgLmGOpVqbgUgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WH+oBN682AMQgo5m0GDrNMenflBqdPxFd2FZPT79Juc=;
	b=XgrphEOlE6G7l8J8tT9gadn8zKrVPB4tqBVD3KZTe7ae61XDOAP/vZPv4UNsduxLyjij
	 0Adfxt/tTWLq2CDGid+xQ4z6gzVmq8lwXak9O+IUppO9zT8Gg0o5/KEUrNSL72z/rY4Es
	 fGQfA1fIh4mwzeNpDrU1gJ+hVWkfrpeJUcO1Mm4IvQ5B7qRkIaxuMXiOtEBpLcSi6bEOM
	 Ee58pIPWpH49yaGRADAStIaKIqrxsSh+1ETsQXQOcWVRn3zpqBTkCjUcQhuKay1SjqtOk
	 QTXB0tlrwsHVeMriAeIpqYDHk4Gngtp8cPS5tVtMtsppX14XYE3Wze4C/ceMRva3jBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AG1H590Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162D7606A330;
	Wed, 28 Oct 2026 18:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AG1H590Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CA11F01829;
	Wed, 28 Oct 2026 18:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210853;
	bh=WH+oBN682AMQgo5m0GDrNMenflBqdPxFd2FZPT79Juc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AG1H590ZQbezXA/eztx0StM7zV6m5HVV7dxKPUvtvr/kuwipHx5OXjdHXyHeqcKVo
	 UezLXBtccHdUjgWwf4klpdLFc1REth+nfHgfT6Xo7h61vaWnBq9rXiMglSNXGF3C49
	 AgcUbJxOxvNJTVd1Z7Jm9Fj3aiIX6ef+Cry28xqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 170/571] ASoC: codecs: rt274: Fix format setting for 44100 rate
Date: Wed, 28 Oct 2026 17:55:17 +0100
Message-ID: <20261028170012.048161710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 6eda8938a790f65bd24fcfaae7b40ad4613fb7a2 ]

As per specification, Sample Base Rate (bit 14)
shall be set to 1 for 44.1 kHz.

Fixes: c7e79b2b2d2d ("ASoC: rt274: add rt274 codec driver")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260918111745.3589393-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt274.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt274.c b/sound/soc/codecs/rt274.c
index 0d3773c576f8c..db46a45b8bd2e 100644
--- a/sound/soc/codecs/rt274.c
+++ b/sound/soc/codecs/rt274.c
@@ -619,9 +619,11 @@ static int rt274_hw_params(struct snd_pcm_substream *substream,
 	unsigned int val = 0;
 	int d_len_code = 0, c_len_code = 0;
 
+	/* bit 14 Sample Rate Base, 0: 48kHz 1: 44.1kHz */
 	switch (params_rate(params)) {
-	/* bit 14 0:48K 1:44.1K */
 	case 44100:
+		val |= BIT(14);
+		break;
 	case 48000:
 		break;
 	default:
-- 
2.53.0



