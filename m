Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B2B2E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC02C433C9;
	Wed, 20 Sep 2023 12:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212093;
	bh=OSp1V0yUYBllwtbYjIYcdAknBxQu9M0rJoly8d5MgUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c5j1Wuv2ufJwIbdKi72wlBEElFl3wGEdq0oXhF0kgBm74YErXZDGDHArRtJ+iOJmB
	 4oSXHUehUWdv41c4Ss44IeQdPgfdQP1ZOj9cd4RkBW6UDjGyPJLfox4uZVFf4Dr7M8
	 QAILpMUs7F7dugAswqJvExL0pgiM9faj9epbL6nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 148/273] USB: gadget: f_mass_storage: Fix unused variable warning
Date: Wed, 20 Sep 2023 13:29:48 +0200
Message-ID: <20230920112851.105050402@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

[ Upstream commit 55c3e571d2a0aabef4f1354604443f1c415d2e85 ]

Fix a "variable set but not used" warning in f_mass_storage.c.  rc is
used if	verbose debugging is enabled but not otherwise.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: d5e2b67aae79 ("USB: g_mass_storage: template f_mass_storage.c file created")
Link: https://lore.kernel.org/r/cfed16c7-aa46-494b-ba84-b0e0dc99be3a@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_mass_storage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index 0b7b4d09785b6..4f221ca7aad15 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -950,7 +950,7 @@ static void invalidate_sub(struct fsg_lun *curlun)
 {
 	struct file	*filp = curlun->filp;
 	struct inode	*inode = file_inode(filp);
-	unsigned long	rc;
+	unsigned long __maybe_unused	rc;
 
 	rc = invalidate_mapping_pages(inode->i_mapping, 0, -1);
 	VLDBG(curlun, "invalidate_mapping_pages -> %ld\n", rc);
-- 
2.40.1



