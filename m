Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830964;
	b=5HBU5zxGbXGeKT+CXjSTlISJ8YZCLqnlfx7G2XFysxqQok89oneaMi/iGeo7bdzUnsBV
	 d8bpALh0gEJZK/YJsvgoqaNvo6rnIFpILai/mAiXOy2U9h0MLh51pCBe+0RU1jd/ay74W
	 SjFnTQDpRXxeHzyLNkuzmFH+E+LNScr3txPX4EXQ5rp7doNis+3Dx5+VGE5A+PoVxzigR
	 ESrxNKRLak/OaCEnfY2hj9EpxVH/xMT1c07hARGD8LLYPRkDXlddGl2PHnyBqAHDnciuI
	 /FUrUN+7Otn0SYYNR+WjWSclCbZkemKJ8ZpBtjlob4n9A80pwMICc9OVI/wnZkjbW7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PTWQAMXZZZw9m/yizK+APc6QKZZn6fpJpfF0rsOkw3w=;
	b=nFaKtPNQktSraq14GOHhP0a4KkMjAKwjksM6ZzADYHrKnydJB1NSJVjQ4k7qybw+aZ/+
	 PsHYLC9N3vi68GdGC4Cx9KkWEHWKZL/p1L6qareNVT2MIvwYvD/S+ycO/l+Mi+2JHA6hD
	 kNQHctjLoTflIbcCOUHY9eDrWZGTUKYdMYIeRyA0eu9RxiP7K8nqOjFwpEK390RG2RDym
	 6nr3EpP4mUmgjq2Y0jE4ypoDXLXzqpkzB6JfT9MaCEEg7o8BeH2G7BhvAjKPBaRNlCWPG
	 zMl0c7BpYkba5FENdAHXq0Tuf/V5N2bVScrPVnVgWfDoKM6iXREYiX3NMyYVa35d40A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zDfyd1JP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED72606A876;
	Wed,  4 Nov 2026 22:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zDfyd1JP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C581F0093A;
	Wed,  4 Nov 2026 22:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830964;
	bh=PTWQAMXZZZw9m/yizK+APc6QKZZn6fpJpfF0rsOkw3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zDfyd1JP/NvApDOanoiCjcFK/z7yrINB5N7uUg0aGMtjZ/ceNUEJEt/w8kkzFso7c
	 4H7DFQi3Khp4rJ/m1k3AvviM/M4cApZrCI0nyMSb95ZBT8Fmz9qDkDo0wvAYUJZgxQ
	 78Z+7bvRsyYwiTQj9DJlP/MFLy4KFXb43ud5pVSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0379/1005] apparmor: fix auditing of mount binary data
Date: Wed,  4 Nov 2026 16:01:52 -0500
Message-ID: <20261104211054.712620440@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit b9f2181b90ec047488dcb4fb1c631d417aff07e0 ]

AppArmor only mediates non-binary mount data, and should only
audit the mount data if it is non-binary.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/mount.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/mount.c b/security/apparmor/mount.c
index 2f5d918832c10..31f792817643c 100644
--- a/security/apparmor/mount.c
+++ b/security/apparmor/mount.c
@@ -344,8 +344,8 @@ static int match_mnt_path_str(const struct cred *subj_cred,
 
 audit:
 	return audit_mount(subj_cred, profile, OP_MOUNT, mntpnt, devname,
-			   type, NULL,
-			   flags, data, AA_MAY_MOUNT, &perms, info, error);
+			   type, NULL, flags, !binary ? data : NULL,
+			   AA_MAY_MOUNT, &perms, info, error);
 }
 
 /**
-- 
2.53.0



