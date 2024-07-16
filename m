Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD497F9E8;
	Tue, 16 Jul 2024 15:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144645; cv=none; b=SvZASAENNY9c9Bl8F1nLoVy0uHS4v9m4NYePWA1+1rdvdcjOopYTE9gXgmTJ331wIJ1/XWfkUN6yIGCiqBGIXEtw45xr4xkBehhH8qD2SO+gkuWb09UvEZ/sUUvITE+6NEa6H7Sv8icksWlbxd9Ks2mh/5PhEraFgB399aYt3Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144645; c=relaxed/simple;
	bh=NlzpLpyQPqFZwmwkVDBVQps/+8GZtXs6jlhGp20Q0u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dF08Y4LSROBNwi4+tGmMjHvnjAHgK38zPxSnetxpOw9hrdG6UsTaUtTKNpCih5r5/agHfYTH1HI/zeTU9aG1nck4IIIT4N+Gg+TN9+F4WZD3iXi6bVqsc49Eca9XkDN/vlA0viTFE6R/uHyF6oUxjuppnUdYLQS5CmKqQTeQgJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZL9TMxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZL9TMxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43356C116B1;
	Tue, 16 Jul 2024 15:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144645;
	bh=NlzpLpyQPqFZwmwkVDBVQps/+8GZtXs6jlhGp20Q0u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZL9TMxtEUlFSjiizP25Z4sBauBhi/kG4lJJ0iPAXzAacbU5NVZrbV0KpBOXaBOBj
	 p79BZHvnOUCPKRmr0yeEsxfYoKebX4X4Lb5IB1/hTTEJaUY7o0mA4B7Dd7KwVt4M0Z
	 H9KiHQXwEHMw6g1QA3AUQQmQx5N873eijAAafkAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Xiaochun Lu <xiaochun.lu@bytedance.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/108] selftests: make order checking verbose in msg_zerocopy selftest
Date: Tue, 16 Jul 2024 17:30:47 +0200
Message-ID: <20240716152747.231551288@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijian Zhang <zijianzhang@bytedance.com>

[ Upstream commit 7d6d8f0c8b700c9493f2839abccb6d29028b4219 ]

We find that when lock debugging is on, notifications may not come in
order. Thus, we have order checking outputs managed by cfg_verbose, to
avoid too many outputs in this case.

Fixes: 07b65c5b31ce ("test: add msg_zerocopy test")
Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
Signed-off-by: Xiaochun Lu <xiaochun.lu@bytedance.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20240701225349.3395580-3-zijianzhang@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/msg_zerocopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/msg_zerocopy.c b/tools/testing/selftests/net/msg_zerocopy.c
index 926556febc83c..7ea5fb28c93db 100644
--- a/tools/testing/selftests/net/msg_zerocopy.c
+++ b/tools/testing/selftests/net/msg_zerocopy.c
@@ -438,7 +438,7 @@ static bool do_recv_completion(int fd, int domain)
 	/* Detect notification gaps. These should not happen often, if at all.
 	 * Gaps can occur due to drops, reordering and retransmissions.
 	 */
-	if (lo != next_completion)
+	if (cfg_verbose && lo != next_completion)
 		fprintf(stderr, "gap: %u..%u does not append to %u\n",
 			lo, hi, next_completion);
 	next_completion = hi + 1;
-- 
2.43.0



