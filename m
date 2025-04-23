Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32988281352;
	Wed, 23 Apr 2025 14:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419774; cv=none; b=ABrYnL3/fwZdpCA7ErbpklRM5PoKo2sF43PUWWmFb81Urr3BcHDJj9SHA1mDSQoqW11wwnszV+5UzKoo4t35uUjvEO6h6BXbU55Zrl5R2kdLtBEyz4/fIGvYzekJSfJ+/zYd5pHqiiBmEx8+5ow1avLURGZ2pC9r97P9LBazIXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419774; c=relaxed/simple;
	bh=nAqEUcJBIFAzfZC0zy6nVh3nShBr6Cid38P2/AQRZWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqx55n34uc04poI53NzIyR32I5gTq2yV9oANuOrLu2hgfK14X9/3HKfmoON+wPtRCL4e0K3wGHQFrbe+4DbGTMM6MSMIY6PnWkGNDlLW9k5WZpC/nCP+15oamwmzX8p/KuDcFcVSEm0mk4ky28+dQ7Ll/EBR6KfepW3wXpa9QYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKzzH8As; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKzzH8As"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9DAC4CEE2;
	Wed, 23 Apr 2025 14:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419774;
	bh=nAqEUcJBIFAzfZC0zy6nVh3nShBr6Cid38P2/AQRZWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zKzzH8AsyuFqlkYrw0rRftHFI2LEpOKFl1Fai3AIQ0y7jGqlGh5EoW4nkgvBcT2xa
	 iUVbHW2tTTSyAVDlQ6M6A+/vA6LT4Mq7SC9NEh5qUjTtrrgs8rRiP/H3c6EufDtF6k
	 Izl0/zjZhKhlNMnxoDUyliXKiJbW4dSe9jusdr50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/223] netlink: specs: rt-link: adjust mctp attribute naming
Date: Wed, 23 Apr 2025 16:42:11 +0200
Message-ID: <20250423142619.541858566@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit beb3c5ad8829b52057f48a776a9d9558b98c157f ]

MCTP attribute naming is inconsistent. In C we have:
    IFLA_MCTP_NET,
    IFLA_MCTP_PHYS_BINDING,
         ^^^^

but in YAML:
    - mctp-net
    - phys-binding
      ^
       no "mctp"

It's unclear whether the "mctp" part of the name is supposed
to be a prefix or part of attribute name. Make it a prefix,
seems cleaner, even tho technically phys-binding was added later.

Fixes: b2f63d904e72 ("doc/netlink: Add spec for rt link messages")
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250414211851.602096-8-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/rt_link.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/rt_link.yaml b/Documentation/netlink/specs/rt_link.yaml
index 11d9abec99bc0..a048fc30389d6 100644
--- a/Documentation/netlink/specs/rt_link.yaml
+++ b/Documentation/netlink/specs/rt_link.yaml
@@ -2077,9 +2077,10 @@ attribute-sets:
         type: u32
   -
     name: mctp-attrs
+    name-prefix: ifla-mctp-
     attributes:
       -
-        name: mctp-net
+        name: net
         type: u32
   -
     name: stats-attrs
-- 
2.39.5



