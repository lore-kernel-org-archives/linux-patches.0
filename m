Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048608;
	b=I5Y7d0tTrJ54LfFMwYEylF/Dwg8I/g5OBZByf19RqE/AFnLx3mQttAA+VREv3kT5S/Ua
	 2Z9ABRPFCCgRuU8xbsgHxAawLEkt0PlrKPnCf/Mh3IDn/P5HDtxFdpeTlSPCq/PQSoLuB
	 C3LXuhrqOGe2LTFs6w/SbO7Or6C4NJH8DY/ZOD25vIqdLJrB7u/qkvjPgJhpVny7Ta0Uq
	 +y91ui6BzXwxKBbpXJ/45XBMGoeQtCmXjRtYZNpfjqFsTaXhOQpuuajQT0D+GHVqUUXBd
	 V2gm4mqKDX7x+0OcbzZwSnxWD95i3AsdOf6A23xWJQWwAElXcowA1IPsn3ynog4wCTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X3A8H9dF9Fd+8dlLQxhPTEmf9rCXSa0JttVeFERDJG8=;
	b=sNb4FuA3OZmOHzsEUzsLD6B5c4fSZtx1cFfHdB1EALVFkRh0Beo2ESPJ+xKAUm5DoJyL
	 +JLDkOm0yEKe8GzU/E8Cxn0a8XOilTwbFRAS1a6/KkO2TcF98wdNwGkexWfpfMgdENw8c
	 LQPM/63SuRFdMqry/IkNA/CzMoImThmq4em5UwHMGhyKlUmN1HhCLI+LalCYe476whoU0
	 m65f5x0nhuo1+lHcHX+mQUjlQa0XXy1B0waCsKZFNpAaC5NfTHqXRtVJarVHlceWGShny
	 GWwEkmkQfHVfpYLaputkZlok8AQ9UEbNhE6NbTEcOxZpaf26pDyepXDsd25b82KXtlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lK29HqsU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA76606A320;
	Thu, 19 Nov 2026 00:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lK29HqsU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52EB1F000C4;
	Thu, 19 Nov 2026 00:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048608;
	bh=X3A8H9dF9Fd+8dlLQxhPTEmf9rCXSa0JttVeFERDJG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lK29HqsUn9/r1gk5joQGTRQ08Fqa7u0OqNgwTkxlE07QeytkFM7otrrCjihpF4o63
	 MmbKMeGcr1oGybv4AZvnLihiWVBammuXRnbksHU2szU+BI33xWHKUSSqVJ3DswvxK5
	 l4O1ZUlzTdH7cRAMAFvPF0W5qY8UusprckF6TB10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2055/2857] iio: accel: bma220: publish the SPI driver ACPI alias
Date: Wed, 18 Nov 2026 15:51:29 +0100
Message-ID: <20261118150315.409414631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit cdc7d3dd101251a6373332726b8d6fad35e83b8a ]

The SPI driver advertises an ACPI match for BMA0220 but does not export
that table. A modular build therefore lacks the ACPI alias used to load
the driver when the device is enumerated through ACPI.

Export the ACPI table. Move the existing SPI export next to its SPI ID
table so each export is adjacent to the table it describes.

The issue was found by our static-analysis tool.

Fixes: bf2a5600a3eb ("iio: accel: Add support for Bosch BMA220")
Assisted-by: LLM
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/bma220_spi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/accel/bma220_spi.c b/drivers/iio/accel/bma220_spi.c
index fcbd695e46549..e6d1e91ed62c1 100644
--- a/drivers/iio/accel/bma220_spi.c
+++ b/drivers/iio/accel/bma220_spi.c
@@ -308,12 +308,13 @@ static const struct spi_device_id bma220_spi_id[] = {
 	{"bma220", 0},
 	{}
 };
+MODULE_DEVICE_TABLE(spi, bma220_spi_id);
 
 static const struct acpi_device_id bma220_acpi_id[] = {
 	{"BMA0220", 0},
 	{}
 };
-MODULE_DEVICE_TABLE(spi, bma220_spi_id);
+MODULE_DEVICE_TABLE(acpi, bma220_acpi_id);
 
 static struct spi_driver bma220_driver = {
 	.driver = {
-- 
2.53.0



