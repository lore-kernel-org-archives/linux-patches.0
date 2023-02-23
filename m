Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FCE257C
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD30DC433EF;
	Thu, 23 Feb 2023 13:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157564;
	bh=LCNzENi/kfiHiyryA3Y9D59ghg9y/RrGvWNFlvU30lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NeoyyfHV4Dp/FSEatT1GdfkdQjCqzNnBQXEdfO7trNOig0lBC13QRxdr2h/BMb1vM
	 P6LCtvU8gur+BRupMz18EE93H71Kes4cc+YOPa+c7q3X6RCGIdpLMqyeSjBzdVOO4W
	 tgig7yETYpJHjMvSZsdagBMy+XVDbMxDQyZwOVwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.2 07/11] audit: update the mailing list in MAINTAINERS
Date: Thu, 23 Feb 2023 14:05:01 +0100
Message-Id: <20230223130426.477546346@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130426.170746546@linuxfoundation.org>
References: <20230223130426.170746546@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Moore <paul@paul-moore.com>

commit 6c6cd913accd77008f74a1a9d57b816db3651daa upstream.

We've moved the upstream Linux Kernel audit subsystem discussions to
a new mailing list, this patch updates the MAINTAINERS info with the
new list address.

Marking this for stable inclusion to help speed uptake of the new
list across all of the supported kernel releases.  This is a doc only
patch so the risk should be close to nil.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3515,7 +3515,7 @@ F:	drivers/net/ieee802154/atusb.h
 AUDIT SUBSYSTEM
 M:	Paul Moore <paul@paul-moore.com>
 M:	Eric Paris <eparis@redhat.com>
-L:	linux-audit@redhat.com (moderated for non-subscribers)
+L:	audit@vger.kernel.org
 S:	Supported
 W:	https://github.com/linux-audit
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/audit.git


