Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036655;
	b=tItqLDa/MLUrxUBIb1dBxmaOOxFvvXDs3aeFE0iVv47R7AWN7G8MKs2dnh6YKpjxlpKN
	 hfcBM4dZllgbj57Na0xdl/kA41HkAwB2GHld4xmjYsSmw5lErjq2/jx0Pw5s2/xdo3FcC
	 Vf98y/rny506MQxGq3BpdD2B9rpuvxCF+C/zv3WsGMefvPurSvvmAmyqIlRsynjawLlFk
	 4Yj9TfgpS0+oE4U+KnK55I+T9BGa5GFNSaSkmHsfqNGLFdbegWCRnUgeEkJYU55Ikf1ir
	 A5U5f+UnZM4lknF7s9JQeGQQHxLe/ZdhO826pLp1WfJXsmKRDEVgYckbUzgmlwXXBFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VtKiRfgHzyUQkutyxcLQy+38AzFRw1KBd9PCu5i4HXc=;
	b=zWx1TBG93evWo3QZ62JLhHa+lUs9TCN+OQ13hrQweYv1ssQqXgFV71ikinZ1PtGgar1d
	 f62LFD3aB+Ph05iRe6syPCpdz5z0sS84LMAOHwHs2chImMwmZwd0Zo1Bbw4B/fNxzIzmK
	 tCZXTD96SKcYEyv0gm5MTxklcAf8UxUHBbM/jwA/ScbW0OJ6m4LB1upeksSk6wHhWIXOq
	 c3X2OKZkw0OlMe34pUAeq9cD6OSLZMFVKpLnjFo7QC/zYdiCG1Y8w4e9yd92b0JEamVk1
	 vK3k/zhQ+9cyNIcDXgmBepYvxuUayVbbvZTyZGsI2M9bc8mLpNws+Xkiind6ruuA8UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y0HYUfQP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AE1606A31C;
	Wed, 18 Nov 2026 21:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y0HYUfQP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA611F000C4;
	Wed, 18 Nov 2026 21:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036655;
	bh=VtKiRfgHzyUQkutyxcLQy+38AzFRw1KBd9PCu5i4HXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y0HYUfQP+y2QepEpAXz4zxAfVQHNpGFVHeRHzekLMqXsgv1wSnpJgn0lZVVfnUEWN
	 QZZVCgRTEbY7XXkECTDhwQ+ZxiJuEnVcMzkty4lDGLCl7sZhC1911QH9eUxMXnartS
	 ST4uPET9deuYEo0h9aKwVLujbWYoqtFpAUhFk474=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1136/3318] dax: Return errors from dax_core_init()
Date: Wed, 18 Nov 2026 15:29:18 +0100
Message-ID: <20261118150354.132701410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b55a015e8576f..1e1ba2078d64d 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -588,7 +588,7 @@ static int __init dax_core_init(void)
 	unregister_chrdev_region(dax_devt, MINORMASK+1);
 err_chrdev:
 	dax_fs_exit();
-	return 0;
+	return rc;
 }
 
 static void __exit dax_core_exit(void)
-- 
2.53.0



