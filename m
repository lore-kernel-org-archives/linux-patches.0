Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F733502B6;
	Wed,  3 Dec 2025 16:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780241; cv=none; b=oBTZezj3jax0u/6Zur9lmmVnDn6770HCcK8AGKVqz73kzZzbteIrL8IxWrs1DyPYXp0k0f2Eztw2rbcVWlaE9Vnz5Y8SKqhvFMrITx3zC9Cb9Ff7m1z48uN16lEFqLX1LWMMri0DXVEfhK0OQI4/wIDAkjU/rhMNAG8LP+YxJ08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780241; c=relaxed/simple;
	bh=7U8X1kbGXa1LRYl9aDewE82yPQmI1tW7sMQykA7orkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+Q9/ABoG3ppzakztE3ByHcRPh01HqrMjEgXNPwkpi1umLKkY9w9DsjSOfg+vDS2FbM6xS5rBXTbjIL0xc7yE78u9bodXX3AdB6SsQ8WA+7nkfxAwmO3dWo/PnwDdO34cihepmg9gdJDNTJ4dzSYYd51hzdWJE7/ReooVkyy19Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJ+cqqum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJ+cqqum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B97C116C6;
	Wed,  3 Dec 2025 16:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780239;
	bh=7U8X1kbGXa1LRYl9aDewE82yPQmI1tW7sMQykA7orkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJ+cqqum0jPKH4HFY+s6hd4nwm9EqFg1TXbxb5C5/XblGm1tpSpjLJVr9LCvw6aS4
	 ajGHs6rj67B8nRSzQcWmCYl2JdgfZJpbEvFXA6jMJca2sVcXsIJFAWvhQnZclXLqwh
	 vz0LGfW69Q2fvmBmPStZD/hm9KvZTpfAx8qQZkmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Spear <speeddymon@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 465/568] cifs: fix typo in enable_gcm_256 module parameter
Date: Wed,  3 Dec 2025 16:27:47 +0100
Message-ID: <20251203152457.733881812@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

[ Upstream commit f765fdfcd8b5bce92c6aa1a517ff549529ddf590 ]

Fix typo in description of enable_gcm_256 module parameter

Suggested-by: Thomas Spear <speeddymon@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 32b008bc99a09..74e4beb351946 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -128,7 +128,7 @@ module_param(enable_oplocks, bool, 0644);
 MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks. Default: y/Y/1");
 
 module_param(enable_gcm_256, bool, 0644);
-MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encryption. Default: y/Y/0");
+MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encryption. Default: y/Y/1");
 
 module_param(require_gcm_256, bool, 0644);
 MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM encryption. Default: n/N/0");
-- 
2.51.0



