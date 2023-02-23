Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4EF2584
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A5EC433EF;
	Thu, 23 Feb 2023 13:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157821;
	bh=KBVVLp/nURIz2EFMEKtJCoL1S/9M8UwGjJnKZ5k8JQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMvGxmgjQ3W5xsfJYWk1qYpHcVZWISYtly8CgWK6KDFk09y1avvHGrRH+kB3sKxBH
	 PdI9LBPS4oBiUT2Ngk9norAVIbM5Cy0BS2cp4dC8NMR8n4jXFuHHeARDZrJspJFPmj
	 9dvx+E7lYjfA/cUWUHgoCjhUx9f4JDCSdKrmNcpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.1 42/46] audit: update the mailing list in MAINTAINERS
Date: Thu, 23 Feb 2023 14:06:49 +0100
Message-Id: <20230223130433.552129343@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
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
@@ -3444,7 +3444,7 @@ F:	drivers/net/ieee802154/atusb.h
 AUDIT SUBSYSTEM
 M:	Paul Moore <paul@paul-moore.com>
 M:	Eric Paris <eparis@redhat.com>
-L:	linux-audit@redhat.com (moderated for non-subscribers)
+L:	audit@vger.kernel.org
 S:	Supported
 W:	https://github.com/linux-audit
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/audit.git


