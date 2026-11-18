Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058324;
	b=PGPZAgXP6zoVArAcChTwtoqhr8tZvPBhLGgXmV9d6f/HARgTDyGk0GzyyGakzuq0IKqw
	 uaysj2AFxuS7J9brKHwzarOoicoGcoKd3uLsskdXnJ5+s+qd3YXKnDJxSpfNRCwWBXhQb
	 k+yFRnw/99Do1BNvF9lUqlHbwmN8Z4SxKjxfdvO7LA2CYjnPGzv8g8D0p5jjB2nMT7u36
	 wd9ybLeYoOvcJcl4D5FcyylKiPmOqPqszNbkRDt7J1qqiCOwRiYG7aYMyoqxi+rQxDgDY
	 728xSZP46doA9Ovy6fQ4fnCHZaIO0cM/SuTXPauySTku5dnwpTlC8TmIvYg5pawajyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tscQx5dhjAXipmcK+n580Vzhxqc3oMA+UAdnwnjXFac=;
	b=U6M07ttBWsjCDHmJ2aqEV/76IxUBMvLDUImdEuHv4imKq0RtU4alXmeMY+O5+BIDMe2q
	 YsOHrO21vz/QlbaxGKzJDe9briet1ZO8ALIEgtKjRlkq2Zi8idrXnFkH7Ab9vK9CtaTrN
	 32L/l/O/f9iHhX9AY8JgzFt+BHEUDzRH00U2cIGmJQBt9m9MmTuxHjl7tcUlm0BOGjeKG
	 CPuW3LGjdRc05+36Be7LQB6s1KyS5xAsRmuwnkyKuoL6c3UhlQ2Bx4KGS9G7qCGnQRrjV
	 todlAhcmqNfrXfnMnpQzqORITZJgnBJ1dYfyK7MOGOWE6AIb25ZcLwsgGeRDPuCn4FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pxB49/PR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17CE606A32A;
	Thu, 19 Nov 2026 03:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxB49/PR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152741F000C4;
	Thu, 19 Nov 2026 03:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058323;
	bh=tscQx5dhjAXipmcK+n580Vzhxqc3oMA+UAdnwnjXFac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pxB49/PRjuD/PR03jx0udCByF8OpZz9UVmADTBpduZ4XWmR2OeCmx8v00Syg6qiME
	 Hdpqw9TEUjNTC30ghtHUA+kdXZw3uSmpB1F8hB3h6veLrAvnFiO3/wjcTlhSxW/CIo
	 YOI9TImqPG5v4tNzSdN7EWQB9QyJIXyqnDWUdeSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0403/1848] iio: accel: mma9553: disable autosuspend on remove
Date: Wed, 18 Nov 2026 15:40:41 +0100
Message-ID: <20261118145930.709571278@linuxfoundation.org>
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
index a23a7685d1f93..56f308c1317a9 100644
--- a/drivers/iio/accel/mma9553.c
+++ b/drivers/iio/accel/mma9553.c
@@ -1155,6 +1155,7 @@ static int mma9553_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 	pm_runtime_put_noidle(&client->dev);
-- 
2.53.0



