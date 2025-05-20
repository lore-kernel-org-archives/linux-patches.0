Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4963D1CCEE7;
	Tue, 20 May 2025 14:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750153; cv=none; b=OLFRd8kgrghBtqUkJ2lc4pRiBKK7pAO2/Yd8K//UtkWApps5mAuV61zvKKMs3DPZ5+/+RGPG3iQBB6Y9RS+ctyrvGn/WLI97bFBAEIgDLKA/emSr25Dv7G3osqh7LNH1aj4Aee61HePMPxgG+Wo91uh1utHqWPjO0bUrL0Z+9vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750153; c=relaxed/simple;
	bh=xM+XaIdmvyYp1S3a85RO2L68REupNk2MU1JcTr/bNrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOxZKoCF52PsP/LfYYD0ibt78sjIi5NkdawMYhF5KGOAWqEnwGCsui53wWkHYuxbSYEetw/R9ZHjpCkqGLkJcwpVaGBwPg91StGem6UDjb9jkS83lllKpkqm0LEn2vFIbMEmH1srQyUq6I/SWAuwARz01OaMp3N6NFXOw3pxVsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TX42HCBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TX42HCBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB47CC4CEE9;
	Tue, 20 May 2025 14:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750153;
	bh=xM+XaIdmvyYp1S3a85RO2L68REupNk2MU1JcTr/bNrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TX42HCBkCuFZLnOMnCAu9se+2oT9T5xPio8wVXjTc9HjA5A26qHZSHRidQWsBogZG
	 yFKIUDUYv3VWMZltPzCU1VAnnvoPBnBuXEZxQ+TwQoAG+tYGM1bEm69jPKnSZxrcrj
	 fjL4susyYBCDpcNUw68MUAACtYLQTw1E6/lg3jkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/143] netlink: specs: tc: all actions are indexed arrays
Date: Tue, 20 May 2025 15:50:14 +0200
Message-ID: <20250520125812.375789244@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

[ Upstream commit f3dd5fb2fa494dcbdb10f8d27f2deac8ef61a2fc ]

Some TC filters have actions listed as indexed arrays of nests
and some as just nests. They are all indexed arrays, the handling
is common across filters.

Fixes: 2267672a6190 ("doc/netlink/specs: Update the tc spec")
Link: https://patch.msgid.link/20250513221638.842532-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/tc.yaml | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/netlink/specs/tc.yaml b/Documentation/netlink/specs/tc.yaml
index a5bde25c89e52..c5579a5412fc9 100644
--- a/Documentation/netlink/specs/tc.yaml
+++ b/Documentation/netlink/specs/tc.yaml
@@ -2017,7 +2017,8 @@ attribute-sets:
     attributes:
       -
         name: act
-        type: nest
+        type: indexed-array
+        sub-type: nest
         nested-attributes: tc-act-attrs
       -
         name: police
@@ -2250,7 +2251,8 @@ attribute-sets:
     attributes:
       -
         name: act
-        type: nest
+        type: indexed-array
+        sub-type: nest
         nested-attributes: tc-act-attrs
       -
         name: police
-- 
2.39.5



