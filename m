Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5178848E0F5;
	Sat, 12 Sep 2026 18:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238200; cv=none; b=rxBSP0STBGzdUc7qlCwreIOrQg/Ok0SZugYUbpT1ra7rAbc8RGcpbGsj/DqsXgbI8+rQNagkfS4P8H2PGubY0z2nsSnPg31i3xAp5sm4JPWH8c1NTBWr1aIV7cGWXeffTJgFVMjHRTT8C2WB9fMfiYk8aOb4x2IssWoYShCiFBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238200; c=relaxed/simple;
	bh=c2MFKLTCYWAwurovFvIHN1dnQR1oQPh0x2fADbOhHRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRH2Z/RwTZY0BY4sw5mKFLXAZ5j1MHp4of8+CeGtB5IAoqdfd+d4uNRcl3dfa2GDLkFl7cOBVSd8WGDebUxDvCULjTlloohzMqFgKWYpNpb5FJW2HIr2dJcf6EWIWQietEWTCrhDh3w3ShYTpAJ5YLCeb3QVQ3VYaO4pJvL81yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adFEHPZB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adFEHPZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA5E1F000FF;
	Sat, 12 Sep 2026 18:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238198;
	bh=K/QSn9hcdDf/ZYvAa8Q0rETEWU7g8iWvSJGpgMaViyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adFEHPZBTybbj6hrLyTQwKj+iPJCwLr97rDveWCFwtek9rXySBlqn6OvJan7X7LW5
	 BZtU7BXeXU3oPnGhvDfclJCoJdKmarVvxScmEZEz3v6lSS2qALOk7nOrZFV3B5mC8Q
	 TJtxrJCU4EVMjrDuHLopfVcqfPNzC7zkgx8dpx3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 414/935] media: keymaps: Remove obsolete RC_MAP_HAUPPAUGE_NEW keymap define
Date: Sat, 12 Sep 2026 08:57:24 +0200
Message-ID: <20260912065536.320324440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 6e5deb2923b0d1b73c77a1a77c30b0da43d9e022 ]

Since commit af86ce79f020 ("[media] remove the old RC_MAP_HAUPPAUGE_NEW
RC map"), the RC_MAP_HAUPPAUGE_NEW define is no longer used.

Fixes: af86ce79f020 ("[media] remove the old RC_MAP_HAUPPAUGE_NEW RC map")
Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/media/rc-map.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 1eb9a93330036..d59aceb38ca05 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -260,7 +260,6 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_GENIUS_TVGO_A11MCE        "rc-genius-tvgo-a11mce"
 #define RC_MAP_GOTVIEW7135               "rc-gotview7135"
 #define RC_MAP_HAUPPAUGE                 "rc-hauppauge"
-#define RC_MAP_HAUPPAUGE_NEW             "rc-hauppauge"
 #define RC_MAP_HISI_POPLAR               "rc-hisi-poplar"
 #define RC_MAP_HISI_TV_DEMO              "rc-hisi-tv-demo"
 #define RC_MAP_IMON_MCE                  "rc-imon-mce"
-- 
2.53.0



