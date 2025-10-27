Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C5C32142E;
	Mon, 27 Oct 2025 19:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591933; cv=none; b=i7H8OuZAMz/Rn+FFbEhH5hX1nyeOcWTloQV8XsAQP449ydvASGCwc1ajVF8DyWHzMIUiWP5azGwcCy/MmCFIK6zKzVnxVZ/wlEOyfFzX3ckSbeIp0zT3p8KqMtB5P6QQZyyoM7GNk8RR0ZBevXyDbk5UXduLg9CdZBppLjEMLOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591933; c=relaxed/simple;
	bh=PiaRngIUOARyCDj7IXeYoAKPgWuhahuLCeY46FIfhAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gl59l703WizD70FGOfEZmc4qAiMR5p6qp2sxZaYQwqGnCNDjY8/7Dp3QPXQbcu4IUsdxYrrMy7Tpm+2h+dSYs2JRIvzzY8tvP6aab3+y0WmyDeflPdQM985qwCNURKM12yZ/racdI7K02HBtkuIzXa47D21wWpXdTpDjTPTncfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XeFY1V7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XeFY1V7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86233C4CEF1;
	Mon, 27 Oct 2025 19:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591932;
	bh=PiaRngIUOARyCDj7IXeYoAKPgWuhahuLCeY46FIfhAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XeFY1V7CLYMOBpNm3a369QvHmorKdOAPMyneZcBnI1AZiHGIcfF2Ee8ozl/R0fv5K
	 JzFZLOA5/2iyxzZkiLPVgsib0GSbj3ATzSTft0xQofzD6IN5a2tJsVKeoGjX69MiJy
	 KWwBSBHLjJL09g1rltiHzt047wDhtvOZjt0T4+BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/123] net: rtnetlink: use BIT for flag values
Date: Mon, 27 Oct 2025 19:35:33 +0100
Message-ID: <20251027183447.815154939@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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
index d2961e2ed30bd..268eadbbaa300 100644
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



