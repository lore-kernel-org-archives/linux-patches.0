Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830993;
	b=BO2gu68QrpktH4yAnMao4Fw1xyirHkujB5JOXi9+V+AwJztTM7bN3WaVGCx+sHhzBYEG
	 gqNxeeO/cX/WAiyMXvb57A7WYJ7vu6v2+m6MBDe6Vte0qUG8oxQq0lQ9TbMTUcfb8wYi5
	 rL/WygB1Bdj/iqtOq+rjTWZMnrLEm7zVRuX76toNSfYuhFxhmjxOTP+qk5KXhA0YmvjbJ
	 ysVwAZZONoGLh0CdhloSRSokzJj9ziuKUxCuqhum+cOnnigXnGK4CzL8CStYyQa9t4FD8
	 q4BKlZoR++ZvEQmVG99vSewJ0BAvCj/KM/F+WEPdZKGQ3DhJeGWCSyJX/r8Gor3DXAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LuT6d37cY+bm80uQgoy6fYJ1S4REm59llhEGpYZJoTw=;
	b=2zDSQ1qFf9RPnUu5oOz9fEj1zKos1ktJnUze0RErQ3q6P7M6EffYNBPTehM02Nj9EASt
	 du6qYGUQQGcnQqeH7Q55PQ/Cf/M7ElzzxN9marZRHX4BflUVb52IlChwe5qb5pBKpZIwl
	 FIlJ1ftwtdVFVCgSNUI9ZkA6DU+k/oswe4NKcUdzxgxrlTkFfTQihHcHFz4ZqT0EsCt/+
	 Uf51vTiseCyouUZmGj0OugFYEeIuFJibtuU+cpoYPBkm/MpeEQKIYSO/trjEJMdK4UZSX
	 LsUoK1Gh20SHrSvP/ESERblm1WEIuN9Y84JHK9MIASRu26m/XBnR3SHBeBxDFvi3zhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wZPEVJMj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1CF606AB32;
	Wed,  4 Nov 2026 22:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wZPEVJMj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974941F00919;
	Wed,  4 Nov 2026 22:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830992;
	bh=LuT6d37cY+bm80uQgoy6fYJ1S4REm59llhEGpYZJoTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZPEVJMjVB440Mp0KjfHKS60kRAOSSNIDjCvMYovSKcekpkp3u+ZHTPGXPS770Xf8
	 oAqXflSXbsNVV5BPKl+YHvBjMTe92SQZKDcuXdl8oB1RE3Z81NbqDcHf3uYW/1zDfa
	 KtQNSOghxBYOzZVoBAc5MmM8UeWubU+nU2kcfWPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <lijun01@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0444/1005] spi: loongson: pm: add .freeze .poweroff .thaw .restore
Date: Wed,  4 Nov 2026 16:02:57 -0500
Message-ID: <20261104211056.503541304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Jun <lijun01@kylinos.cn>

[ Upstream commit a9c2f0d401fd1e11ce59e4243946a59bd818e8c5 ]

after execute s4, the spi error,
[ 1104.754246][ 4] [    T1] tpm_tis_spi spi-SMO0768:00: SPI transfer failed: -110
[ 1104.761503][ 4] [    T1] spi_master spi1: failed to transfer one message from queue
[ 1104.769201][ 4] [    T1] spi_master spi1: noqueue transfer failed
[ 1104.776344][ 4] [    T1] tpm_tis_spi spi-SMO0768:00: SPI transfer failed: -110
[ 1104.783609][ 4] [    T1] spi_master spi1: failed to transfer one message from queue
[ 1104.791308][ 4] [    T1] spi_master spi1: noqueue transfer failed
[ 1104.797446][ 4] [    T1] gttadd tpm_chip_start1 ret = -110
and in s4 the loongson_spi_resume&suspend are not
called at all. use DEFINE_SIMPLE_DEV_PM_OPS() add .freeze .poweroff
.thaw .restore, after s4 the spi communication is normal.

Signed-off-by: Li Jun <lijun01@kylinos.cn>
Link: https://patch.msgid.link/20260820092351.101605-1-lijun01@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-loongson-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-loongson-core.c b/drivers/spi/spi-loongson-core.c
index b46f072a0387b..f07ee432f96b5 100644
--- a/drivers/spi/spi-loongson-core.c
+++ b/drivers/spi/spi-loongson-core.c
@@ -270,10 +270,8 @@ static int __maybe_unused loongson_spi_resume(struct device *dev)
 	return 0;
 }
 
-const struct dev_pm_ops loongson_spi_dev_pm_ops = {
-	.suspend = loongson_spi_suspend,
-	.resume = loongson_spi_resume,
-};
+DEFINE_SIMPLE_DEV_PM_OPS(loongson_spi_dev_pm_ops, loongson_spi_suspend, loongson_spi_resume);
+
 EXPORT_SYMBOL_NS_GPL(loongson_spi_dev_pm_ops, "SPI_LOONGSON_CORE");
 
 MODULE_DESCRIPTION("Loongson SPI core driver");
-- 
2.53.0



