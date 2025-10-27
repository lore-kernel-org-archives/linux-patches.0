Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F83F32A3D8;
	Mon, 27 Oct 2025 18:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590816; cv=none; b=ap+1NvfMXwV7eNByshlibfzapDOzd7DvV8J/NpSKCAO3JH3SiH0MFqCesBQHHxLmtKM9sqAjOi95oGchXF8xGsFuaWDanKNJ0uopyPqqXh9VjZfeJxG+b/7gS8/GvXTZoK7HXaBZ4pNMT7gKPntCNLKtRYikzUjxCah4ckvbHco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590816; c=relaxed/simple;
	bh=7w7xEdI3iVWojr+NKs9aH91j0nmOnVJTAk4R0603qLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8oeKMlZfL0CbTJL04qtOOh2O/h8NncwW2v2peWZu5Zdslj1j6mbo3ystd7qpjZd5flLM9YuD6EM3ZbYN8g9Q0h0aJVkGlKVJBG8qCWxUvwBuJvypHGC2LDTtjpfq9ShRL04ub3zPK5B2Jx4R1FlhgVUmYoY4XddeJlB/q1RoHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPiu4BkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPiu4BkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31A5C4CEF1;
	Mon, 27 Oct 2025 18:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590815;
	bh=7w7xEdI3iVWojr+NKs9aH91j0nmOnVJTAk4R0603qLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPiu4BkY8E8tWG6gFvKk+o9VzElhKxCjFuUB9wvl5sV8/JQKGbGx4+hhgUW4ntkkh
	 ZTmsViejCCigFWopyXLM+jY6WUEqo3Iql7RWKXZiW2Ec3BcTAIxBdI4sksSPdT9EUz
	 ZG1NoSJwLH//mI/e+R+9hCnQ+5TbmGr6V+t48qws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 185/224] net: rtnetlink: use BIT for flag values
Date: Mon, 27 Oct 2025 19:35:31 +0100
Message-ID: <20251027183513.797781557@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 0569e31f1bc2f50613ba4c219f3ecc0d1174d841 ]

Use BIT to define flag values.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bf29555f5bdc ("rtnetlink: Allow deleting FDB entries in user namespace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rtnetlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 02b0636a4523d..030fc7eef7401 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -10,7 +10,7 @@ typedef int (*rtnl_doit_func)(struct sk_buff *, struct nlmsghdr *,
 typedef int (*rtnl_dumpit_func)(struct sk_buff *, struct netlink_callback *);
 
 enum rtnl_link_flags {
-	RTNL_FLAG_DOIT_UNLOCKED = 1,
+	RTNL_FLAG_DOIT_UNLOCKED = BIT(0),
 };
 
 enum rtnl_kinds {
-- 
2.51.0



