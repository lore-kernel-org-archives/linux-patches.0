Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213087;
	b=4vK+UGWA/tU4qaa9RKdSEEvPaLyNI/0ogZ6EIj3IRfkEz2BY8Gu0SVP4owGjoSUF2N4B
	 MXY6i+6okRvPwQ6sc3/4lsCpcloZLOGrc5vUOX/6u9u5ay9as6MJtS4FXLXOczHr2dcHl
	 uGfJEPL8G9RJI+rBt64wfQou2g9ZzsIKksFWCqjl94HEC+ccc7wB4fZHGk5YB1ZycIt+T
	 R/1aNW1mK4uNxdZjZy/3zn1/DhZiIvpvARfrBU3wbT5p2HeZh5LVoU2Zyse2ZZSQtR00Z
	 HSuH2/HHRtx/u9GUQ6BfZYukD/WbT0yPZhlK5LSMwgw382yHuxFR8ncDwcdl0/vZXmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X79PEEJzccS4Ad3ni1aLhHh6MeVznjB0F33SKudEj1o=;
	b=VBV9I+PaFkyImIDAEct/rbOOrS9Vw+bV43f4XBYRePUzQdijcRHDGj6qwEg/aUNqQDXY
	 b+ELPB970OLXZJTMxwf/dSGx4c0lQFsqRPTpF/WrZX/5thzArXD3832dQwIG7pEbZoltk
	 M5ZxGXeMSXbIR/qz8a04ft9tb5lNDhIpQWXfx5caxlE5QIEeU6dVYWLejg+nuFoT6XH3H
	 DDI83xW0wFa7Xqy6dW/J08UihL1BeqSLEV/wmXgpqGUSd3nyiN7UgN8gbKnpQpyqhyX23
	 UlR83we9SaCCp1eZjhsYA/LUmta4aRWnf3xY7//CNCZXIWvLzoYnIggFxoZR4RwJS9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iWWGlh8o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E5C606A31A;
	Wed, 28 Oct 2026 18:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iWWGlh8o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B2D1F01825;
	Wed, 28 Oct 2026 18:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213086;
	bh=X79PEEJzccS4Ad3ni1aLhHh6MeVznjB0F33SKudEj1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iWWGlh8okzQb/uH2fXJvVoV7DwTcRZxje44LnStDLrEfRc7iPB0/ymqKhZ4NvES1t
	 vlWXf//pHaEW3i+sGCMy7PuIGaPv8dfQsWCa54jq4l0+KSXuRDD8iei7VBofLjlUr5
	 YzDDrSjmUh2Q732xzgwbZ54r5okl7qKuNDDTJUU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0345/1887] iio: proximity: pulsedlight: fix iio_device left registered on PM setup failure
Date: Wed, 28 Oct 2026 17:40:41 +0100
Message-ID: <20261028170507.079272098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

commit 4daa9ca557b4b98ae1ad38a6d1deaa3e31eb8edf upstream.

pm_runtime_set_active() failing in probe() jumps to error_unreg_buffer,
which only calls iio_triggered_buffer_cleanup() -- it does not undo the
iio_device_register() that already succeeded a few lines above. probe()
then returns the error, the devm-managed indio_dev is freed, but the
iio core still has it registered: the sysfs/chardev nodes stay live and
point at freed memory.

Add an error_unreg_dev label that unregisters the iio device before
falling through to the existing buffer cleanup, mirroring the teardown
order already used in lidar_remove().

Fixes: 4ac4e086fd8c ("iio: pulsedlight-lidar-lite: add runtime PM")
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
+++ b/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
@@ -299,12 +299,14 @@ static int lidar_probe(struct i2c_client
 
 	ret = pm_runtime_set_active(&client->dev);
 	if (ret)
-		goto error_unreg_buffer;
+		goto error_unreg_dev;
 	pm_runtime_enable(&client->dev);
 	pm_runtime_idle(&client->dev);
 
 	return 0;
 
+error_unreg_dev:
+	iio_device_unregister(indio_dev);
 error_unreg_buffer:
 	iio_triggered_buffer_cleanup(indio_dev);
 


