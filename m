Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7AA8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D197C433C7;
	Sun, 16 Jul 2023 20:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539167;
	bh=C3OA2v5ud/ha42/sFE14w66+xvXvrDJs91j5mmfy5UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2UEL/jrcKExd+HNz6nyXDxA1t0owxHtvSm/88lbkT/JGUhjxJgzrLkk75acFqzFTE
	 STfLSPAjF7oQxlOqm0tw4bPrmxy7L8T5Wva3nZ+36aWQ/DA6n45DJHTqYD4YD8Ml4m
	 vOqYkKhhB+sisE1abE9cUz3Hgz4rOQNljehpelL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 711/800] apparmor: add missing failure check in compute_xmatch_perms
Date: Sun, 16 Jul 2023 21:49:24 +0200
Message-ID: <20230716195005.634126215@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 6600e9f692e36e265ef0828f08337fa294bb330f ]

Add check for failure to allocate the permission table.

Fixes: caa9f579ca72 ("apparmor: isolate policy backwards compatibility to its own file")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_compat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/policy_compat.c b/security/apparmor/policy_compat.c
index cc89d1e88fb74..6fa185ce8d9dc 100644
--- a/security/apparmor/policy_compat.c
+++ b/security/apparmor/policy_compat.c
@@ -179,6 +179,8 @@ static struct aa_perms *compute_xmatch_perms(struct aa_dfa *xmatch)
 	state_count = xmatch->tables[YYTD_ID_BASE]->td_lolen;
 	/* DFAs are restricted from having a state_count of less than 2 */
 	perms = kvcalloc(state_count, sizeof(struct aa_perms), GFP_KERNEL);
+	if (!perms)
+		return NULL;
 
 	/* zero init so skip the trap state (state == 0) */
 	for (state = 1; state < state_count; state++)
-- 
2.39.2



