Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064324;
	b=0BuyTRqJ86hFIKOg05+uPY35ObqnF5US1G8H/Of3qNha5bY9TIenChYcS41h27C115ZX
	 eaqitEPm7vW81WldjL6k08Bp00n/r8rjFrSj9CNO+OQn7ZAR5VAL6jUnC4V2h7i/NHnaP
	 okxGJPp4afZPKK4gYz/ad6r3GgTrK+HnwyIFRiCOegCFh0l//mmKN26m88OoKl2QtGsc6
	 TwyOc309DszJVvV/R8jLExKfkHLNYuajhf95XOQavZhojLm1IYo+Ehg8H8FQF5wfzoG5k
	 zkHPU0NGoOZxtMhXzXz/l0pYBsqruH2q++9n8h3tQtCPcbEzzpT6qxq7U8ZPgfRHMLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NiNhqI8WVGzx0qVm9slMhKRpYfd9XoNlJWAhMl/wkQI=;
	b=mUvrQVRhR3Q0XtWQqp5BFuReqNvXgyLakXrYjDkuu1TByrbk/Qr5vqy3sB8CbJVwxlwP
	 swKYSOsULA5qsW3+rTUhpGvXRWAv/l4OVBs0BLRcYJhd9n0hYFmBVTCpjJDyhkWRP6VHA
	 jUsruwirtlHsJJa8NXrNr0Uaf48PyC9JK27K3xIpqU63CfSEke3SOeb3mPTZEH5gHdzH1
	 ArtVBo6w9RReI2oZ6mjxnq8SppWO3lqBBzG4uoUGa6AFX3q4KTaH5Rz3nXIUBxfnZ5zmr
	 ou/V/h6DEW3P+ByxdhvJZk66dx1id5HoQ9kfGrzkSIHXb/7FNBoF1iBDkmUO+5usE+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qSoNbTUo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DBB606B880;
	Sat,  7 Nov 2026 15:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qSoNbTUo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88121F008A2;
	Sat,  7 Nov 2026 15:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064324;
	bh=NiNhqI8WVGzx0qVm9slMhKRpYfd9XoNlJWAhMl/wkQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qSoNbTUonW9z7y8tRMXYriRL560lZk8MuO/7xuce68XYYUCNx6hMYKyZXfsylEgdI
	 uHcglSmXAB8WCbHEBWJVcsxRaxv3jBJ+2WEEBHvVVEjEf4FqkM4WmSFqF5LUDvnSiY
	 tylXm6Q9kp7o7w054iDuQiVQMtLjxv/lG0nH+GGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0411/1257] media: pvrusb2: Fix USB parent device leak in class_dev_create()
Date: Sat,  7 Nov 2026 08:45:07 -0500
Message-ID: <20261107134950.870736941@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 02421d7278e4a62c3daf37ad6c45d4af96ee4252 ]

class_dev_create() stores a reference to the USB device obtained with
get_device() in class_dev->parent, which class_dev_destroy() releases.
When device_register() fails the function only drops class_dev, so the
reference to the USB parent device is never released.

Drop the parent reference on the failure path as well.

Fixes: 28c4a5e6d324 ("V4L/DVB: pvrusb2: Fix USB parent device reference count")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
index dba43d4c24f23..678e069b4c924 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
@@ -633,6 +633,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp)
 	if (ret) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "device_register failed");
+		put_device(class_dev->parent);
 		put_device(class_dev);
 		return;
 	}
-- 
2.53.0



