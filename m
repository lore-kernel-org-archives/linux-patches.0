Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3726D1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87E9C433D2;
	Wed, 28 Dec 2022 15:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241929;
	bh=jPTkkaYuH0DswnGejV9IOCH+RcQYHlma1W2FmPDhEKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/OTTqWq0tKuEwNt/lMonD4NybyoRelMi+E2P8e/ODUbnoA9n8dFZXPpleEQsDrf7
	 ix4VAsFD46qICabKMCTVagKX8XUCQUvVXQcpFc3uo81ycbpyLVGsGAmqIzzo/8ub3V
	 y2N/zM33/kFn+WwHIVk3P5QbEb72FTwxqZrnIp9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cole Robinson <crobinso@redhat.com>,
	Borislav Petkov <bp@suse.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0306/1146] virt/sev-guest: Add a MODULE_ALIAS
Date: Wed, 28 Dec 2022 15:30:45 +0100
Message-Id: <20221228144338.466107745@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cole Robinson <crobinso@redhat.com>

[ Upstream commit 2874529b3513bdc90299c90f40713602da685e35 ]

Autoload the driver when, for example, SNP init code creates the
corresponding platform device.

  [ bp: Rewrite commit message. ]

Fixes: fce96cf04430 ("virt: Add SEV-SNP guest driver")
Signed-off-by: Cole Robinson <crobinso@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/ff480c5e688eb0a72a4db0a29c7b1bb54c45bfd4.1667594253.git.crobinso@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 1ea6d2e5b218..99d6062afe72 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -800,3 +800,4 @@ MODULE_AUTHOR("Brijesh Singh <brijesh.singh@amd.com>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("1.0.0");
 MODULE_DESCRIPTION("AMD SEV Guest Driver");
+MODULE_ALIAS("platform:sev-guest");
-- 
2.35.1



