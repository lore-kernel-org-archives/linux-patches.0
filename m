Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062059;
	b=A95O9XcOw84NiS3DVUh9CWHND6UO1LeHWSFuau5vYYQXKYNcNKBKKIiB+O6EVvb4N1dQ
	 romfhFHQ5duoVOTaGz7MqoFP9Lqj4tsDUWcsqK1NhlDQGQJctmkUeCflOScCN4zCY0Cy3
	 RRqV0AQu8RNbaiIoraivhqiJFDdpdfJjWeMrzYov/HjS6YzsTl02zjHrXW39NWThiU0cP
	 +jPQ4wpYz+zvvnePHf4+iNFrfKPJs7MNxrW1k+7q8i2nebbPIG90nP6EeVfmvshVa4obU
	 uayVUtaUMVS7eAI0mCF7B6R/oAx6hgMSH/Oqurc8MBCPMpHl5HUxMWdCdqbc9cMncHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3czAOHcCYmlULUVDZ/n+3Vg7eNjz6fqFlPnRWJCA53Y=;
	b=cD8bUKgjBBftcBZOjboV+9UmtEWvEZ7Ioj4BTZTfBAdlGqpsAgPzDvxL4w/jz05Iwfft
	 0Qw7TJlVYwmZVynAVUIotjXGC2JiuPA4GueQFDkN8iQLKHYCseba+KZmBiicurYAC4/q1
	 y3/30pQTk6NXHwnrM/tnf7mCAshxGiuuxaTDCj0QFzvl6LJcKuXzhK5lo6ZjOlh2qT2Jh
	 zZbw6hwZ7D4W3tfcqyi6nixRY+T9sNo83u30RfzM3gMFZhNFoO0/6pu6sGQylomh539cm
	 U1CNSqrQ/Y2NTAdWRTIXVCH7HaN4pmK/U2TrtrQPO6zt9uXZSV9OGI+6Al4/Zr53/QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RbzAtMIz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9A2606A332;
	Sat,  7 Nov 2026 14:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RbzAtMIz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2981F008BF;
	Sat,  7 Nov 2026 14:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062059;
	bh=3czAOHcCYmlULUVDZ/n+3Vg7eNjz6fqFlPnRWJCA53Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RbzAtMIzfXDP8P4Sb/IJ2YdGbsLzQ3/vz3qDnP+id5/1v9bD2zuKKIgSasTIpuNys
	 HHoTWTeX/2PFILngzqQ1F/emSxjFVXRWYCY+2bdF7uq+i4RRxML51UGtKO1tVNXmhN
	 U1uW1/vOeIDLBVCOTXt3mfgnCTvbRbNiWsg8bMCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1040/1536] media: cec: extron: clear response tail before dispatch
Date: Sat,  7 Nov 2026 08:50:56 -0500
Message-ID: <20261107135026.885146683@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

[ Upstream commit a601427f03e015e3d4d2ba44cfa6e0de144983b9 ]

The serial receive buffer is reused between responses. Terminating a
short response with one NUL leaves bytes from the previous response
behind it, while the dispatcher also checks fixed offsets beyond some
prefixes. Those checks can consume stale tail bytes.

Clear up to ten bytes at the end of each completed response, limited by
the remaining array capacity. This includes the terminator and covers
the dispatcher's fixed-offset tests without adding a separate length
condition to every prefix branch.

The issue was found by our static-analysis tool.

Fixes: 056f2821b631 ("media: cec: extron-da-hd-4k-plus: add the Extron DA HD 4K Plus CEC driver")
Cc: stable@vger.kernel.org
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c b/drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c
index ac1013e114304..4f0a216352252 100644
--- a/drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c
+++ b/drivers/media/cec/usb/extron-da-hd-4k-plus/extron-da-hd-4k-plus.c
@@ -846,7 +846,9 @@ static irqreturn_t extron_interrupt(struct serio *serio, unsigned char data,
 			return IRQ_HANDLED;
 		memcpy(extron->data, extron->buf, extron->idx);
 		extron->len = extron->idx;
-		extron->data[extron->len] = 0;
+		/* Keep fixed-offset response tests from using stale tail bytes. */
+		memset(extron->data + extron->len, 0,
+		       min_t(size_t, 10, sizeof(extron->data) - extron->len));
 		if (debug)
 			dev_info(extron->dev, "received %s\n", extron->data);
 		extron->idx = 0;
-- 
2.53.0



