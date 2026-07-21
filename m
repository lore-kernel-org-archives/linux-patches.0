Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A4246A5FB;
	Tue, 21 Jul 2026 16:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649746; cv=none; b=qDRfXY2PgUCVPPQlGSerTF3YGFTmAkI+XMwHO39j9HCGJJKdAFuEII21ywK7U3VWqIgwsZuAx2JJqRrdcDUK5jDHrbxix7xr1Jx7TK2XSUfhF4hDAP8XCPyaduH7w/oJP9Ka2Fcodg00ghQ0jkqy84jPKnZI9s7HVgLa0wBrGMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649746; c=relaxed/simple;
	bh=z1G831BK/WCmIStxAqdevW+d9qnR+DMttZgcpxMk+dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWXzG11BbAd1I73PPpjiJmJprw3I3Kt5JX/ZVI61Na1SOZZInq1UW+Lzr3/bz+4Dhghn9YAWt+LqDNwddJqK8HrXM862O9IBMPNhqwlzaNUlcvr0mX2PGfSs6pwPmBMZef/Pdut82BhrggH1jhFdQm148q3HRZS+uHlQfITqu5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WGuuerFc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WGuuerFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134621F000E9;
	Tue, 21 Jul 2026 16:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649745;
	bh=AHHZIAU2fTq+/gqeA0W7GW7dNBrjdlPIWYXI9dNbk6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WGuuerFcB1psQXoI0j+4H5GTLgyhHAUklvxY4NLLrhCDNhnGLN2ebA7fRiyPONDgD
	 4XG2ZL2HFvTBLCUuwOxkzduXOc5EC8b4RSToeHzugZofQ9XF1nh01JEY8gdDV7t0vT
	 VDkjcAFdtNw3c1nma0Cu67hjNvnytJSCoXYNPPiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Scalbert <louis.scalbert@6wind.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0648/2077] netlink: specs: rt-link: missed broadcast-neigh
Date: Tue, 21 Jul 2026 17:05:21 +0200
Message-ID: <20260721152608.089607764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index f23aa5f229c500..484e0a97b653a1 100644
--- a/Documentation/netlink/specs/rt-link.yaml
+++ b/Documentation/netlink/specs/rt-link.yaml
@@ -1351,6 +1351,9 @@ attribute-sets:
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



