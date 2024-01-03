Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026E71BDEC;
	Wed,  3 Jan 2024 17:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="syAqj9Bh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EDBC433C7;
	Wed,  3 Jan 2024 17:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301970;
	bh=xB3JehLrx/YneE5raav/OWuJUBXdLX+y3O/0AIe1Tbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=syAqj9BhrNH2uMpQmIBBKbIUsMPSkw9BFu33N1ryuboSzTIom8uPs5MgIvxy+xkIz
	 fl8pKjkRCqSceRIOp88t7z4G35Bmc0kRvKXYLh4zrRZyeQvTK+mZb/2ScnsmDQswYS
	 Fv8d0N29Fuyu8zU2AtHaNzXlFyhZLoxhf0yJdO+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng-Han Wu <hank20010209@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 01/49] ksmbd: Remove unused field in ksmbd_user struct
Date: Wed,  3 Jan 2024 17:55:21 +0100
Message-ID: <20240103164835.183604549@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
References: <20240103164834.970234661@linuxfoundation.org>
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

From: Cheng-Han Wu <hank20010209@gmail.com>

[ Upstream commit eacc655e18d1dec9b50660d16a1ddeeb4d6c48f2 ]

fs/smb/server/mgmt/user_config.h:21: Remove the unused field 'failed_login_count' from the ksmbd_user struct.

Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/user_config.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/server/mgmt/user_config.h b/fs/smb/server/mgmt/user_config.h
index 6a44109617f14..e068a19fd9049 100644
--- a/fs/smb/server/mgmt/user_config.h
+++ b/fs/smb/server/mgmt/user_config.h
@@ -18,7 +18,6 @@ struct ksmbd_user {
 
 	size_t			passkey_sz;
 	char			*passkey;
-	unsigned int		failed_login_count;
 };
 
 static inline bool user_guest(struct ksmbd_user *user)
-- 
2.43.0



