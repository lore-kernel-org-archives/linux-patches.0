Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2022281344;
	Wed, 23 Apr 2025 14:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420342; cv=none; b=E9xcKQmkEfr2+ikU9twd2u59aewck3x5tEMx83iuwbF6JKGufxm4x8Oh6p667IrVzPrnCPtjFHH/D4C2XZvhOYcvvCAihFlVTeyA2VK1aPSxr3gURxZU02MpB5yjW5BJIWWUZFSN5z9Du/EW7bpbpLHYOz6KHhj2OWTjH12agGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420342; c=relaxed/simple;
	bh=YyMBXsvPuUWLaphv/MV+3bJKRTCXKMO44EVGvMJxwc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMKTMmiwv8CzwuC3ItOfFZyTShTmrDkW0r+tC6ieNcu3YIuOJr2jfaRW5Tbzl7T7JtxL3IY94LNdHx0ow1JUj5MBLO64lwJnwmyo71EaQsEwU++Cd5xh8KjfaZzB3oehiZk0b/ECEHzRN/AumgojqgHABo1lX27jq0pJEIQfSD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUafnvqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUafnvqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E80C4CEE2;
	Wed, 23 Apr 2025 14:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420342;
	bh=YyMBXsvPuUWLaphv/MV+3bJKRTCXKMO44EVGvMJxwc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUafnvqKPI3vQ7CCzUddTqg+IKbAq7AWm+2Mxok51Rh5E/F9w9vrXh08aUIwkZzMq
	 SB5AqtrI+1Wps8NEAA1+8jQdAA3WPyFU8JI/nNoMjQHFbBf1HlSRjPndMMiPHfdTJH
	 8F14FRAh+um77LO04pNmaro3P3zkAboQIY0YAim4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 068/241] netlink: specs: rtnetlink: attribute naming corrections
Date: Wed, 23 Apr 2025 16:42:12 +0200
Message-ID: <20250423142623.377768943@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 540201c0ef7e8e7b169f68a238ade931a81a31a6 ]

Some attribute names diverge in very minor ways from the C names.
These are most likely typos, and they prevent the C codegen from
working.

Fixes: bc515ed06652 ("netlink: specs: Add a spec for neighbor tables in rtnetlink")
Fixes: b2f63d904e72 ("doc/netlink: Add spec for rt link messages")
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250414211851.602096-7-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/rt_link.yaml  | 6 +++---
 Documentation/netlink/specs/rt_neigh.yaml | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/netlink/specs/rt_link.yaml b/Documentation/netlink/specs/rt_link.yaml
index 1eab6aeaa2193..9f0ca05df0b98 100644
--- a/Documentation/netlink/specs/rt_link.yaml
+++ b/Documentation/netlink/specs/rt_link.yaml
@@ -1576,7 +1576,7 @@ attribute-sets:
         name: nf-call-iptables
         type: u8
       -
-        name: nf-call-ip6-tables
+        name: nf-call-ip6tables
         type: u8
       -
         name: nf-call-arptables
@@ -2064,7 +2064,7 @@ attribute-sets:
         name: id
         type: u16
       -
-        name: flag
+        name: flags
         type: binary
         struct: ifla-vlan-flags
       -
@@ -2152,7 +2152,7 @@ attribute-sets:
         type: binary
         struct: ifla-cacheinfo
       -
-        name: icmp6-stats
+        name: icmp6stats
         type: binary
         struct: ifla-icmp6-stats
       -
diff --git a/Documentation/netlink/specs/rt_neigh.yaml b/Documentation/netlink/specs/rt_neigh.yaml
index e670b6dc07be4..a1e137a16abd5 100644
--- a/Documentation/netlink/specs/rt_neigh.yaml
+++ b/Documentation/netlink/specs/rt_neigh.yaml
@@ -189,7 +189,7 @@ attribute-sets:
         type: binary
         display-hint: ipv4
       -
-        name: lladr
+        name: lladdr
         type: binary
         display-hint: mac
       -
-- 
2.39.5



