Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F84125B6
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEF9C433D2;
	Mon,  8 May 2023 10:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543594;
	bh=AIEDbdtkdwfgnxXgObbj/Xfv0A+aP9sTc29GPKhmA2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IaDwskWgRIXdlE43uc4iIsJeibiL6W784QMS4MGsKe6LmQBVMX64as1329Gi4aP2T
	 DsTUTfy4WQCM6AbFjpU+GA4LnQTtjuW47/L8qFT9CysaaKNb8ZrJJhpCeHsvrsGfbQ
	 SpzQlXd3/2iOxcuC7LzPqCsqNqmihWyb+Prb6J7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 139/694] selinux: ensure av_permissions.h is built when needed
Date: Mon,  8 May 2023 11:39:34 +0200
Message-Id: <20230508094436.967956368@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

[ Upstream commit 4ce1f694eb5d8ca607fed8542d32a33b4f1217a5 ]

The Makefile rule responsible for building flask.h and
av_permissions.h only lists flask.h as a target which means that
av_permissions.h is only generated when flask.h needs to be
generated.  This patch fixes this by adding av_permissions.h as a
target to the rule.

Fixes: 8753f6bec352 ("selinux: generate flask headers during kernel build")
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/selinux/Makefile b/security/selinux/Makefile
index 103c2776478a7..0aecf9334ec31 100644
--- a/security/selinux/Makefile
+++ b/security/selinux/Makefile
@@ -26,5 +26,5 @@ quiet_cmd_flask = GEN     $(obj)/flask.h $(obj)/av_permissions.h
       cmd_flask = $< $(obj)/flask.h $(obj)/av_permissions.h
 
 targets += flask.h av_permissions.h
-$(obj)/flask.h: scripts/selinux/genheaders/genheaders FORCE
+$(obj)/flask.h $(obj)/av_permissions.h &: scripts/selinux/genheaders/genheaders FORCE
 	$(call if_changed,flask)
-- 
2.39.2



