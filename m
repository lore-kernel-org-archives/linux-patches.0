Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024836;
	b=UiUnThbTY/DWseA7/XVZOs3X/YwPLd8nZCF63cwj+M/HaYmbmgBe2UHoEm9N/T5zMNrL
	 JnUU1ebBfbKKpCKAbvf5yZeUebOra8eZv91o/l7VL/RzyNuSVhUdvxnUGnq7qB5CV2Ele
	 fSrM2fXdBSPuCmPir1hsbUNBK8q2oBE1+MNvWHh379Ss1u2CvDPpwCuy7JNdhdGn3bTgP
	 S0DtZQOgab2s9tB/Tb4T/OXR5iMglpx0g1jQotGE+dfP3KE8gH/6GoAVZTTL9b+fvbYIq
	 XZstvOKNmzADH8wyLJkKFcP4OCj39nbvBjH+rE1OTep0S1n0UAOnheOgrGURh8rnRUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024836;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lBNZoj/Nb4585t5pqodZu2HHUwiqM9dRBILB5ze4BFE=;
	b=a7iLuK8t5fwj7P0507Qch5yrQz6Ar/56/n5NXosmk9+53xbNTBq4G4ewjhYIJDRFzjGP
	 qkUMUYO1nOVqZrbeD2e8tnM6OLRiXCeu7W3eKZfruVCEk/5pXjM+1YxQeszDgtY4M3ugt
	 IR0XcT7oz9LKbKGcLebt9LxV3Cje2JiAzIcn9Vw4X4oSHIHPpWl5gjb9FUXXsGvYreB9s
	 C6IMx0/B86AN+cTN9/oQ+MsaMkdXkzgSLn6stxQnJtt+WIkwQe0I+kVpTwWoFhF9oA3ak
	 G13T6JZhxgy90EB9Qxpht/cOA0Vxoe5WsPNHEYu0XO48YLEXwenchg002qQcjJL8XNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iKI+KDHN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7335606A31C;
	Wed, 18 Nov 2026 18:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iKI+KDHN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D381F000C6;
	Wed, 18 Nov 2026 18:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024836;
	bh=lBNZoj/Nb4585t5pqodZu2HHUwiqM9dRBILB5ze4BFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKI+KDHNhYLcWLkDzObncwe0Hy9cghzwWfT8bdSQ/UBGRYftCK7usabKfU7cF0h2J
	 whk2Idwn78wEanSgXJmEAdCLwW7ulCPeMkAyUPEHjeLvNAhW8wj9RfjxOXxOB8NKs7
	 3+/Sbb4rRmQ+Y8wjOmNR37RUsF8snNX3lGIF/r1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0864/2151] media: iris: cancel sys error work on driver removal
Date: Wed, 18 Nov 2026 15:43:19 +0100
Message-ID: <20261118150153.691578727@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 4524809316482b64ff092afb7e7b0525ce137c75 ]

Cancel sys_error_handler before tearing down the driver.

The delayed work may still be pending when iris_remove()
runs. Since iris_core is allocated with devm_kzalloc(),
allowing the work to execute after driver removal could
result in accessing freed memory.

Fixes: fb583a214337 ("media: iris: introduce host firmware interface with necessary hooks")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Reviewed-by: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
[bod: Fixed patch title]
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_probe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/qcom/iris/iris_probe.c b/drivers/media/platform/qcom/iris/iris_probe.c
index b6251493bd9cc..e9f30093afa2d 100644
--- a/drivers/media/platform/qcom/iris/iris_probe.c
+++ b/drivers/media/platform/qcom/iris/iris_probe.c
@@ -254,6 +254,8 @@ static void iris_remove(struct platform_device *pdev)
 	if (!core)
 		return;
 
+	cancel_delayed_work_sync(&core->sys_error_handler);
+
 	iris_core_deinit(core);
 
 	video_unregister_device(core->vdev_dec);
-- 
2.53.0



