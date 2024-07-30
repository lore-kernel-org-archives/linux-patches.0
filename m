Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF4D1A76B9;
	Tue, 30 Jul 2024 17:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359815; cv=none; b=QMSpVRTV7RqETTajuSRUD8zs54vkkB5RrFYvsJ4hISDHnBPRpGMqrqghXnF3Z8AOnJJgS30xizZdczh8sBg4It13vcBYI7XkAV/CUttNHHXXot6dKBDW6Rbs3D+4e1MCwMBnSp1cabmbtag+LPOkuQtY7nw0Tx9N8kIicbSkDr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359815; c=relaxed/simple;
	bh=vOamrQEocojUybigbGKYDQJwuvXx43slEl/uMPXhZbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfOVbBaDurwQSbI4aTDz77eW9syWo/bVYjXKyeZE+98588zqec2PdGPSdE7/E1nu644gkHExU7/dTGC5Kxh8jcbtrhk+2TVpvH5BOQljR6I4eVcSzKAG3lI9BroRtQf6oLTPGFZ7PddBUxUFmbJgE9H/+fc9GNuA9ExYW1u+sfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnY1nQ3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnY1nQ3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBB6C32782;
	Tue, 30 Jul 2024 17:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359815;
	bh=vOamrQEocojUybigbGKYDQJwuvXx43slEl/uMPXhZbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnY1nQ3wiBvj515o4P2blxFafbIVXvL1G1Jg0HsykaAea6H7lRZwX0DJcTF/jt5OH
	 Bx+EcyeWaaY6lkdG+WN6PnLjF3ddOf0b/cQRM/ZrWY8r6wkfI6pNtmt/ViYns1502a
	 fHk12zq0EFgnCYviKDdFtQr6Hyj+SBpBPDlhdq3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 514/809] fs/ntfs3: Fix the format of the "nocase" mount option
Date: Tue, 30 Jul 2024 17:46:30 +0200
Message-ID: <20240730151745.038376232@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit d392e85fd1e8d58e460c17ca7d0d5c157848d9c1 ]

The 'nocase' option was mistakenly added as fsparam_flag_no
with the 'no' prefix, causing the case-insensitive mode to require
the 'nonocase' option to be enabled.

Fixes: a3a956c78efa ("fs/ntfs3: Add option "nocase"")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 24a134eeb45a2..02b6f51ce6503 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -275,7 +275,7 @@ static const struct fs_parameter_spec ntfs_fs_parameters[] = {
 	fsparam_flag_no("acl",			Opt_acl),
 	fsparam_string("iocharset",		Opt_iocharset),
 	fsparam_flag_no("prealloc",		Opt_prealloc),
-	fsparam_flag_no("nocase",		Opt_nocase),
+	fsparam_flag_no("case",		Opt_nocase),
 	{}
 };
 // clang-format on
-- 
2.43.0



