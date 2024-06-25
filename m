Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDBE13C90B;
	Tue, 25 Jun 2024 10:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309686; cv=none; b=VnHJ8IYSRgHyZpAgEabn3IuAkSmK+sNSwb9qekzHyraK5SeBHjQmpmzhzUeqUhtNC/ATMN1897j0vUzrNFNGQdo2/t3K0W9UzQkTBrY8q4DZVI3df8xtrZoB+bTBpEGhCT5KfDKC7IvkPS9Auybez1asMuqDEdB7YY2qlfUag9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309686; c=relaxed/simple;
	bh=7Ts+uAwNDASkgW4//TfUfafCzlgQSH4tdTtR2T1S1m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozdA+2DQFmMTL/NLsErV9qCYpz1jllVEUgDfUM4dH5P5t+bb7LQ7Rs2r0160WIkymUP2OX9NG84N+zwdNenmoq0gQ980s5hrX20CgdH9PTdUBeMNvHt3WKk612iuRv5Bs4Q/1Vz7ThD701NheOCbmnWh25oVCjZEcUebM9RXLzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6u9LQX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6u9LQX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CFEC32781;
	Tue, 25 Jun 2024 10:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309686;
	bh=7Ts+uAwNDASkgW4//TfUfafCzlgQSH4tdTtR2T1S1m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6u9LQX3EJokNZjSxeTXNXzFqDcurmeUtjpTk6ELiH8p8OxQ+mmjHMtZdDFzXcdgR
	 JxgogFuyXoN+jOTNPOLk8wbknJfSJtN67PZjCQQthDZghdPYz4dEaxV9h9kKS72dLA
	 j/kv4PSvtuhw+qZ/o7x7WidBopQWC9F9VjWIMQiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 098/131] cifs: fix typo in module parameter enable_gcm_256
Date: Tue, 25 Jun 2024 11:34:13 +0200
Message-ID: <20240625085529.663959272@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 8bf0287528da1992c5e49d757b99ad6bbc34b522 upstream.

enable_gcm_256 (which allows the server to require the strongest
encryption) is enabled by default, but the modinfo description
incorrectly showed it disabled by default. Fix the typo.

Cc: stable@vger.kernel.org
Fixes: fee742b50289 ("smb3.1.1: enable negotiating stronger encryption by default")
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -128,7 +128,7 @@ module_param(enable_oplocks, bool, 0644)
 MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks. Default: y/Y/1");
 
 module_param(enable_gcm_256, bool, 0644);
-MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encryption. Default: n/N/0");
+MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encryption. Default: y/Y/0");
 
 module_param(require_gcm_256, bool, 0644);
 MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM encryption. Default: n/N/0");


