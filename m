Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110D2DF53
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9AAC4339C;
	Mon, 15 May 2023 16:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168756;
	bh=+UNjsZf7xSoMA0b4vk92VZpnzERx3koPDWnZB8LYeNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gDXxTJ5V9GXANcz9AhLKfnQ1Ps3g6kOHlfJl0Gz6Uq3+vgiISfyz/q8StsDPSj3P
	 3djREXzcR17Ph0fqo1719BDbRY5GU6nXuFl4bEqkgT/+dLBNyQt4Q/nMFPJlELo4gZ
	 Gfe6zL1kVOxEMkwvpYB0jsUOjn17COW4OnwgvPZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 024/191] selinux: ensure av_permissions.h is built when needed
Date: Mon, 15 May 2023 18:24:21 +0200
Message-Id: <20230515161708.066273271@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
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
index 3efb0dda95b55..08ba8ca81d403 100644
--- a/security/selinux/Makefile
+++ b/security/selinux/Makefile
@@ -22,5 +22,5 @@ quiet_cmd_flask = GEN     $(obj)/flask.h $(obj)/av_permissions.h
       cmd_flask = $< $(obj)/flask.h $(obj)/av_permissions.h
 
 targets += flask.h av_permissions.h
-$(obj)/flask.h: scripts/selinux/genheaders/genheaders FORCE
+$(obj)/flask.h $(obj)/av_permissions.h &: scripts/selinux/genheaders/genheaders FORCE
 	$(call if_changed,flask)
-- 
2.39.2



