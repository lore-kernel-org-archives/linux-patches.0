Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042715;
	b=EmC5zwQt4D+Wqg8ihxbx6AWiOofR/ptJfuy7925Wk9v0SJsbEEy11gDozTI4j9uUl/UM
	 fGKAt85Iy3uZN85QZe7t/lxPUHVLnCxjUx7upxPOq0x4upbM4HahO0in+IqFEq4RbDMcl
	 zHrFypBAdPcY2Y+lzsdIJDIE3dwPag1ZGjXdl8ORKFzK3SQjZoWzC88Cm4Il0nF0Vnq2/
	 QGceCkGLnFbYGRsxWKDd9JCLnbg7LiPRiltiN+bB4A8ups7STp1P84FvW9UxbscvpIQQY
	 WyZhyqQQLVuz+BS5d0aAGtxBDudBpamjYtGnsz0jfgicpnN1g828vSUewgte+L0AoTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7dwFqHU+UCKeryaSpka4FmVfGd6LIVOlnEnvdLM3AYM=;
	b=MJc1KSvus/gkPzow4FxHi4rBh7FOFcOp3gWW83SZbDhQKF5ai9FLlRfg3WgG/eyzKVJS
	 CS/4mUlUCoyxoUR4pf5r+133UUZ7rbLaozv4OQpJNjivnd8JxbZZeOI+2L2pVkfnKWwWu
	 MOL1rjbZOQLj/Pvhv3WE3PFPvNJoXRRMuSGqWX0sn4GrxknoRztWBG83YSSmFAAomwBRh
	 +Ic3rzRDp1SQJCIlZES9bjEaacBol3wIXXhiLxHra+MxrpeWxwmMnW//ZgBCscZ/nEiFQ
	 W9wJV0gwOI9fyAFywnh1Q5RYEr+inz9Ro8MWIL1cWQKTFuXbPcAMypbSQrRM1f+QeLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LJy0f2Ju;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA46606A320;
	Wed, 18 Nov 2026 22:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LJy0f2Ju
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004601F000C4;
	Wed, 18 Nov 2026 22:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042715;
	bh=7dwFqHU+UCKeryaSpka4FmVfGd6LIVOlnEnvdLM3AYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LJy0f2Ju1KmiZHatKGUjXif20rosbC3NtuuGNfkEyDCagjvE3ObjTL5CC7MQapMcB
	 mrHTCX6t39rfG0W7RVMHrfur1jBhtvPTxtMJPzPXR0IBrB+5k2vkTEF7vK2HBWLH82
	 QdxOLdGjZSyJx00u27dD0AaATmWMHqWt+J4RsfPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Jon Tourville <jontourville@me.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3269/3318] apparmor: advertise availability of exended perms
Date: Wed, 18 Nov 2026 16:04:51 +0100
Message-ID: <20261118150457.687445409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 180cf257998c5f136f76b8899ef6ec57b410680b ]

Userspace won't load policy using extended perms unless it knows the
kernel can handle them. Advertise that extended perms are supported in
the feature set.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Reviewed-by: Jon Tourville <jontourville@me.com>
Stable-dep-of: e667fc72f7f4 ("apparmor: convert duplicated dfa transitions to match_char()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/apparmorfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 3a14b541e44c5..725f249d294bf 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -2420,11 +2420,14 @@ static struct aa_sfs_entry aa_sfs_entry_versions[] = {
 	{ }
 };
 
+#define PERMS32STR "allow deny subtree cond kill complain prompt audit quiet hide xindex tag label"
 static struct aa_sfs_entry aa_sfs_entry_policy[] = {
 	AA_SFS_DIR("versions",			aa_sfs_entry_versions),
 	AA_SFS_FILE_BOOLEAN("set_load",		1),
 	/* number of out of band transitions supported */
 	AA_SFS_FILE_U64("outofband",		MAX_OOB_SUPPORTED),
+	AA_SFS_FILE_U64("permstable32_version",	1),
+	AA_SFS_FILE_STRING("permstable32", PERMS32STR),
 	{ }
 };
 
-- 
2.53.0



