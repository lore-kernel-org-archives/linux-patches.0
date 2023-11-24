Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50971381BF;
	Fri, 24 Nov 2023 18:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELh174Sv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A6DC433C7;
	Fri, 24 Nov 2023 18:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849975;
	bh=tV5XaAiuWqiU33L7+AXfXygLGbbdM/dxWis1XOClXEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELh174Sv4Ag/x8U71uuJ0IziybCftbK9szR0f1baQ7V8v7wh5y3oZZ6kdFeQ52s/R
	 KvxS+kD6Y3zlQUX6wCppIWSX5JZavVPwHe2pyE83QeEHZrymNPw/haJxs9awbin8jr
	 rj3Gvl8KPgEQE+e7LAhjh81yhBkcjtbvcDdccArY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 395/530] apparmor: Fix kernel-doc warnings in apparmor/audit.c
Date: Fri, 24 Nov 2023 17:49:21 +0000
Message-ID: <20231124172040.046402129@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 26c9ecb34f5f5fa43c041a220de01d7cbea97dd0 ]

Fix kernel-doc warnings:

security/apparmor/audit.c:150: warning: Function parameter or
member 'type' not described in 'aa_audit_msg'

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Stable-dep-of: 157a3537d6bc ("apparmor: Fix regression in mount mediation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/audit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/apparmor/audit.c b/security/apparmor/audit.c
index 5a7978aa4b19e..a3db0f8bd4f85 100644
--- a/security/apparmor/audit.c
+++ b/security/apparmor/audit.c
@@ -142,6 +142,7 @@ static void audit_pre(struct audit_buffer *ab, void *ca)
 
 /**
  * aa_audit_msg - Log a message to the audit subsystem
+ * @type: audit type for the message
  * @sa: audit event structure (NOT NULL)
  * @cb: optional callback fn for type specific fields (MAYBE NULL)
  */
-- 
2.42.0



