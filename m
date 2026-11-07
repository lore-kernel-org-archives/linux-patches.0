Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064194;
	b=UENA6XNfw/SRfpNU+PWFSNu3szuJe6YNeGOhgP3eWExdewxcg3Kh3BfKaemdVlUxbMjF
	 3IMdLrUem931S+UF6ihZPktOLP4zM92W7k1OdT+4cZK85sSEwlpMdx58NsrFucJRXjGzu
	 wlQpNnK1w7NhwxAQqbCOhbX5goiujywh06ATyF8s5+ij9Unrb4v4IdTlNocwDXC9OIW/4
	 5dnYRlR1rw50qnOoEqAWadMDTxc226JoYZZwNU1VxOcty48CcS5CrF5JjKALFFOrV7ico
	 t6EnyVZ18AZWtz5od4pZ5duMJJCH4UfJ2aLcq/miLj39qWt1EFcT+5b1nOuVQoUguhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fGzOLiI3vGv3Dsj6KMdBR1+IdG5Yk9Lk4o2C2MkpAlY=;
	b=pC2IjTfteaJKmn8czIyIxIPaC2jAcr765mrjUCgzShUlNH2OlrXp4MfSMFatMY2gBSjl
	 TdCa9Hgvmq9k9i961v8uUKGdZwwEBEVzWpj2NPoz2LLoucuQgBVwF0yGrVg5Oar3lNKZl
	 UCHLP/XijeW3EqpSTwhusP8VvZmB0VLOoB9SiRoDyzvcqoXEZdlNh0cu6LhGzOT9moTiP
	 N8DDc9eq7FQodqehm+C+mpKjC3LgWx1skrlONtrAyG31uAVtPUHwTzV5mNg02yurLx1Ut
	 ifRssHpE6Z19AtT1lJo1DpJA/i+4JDF0HWuDYyantW2sMQMgG19b69vWEcYPP5zNcJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vGGoHzw0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DCE606D829;
	Sat,  7 Nov 2026 15:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vGGoHzw0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6126F1F0089F;
	Sat,  7 Nov 2026 15:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064193;
	bh=fGzOLiI3vGv3Dsj6KMdBR1+IdG5Yk9Lk4o2C2MkpAlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGGoHzw0t0mNAQ8pXjMX+VW8ue8eiRzu1nc5RoEV+lctQlXZl4fKjC/rRQYgs5QkQ
	 5LoJiFaLPYM0nE74rdDq6LNiK1WriQpW3/aY6FkU9cxo9ZASRp+iJsyy8WIpUuQ/64
	 Ff4WVRQ2wDliOkhyg5rmQYyuL+1cxr7x8IHWGxv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0333/1257] iio: frequency: adf4377: reject devices without match data
Date: Sat,  7 Nov 2026 08:43:49 -0500
Message-ID: <20261107134948.610106613@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 2f3196d27e3bfcee0569d23a123aedcc6ddd39f1 ]

A device bound through driver_override need not match an entry in the
driver tables. In that case spi_get_device_match_data() returns NULL,
but the result is later dereferenced by the property parsing and
initialization paths.

Reject devices without match data before continuing probe.

Fixes: 6140a92cd086 ("iio: frequency: adf4377: add adf4378 support")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/frequency/adf4377.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/frequency/adf4377.c b/drivers/iio/frequency/adf4377.c
index 7385be62fa6a3..52266f83877ac 100644
--- a/drivers/iio/frequency/adf4377.c
+++ b/drivers/iio/frequency/adf4377.c
@@ -1060,6 +1060,9 @@ static int adf4377_probe(struct spi_device *spi)
 	st->regmap = regmap;
 	st->spi = spi;
 	st->chip_info = spi_get_device_match_data(spi);
+	if (!st->chip_info)
+		return -ENODATA;
+
 	mutex_init(&st->lock);
 
 	ret = adf4377_properties_parse(st);
-- 
2.53.0



