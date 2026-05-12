Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29EE3EDE70;
	Tue, 12 May 2026 17:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608379; cv=none; b=NS82ccJsltZZRCwY6XMUZLWrzHqqo1IYH0bjRzVeKU7Akylw+Q1srNmVV5CdU4hp7cqe12X81PT5W6WLsBmbq0TCD0NQAXlKYzCHKV9SCNjgyBDGQcNVjFG1NCrFsygnewrYu+HizbkGiZNZ2NRSFEL/w2ajl1EFMBoI9xwK7NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608379; c=relaxed/simple;
	bh=hUljUSIK3nq6A/LgXbPMF3E4NPO0EKI7sd91NNtQyTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uynIPw49zUnH02ORUE9lB6hbq2qDuSxX8iGuJstMAA2lkiHnYYWN4EmaZdRJ4bwgguzPsZYLo0BZag3d5sqOWN2bWwoe7Q84XRcDb57P/bqqw92Zlsd1K3aHrttc1y6Z4BUnPxs/Oab3buQeaSQ8QvYOxFPVOtkkl6J1VoSnxxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lg5O4kmI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lg5O4kmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D72AC2BCB0;
	Tue, 12 May 2026 17:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608378;
	bh=hUljUSIK3nq6A/LgXbPMF3E4NPO0EKI7sd91NNtQyTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lg5O4kmIPx+WM+cNujOHwYQRslH3CXQxBvl6mNHkq9nb0D/yV/dp856GM/Figihf0
	 joJdVcK/nrV6NJ9GebjKmjSJB4vqm3pd1wMIUlHAaLQN5/POprv7WICy7Hh8nGc8Ry
	 iMY7CWUK27fXfO514+VX8FQPAUCno4L2QBJbK4+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ruijie Li <ruijieli51@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.18 056/270] xfrm: provide message size for XFRM_MSG_MAPPING
Date: Tue, 12 May 2026 19:37:37 +0200
Message-ID: <20260512173939.630773585@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruijie Li <ruijieli51@gmail.com>

commit 28465227c80fe417b4013c432be1f3737cb9f9a3 upstream.

The compat 64=>32 translation path handles XFRM_MSG_MAPPING, but
xfrm_msg_min[] does not provide the native payload size for this
message type.

Add the missing XFRM_MSG_MAPPING entry so compat translation can size
and translate mapping notifications correctly.

Fixes: 5461fc0c8d9f ("xfrm/compat: Add 64=>32-bit messages translator")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Ruijie Li <ruijieli51@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3314,6 +3314,7 @@ const int xfrm_msg_min[XFRM_NR_MSGTYPES]
 	[XFRM_MSG_GETSADINFO  - XFRM_MSG_BASE] = sizeof(u32),
 	[XFRM_MSG_NEWSPDINFO  - XFRM_MSG_BASE] = sizeof(u32),
 	[XFRM_MSG_GETSPDINFO  - XFRM_MSG_BASE] = sizeof(u32),
+	[XFRM_MSG_MAPPING     - XFRM_MSG_BASE] = XMSGSIZE(xfrm_user_mapping),
 	[XFRM_MSG_SETDEFAULT  - XFRM_MSG_BASE] = XMSGSIZE(xfrm_userpolicy_default),
 	[XFRM_MSG_GETDEFAULT  - XFRM_MSG_BASE] = XMSGSIZE(xfrm_userpolicy_default),
 };


