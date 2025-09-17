Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402343233FC;
	Wed, 17 Sep 2025 12:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113407; cv=none; b=epC1ALlLiE4GRzu/xnvS37fCgbpQZWGnh8/BzlgPJYZuWWhJDhhcf8IXBUYMxK+2I+FRDUGcfqNcSHl6dD32eWwkNgzJTv0lR0SwtNftpishVbpOmMvkz85eUplMNKNFv0jUbRPPVzKk5mX+EK9ZNhTNkXbQFUHyf9T2nuXtKKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113407; c=relaxed/simple;
	bh=so9mJlsrQwHnYKYZX7FQjBWErhnrsuXeVRtGt61lPng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfQHcXAKgU2eR5xD+rl945lPlso53O4a//7mQzqSdiVT2YLbGnchh205Uww5/PJxcNYftvyFUDthrk39j4JjeUHaGI1At2UmqM6UUeTd4xXHTI3YnWrj8Y6TjwIa8azzeCzt9UGUiLqhJDUROPUkIJG2taU4YrFJlSqAIVlA5Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hpv1Qj3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hpv1Qj3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9D6C4CEF0;
	Wed, 17 Sep 2025 12:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113407;
	bh=so9mJlsrQwHnYKYZX7FQjBWErhnrsuXeVRtGt61lPng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hpv1Qj3lPqA4pM1M8mzLRtAVleNzfZLBnUOHhqeSxACjgQJsi2W2EJlGA6EXEvCuo
	 LsBDnBTsEJFGJZbJyBlTsRq5C/NUqRbuZch6IztYvzpCAEqRgPvswr3PhGd/25qqZ4
	 G1nmSqf/VjlNic4FzqXWLHZ603q33e2hvHmp+WCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/140] netlink: specs: mptcp: fix if-idx attribute type
Date: Wed, 17 Sep 2025 14:34:06 +0200
Message-ID: <20250917123346.120734211@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit 7094b84863e5832cb1cd9c4b9d648904775b6bd9 ]

This attribute is used as a signed number in the code in pm_netlink.c:

  nla_put_s32(skb, MPTCP_ATTR_IF_IDX, ssk->sk_bound_dev_if))

The specs should then reflect that. Note that other 'if-idx' attributes
from the same .yaml file use a signed number as well.

Fixes: bc8aeb2045e2 ("Documentation: netlink: add a YAML spec for mptcp")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250908-net-mptcp-misc-fixes-6-17-rc5-v1-1-5f2168a66079@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/netlink/specs/mptcp_pm.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/netlink/specs/mptcp_pm.yaml
+++ b/Documentation/netlink/specs/mptcp_pm.yaml
@@ -256,7 +256,7 @@ attribute-sets:
         type: u32
       -
         name: if-idx
-        type: u32
+        type: s32
       -
         name: reset-reason
         type: u32


