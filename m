Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95AC269D18;
	Tue, 21 Jul 2026 18:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660228; cv=none; b=NB9anEZwxd2SF/ohyMnsyJ4FGXRSgNjXATMh6Fhe5Hk9eCzb5/hXwnJjqh5im4NPdzaXINEpZD53Dbe9+/iTVDO5oGTB2quK0xjZmChrZQjyZ5RJzcGcueZcLlSctp/ql0KWD0wKXglJDmLROs9SzXvGFnsr9VTG2mZM+5LtZUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660228; c=relaxed/simple;
	bh=8E9d/fBz3sIpJe0wGKtScpe+Wj1sZ0wk8kYD3UidDvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5nIaFK+BdxEfCGoFa6BnxJrUp87/cGvmrN+ssxgtFrteq72PMIZN8MnGlVb7NPZ+/J94YuTET+RFsHxD6WR/mJnySI34MVJE5K/bz4HOr8R5ZNQEh91TQ7MWIXVgEtCDLI5arrp6Q/hbKQk6VIdi2MxrCQB3k57UKe6deBiM6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKq9g4Mo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKq9g4Mo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9331F000E9;
	Tue, 21 Jul 2026 18:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660226;
	bh=Gq5w/xtaL7eoXkSSFOI2WmK21DSkmuUp5ADXSYc2yjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKq9g4MoY9+2Q2X1ybGJy0k2tsd3OtofmInQMrDL2Xa+mgFj/Dcq4heFfRorxKmx9
	 kRTysf53zHUqXa9YTnJyO3MWREOfBwbqDvfx9ZusCWAfaMatGEXrVwA8+JG7f8trJg
	 j1oe1oOM83V3XwuvlIhOOoT5m46hTAjJFp8qCuZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baruch Siach <baruch@tkos.co.il>,
	Willy Tarreau <w@1wt.eu>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0900/2077] docs: threat-model: add missing closing parenthesis
Date: Tue, 21 Jul 2026 17:09:33 +0200
Message-ID: <20260721152614.045690806@linuxfoundation.org>
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

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit 89f332c1ef348e260a885085cd7821d6d72db7ec ]

Fixes: a03ef333fbd6 ("Documentation: security-bugs: explain what is and is not a security bug")
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Acked-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <da8ee1e8b4e99261ec11544c4e1a4f81316ae965.1779032501.git.baruch@tkos.co.il>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/process/threat-model.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/process/threat-model.rst b/Documentation/process/threat-model.rst
index f177b8d3c1cafd..9dd8011dde828b 100644
--- a/Documentation/process/threat-model.rst
+++ b/Documentation/process/threat-model.rst
@@ -176,7 +176,7 @@ regular bug:
   * problems seen only under development simulators, emulators, or combinations
     that do not exist on real systems at the time of reporting (issues
     involving tens of millions of threads, tens of thousands of CPUs,
-    unrealistic CPU frequencies, RAM sizes or disk capacities, network speeds.
+    unrealistic CPU frequencies, RAM sizes or disk capacities, network speeds).
 
   * issues whose reproduction requires hardware modification or emulation,
     including fake USB devices that pretend to be another one.
-- 
2.53.0



