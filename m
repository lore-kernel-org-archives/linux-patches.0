Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3506261B9E;
	Sat, 30 May 2026 17:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163682; cv=none; b=Umdy6MGhO9kFbQ42jWTyl3VZbV4CIsLo42mQeynIB+QQQDdkR7s3fEQB5nIC1gB/nM5Pqb8fY38Z0DhF4c/dcTy8ed6HGHP9jcC5Tucf4IYuVzx6UN+cFpsTZjRgWET7M+DD9WH5Hjf8idV84CHV/PJ8oze65BGMb/a0BYulq/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163682; c=relaxed/simple;
	bh=gMava9Zm8yXFd4Yldli0sbk4myw+SrxQV2+gPStF0sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9KyhQiJtVpqwfczHi7qfoYCfJTM4Z+q5blHe4Ur1SHefs9xuUpsuehr1yINVN92Mhe/5XstIeHkf4Ih8elTsnsCoNBQjzE/EBBo0Eaqm/ur2el7/BhAWKBOXnzAtXL3qX3/LekP4KcPsf0q7ALt2JWspRJP/uuw9XU004eQ/tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sz/al5Sj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sz/al5Sj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BA71F00893;
	Sat, 30 May 2026 17:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163681;
	bh=mdrc1G2asQT3iRPDXxwvMYOaL16Ys8tLS5tmGGHUbsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sz/al5Sj2jGqQy+D8GhYlltDhVHGMwnYPKQdGTGrHOzUn5gunBfZfQWE743+crwOY
	 devOxpCVo17lovQXVV6r0ndD+wspAs5vmJIr37Q0FSI31gwerJWMFhdDuUEP3aPXxr
	 b/4YBYeH+0WGj249Rkrm8uNLe0RJTpA+lXhgSk70=
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
Subject: [PATCH 5.15 301/776] xfrm: provide message size for XFRM_MSG_MAPPING
Date: Sat, 30 May 2026 18:00:15 +0200
Message-ID: <20260530160248.343907271@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2826,6 +2826,7 @@ const int xfrm_msg_min[XFRM_NR_MSGTYPES]
 	[XFRM_MSG_GETSADINFO  - XFRM_MSG_BASE] = sizeof(u32),
 	[XFRM_MSG_NEWSPDINFO  - XFRM_MSG_BASE] = sizeof(u32),
 	[XFRM_MSG_GETSPDINFO  - XFRM_MSG_BASE] = sizeof(u32),
+	[XFRM_MSG_MAPPING     - XFRM_MSG_BASE] = XMSGSIZE(xfrm_user_mapping),
 	[XFRM_MSG_SETDEFAULT  - XFRM_MSG_BASE] = XMSGSIZE(xfrm_userpolicy_default),
 	[XFRM_MSG_GETDEFAULT  - XFRM_MSG_BASE] = XMSGSIZE(xfrm_userpolicy_default),
 };


