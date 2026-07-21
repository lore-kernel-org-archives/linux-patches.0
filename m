Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB21472F69;
	Tue, 21 Jul 2026 17:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656596; cv=none; b=uavK6zda/kaIBRHHnWyVie2cBZ/GX1WufjzLQXMQh2PHxZUX491HpWAYk2EaGAlMms4q3mNcKMV+8gJAfkNS1L3MtV821FWQ2ti7KEiZIOoAiE9xA9URYcAmdy1uhC+xfUL/uJd7qSY5nTrpAa3XxxXaTFWOpN/7zZYE7g1wPJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656596; c=relaxed/simple;
	bh=W5tLZF/hOwhlcWkdOt8WbGHTsHXOAIOcQaPQj9QhW7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaEoQAfwyB14Ns3Y3SA8SPoMKToMfh/ygQz7dDWXn1YIrWEVQ9SuyDY4PsAjyuEbEEcHWAApf7u6D2AAO+zM7FxBY5lIJ1IrWMU2bDVNEkHciJ1Fq+9WRJvbYj0VNadlGT/9GwBfy7Hv2HQEMd6lEy0yiXrQ4Mt7QNA9dL/PKVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPMdw0Ks; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPMdw0Ks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC011F000E9;
	Tue, 21 Jul 2026 17:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656595;
	bh=g3V0xv+5iOjoemOeWDtkcPGl9CUX4LUfgHGMIAHVyBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPMdw0KsJn7YTvl7XUreGqOsa65eZkIxJSpDs+lTER25lGKtyTe3tbaMzm+97FFPH
	 CIA4csICDDA3vwgoX9bW4DtLIzz0QQ2Vch0ug34ktgrcBkZboom3BzgetBRTbQekj7
	 yk3ezBG1kEYEZ4OoYAKQSsoHZQcCx5a81mc+pWak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Scalbert <louis.scalbert@6wind.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0447/1611] netlink: specs: rt-link: missed broadcast-neigh
Date: Tue, 21 Jul 2026 17:09:23 +0200
Message-ID: <20260721152525.352518861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Louis Scalbert <louis.scalbert@6wind.com>

[ Upstream commit 363037983cc503eb0b5a5c0ab80bf1434cfd168a ]

Add missed broadcast-neigh.

Signed-off-by: Louis Scalbert <louis.scalbert@6wind.com>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Link: https://patch.msgid.link/20260603150331.1919611-3-louis.scalbert@6wind.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 32b0b8953343 ("bonding: 3ad: add lacp_strict configuration knob")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/rt-link.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/netlink/specs/rt-link.yaml b/Documentation/netlink/specs/rt-link.yaml
index 2a23e9699c0b60..0a1f957961f80a 100644
--- a/Documentation/netlink/specs/rt-link.yaml
+++ b/Documentation/netlink/specs/rt-link.yaml
@@ -1336,6 +1336,9 @@ attribute-sets:
       -
         name: coupled-control
         type: u8
+      -
+        name: broadcast-neigh
+        type: u8
   -
     name: bond-ad-info-attrs
     name-prefix: ifla-bond-ad-info-
-- 
2.53.0



