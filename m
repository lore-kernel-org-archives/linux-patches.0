Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053274;
	b=zGZ87mhOpvFQL6F7bMUI9YOyKdiRQMU5vO7grKaMza4RKBDaxWINV7UFthFP/EHwPz/P
	 xBynDv/oPzpblmykHoT3K51RjW+T0qZhEfUVaoeYpXvO8bFh3zOK+o7JrP0hsMTludjCM
	 ELfQmANy6/2oAJU2kpvVN/UEd73cDLdqqyyuhRX2DwbvVSvzn8tD5EAIQMMyZCz/L0SXt
	 eBZak6at2MiiLJ56mUQ0MjA5mJUbZlKlRt9myXKbH+TsVPo4WLSSMru6vmSUYLxLjlSgX
	 zsheSDIeJqDLaNwS+PWH6fPbzaU7yc7xikB3kcTjnUCItWveLianNWYOxs65oiYKwrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FbNUzbsQ57yZMUuVMgxSaM1w4RGZAzHGIAkBQB8K890=;
	b=myX7EpgHYZMNfgfGEgzyZ3dTpyQy3CCCym0RJ8oCSHS2peoyX6CBEsesUBWMCG/neiEv
	 pgEIr2Upe9iMpJWRdQptIFEzY9UAD765pw/z0TEIkjMhwqRIHgnj3FyHEYc1BEvaFg2U8
	 o5Fa1UiYfWbV3e01oAulrPvrf2hNHRpDRHlChzZjytQbXhXGbVANX+ZYoY2QigX5GHJ4R
	 rmDY9pmgYIUXFfaLQb02o/YHA9lOjV4jdIAKfcNC4ncoh4GwPeUxxpZzV0zPhp+vX1T3g
	 pPkKk7WtIbmGYgM5uY8JB2xzC9NKlWO5OkCL/WsGenM87LbpmiaVmCtof3tOzVLTJXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jv+k77Sg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52071606A320;
	Thu, 19 Nov 2026 01:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jv+k77Sg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE731F000C4;
	Thu, 19 Nov 2026 01:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053274;
	bh=FbNUzbsQ57yZMUuVMgxSaM1w4RGZAzHGIAkBQB8K890=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jv+k77SgwTK5j2VO/PVp2Mce6A3qsyLzVgcdvrUVLI0dAc7Zg+4A83q9afr7OJqXQ
	 0Be4veTIjORIxXrCWDF9x8jcgvZSZQXP0ggJ1nyD0ec/XpJxiILfNchz8K2/4TPxJu
	 da7Iuro5zUkOmut3Mo1JrQ/C1hy4A/OOYhHJND6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ian Bridges <icb@fastmail.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0861/2214] ksmbd: grant a POSIX ACL group entry only to the groups members
Date: Wed, 18 Nov 2026 15:42:17 +0100
Message-ID: <20261118150046.601184449@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit c00ec7ad449b68c291a4986e481941302ed399c5 ]

When no ACE of the DACL matches the caller, Everyone or Authenticated
Users, smb_check_perm_dacl() falls back to the file's POSIX ACL. It
takes the first ACL_USER or ACL_GROUP entry whose id equals the
caller's uid. For ACL_GROUP, this compares a gid with the caller's uid.
A numerical match grants the group's permissions even when the caller
is not a member.

Match a group entry only when the caller is also in the group.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Namjae Jeon <linkinjeon@kernel.org>
Closes: https://lore.kernel.org/linux-cifs/CAKYAXd93czbFD=znZUq_pJLXzDR5N3zc_auvAGWT7pzKR1f9Ag@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smbacl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index 6d5611c47c434..ed690767837fd 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -1375,7 +1375,10 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 				else
 					continue;
 
-				if (id == uid) {
+				/* A group entry grants only to the group's members */
+				if (id == uid &&
+				    (pa_entry->e_tag == ACL_USER ||
+				     in_group_p(make_kgid(&init_user_ns, id)))) {
 					mode_to_access_flags(pa_entry->e_perm,
 							     0777,
 							     &access_bits);
-- 
2.53.0



