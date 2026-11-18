Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034780;
	b=zNDY3ML6EEG1Y2+VwLFG4xcnVt8PAYC5PftQXC7ZVi0KStRpTqfYZzNgYDsP1hvCsUia
	 zlzGlwGZmCNdAHiq2myYjN10vHxQS3bjDneSrcYEHVUG7hYIyj4LtTusyKpWxbnWpQUqT
	 G4daVjcclRnaJ/mn9Pgo8BcnoBV7jhrj6ne9HNbNVK0RHj5pIGwHRSgkm3xfY2lKm+1z+
	 mC351xNig0xDXizScmbD6OIBq28eL8YVOck3EoyKQox5OH9siFkb4cNZafTYiy0EAzxbV
	 MrHjeyOH/JrNHUDe1ZXSDfnAJW5SM3jUkFy+50kodYg0xmqextYw0T7GB4ayt1MgK1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pZB//sOOa4iTXtcUGxGSYUz7HL6ZaGsssa8fNj9qlCc=;
	b=l5B5KjD3m/r/wqa2/O4XLTwTeG6s+uPVn321irBs8EnFoOegN5oICaMiDj+r5qJUqzMG
	 sL67Cwkk3eKFY8jDzWWoPI3LRrJfQysku6ml1pBFE3oj1nfYUj+aU0oq608EyN7+ynZFj
	 gC66JZSveqXaZ0FMderf+7VU7WR1WO0CUCF2TbXRJrO5Nr1p6trtAUfh1Cq1OFQQBt4lU
	 Xu1Xj4GtT4D+LrjOHtAsdegkEYko3YOGJyR/WRpslc5Yo12PldfY0bsXUbdwK9jnMd0ml
	 JAPJceVWABaKSvYYujThe1hA0bGSmnxRD65E83YHuUyFhMPBjRnsTWsP77ME8YW54Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tWUX4fEN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCCE606A32C;
	Wed, 18 Nov 2026 20:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tWUX4fEN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CB21F000C4;
	Wed, 18 Nov 2026 20:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034780;
	bh=pZB//sOOa4iTXtcUGxGSYUz7HL6ZaGsssa8fNj9qlCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tWUX4fENLHWgaz+nph5Yb5obcHw1gbpL38zYkooSzVgfupHPoNoCRZrn5KnT4OLfz
	 xo+ztKyUguYO5QxzqBcN8Lc9VhuZnWfUlAnnmHvviqrgglZyLGzUdfsLP0g+3KFiM8
	 0K7WI43SYBCxEvgmE4Xcid6r9PtckkfnojNPX/lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0484/3318] ata: libahci_platform: Fix device reference leak in ahci_platform_get_resources()
Date: Wed, 18 Nov 2026 15:18:26 +0100
Message-ID: <20261118150331.488778191@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 0d1cb83337f13af082afb68b28d3fdfe29cde7fb ]

of_find_device_by_node() takes a reference on the port platform device,
which is only used to look up its port regulator and is never released,
neither on success nor on the error paths. Drop the reference with
put_device() once the regulator has been obtained, which covers both the
success and error paths.

Fixes: c7d7ddee7e24 ("ata: libahci: Allow using multiple regulators")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/r/20260915065933.1733061-1-vulab@iscas.ac.cn
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libahci_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index 91d44302eac92..7308d48cf748b 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -623,10 +623,10 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev,
 			of_platform_device_create(child, NULL, NULL);
 
 			port_dev = of_find_device_by_node(child);
-
 			if (port_dev) {
 				rc = ahci_platform_get_regulator(hpriv, port,
 								&port_dev->dev);
+				put_device(&port_dev->dev);
 				if (rc == -EPROBE_DEFER)
 					goto err_out;
 			}
-- 
2.53.0



