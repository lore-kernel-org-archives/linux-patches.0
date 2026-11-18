Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021447;
	b=Py50FRPD0NU9KGrS4J+R1RKRmzJ9AVenEhmQd5mD6U081sBvIiXhoMBHBn1G9uWtiYqd
	 /1a4jTTOqDFcG/bu9LeQhUsPzmQqUjTZ5qJsUggw5BZt941sSHPaEME58INQOfni19rnL
	 cBd4t8yualshFbPuPRQzWkYrJdt/1Ki14MbNTyt8X/PqNvFFJbdnBw1pdbCgeRDvBNvKE
	 9JeIrioHQ5Gx0PzrlZofFQR7UdJJiYr1QtqF/49DSIbr5FLD2MUXv9QphdvVg8XVKXUcf
	 hL5t3vzc0NdpyGmlxBX+SfNLRyPxlNWSMh9QvmcKSeUf9KUlN+DjketLnWIr9DCnbLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vp+LlSSWxnwAaT4/+JgklMZWEbOGU5l0efOIVg5GxEE=;
	b=vDrnt8oa47bcSMN+5fVgJilV15I9nntMFqrFHnB30eHkW3WIZVWMveBwHc+0ctGUS0Ay
	 cCszSbWCIXrAkJFwtcae6uIxz5kVWUoW9HHhw7DFgyfVuQrio9r/eXRE2TYYpP5C83LBu
	 c8cGuxAf1iRqHptwC1M547t8ujv2q/K6FplIPs/ukGCLcdAVFnBFWjADq3vA3oVboJJ2B
	 9YPEVZfJpgmOIstbT2P+XEkfTth9K+2xA6rAR/31jmmMSinESSHf2+blyQXCsjvbEvR5i
	 sJMX0c4+eEmtdZJZ4MzyYzXqf+g9USPN8T5llVyUtvnoCZaOM0ogKplUesw5KHhJVhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fUHcvWtt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B18E60A2626;
	Wed, 18 Nov 2026 17:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fUHcvWtt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6499E1F000C4;
	Wed, 18 Nov 2026 17:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021446;
	bh=Vp+LlSSWxnwAaT4/+JgklMZWEbOGU5l0efOIVg5GxEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fUHcvWtt6yApViXzL8SO3B9gZWIdoXXozEKCa+RWQDRJ5WQM0h2la+pRcHiA6Ojxe
	 373tqbRM2VkV/nzf6sXxcBlEFzcjeL2CzQUH0oXPE6uz2XAJU2a7L+gWSAQ+Lvzs5l
	 Nfj33sVyVuc0ef2inGyqbqcacTUrIFLFgQoTcaMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2309/2651] mshv_vtl: initialize poll file mutex before device registration
Date: Wed, 18 Nov 2026 15:59:09 +0100
Message-ID: <20261118150408.366994258@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 60de22022fe0cb37bdec608d60d53292050903d5 ]

mshv_vtl_init() registers /dev/mshv before initializing the poll file
mutex. A concurrent MSHV_SET_POLL_FILE ioctl can therefore attempt to lock
an uninitialized mutex while module initialization is still in progress.

Initialize the file-scope mutex statically so it is ready before the misc
device becomes visible.

Fixes: 7bfe3b8ea6e3 ("Drivers: hv: Introduce mshv_vtl driver")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Reviewed-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_vtl_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hv/mshv_vtl_main.c b/drivers/hv/mshv_vtl_main.c
index 9133646b5b66c..2d4fe24cecbff 100644
--- a/drivers/hv/mshv_vtl_main.c
+++ b/drivers/hv/mshv_vtl_main.c
@@ -97,7 +97,7 @@ union hv_synic_overlay_page_msr {
 	} __packed;
 };
 
-static struct mutex mshv_vtl_poll_file_lock;
+static DEFINE_MUTEX(mshv_vtl_poll_file_lock);
 static union hv_register_vsm_page_offsets mshv_vsm_page_offsets;
 static union hv_register_vsm_capabilities mshv_vsm_capabilities;
 
@@ -1411,8 +1411,6 @@ static int __init mshv_vtl_init(void)
 		goto free_low;
 	}
 
-	mutex_init(&mshv_vtl_poll_file_lock);
-
 	device_initialize(mem_dev);
 	dev_set_name(mem_dev, "mshv vtl mem dev");
 	ret = device_add(mem_dev);
-- 
2.53.0



