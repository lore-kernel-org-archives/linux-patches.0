Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054033;
	b=2+ymua+daOoCxRu+GbwGuSf6TmhTQYJt0LyByGQHHcc0Itzyl80EyXrzEeJFP1yJeli8
	 tFAf8K7QZyi0wd1kgvnbYft9KTsXD0no8QRdsm6m3Nj6nMg9paxcE197ekXOJ1NXF5GZ8
	 OXpiWb4B/EApMnVFAz2if9L0LDRBsheYvbs+QDYHF5lP4/3ndZqK1h2guP9IarBlliIyR
	 XHkxjc+j8ncplBf9K++p2eeH5EbBAENkQPfOF0x/ZKxqewgiNGfG8t0yur2PV0vEdaCy1
	 c3MRj/qUqrTMFZeYp1ZZZLdzTkFlhCGzkQtAWWJRBZCj96cdslGcYOAD9NuctVua0Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pg0aoc//DLPIxsLH/eWQVjC4hMX5NKcenzjq+pmAdyk=;
	b=bKLxgAts/OGCYknYP1DhdFqB+MFrkXEmJw7fnL20yrTyI0fRTYI7OHfDT5HY+dXLuqcv
	 TrCqQCpxe2JzNIACQkQpWDIeqzgp7Tbwmds7dLKSjEdrcCWuPuSTKsrkC/++p1uGe1CCt
	 OThAOJfSmbonwbSoNVfeE32pQElfdmTuXajPS9RFpflgbzexEnnaF0b24sYwmH/qWvKOL
	 C+wJZ+Jgh6FyVcDrMq6cN2zAmvOjpIfa7mAhupnabBHdCY2G4I4zTI/BV3+Fug8SsBkd6
	 A04pN3h6dNG+xFf10ZiFHIOHnHChtYlMeQYQ4Np18azd1Ucw3UDDmbbI3X7+Fom8scw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bCZWUIbF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134B1606A320;
	Thu, 19 Nov 2026 02:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bCZWUIbF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1742D1F000C4;
	Thu, 19 Nov 2026 02:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054032;
	bh=pg0aoc//DLPIxsLH/eWQVjC4hMX5NKcenzjq+pmAdyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCZWUIbFQwwkJADN+UOBRV+mY9sqYOwrMK7Is7zT9YgfHG8mql5g/w9m6c0zE3K92
	 Avat3e/vbnikHGWb+DI7sxklHFduNAfjDKeE17tP+iAMuvCQ9fYNSSWBEYqjaGBmcS
	 iRF3GpBqY/Q9tb+rcebc7Xhvgd6BQV+nbfYCTlZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robert Foss <robert.foss@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1131/2214] media: camss: vfe: Dont call hw_version() before its dependencies are met
Date: Wed, 18 Nov 2026 15:46:47 +0100
Message-ID: <20261118150057.302168620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Foss <robert.foss@linaro.org>

[ Upstream commit 745b475e7e10ae1e8c538e5db89494411ee1c22b ]

vfe->ops->hw_version(vfe) is being called before vfe->base has been
assigned, and before the hardware has been powered up.

Fixes: b10b5334528a9 ("media: camss: vfe: Don't read hardware version needlessly")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-vfe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 142bda014d4da..ba56403297797 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -644,6 +644,8 @@ static int vfe_get(struct vfe_device *vfe)
 		vfe_reset_output_maps(vfe);
 
 		vfe_init_outputs(vfe);
+
+		vfe->ops->hw_version(vfe);
 	} else {
 		ret = vfe_check_clock_rates(vfe);
 		if (ret < 0)
@@ -1339,7 +1341,6 @@ int msm_vfe_subdev_init(struct camss *camss, struct vfe_device *vfe,
 		return -EINVAL;
 	}
 	vfe->ops->subdev_init(dev, vfe);
-	vfe->ops->hw_version(vfe);
 
 	/* Memory */
 
-- 
2.53.0



