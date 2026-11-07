Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063502;
	b=h9eXSmp9rNdIxsKgRhMjBY3ip0r9+vXNLU2mJ3+Vpag4/P1w3hzypwx6+qjzm18t/oal
	 E5OgVnuvES6cbuuu4OzzGICkvx6lOyZHn8aPppZ+bqfTbU0+/fJvNbs8XYr43sJfvEvef
	 DKRMiocQ2voCkD4S/n37j6arCVya/2TfyaNpOvvsrm7gqey+Gx63aL/DmzpK15LqMtvqK
	 RP7AHsnYF4iRLt3zis5xTI7NCQ0TVOEGGd/Bu9egZYrO4eiVuhV9uGbUa2W5ZXbgy1jYJ
	 vURuA0Z1MRz60wj6oEpid9JqeV7IFBxvzyLeYeEvtNT+OYp+QMasqik8LOsUnLbRWhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=knJ00KqCfpfP/Wk0jbRY9if4jj3c6dkS0dFHqI82zEA=;
	b=yV9hznMli3yZ23Py8GovkgMSjJm812q9NChtDDsXIUPSjKjhjlTu/TfJpdfiufZ9yej9
	 1aRe/zYk1ihtXUX2tPp24cbwfgCtAmB8ZLXp+Z1sLrS3Kqp2GWvrOw673S0+el6l1BLYF
	 lep6hB+CDU6yNHp37k5LBxEB8Alo48JsdV6Tb2pNmS9v/sHrIMrQEIWBYqrO5297suXBz
	 pqnWnJ3oFQcwV77bVTEGCt3v5TK5r+cjO+spe0jdpL+MPbERKxa01Ssp1DjD4gyVaY01i
	 WCC+3rIVElmS9Yhg/DKj8GorwQqbravu8DMuevcASrU1YZ14YjElIY2A3rsr7kARX/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xJzhoOks;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD68E606B89F;
	Sat,  7 Nov 2026 14:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xJzhoOks
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692401F008A5;
	Sat,  7 Nov 2026 14:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063501;
	bh=knJ00KqCfpfP/Wk0jbRY9if4jj3c6dkS0dFHqI82zEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xJzhoOksIwyDphoXQdOwdzRj+KEUjbFnwPqgIzOlZLDDrLRRiif9Fghp6liUy3oeD
	 wYU/nxgT5hdvU52R2nUxY7QlDzhTeDzuciM8XYIzF1b7cKDHQscrVrYarLTAhhjfRX
	 0XaeCfG0+BOqzhv6FehQDtyWRmh2CG/34DzIYRvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 598/869] dax: Return errors from dax_core_init()
Date: Sat,  7 Nov 2026 08:54:40 -0500
Message-ID: <20261107134913.351156912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index efa5f61860190..9b46166fd2148 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -601,7 +601,7 @@ static int __init dax_core_init(void)
 	unregister_chrdev_region(dax_devt, MINORMASK+1);
 err_chrdev:
 	dax_fs_exit();
-	return 0;
+	return rc;
 }
 
 static void __exit dax_core_exit(void)
-- 
2.53.0



