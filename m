Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5823247290;
	Tue, 20 May 2025 14:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750661; cv=none; b=XkqB6ho3IzK0jg555gq16TonYsFnkg4WnjjfJ5OxCUpQ/g8hH6o6+Rov+1nVSq6dca9erswqNlaQhOqzqG7Z7p4F4igjA0vP13jvftqiZ76BsE2DMM+MxeJlcmODHTaL5IoI9XPuGVPgTQL5BdJlJ5yrpcmuKasgwBxuaLwT2tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750661; c=relaxed/simple;
	bh=GLav4X2DOJZfm1YCMP458BEm1jZQW794rdRKsHqQBEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPJeHtyHxgbBZ+FBbbDtg2OUM+FGa/sSKHCS8p9nWquYW3b1tD4eaWxwIpuFGm5Yg4yHYaGiBkloQRca+JHAQpyTUom5qCHeEP6yH1C8xBvgBBqCuHLAL7x8jVagMnoKCmhnYbEeQ6w5n23aswp44RP20AX7hR/bBFNB6k3uDdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6r/9GC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6r/9GC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B032BC4CEEA;
	Tue, 20 May 2025 14:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750661;
	bh=GLav4X2DOJZfm1YCMP458BEm1jZQW794rdRKsHqQBEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6r/9GC+BX8xnbvl8eXaJCy5KAKdYUJsMGWFogQxGD9rVoEsqeRBk81oZYOykXnUY
	 9I8AOL0ijMfSROl1S2vX3/ztwjVumrVETy9+ae/ivPZwRK//P8HaWic612RLoOjlQU
	 y1TCbFoYra0AXX8CqsZAceACURWPqT+q2FS6eQ1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 050/145] netlink: specs: tc: fix a couple of attribute names
Date: Tue, 20 May 2025 15:50:20 +0200
Message-ID: <20250520125812.536303485@linuxfoundation.org>
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

[ Upstream commit a9fb87b8b86918e34ef6bf3316311f41bc1a5b1f ]

Fix up spelling of two attribute names. These are clearly typoes
and will prevent C codegen from working. Let's treat this as
a fix to get the correction into users' hands ASAP, and prevent
anyone depending on the wrong names.

Fixes: a1bcfde83669 ("doc/netlink/specs: Add a spec for tc")
Link: https://patch.msgid.link/20250513221316.841700-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/tc.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/netlink/specs/tc.yaml b/Documentation/netlink/specs/tc.yaml
index aacccea5dfe42..5e1ff04f51f26 100644
--- a/Documentation/netlink/specs/tc.yaml
+++ b/Documentation/netlink/specs/tc.yaml
@@ -2745,7 +2745,7 @@ attribute-sets:
         type: u16
         byte-order: big-endian
       -
-        name: key-l2-tpv3-sid
+        name: key-l2tpv3-sid
         type: u32
         byte-order: big-endian
       -
@@ -3504,7 +3504,7 @@ attribute-sets:
         name: rate64
         type: u64
       -
-        name: prate4
+        name: prate64
         type: u64
       -
         name: burst
-- 
2.39.5



