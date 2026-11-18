Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035595;
	b=teJ1p3PDlwj4CxSkyUYR/n6zqcpd/ZUsqTaTHJhOA9f24VWBBUgdXIIJjpMsObkMwoc8
	 XzMvFxy4ejKXKvxuKfdiQChLvcARNBbHI1j30MPWnw+I+3ZegKujzOOyVRnBdxkIonMvF
	 WSTYWJYFdClLAf2LacDe9H/PvyorYpGl09i05Db9cIU9GLuw5p4S171Kq/ZQ2OHcQVyLS
	 Be6OrtCqx9DObsl/uGVWnrMx1wkCtr1cAoGS8i0XHO0NnZRPwlnJEa9d+6bGTgsAHO49S
	 opaaeJ6f23JIwKLs6jruEtsYVoijP3AL3tJyZg6FX8BS3W8my0OyzjOqUead6Omz6QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DoKhLLG3vGneUkynl8L5Jgqt3MCWO7QN5/E6HOWy7dM=;
	b=vBpo2hEywV3ptX2rEJN9u5dcv1ChgbbRe3WI40Qv0H6xjrFr6wXcNg07MfCHKF8c4FLM
	 J7vmZYKKvqqqFCiu8M+KC0PHbVSUOE18vvvUi4T0AvM5TIMHGDdp2OglPOYQJznAU121w
	 7WDL0SLTgqMBclKGonxlHM3Jk+Zp0IQj97jyZFHLoJFW9jIZ3NO/9OZJXMqT9nTAeLrN3
	 MzcuDeGmiMP5mKecfL+XCNZBgorTaWHpMJ9qBh4wExZEtiTtzPMIFqNRQireSCaENiDjY
	 T3zu5bQsER65wK5qyp9tudojVSMpD7viOK7tjNAcS96mEDHZxj/CVTQhvzI+iUEUXPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="poOE3b//";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8455D606A320;
	Wed, 18 Nov 2026 20:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=poOE3b//
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60701F000C4;
	Wed, 18 Nov 2026 20:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035595;
	bh=DoKhLLG3vGneUkynl8L5Jgqt3MCWO7QN5/E6HOWy7dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=poOE3b//EQ/uPgYT30paZVgDH2OBojWYDOBxmDmGVuQqcYC62QkHFR2WFDOpRZLM6
	 6tT+U5ID88iruQGDzE8od2ulNJRtcg+t/fBRXvwAfK+6C4W1eYpbFGxLSHU+yJug4k
	 uVcvSXk8U/mmQsduc8DE57ZLR2pAVww52kea/jR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Zachariah Mithani (AploSec)" <zachariah@aplosai.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0761/3318] ksmbd: prevent share root removal through empty paths
Date: Wed, 18 Nov 2026 15:23:03 +0100
Message-ID: <20261118150341.537798731@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 9fd1fcbbf84986a7bcf601a2b90540899069d263 ]

A FileLinkInformation request can supply "/" as the new link name.
smb2_get_name() strips the trailing slash and passes an empty string to
ksmbd_vfs_kern_path_start_removing().

ksmbd_vfs_path_lookup() resolves an empty pathname as the configured share
path, without LOOKUP_BENEATH. With ReplaceIfExists set, smb2_create_link()
can therefore remove the share root from its parent before link creation
fails. An authenticated client with a writable share and DELETE access to
a file can trigger this if the share root is empty and the mapped user
has write and search permission on its parent directory.

Return -EINVAL for empty pathnames when for_remove is set, before
resolving the share path or acquiring removal resources. Ordinary lookups
continue to accept empty pathnames for opening the share root.

Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and ->d_name")
Cc: stable@vger.kernel.org
Reported-by: Zachariah Mithani (AploSec) <zachariah@aplosai.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Moved the empty-path check from the shared lookup helper to smb2_create_link() because the helper lacks for_remove. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 52142a08f9683..8bd4e2c1e12d6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6303,6 +6303,12 @@ static int smb2_create_link(struct ksmbd_work *work,
 		goto out;
 	}
 
+	/* The share root must never be removed. */
+	if (link_name[0] == '\0') {
+		rc = -EINVAL;
+		goto out;
+	}
+
 	ksmbd_debug(SMB, "link name is %s\n", link_name);
 	target_name = file_path(filp, pathname, PATH_MAX);
 	if (IS_ERR(target_name)) {
-- 
2.53.0



