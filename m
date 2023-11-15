Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D73433C1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19nX1Y3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846CBC433C7;
	Wed, 15 Nov 2023 19:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077071;
	bh=jMhnQDDP1/17ilzD2T0aj5JKf8eSPqq9hyJJX2mGOJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19nX1Y3L3NrVkZxOXzK/fGK1CwrD1WnUfEhvnPsJI5Q2f85ms66R3bDFFzxtjgLun
	 FwYF8aZobPqihEXFDNOElzCmu1DjgJ0yEIYcoTcCcRGkqVjHfOATL4NuloMIOIgxmw
	 wlt6IWvfeiua8v20W6AX4dE2kwJHT+rOlOkqE2KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	wenxu <wenxu@ucloud.cn>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 503/550] inet: shrink struct flowi_common
Date: Wed, 15 Nov 2023 14:18:07 -0500
Message-ID: <20231115191635.784442221@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1726483b79a72e0150734d5367e4a0238bf8fcff ]

I am looking at syzbot reports triggering kernel stack overflows
involving a cascade of ipvlan devices.

We can save 8 bytes in struct flowi_common.

This patch alone will not fix the issue, but is a start.

Fixes: 24ba14406c5c ("route: Add multipath_hash in flowi_common to make user-define hash")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: wenxu <wenxu@ucloud.cn>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20231025141037.3448203-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/flow.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/flow.h b/include/net/flow.h
index 7f0adda3bf2fe..335bbc52171c1 100644
--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -40,8 +40,8 @@ struct flowi_common {
 #define FLOWI_FLAG_KNOWN_NH		0x02
 	__u32	flowic_secid;
 	kuid_t  flowic_uid;
-	struct flowi_tunnel flowic_tun_key;
 	__u32		flowic_multipath_hash;
+	struct flowi_tunnel flowic_tun_key;
 };
 
 union flowi_uli {
-- 
2.42.0



