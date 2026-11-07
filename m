Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064003;
	b=ZQh4moITVa091qLqRQRiVx/rhwWaMVjtEBIBNPuaBozz7RXlhGNrIzbIAnIRP1A5Jfpj
	 530dsv8+zLb5Yh52kZUDcV5QIdBqYQEa3sco37Ln9l36s++bd+ET5VSIm98UCRVZn7pWz
	 BJnzl9DCuGrvqzGpx1lZ1WPgmj7GAM7OcF1fc4OwgBz1QC3IA0pBjynvAt4z61EIfMmxo
	 3bXux/Lj6g/RRSepPRii63WwM2UEbXQqIlChN8X65Mi1uQJ1tOaG5DGXSdv6VCUjgdh0U
	 fBUOIpwuBUT/gdcwKJWr1q2Pb28ThZLIrgTgZzcpwCyGz86YbsCFvtSvMsJpBw4ivog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qW0Vh8sx0kJ/rlf59cW3kx9r9/JzA0f5/SGxjpDZ/Wo=;
	b=0D93zUSV/oqC9H7D/cl9fjse9xlJfaffVZWxwEhkrpzG8MRXVnG2eT64RYFFYR8E9YkL
	 3hs0othV4GjV3bjmZaOPYmGjy/s5kAcCOndw75zpzIDr1C6YEsbdQkGdpujGJ4SlK8ZVZ
	 iTgBhvl5mNU/7OoLAbOv1+wMKGPlOn882kALqHWz9l6s7NDco3vqy0zTy2UBU+i2ZDrK1
	 n7W4mzX5dI3RapL3NcguSACzKoPtp+zFE8ygD4ztm9qJywTBtImGaPkmdJVUA1FnB8GbX
	 kCW7iAtCFVZ3Xw+OjeOaTDq1ojB4xNgUR1r0phiXZaeO3nxkSRl6g/qstFUB9VougUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iadb7T//";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF6F606D82C;
	Sat,  7 Nov 2026 15:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iadb7T//
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7071F008AB;
	Sat,  7 Nov 2026 15:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064003;
	bh=qW0Vh8sx0kJ/rlf59cW3kx9r9/JzA0f5/SGxjpDZ/Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iadb7T//3tr7yy6eCeaSL6Fa/FKMkPzrMNzJJYZyToY4hm19Llb956M0LpFQ3QoJU
	 IPLDBob1x5Odd7xSes/K8/+A4uShO/YT8bI05rebbO1YLh3aguxPP/UIU+vk/sjXg8
	 QAVBl5fyBUPMgiriqtm91h7sg62tDBu/46ksS+GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0184/1257] iio: accel: mma9553: disable autosuspend on remove
Date: Sat,  7 Nov 2026 08:41:20 -0500
Message-ID: <20261107134944.537039500@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 4dda1f9d25fb889649e81bbf015809daa512a049 ]

mma9553_probe() enables runtime PM autosuspend with
pm_runtime_use_autosuspend(). The probe error path correctly undoes
this setting with pm_runtime_dont_use_autosuspend(), but the normal
remove path only disables runtime PM.

The runtime PM API requires pm_runtime_use_autosuspend() to be undone
with pm_runtime_dont_use_autosuspend() at driver exit unless runtime PM
was enabled with devm_pm_runtime_enable(). Leaving the autosuspend flag
set therefore leaves the runtime PM state incompletely cleaned up after
the driver is unbound.

Add the missing pm_runtime_dont_use_autosuspend() call to the remove
path.

This issue was found by manual code inspection.

Fixes: 40cb761306d6 ("iio: add driver for Freescale MMA9553")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma9553.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/accel/mma9553.c b/drivers/iio/accel/mma9553.c
index 8e7aaac89d473..5a36d415a8372 100644
--- a/drivers/iio/accel/mma9553.c
+++ b/drivers/iio/accel/mma9553.c
@@ -1136,6 +1136,7 @@ static void mma9553_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
-- 
2.53.0



