Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033268;
	b=Mo49rysAPAfHU1JCIcTicZgZog51YfNQES8vHm9yseScg7R3M22PH7ddg8Dz+fxQAkFf
	 jiTC/Iurq3sFfWjAAMijbUCsipkET2yMHJZ55dGcnvlrOGsluUBBEIyWZGzUid9DxjPau
	 aOQbNQr9BPY2OVjdOvpXjDjP27eZZtJBTnpkLTbuGfw5tGFm8dDay8ppknM38iSTjQQZ9
	 vLiPNzX/9xloXD4xI1qloLnA+jFXW0BtVxLUcVsbgNC1g3puyRfuIVuExS9ZuSHfcxqSp
	 RCxKqrIbcVQta/pI61mB/+kYRjst6WbSa5ISNww7pvx5Oebdt3f2ZGkgwrffYZOC/hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033268;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ICH339zJUdIaPQs3esKbkFlrOIaI3iq+9pAmbfEyrQA=;
	b=zY3UHWtpuEguojkYzkZz/NvB2TS026ayhBaaZBPsNgnPmBMIeO/icXgfhbGVtgnPHz5Z
	 lopQzkMDowhAxP2ptMXtZR8ZYXVpQgSNl5AV0aFhb8CnqH23kSvyuM7jfp3OyJrcQaxLb
	 X4yl1i2GX63sbWlta69h+e6aazqFI4MDheGUvBxH6s9m/kfivROHSVwBBhbqv7qmj8gor
	 7MZxuyRiT1f1idZWSrKIUbi0TgE5rLez+GiYdWrpcA6+ftp6Mf5e9v6jz71CXWXT5/yue
	 90X5800jZRB87Z3LMb4Xnkh2i9oemoaR9aCwk7BbwoyvX4GO4LBLZEtQGh/QuMeN9BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jWaDk3Qz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E5D606A32F;
	Wed, 18 Nov 2026 20:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jWaDk3Qz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8409A1F000C5;
	Wed, 18 Nov 2026 20:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033268;
	bh=ICH339zJUdIaPQs3esKbkFlrOIaI3iq+9pAmbfEyrQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jWaDk3QzkVwAjUtRgf+Z/tKXhkzWLApQl1QD+SyPM3snM9QmyDAJL7A1RrAoL8TTF
	 KF1159uDD9yxSsxq7WFW01YMSECSbv78jId9wx5BDZIczxrIlHQU2BfxwaIqvCDkXO
	 Y7NU0RrdApWeOFnmXEpZ9FJxfxS1lQLZ75qyw6W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1709/1756] apparmor: advertise that sctp is being mediated
Date: Wed, 18 Nov 2026 16:03:56 +0100
Message-ID: <20261118150117.662505548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 35b8ab3f36ac0fcd8fc910da0bed889b6c75c426 ]

Enable the test harness to detect that the kernel should be properly
mediating sctp.

Fixes: 7a82f9a06459f ("apparmor: fix check SCTP bind, and connect permission checks")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/apparmor/net.c b/security/apparmor/net.c
index 6e989184e4086..662a1b58d7d72 100644
--- a/security/apparmor/net.c
+++ b/security/apparmor/net.c
@@ -22,6 +22,7 @@
 struct aa_sfs_entry aa_sfs_entry_network[] = {
 	AA_SFS_FILE_STRING("af_mask",	AA_SFS_AF_MASK),
 	AA_SFS_FILE_BOOLEAN("tcp-fast-open",		1),
+	AA_SFS_FILE_BOOLEAN("sctp",		1),
 	{ }
 };
 
-- 
2.53.0



