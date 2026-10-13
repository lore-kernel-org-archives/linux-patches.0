Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829CD1DDA18;
	Tue, 13 Oct 2026 12:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892821; cv=none; b=kZXKQkPKh2oPpLSdAzDE/161/j8EIS6cJLuYETOYyPWZ7p1/GE55Ghy7GPlggm14RpHXiFfuDZyYbKQFFUJ93ettv+qNS5+c4lAEgHbz45+h8Xnoc5XDY0ec0ADSNgC8VLp0zb+HQO48/RFxzPZH4jZQxtteYGP+FTp9vg/o0y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892821; c=relaxed/simple;
	bh=zmOgiGnm+ZSjNPSoerFk8wvq5lIe+oKB7zk1cUZrX0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKhjHWbMCeitknmVyP4GhA4BqDAphuZP5mSp1Hmx6foyn0enFF2kGBBQH3HcQHbnjkfJoPkdvzYHxIVOsXiVSvx8oA+PIcoAgZ5klmyQk2ZHaUUFyPA1BbUscF8bb1BNwOd8X6u6P2cRfHDW6ZlU8dj73LiJZWxs3NzIXbjOvI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6yjHYoc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6yjHYoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F0C1F000FF;
	Tue, 13 Oct 2026 12:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892820;
	bh=va4SYFEuQa7HdUo0JP0P/w6p1B/ogqae4QIrih4fP9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6yjHYocLAZx4rr4ZG+jLjEKR474ej6am6T27Zmn0o0Rsv3YiKlRZoV2E3siiBmMO
	 mi2qdN4Fe65SyiXEqYzBjVMVPESW5NsqUZi5eoyYR7a62iQPU836IFoRmwE9Cxe8A0
	 Vwp5TZM/h3YyvC/Jsc+fROFoqpIpKDiK26Jx6jBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 009/621] ynl: fix schema check errors
Date: Tue, 13 Oct 2026 13:30:04 +0200
Message-ID: <20261013112921.084638350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Donald Hunter <donald.hunter@gmail.com>

[ Upstream commit 1adc241f3940c172c8c674a62004d3c34b360ab3 ]

Fix two schema check errors that have lurked since the attribute name
validation was made more strict:

not ok 2 conntrack.yaml schema validation
'labels mask' does not match '^[0-9a-z-]+$'

not ok 13 nftables.yaml schema validation
'set id' does not match '^[0-9a-z-]+$'

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
Link: https://patch.msgid.link/20251127123502.89142-5-donald.hunter@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/conntrack.yaml | 2 +-
 Documentation/netlink/specs/nftables.yaml  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/netlink/specs/conntrack.yaml b/Documentation/netlink/specs/conntrack.yaml
index bef528633b173..db7cddcda50af 100644
--- a/Documentation/netlink/specs/conntrack.yaml
+++ b/Documentation/netlink/specs/conntrack.yaml
@@ -457,7 +457,7 @@ attribute-sets:
         name: labels
         type: binary
       -
-        name: labels mask
+        name: labels-mask
         type: binary
       -
         name: synproxy
diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netlink/specs/nftables.yaml
index cce88819ba716..17ad707fa0d5d 100644
--- a/Documentation/netlink/specs/nftables.yaml
+++ b/Documentation/netlink/specs/nftables.yaml
@@ -915,7 +915,7 @@ attribute-sets:
         type: string
         doc: Name of set to use
       -
-        name: set id
+        name: set-id
         type: u32
         byte-order: big-endian
         doc: ID of set to use
-- 
2.53.0



