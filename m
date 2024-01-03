Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C241BDF1;
	Wed,  3 Jan 2024 17:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2A4a+CV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7733C433C7;
	Wed,  3 Jan 2024 17:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301677;
	bh=m3efA7YfqUcQrbPdhhJiyAsA65OQsjZjOcJW2k5bEWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K2A4a+CVqbi0GoFVeMi8w+EoKCQlSyW3F5hbH8TtC+8ACIWm1Ex9+cbq5L2tPwA3l
	 qje5zUf9zKYAjQ9PSspu0DRrnh/qGTMDfM9NSjxmnkxcVsFFlUjwYXAtQ+fOA3B0Hh
	 977wnbIdyIRPQMXTO8KC99/JIkjN63A2gKpbJ40Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 66/95] ksmbd: have a dependency on cifs ARC4
Date: Wed,  3 Jan 2024 17:55:14 +0100
Message-ID: <20240103164903.899925729@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

Omitted the change that has a dependency on cifs ARC4 from backporting
commit f9929ef6a2a5("ksmbd: add support for key exchange").
This patch make ksmbd have a dependeny on cifs ARC4.

Fixes: c5049d2d73b2 ("ksmbd: add support for key exchange")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index a6313a969bc5f..971339ecc1a2b 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -369,8 +369,8 @@ source "fs/ksmbd/Kconfig"
 
 config SMBFS_COMMON
 	tristate
-	default y if CIFS=y
-	default m if CIFS=m
+	default y if CIFS=y || SMB_SERVER=y
+	default m if CIFS=m || SMB_SERVER=m
 
 source "fs/coda/Kconfig"
 source "fs/afs/Kconfig"
-- 
2.43.0



