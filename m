Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055365;
	b=o6iZjR5m1mp7oA7sHekxGQmc6cU4YY1I7+fcRvVesaD3F0gnJ9EjzHMtpyl9M9qd7L7V
	 LVg+pKM6h4yfWP23fuMEdeHjwsTuNYiTCpJ9Yfx0cuRNXB93H6lmBd1jLuH7VxIM2lteA
	 14C/md9HQnYkryb9lWGnsmNlohMT6qZ1N1Vj4jGaq+sG2Ta7/9d+0ryEuZ9Nbn9VR9V1p
	 XN32Xx5VFB5uutlDokeweS9uK4XT8ImJdh4SMpn9eIuqYCct+VUzy7SY3ZqXleIUMUxfj
	 aMJ0DfaXZmRZI2T7bzpLkwRZqE/5NWxHLPyEVF1mrzYFihjKFfQdyoDbHXCzkd9Ls3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eUtHCyaB905GblH+/lFubNiXsgD5pUO2AvaZHRtNht0=;
	b=qTfmUnJbO8pGozACOKl2uRYgWeJm0OV2nYJsxd1eH+L/CTex6jAFUsmSCs6o4fS6UaCt
	 o/3k9MaYK3vNgaPv4yDK5ymhWNe/sNl+NlPy2uoUUBg5Jkf/7mqyI9f5aWLF79/LuUcR2
	 IGicr+k6weSyCEKKCO/66IbkrkRbzLfZJL5P9iG1OgWMBQ5X1cZcTRGLFSEhl8Um/5D60
	 7jb/S0DHxoMF9adVjjUb2CQLtK7RHAJoTzmv/pUeBhHoR2/wOslHzyWS8DWnb02bOGLme
	 QouLulDyeHxn70e9cqTFveZGww/f/gTPyeqkdONP+dI9umnk9sDwuIjAkn8li2vgpRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vqH9vz08;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8F8606A32F;
	Thu, 19 Nov 2026 02:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vqH9vz08
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413CA1F000C5;
	Thu, 19 Nov 2026 02:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055365;
	bh=eUtHCyaB905GblH+/lFubNiXsgD5pUO2AvaZHRtNht0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vqH9vz08jFwtoYW5K1YozCw5vKgge0I3HPIFvr1SJ2Ee1mY3j72V5Fm9OIvlpGD88
	 zPsh3AjwXZLJTgXLh3EyrxouyIiS721Ff6KFuPOsc4s8hSlCCu6Vm7yXyVw4smOs1K
	 mDPqEgiMNnFA2QioJrUga5NcQ82BNJ7ftg3jww+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1606/2214] iio: accel: bma220: publish the SPI driver ACPI alias
Date: Wed, 18 Nov 2026 15:54:42 +0100
Message-ID: <20261118150116.194211656@linuxfoundation.org>
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
index bc4c626e454d3..4497e80ef0199 100644
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



