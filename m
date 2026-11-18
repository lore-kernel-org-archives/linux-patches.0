Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057549;
	b=lryovm4MGbCiWcJ5LHENPGL3y2myeFm1heXq+iMyzjNesAUzaDnuLRGvK3wtONnBwypm
	 tbXIHN0gzTlRVaqbFab/jbS4ixhcPgWvdx1GVuyux/MD7f23tFR/CmJ08G63zJyw7XOvF
	 9AMo5LoSCBVvLiv3yWlHcv2qB5hbXHGLry4ikomIoMxQuuMTKxvf4r2+E2TA+3D1l1ySG
	 YlIHyhIL9JFHq8oN4N5xH93mgfygdS+RIF8Wa0oji9MycsRxpEr2BFXfSu/2Ui9d90Jet
	 YlFn9GnJGW0TTDsTaHyqCEdjT6GVEfhqIXR96pUJTaS1Q1FrVwY4Qz0nn3laGaPWmyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DP+paqJALMTAjc406SvDlZnhrypLxaV9bhCzDquRC8Y=;
	b=pbQk0rVpfKZJ6uOY67tWORzKWZAS1K8vYs4RgdScqCk1BVeOuNvVTFHUQTa8Q2WlVz7r
	 zpNkDlf7kp/2xla1Gdy9uau28uPIYOvUNvc2eGl75WkhDXHqK2TWfpAwKQQt8OcvLpkFF
	 B+vO8R3rm8RHBVkX9IUdg6qr1IAgn+KPqbx81Rh1yG/X4n4AwvTV9IYhOMX1w6Xjny+fw
	 Ukf4MAPdK0pk9lX6WM3LfTMpeK4b08hcQwFXPNxvPJj6AS0FF9jLWBu659PASMQrKIiO2
	 2qdh6vArLV0mvtaeILHm95+x7WN0M6HHN8yvNN2uKLQpTVeUkIlIaquXndRi+RFlpsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RCewOIjo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060FD606A33D;
	Thu, 19 Nov 2026 03:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RCewOIjo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0D51F000C4;
	Thu, 19 Nov 2026 03:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057548;
	bh=DP+paqJALMTAjc406SvDlZnhrypLxaV9bhCzDquRC8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RCewOIjoT6xgIoj9n/4Fjph1kKd7gSN55l3G8rt4rqXZq75T32kauESWBmi05p0Ap
	 bMniW/XABLWmECm8kc3QgadqmAccROHVcWkWooNc0CH0DIHGDdt/pNGAhD7ybYy+pO
	 AoEwtAv4pwb+zwtk7+lrF844iFC/D76eZIrOBgRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0168/1848] nfc: mrvl: spi: Unregister dev on allocation fail
Date: Wed, 18 Nov 2026 15:36:46 +0100
Message-ID: <20261118145918.656090606@linuxfoundation.org>
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

From: Griffin Kroah-Hartman <griffin@kroah.com>

[ Upstream commit d832b95697384a2b67f20b35106bbf925358cde9 ]

Call nfcmrvl_nci_unregister_dev() if nci_spi_allocate_spi() fails,
unwrapping the previous call to nfcmrvl_nci_register_dev() during the
nfcmrvl_spi_probe() function.

Assisted-by: gkh-clanker-2000
Cc: David Heidelberg <david@ixit.cz>
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026070716-crucial-slouchy-b8a9@gregkh
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nfcmrvl/spi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nfc/nfcmrvl/spi.c b/drivers/nfc/nfcmrvl/spi.c
index 1f4120e3314b2..885ab332df272 100644
--- a/drivers/nfc/nfcmrvl/spi.c
+++ b/drivers/nfc/nfcmrvl/spi.c
@@ -182,6 +182,10 @@ static int nfcmrvl_spi_probe(struct spi_device *spi)
 
 	drv_data->nci_spi = nci_spi_allocate_spi(drv_data->spi, 0, 10,
 						 drv_data->priv->ndev);
+	if (!drv_data->nci_spi) {
+		nfcmrvl_nci_unregister_dev(drv_data->priv);
+		return -ENOMEM;
+	}
 
 	/* Init completion for slave handshake */
 	init_completion(&drv_data->handshake_completion);
-- 
2.53.0



