Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040703;
	b=qNfot4SRXJ9Tee7XNV+lDC5Db5X5kHjJVAvP43a2Opq6PwELRdQC7ymAtNQofyIv+zfy
	 QctP3cdhkxWCbj6h68LhUSiSVYFaCwfeXCkLh+oVCYR4J0WtfjuNKOZ4DoFB/jd0oj5OD
	 pkN6mjuT+9YaLvU1Z+TXBuX7n6kAOzVA4ewZXdRXQxYSSLmbwlDWaxwAECmf11cLsxEks
	 9XdUdhnSgEJSSFa1rK/Dc/+8L/DY++ALDhTIy5oJ0Gb/VHc+lEJlfHCmkzkkzqVMv8sRG
	 uHql50ZpQXjGrDiMJN/OTzPiHcVJPKwv3q2//85kRiZMS17lMzLzuo7kqy4+CV0pGuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7S0n4BAQTSjad30nkNAbYOMqNlhHDZNNAEwSc6uwNNk=;
	b=2XgBj2wuVDq92sV9BZCzrjWyu7KLxOQUXYyN3EIB5vfdO6MVoeoybyT5J7bZi/h7qE5J
	 qm9PSKy5PhOV+dV/EarEJz2pJm3UATeUAfb93t5TbmrNXo4uPo3eoVrQbTF32sVxUq4ZW
	 uEmm6bd/lJ0m1oX+hDuJGKGWuDf196xHN1QtzFB3aya3uXCGJVr4fHtDtjRZcQPTNH0oE
	 4det1ovcS/hm4FddMkv2XXeCbizvdsaYGu/GrEyIgt+G88z8OJQX/9iLjVD4jKWMmnYpg
	 cwT/tutgq1/2rsDi/647JhmV9eMQ6ruVhK5dtkRjsKj2d+FSg/lasSf5xSj3Jvb6B7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vn5cU6BU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFEF606A31C;
	Wed, 18 Nov 2026 22:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vn5cU6BU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5131F000C4;
	Wed, 18 Nov 2026 22:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040702;
	bh=7S0n4BAQTSjad30nkNAbYOMqNlhHDZNNAEwSc6uwNNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vn5cU6BU9Fof+TC6xNv6Ycl110+dcHChPGJMqdXgxBhGOc/Jf/Cghgp7tdI5otXEw
	 cI/YAjJq3R7X3IaZQhe2OH5T9YiDrK0FP63tAkFQdCquinXwD9jOzB409dCI3Ub2ya
	 FCUeUdfZfAtOfga+CjAc0+qmop5Vk0QliEBu5oQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2552/3318] spi: fsl: unmap immr_spi_cs on remove
Date: Wed, 18 Nov 2026 15:52:54 +0100
Message-ID: <20261118150437.844318292@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit af1d882d421de504a1e5fac92eb06947b6cbdd8f ]

of_fsl_spi_remove() does not unmap pinfo->immr_spi_cs after a
successful probe when CONFIG_FSL_SOC is enabled and fsl,spisel_boot
causes of_fsl_spi_probe() to map it with ioremap(). The probe error
path already performs the matching iounmap().

Retrieve pinfo from the platform data and call iounmap() when
pinfo->immr_spi_cs is present, pairing normal removal with the mapping
established by of_fsl_spi_probe().

Fixes: 0f0581b24bd0 ("spi: fsl: Convert to use CS GPIO descriptors")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260924112329.1566051-2-lgs201920130244@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-spi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 0c0d1b89c9d6a..d4c8e124dc17b 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -703,10 +703,18 @@ static void of_fsl_spi_remove(struct platform_device *ofdev)
 {
 	struct spi_controller *host = platform_get_drvdata(ofdev);
 	struct mpc8xxx_spi *mpc8xxx_spi = spi_controller_get_devdata(host);
+#if IS_ENABLED(CONFIG_FSL_SOC)
+	struct fsl_spi_platform_data *pdata = dev_get_platdata(&ofdev->dev);
+	struct mpc8xxx_spi_probe_info *pinfo = to_of_pinfo(pdata);
+#endif
 
 	spi_unregister_controller(host);
 
 	fsl_spi_cpm_free(mpc8xxx_spi);
+#if IS_ENABLED(CONFIG_FSL_SOC)
+	if (pinfo->immr_spi_cs)
+		iounmap(pinfo->immr_spi_cs);
+#endif
 }
 
 static struct platform_driver of_fsl_spi_driver = {
-- 
2.53.0



