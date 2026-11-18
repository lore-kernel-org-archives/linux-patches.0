Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015116;
	b=0LpEVtOF+OecejUvgSlw5ZrNkDWX6hOr7C3lOPbpKIRYYCroLpOjliiQ6XibMCFD1mEL
	 mjOJ30NBmfbpQI2VpeazSyzUgnClWb8/YQ8pvMGxnlqZkvvu9qaveMhvFFLSEfckdmSTK
	 /X8JjZmF0xDEkhjvwYKlN9RxdGjX//ka22X3Alt96E1upDcXXP5m5M5xZy+NtlWesV58Q
	 m83xLVZDtkJFjM3WG4s/Nm1rOGsflQ0ZzJwjb9ktdGqymL3APfeIvXNYDrzkO2S3CzpQT
	 qYmEG/NZB3rmoivjQEHscfgLFWaapcr0TnAb/bf+PE0sVoFaLFppHY0G2XBt7aR+Cag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Y2ictk0g65m0Ave1kEba8qmk6lzLWOvEefFB0gy7Pc=;
	b=gHlovSk6Vy5Sc/aPPImFfVZPfztJdEYzNOwdJO3N0w5186w2Iol+DfFiFzLg9TVv2R9o
	 aGvSDDdKx2Lg2QNt2SPOV3GYxE42K/khDXSWkwUTcbcqdSV/mCqIcdELwCa4KWbyPYfRh
	 tl9jRlCZIgoBzMLCWeVpwuqS/ggsQz2MfnXSv8unwDSrg7WPSEkcGhS0JiBZ1ylgFArXu
	 SJOSazq5HbFJlcb7TB92xnmezGE6nsO+8dQdb0EXvt8DUBm1N++dXT8jsYyhHHtu7BRgT
	 aBmIMLEFfdmE22ioIHlVFB72uqB9mGPMAZR//fZ8FzSRpRGEiGgnPLSdDbOyWzokiEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=egGLi1SR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406FA60A2631;
	Wed, 18 Nov 2026 15:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=egGLi1SR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE851F000C9;
	Wed, 18 Nov 2026 15:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015115;
	bh=7Y2ictk0g65m0Ave1kEba8qmk6lzLWOvEefFB0gy7Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=egGLi1SRoYo9OeAwS/Nz318vKi2vxWFkfBrk5+Zc11WVqaJ1PBhyPDdr0etADfI3Q
	 1PKPfykyFiA8IFWF4K5Y+fadGtALcD9/LeA7cBvA8FHbsw+HmkZRmOI8crUx9XZKwH
	 rtulJ/gRfrPYZCKL1Ye6zpUWXpLNz65CoasKXxuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0057/2651] accel/qaic: Add <linux/device-id/mhi.h> to qaic_debugfs.c
Date: Wed, 18 Nov 2026 15:21:37 +0100
Message-ID: <20261118150250.002447937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>

[ Upstream commit cef139aa5394844f61fdb81d9fb07e71ba4e2407 ]

qaic_debugfs.c uses mhi_device_id implicitly. Include
<linux/device-id/mhi.h>.

Fixes: 5f8df5c6def6 ("accel/qaic: Add bootlog debugfs")
Signed-off-by: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Reviewd-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260727173326.2219191-4-youssef.abdulrahman@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/accel/qaic/qaic_debugfs.c b/drivers/accel/qaic/qaic_debugfs.c
index 95c78e12dd61b..909a4d774d906 100644
--- a/drivers/accel/qaic/qaic_debugfs.c
+++ b/drivers/accel/qaic/qaic_debugfs.c
@@ -5,6 +5,7 @@
 
 #include <linux/debugfs.h>
 #include <linux/device.h>
+#include <linux/device-id/mhi.h>
 #include <linux/fs.h>
 #include <linux/list.h>
 #include <linux/mhi.h>
-- 
2.53.0



