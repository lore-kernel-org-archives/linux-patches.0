Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9B421D5BE;
	Tue, 20 May 2025 14:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750664; cv=none; b=P5gS8lCS0JW7QjUu8kADLsghmRq/w1e/X5EmKAX8guhmLUEeO1Ese4rmiytAgPElyRyP7877QBHJLjfF3mbt/EjOB31qJQZIREiJ5auLoz4ARc59Oeq8beOPesOCNlkn55pW9DKs6vBjJrCXY3Eh5fMVC+2TfpzVjqlszvG4HBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750664; c=relaxed/simple;
	bh=fBr0+58u34wd/z6VFkohke1w99Z7sMdTTuXC2icZGQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trSEDD0dH2q8eYSGM5Zjr58ijcNGaq0y5UKGvsT2ZpnrffFBACEQv8GUS1L3lazSc9UQFd5q91z2rkjlCheWmqRjKH78djy9h4F/rQOH/hN5VI3mwbn9+6KYC5XaK37cT6sSlkSA+JnTQi5ahJA1nLsUKXonY3uE+fBbfF9vCag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rY2p7umL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rY2p7umL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9218C4CEEB;
	Tue, 20 May 2025 14:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750664;
	bh=fBr0+58u34wd/z6VFkohke1w99Z7sMdTTuXC2icZGQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rY2p7umLtDB19cMnm2ZOXcTe7wg4/tke4pkuADdbK/IMZ+CdjyY+uFEVGLKseE+JI
	 +MDDN0RVekRPL9cI9TERnjwU+fUIE7Udk8kNKiktfZqBX6Q7ppwdpBCQdeiRWUkiBN
	 U6oFNahsbxrvU1GD8i4rCtMTvbXrDPvIlWsLGp+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 051/145] netlink: specs: tc: all actions are indexed arrays
Date: Tue, 20 May 2025 15:50:21 +0200
Message-ID: <20250520125812.573930367@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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
index 5e1ff04f51f26..953aa837958b3 100644
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



