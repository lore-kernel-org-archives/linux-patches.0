Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97461250C06;
	Mon, 23 Jun 2025 13:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686215; cv=none; b=iUv/mHqs1bIINoD0gVmFaUg5whFJme5FvMvnQNqfmYiU4Ws1ULKrj2HuFmUO2d4u5PHbvmy87rb7C6EZSdY7m/AEFdGAv8rdE4XYXHb7Mesfp/bT/o3qddYxvkw68VOJh0hEeohP7YChh/vZH0nJqVhEJSFwFE8JGKTvKxQkwZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686215; c=relaxed/simple;
	bh=+LHcmqV9Wwfkqb+IBOblDqFapeVN85lv4KTSi7kvTvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEXX4XqE58O4HKLMu+egpiCv5HwnE9Ve0fCzQuAeu3oUyRAI1Is8WKhVhtWiJG1PZq86fbJsHLxgepTQtZPfRQUXwJUsLb1y8GB5G9gB04i1PjIXFqfB2iC6QMTK9fabD6ef6+E7wbyGhKA/Jx21rKMhWCqWz9yxdNVSA1npUiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMMy95Mk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMMy95Mk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FD6C4CEF0;
	Mon, 23 Jun 2025 13:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686215;
	bh=+LHcmqV9Wwfkqb+IBOblDqFapeVN85lv4KTSi7kvTvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zMMy95MkrPJE48cCpqVTzetSb+p/oDhfLpsFZUGNU9vU/21nNF4iC9W96PvVkQjNu
	 P7uJ/FOtQfZ0Gmq8eZafWr6kLOdh/VoeO4D+cm9/FmKbIAxscC3YUjnAmyC8FZb+TW
	 bzwhVI+IkOIyD+OreiS0ZDsmihYssV6iytrCVPPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/508] efi/libstub: Describe missing out parameter in efi_load_initrd
Date: Mon, 23 Jun 2025 15:02:01 +0200
Message-ID: <20250623130647.107296088@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hans Zhang <18255117159@163.com>

[ Upstream commit c8e1927e7f7d63721e32ec41d27ccb0eb1a1b0fc ]

The function efi_load_initrd() had a documentation warning due to
the missing description for the 'out' parameter. Add the parameter
description to the kernel-doc comment to resolve the warning and
improve API documentation.

Fixes the following compiler warning:
drivers/firmware/efi/libstub/efi-stub-helper.c:611: warning: Function parameter or struct member 'out' not described in 'efi_load_initrd'

Fixes: f4dc7fffa987 ("efi: libstub: unify initrd loading between architectures")
Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 97744822dd951..587ba946ba9d8 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -697,6 +697,7 @@ efi_status_t efi_load_initrd_cmdline(efi_loaded_image_t *image,
  * @image:	EFI loaded image protocol
  * @soft_limit:	preferred address for loading the initrd
  * @hard_limit:	upper limit address for loading the initrd
+ * @out:	pointer to store the address of the initrd table
  *
  * Return:	status code
  */
-- 
2.39.5



