Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057343;
	b=T03D7zzyc/L/qPTXPwe5MV0p8GRCO/FH5vJaYWAAEFZbuaEtjbRKVj7TM54/MbRYwJc8
	 +Xj3SuFMTSBvJBvIhWy+X/L5QPEqVWp840QtL+WZeQ3mpibh+pFAVyf9EoTck87l5+c1f
	 uaXqN7Z2PeSFUJ2eQTfTvVgDeEYejvEjIi+dkXrfddglhGp6b91KAFIRdqCHe/BfxUioc
	 21zT9JGZVEI3whos9Ae015hntaQ5zLf7vJZ/AKnh1xbfPwuhStOAyBbHmAt71IzQh1SBW
	 ynPDS+C4qyBzCJx4ABz1f9wnEG4MctgVINLQQJTwlu6QqikSVE0YpK7zGLksrWfJOiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kfRQgBpIs++/Les/iVAuuUosErb4stZIXii0SUIj3K8=;
	b=YSUk0TBaYxTIQahXTZUlZcK8Y82Ig1grLWSTRtcYVrcHpugWE0gH7Y4fAtkAFugIL7fp
	 JTN5lrW5D7hHvHgHtqkIELdv5oZEvBvoroO2ThK6+3GSUq8ECwL5IH58FdqnwaHOLsFGC
	 MIVeOC/32s/Yy7wD46IM+f5GHNgLGp8eXpziKY0u8CVH4mpR73HcDfIt4qli7WzvWUB4i
	 +9DNjq4KamAKZU2GYhsiyXJ9C1cxArkb98BO2wvVmIB8IHALxsqlZsCaGi1RYlepXbAx9
	 ouT98EZB0u4XpkpVlIzAKvPL4oyntCFIEJraDRfo1+5TXi2oiVfZfxIoOEXbDRr3SnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ozLhNNF/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3A960A2622;
	Thu, 19 Nov 2026 03:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ozLhNNF/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1071F000C4;
	Thu, 19 Nov 2026 03:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057343;
	bh=kfRQgBpIs++/Les/iVAuuUosErb4stZIXii0SUIj3K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ozLhNNF/G0cR3Xcqh8GbIpsVvEXZZOQW45hHcbTKFt8EPm+DIrQlhSn3YpvUfwBp0
	 nc2HRfE51qmyiiOyGKOV+q5meGW1jt4ESQGE6PuZGCMm931jljda3Zm6pZjkUQFJrk
	 d6TrMKA3yqSGHr8Bt+/vt+DyrSh99Kw2KUpCsBwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0056/1848] media: cec: tegra: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:34:54 +0100
Message-ID: <20261118145913.448815369@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 8dcf23edaf4bdf22259f6a47cfddc8bb1467425c ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/platform/tegra/tegra_cec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/cec/platform/tegra/tegra_cec.c b/drivers/media/cec/platform/tegra/tegra_cec.c
index 5e907395ca2e5..43fe54f792b65 100644
--- a/drivers/media/cec/platform/tegra/tegra_cec.c
+++ b/drivers/media/cec/platform/tegra/tegra_cec.c
@@ -460,6 +460,7 @@ static const struct of_device_id tegra_cec_of_match[] = {
 	{ .compatible = "nvidia,tegra210-cec", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, tegra_cec_of_match);
 
 static struct platform_driver tegra_cec_driver = {
 	.driver = {
-- 
2.53.0



