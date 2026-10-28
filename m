Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213886;
	b=ai3h90w2DNeJFD+KQnSlquqW+UPrQ4rzDvLIZMtLucxOD+xAr17p8QLBu3WpmhCvq4Iz
	 enZw1TMjwQrF8/5CNWXRN4hq+JLPqd2LESZl5ys28lYEhwVEgRtw8m6jTPtlGIgf6dGbf
	 0IiKfZi3cP13eo5k3h5JQzobSYY9/Bx2VdJcRevGYUyc9KbAwIfaG8u2yRnhU0X2b4+zA
	 RfPg7SS/caysLEsi4NlntPBZK34tzYYFfbYZykP4l3yAlvHENoEvj5hmwKUovT/sqSYcu
	 aOXfYF8PTKugwnUU+8aIDYYHk1E64qpjKUPwPkN12alzyapNT3A6URp/oiPFweXus6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BMsE1rUDemVUVEMTD8J2vf3xHir0Hdhxgo1hVtN67Mw=;
	b=N4ko6NKF5WRHyHuQ1l7SBGzUpxg/24Dn2Y/3HHDa6cpOyuI5m0DgdaoklV5AUvyTNVOy
	 i/GpMwsNVbzcoQBkqzDnq78Ov6q7T4uK44swp0duPVzqyvBwBIaESQywPEC9OUjeAUyLs
	 hnZvElclQs3h5x0yXCKYxwSvg/8jrNbqyTneRTbcd+8Vn/uB+ZZsS3xma9Ec4LqMRszJ/
	 LN4amqPpJfsWukQPAuXVLWYdC+amiRgjp5RY4uaH7xu2S4SGb1ndbtmrSpTbRil4zgo8E
	 6mDwhDGZjmAC3bQL3kruA+3rbVXCKF0feMJI93mopL5TTtBCiKqzsJnVtNoElV29upA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cTbegx8n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDE5606A31A;
	Wed, 28 Oct 2026 18:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cTbegx8n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3631F01825;
	Wed, 28 Oct 2026 18:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213886;
	bh=BMsE1rUDemVUVEMTD8J2vf3xHir0Hdhxgo1hVtN67Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTbegx8nEgo2DwQ0WdwLIUPCvy9fTR5M6ngqRbhLYf22lnwqRXfmjrjDbEZfDfP/g
	 cg83uPPmSQFKo/ydNOWL3xs8vkFaFSyPpLpiK6pZ2RF7CnMh7KDd9JlfDv6KxWWFcM
	 IOnE8d/Mh+5UpSxUm04LhH9xqpeTLknPYyRz3N/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devyn Liu <liudingyuan@huawei.com>,
	Jay Fang <f.fangjian@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0662/1887] spi: hisi-kunpeng: Add verification for the max_frequency provided by the firmware
Date: Wed, 28 Oct 2026 17:45:58 +0100
Message-ID: <20261028170514.476444234@linuxfoundation.org>
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

From: Devyn Liu <liudingyuan@huawei.com>

[ Upstream commit 5127c42c77de18651aa9e8e0a3ced190103b449c ]

If the value of max_speed_hz is 0, it may cause a division by zero
error in hisi_calc_effective_speed().
The value of max_speed_hz is provided by firmware.
Firmware is generally considered as a trusted domain. However, as
division by zero errors can cause system failure, for defense measure,
the value of max_speed is validated here. So 0 is regarded as invalid
and an error code is returned.

Signed-off-by: Devyn Liu <liudingyuan@huawei.com>
Reviewed-by: Jay Fang <f.fangjian@huawei.com>
Link: https://patch.msgid.link/20240730032040.3156393-3-liudingyuan@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-hisi-kunpeng.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-hisi-kunpeng.c b/drivers/spi/spi-hisi-kunpeng.c
index d5cb4bb709748..562e23d66d13d 100644
--- a/drivers/spi/spi-hisi-kunpeng.c
+++ b/drivers/spi/spi-hisi-kunpeng.c
@@ -491,6 +491,9 @@ static int hisi_spi_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	if (host->max_speed_hz == 0)
+		return dev_err_probe(dev, -EINVAL, "spi-max-frequency can't be 0\n");
+
 	ret = device_property_read_u16(dev, "num-cs",
 					&host->num_chipselect);
 	if (ret)
-- 
2.53.0



