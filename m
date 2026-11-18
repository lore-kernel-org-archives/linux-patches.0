Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061601;
	b=XZSzlBcUHoUMFVCGd2q3vswrgWUDWSgJ/17wnDGVH1DBJK7irQe7KRvB0L8ZbceL9eID
	 KQBORzZu+KMue9K4fNwO2Z6eNZzgAxIB0zSgemPhtswxLchyjHmn5xQiFoRHGsTpjxP/G
	 SfQCeCrmV/vMoARE8LkiovdXc3C8ZsFacOseeldh3DFHl4MqPABT6WtQlmqnO2a3cYow1
	 jJyoNszfC0x0W4lZ4FrZOdc9roQRvfsbir3oNtC5dhjcUhKERfjA5mfgykq+cQfYlRf4P
	 0vLA4nueuMqfBs3WY8bqCgnW8t6xVOxn+6aEM2F4Qhpk9q3CQf+RNoKwREQlGxlEM4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aTTkCICpmLbPKkxjLkSYWoSBQ+XrnyPQAuvEbXMA/ac=;
	b=K9BPlHnCpMyE7I9Lzufifq+hyk2jGPDhDFDYulsUju25ZswwjAfYsiOMeoAw3suVeuaH
	 ffXEPp8m2sEklQBM/spH69XKhTypsMIrP8ntg6mC95qqb0aBxlC6ht7fPyOtTUyyI3tQf
	 DaC6KkR7LYdqjf9VzMZPEE4OCrlRprlYPw3O9j2gWS+d7E4pyRNTugVx/CCUgDhCPy39R
	 6A22k3M5qcgJp6sL7dDDU//lCnVsgQJ/VfI0AxUp5ogJv8ZOP/7WfFbmXrMtYJ05Hq03T
	 pyUi59G9EIi1L7LYMn7RyNJWWjPGl0qoVeILVemAXrRzVqkXQ7dElmbhbFywnIaI+TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zpv62CrZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7185E606A33F;
	Thu, 19 Nov 2026 04:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zpv62CrZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7D71F000C4;
	Thu, 19 Nov 2026 04:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061601;
	bh=aTTkCICpmLbPKkxjLkSYWoSBQ+XrnyPQAuvEbXMA/ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zpv62CrZe/reyCFnPLGTisGIPiJIQQdkCBSMn0xUqlqzUQrjXMtxkkGZkZ8sGd94c
	 ULVx/EgOWBuaex9oXIFyM3co8ybbNxqOlcCejgZbp93hXS2OxmNBlopNlCVR66ZY1c
	 8J4xP/nyanPQT3x5b24ihIWpXh7bB+1hlXzEZHCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1612/1848] ASoC: atmel: atmel-pcm-pdc: Fix atmel_pcm_close() being skipped on rollback
Date: Wed, 18 Nov 2026 16:00:50 +0100
Message-ID: <20261118150027.006307018@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 50aaca643038774b6779c911c4f96bc7e0d607e9 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from atmel_pcm_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 92dfa6198623 ("ASoC: atmel-pcm: split into two file")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-10-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-pcm-pdc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/atmel/atmel-pcm-pdc.c b/sound/soc/atmel/atmel-pcm-pdc.c
index 704f700013d3e..fc89b11c694ac 100644
--- a/sound/soc/atmel/atmel-pcm-pdc.c
+++ b/sound/soc/atmel/atmel-pcm-pdc.c
@@ -363,6 +363,8 @@ static int atmel_pcm_open(struct snd_soc_component *component,
 	}
 	runtime->private_data = prtd;
 
+	return 0;
+
  out:
 	return ret;
 }
-- 
2.53.0



