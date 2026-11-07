Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064919;
	b=15UEt5ypj/W+UL/BQ9/gwSJ2Moa+rJ1dHlvAuYa1IKI+8K3jihyI7/0buKM5pTMNZM9l
	 6j5nbHN/j8aowRtPlfCUt/rri68/8QA350F3dscINjiQW74UlBH9FGTz8aS8V+MSqU1R7
	 SRspSH2C0A/jJvynWu04ll5ZteNDZnkUzoYiRhXD/b8iSIKHClpx9fnjOGSg9NOgwmAU3
	 hCwflrau4aXadx+RfMzIsLvsltE/iusZvCrtK1ZZErRLL9bPycAIJpuj5INUY1Exc9dwz
	 NvaiC6IKs8djcMphcEzzKwH8h+jvY1kn8vMxb81mJtGtO2AkwQLj4ihXncMZHbagp1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vJoE2FdICEKQoBrWHw0nx6CX5IW7VdkN/AmUNli2V8c=;
	b=Dcfmx6AquQIVQYuhuVb2J/pYihU6mzyioD5653HxMivq81aVSpH/K7ceq+FlWyCuw7a/
	 3JvNwj7bv0hRHlIVorFLgZAJqJjCcEk2ZtbyXTRKWUF326AGviNIag9lxPCxj3+rlwBOn
	 H7r7nYa3PtmbjMhF4QiPJkF97rR1a+sfpFNir5qCJq+L84ZY4gwTYAdcn5s70YUKRYEH0
	 q0lraV61j7t+6Khyle/IJMujpLynRV4xOI/G0xJAQcxdAU6IF8Rgpuf2QQht/S2q34FkO
	 afvW1xi8nDqdWYO/Rzdk2WHQ43xaJSOfTxNgYY32xt+eJiKtYGk2OIwAceLvJrAqCjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JiHS8Php;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68378606A33E;
	Sat,  7 Nov 2026 15:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JiHS8Php
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104881F0089F;
	Sat,  7 Nov 2026 15:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064919;
	bh=vJoE2FdICEKQoBrWHw0nx6CX5IW7VdkN/AmUNli2V8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JiHS8PhpbHKbmJ7XlcJppqTzE1cfxshPKyuX1BKfXFcwA25bORfnxIPjiXVklNgm8
	 HniYDNp96zWDIUbrPiOKEyA6AjT6l8b5n0KjsE/ShWu2gik+ijEGyAbmIAeDoVjuN2
	 Fqx3iDEKz338QdgM94YBbwONuSEtupXRsyOc4YPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0817/1257] dax: Return errors from dax_core_init()
Date: Sat,  7 Nov 2026 08:51:53 -0500
Message-ID: <20261107135001.909162436@linuxfoundation.org>
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

From: Jianyun Gao <jianyungao89@gmail.com>

[ Upstream commit 4da700e2cadf84a6e858391d5be51d64dcba080f ]

dax_core_init() returns success when either the character device
number allocation or DAX bus registration fails, even though the
error paths have already released the initialized resources.

For modular DAX, this allows the module to remain loaded despite
failed initialization, leaving subsequent users and module removal
to access resources that have already been released.

Return the error code from the failed operation so that module
loading fails rather than reporting successful initialization
after the resources have been released.

Fixes: 9567da0b408a ("device-dax: Introduce bus + driver model")
Cc: stable@vger.kernel.org
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20261012151857.22534-1-jianyungao89@gmail.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 45f84b0eb909a..210f4af479f0e 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -738,7 +738,7 @@ static int __init dax_core_init(void)
 	unregister_chrdev_region(dax_devt, MINORMASK+1);
 err_chrdev:
 	dax_fs_exit();
-	return 0;
+	return rc;
 }
 
 static void __exit dax_core_exit(void)
-- 
2.53.0



