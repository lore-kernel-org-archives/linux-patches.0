Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1141A76A5;
	Mon, 14 Oct 2024 15:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918680; cv=none; b=nsGWvbm8w6b0NJ7oKHe8NbAdp/yU4vu2xbQ8m9dhm4C+mi3Ly3z0U3VzTkUfEy8Tydi8Uwd8iatP/ikkzGmdZXk+aPc5fgHZLS13KcpiXHhq0R58TCcB3+Uo8f/QOwMydTBbVp2nk8ZTRJP35gBzxt5UwmW3iq/9Z8ECyGvr+y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918680; c=relaxed/simple;
	bh=kzWrQchQZ5GetXQWEWrBdTWZ/UJfBsM+ZUEYEAZe9HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZURPsuDQjoCbowvLaaJoDzUNSqiVw6MQ0BZZbAfnhmbaSlAwXb2DNkVf0GmrNUQjztCD9v7TsTbcfMmOetifQiraqtV85PWqi4xVYeNcTlyM91GtdgiKBfJJiILKwEYz6hGJ3lirQpyzs6RpFr3jlg6qoA5q9Y0fIEWGM0/jR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyp7ebwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyp7ebwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCC9C4CEC3;
	Mon, 14 Oct 2024 15:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918680;
	bh=kzWrQchQZ5GetXQWEWrBdTWZ/UJfBsM+ZUEYEAZe9HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyp7ebwFssImDZ0ckNLf0wLPLHItJvFq8YzaLbNT4SIW26Yg7M8RNJOycdGuOP1Nl
	 iNnYJVEdg0KbsymKfJjGotRP8vqfPIpusbq8XLhwhqLuUMtpY/sTP1jhHZjxaXKP5n
	 x57RckByR0nJTQFoe7flNdl9mqIc2fU7n2jr9SFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 390/798] netfilter: uapi: NFTA_FLOWTABLE_HOOK is NLA_NESTED
Date: Mon, 14 Oct 2024 16:15:44 +0200
Message-ID: <20241014141233.267725650@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 76f1ed087b562a469f2153076f179854b749c09a ]

Fix the comment which incorrectly defines it as NLA_U32.

Fixes: 3b49e2e94e6e ("netfilter: nf_tables: add flow table netlink frontend")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 672b2e1b47f24..557d57671cb51 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1642,7 +1642,7 @@ enum nft_flowtable_flags {
  *
  * @NFTA_FLOWTABLE_TABLE: name of the table containing the expression (NLA_STRING)
  * @NFTA_FLOWTABLE_NAME: name of this flow table (NLA_STRING)
- * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration(NLA_U32)
+ * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration (NLA_NESTED)
  * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
  * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
  * @NFTA_FLOWTABLE_FLAGS: flags (NLA_U32)
-- 
2.43.0



