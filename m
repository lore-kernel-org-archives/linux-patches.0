Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D362AD58;
	Wed, 19 Jun 2024 13:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803025; cv=none; b=EvBn+POXMBXAQ0GoayJm00wVcEGwgfbxKGvi0TIeM8diuYb5YMaLGcD/OBMsTJtJk+U4U99ZuqheKc4jJ6OQYZBSuFhbr+dMsSSxeBXIOGBOFipcmAn9hWZxXN2xNOlJLC47G6LUVgQBiVKBxhH7nu/saPaQRBMQHe3pQHbdk3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803025; c=relaxed/simple;
	bh=3QwCABTARHq2W5IvndfRtik+OeC9Tx+VsCUzu7rL+cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTaruHrkfWoF3VsjyaSwoD5vOaNsGL3coYF8rBBTv63iG7WpfNGsnspy8HL895NVea7iMb2sy8EQQ5xzQmEz+lKLZI6ynoDBG2nVnMnfu8JdUqE2HgWHy/Ia/xGddQJVO4AO5GpBFqpBZ+Frp7Cd6Gv1aWBNOuyLxNfIYEBTHDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zdeWPRso; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zdeWPRso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7048C2BBFC;
	Wed, 19 Jun 2024 13:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803025;
	bh=3QwCABTARHq2W5IvndfRtik+OeC9Tx+VsCUzu7rL+cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zdeWPRsoTU50ChvGtF0JOEeeRPuNO3zj1oSEJEKcVxXDP7TKQGPYDJDSgl1RrR+Xb
	 SirXA8GRy5RKN9MI4Nsr1nCLHQRAsWIZOijkwnJ9OtjxJAYIoHGIfurLx96v2i7UQ4
	 Kj5aaOUubdcGKmtlA3XI3WjsbUbie32wQIJVc8Rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 110/281] cachefiles: add output string to cachefiles_obj_[get|put]_ondemand_fd
Date: Wed, 19 Jun 2024 14:54:29 +0200
Message-ID: <20240619125614.082408905@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit cc5ac966f26193ab185cc43d64d9f1ae998ccb6e ]

This lets us see the correct trace output.

Fixes: c8383054506c ("cachefiles: notify the user daemon when looking up cookie")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240522114308.2402121-2-libaokun@huaweicloud.com
Acked-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/cachefiles.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/cachefiles.h b/include/trace/events/cachefiles.h
index cf4b98b9a9edc..e3213af847cdf 100644
--- a/include/trace/events/cachefiles.h
+++ b/include/trace/events/cachefiles.h
@@ -127,7 +127,9 @@ enum cachefiles_error_trace {
 	EM(cachefiles_obj_see_lookup_cookie,	"SEE lookup_cookie")	\
 	EM(cachefiles_obj_see_lookup_failed,	"SEE lookup_failed")	\
 	EM(cachefiles_obj_see_withdraw_cookie,	"SEE withdraw_cookie")	\
-	E_(cachefiles_obj_see_withdrawal,	"SEE withdrawal")
+	EM(cachefiles_obj_see_withdrawal,	"SEE withdrawal")	\
+	EM(cachefiles_obj_get_ondemand_fd,      "GET ondemand_fd")	\
+	E_(cachefiles_obj_put_ondemand_fd,      "PUT ondemand_fd")
 
 #define cachefiles_coherency_traces					\
 	EM(cachefiles_coherency_check_aux,	"BAD aux ")		\
-- 
2.43.0



