Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030090;
	b=sewu3Rvrp3Qy4yz6bxMErg9/pLTabnST4k759Y5OEZqfpjDPNEPlJZbH2hEonxN2/DAP
	 piPXfHvejJlPbO6aHz9+kx1cQnNqnjLHiWEzV+snQeqx+UXgx63w7BXGikNlI8urT7M7j
	 wTGhR7SD26fa/0o9f9lhENL4WmB0vd5HpoVYAEppfpsIY5lhL1ngfk8tnp3xBKFhTNPVU
	 YCkeybf3vZk76oPH0yOAbXniPkLLsbT7L5RUqG/HGFnBezD4cbb0mjQFWmhTMZYlyhz7K
	 5ez50SVivkzfglOJFx5z1Rgjrhrn7/T7YF34pB/hqKegTw8k9Z1IarK5kQm89Zmjn9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sE/hnFwZmaAhSQ4IT6TKtnC9Td0gz42DclpgOdB6Ass=;
	b=s9WtB8mNBFbntX3LtpI7/dYO/Hq6ueY7WQaIkkZCZf1BayOoz5AiPTgh6V+92YgUOOSN
	 jcNXipc0fy3go7KvnlAmzdQZ8E5cjS8/7iZXTEaIusfE/wbs2j+2OwmDwZmHjAXi3mvxk
	 ZWpawxP/lC9MZZbSLhkNfBR/eZPkquovM9w6fu9zj9wkOcnkTKkFcTFwhxpKWx0kgfmTh
	 MbV4krGxpPv1k6Ot36dRjhRmFJn9jQM/O7aCDwzgCNs9hVW+m3dkrxAE7UqwnoLehgcvA
	 aPWivLKFCQPPnsn71ymfSrWWA9Zx5krqA5lr2p3anbF61bKV1nRv6ij7YODKFtXfeZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fWjYywuL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6573A606DD2D;
	Wed, 18 Nov 2026 19:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fWjYywuL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8755F1F000C9;
	Wed, 18 Nov 2026 19:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030090;
	bh=sE/hnFwZmaAhSQ4IT6TKtnC9Td0gz42DclpgOdB6Ass=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fWjYywuLwO9FWAj3mLzBP1U9etrBeSmNU4L6urNjncDMYx1GMYWtSYN5kh/t8YCfj
	 RzzAwtfOKfrGhcK3SkkGqmYANgzX2QuUETbRtVb+Ktfwenk4Zi570H3fOKAzs+LMPw
	 tAxCzCxUxvXWaHDY+9vkCGyi3hFVy1RWPnxgv54s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0581/1756] iio: accel: bma220: publish the SPI driver ACPI alias
Date: Wed, 18 Nov 2026 15:45:08 +0100
Message-ID: <20261118150032.165317939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



