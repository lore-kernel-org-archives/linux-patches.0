Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DB430DED3;
	Thu, 27 Nov 2025 14:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255321; cv=none; b=i0yo/g2w4HXYZ6E5t/IB96hXFPFUGPrRRfwjnwHzRSRfiP8yyflQfAgfwE+56SNQqwm6Xq1dx32SxfU2Voj8e1VJJBDiLCvgcX+HGNsmyTaSP/RnqJHyLAqcoERCk50RU51OwHR9sshrZt3ajAoJGJIEPQo5eyy544Xr0TGr5cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255321; c=relaxed/simple;
	bh=IrMjpjnriwEZF1xQQnjvaTcEJ95uvStyvmlukuIgI+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S855t4vHPpOHQQoW67OUfBd5bxEUA8OWMLNN552GzFVwKJznuuxiXqz4//OakaC1OoQfPqcHVcjNjjHW6QUpVh9Gd3BnBRBHE0/ayxQY7gSb3l2VCK0SVjpncBi4K8KmqMwe8nX6ta71MO/ISRNUkeKGh9vHOovZZJi2DQnwPAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJSIDR/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJSIDR/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF5BC4CEF8;
	Thu, 27 Nov 2025 14:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255320;
	bh=IrMjpjnriwEZF1xQQnjvaTcEJ95uvStyvmlukuIgI+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJSIDR/EaoAFy2AlbmotWhjra0IgHc4JQPQWkAJmaXGuyNgQzWvnD1c/QvX/TXCk1
	 6nZgdLu8HXCQZZwyIx5d42VUAf5XM9Q9NEJxpY972nCm5RGZAvbzra05cvObSFEY/v
	 GZgs1XWTyaGvppUfaU7+2XJH18fRMnghwsExrnz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Spear <speeddymon@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/112] cifs: fix typo in enable_gcm_256 module parameter
Date: Thu, 27 Nov 2025 15:46:26 +0100
Message-ID: <20251127144035.916351138@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 64dc7ec045d87..1187b0240a444 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -134,7 +134,7 @@ module_param(enable_oplocks, bool, 0644);
 MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks. Default: y/Y/1");
 
 module_param(enable_gcm_256, bool, 0644);
-MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encryption. Default: y/Y/0");
+MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encryption. Default: y/Y/1");
 
 module_param(require_gcm_256, bool, 0644);
 MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM encryption. Default: n/N/0");
-- 
2.51.0



