Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D085572610;
	Thu,  3 Jul 2025 14:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554182; cv=none; b=hN93oPZwRZ6sBtatLMwLyH1UNQkk+qxtSBfWTVbQP5ia9aBr5hSGKT68TWCTfp0KuNxu+qu3+IDD6T9+1WlsCVsmWvjFterQtCb0d4LjUoaXXnEf99TbYJhl5XmdJxn5GqqMiLgIq9SVFuElgloBDQ0AxrafUvZDZV9zay73tmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554182; c=relaxed/simple;
	bh=8d1zdtwx5irLTbhFh5h6PO1qjl/s+b+KQdnOY0uwIBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QS1mJO79zS+gkIRM7NfWMesNDcAFUwFRwZeSPjIqfywIvJjje5pZnjo6ZvQUYEfTyifb7ZwWN3VU/5kFuxU6O44bKaiw5GP2Yau23Fna3oO1zdF+RHZK7LnL1LRuJ7maMwO1V/v9Btz+BkC5UsK97ruGOxBqKRORtSBP3boay6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUBhYuHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUBhYuHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E6EC4CEE3;
	Thu,  3 Jul 2025 14:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554182;
	bh=8d1zdtwx5irLTbhFh5h6PO1qjl/s+b+KQdnOY0uwIBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DUBhYuHoYku43hpfalMrW+kHAkG8Elh67CZAoFSrGg1nhC01iPCiW/b1CiBiTyT1y
	 vm3Pl05rLuss2d0rukZ28eSjEEB4v/5G77v9wY2KYb8EP3qBnf3HLo8WuUWJL689LX
	 dnZypZp9Jhk0hTMkQldnYBp4pW+ibKR8YFgGg0Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/218] netlink: specs: tc: replace underscores with dashes in names
Date: Thu,  3 Jul 2025 16:40:55 +0200
Message-ID: <20250703144000.214245016@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

[ Upstream commit eef0eaeca7fa8e358a31e89802f564451b797718 ]

We're trying to add a strict regexp for the name format in the spec.
Underscores will not be allowed, dashes should be used instead.
This makes no difference to C (codegen, if used, replaces special
chars in names) but it gives more uniform naming in Python.

Fixes: a1bcfde83669 ("doc/netlink/specs: Add a spec for tc")
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Link: https://patch.msgid.link/20250624211002.3475021-10-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/tc.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/netlink/specs/tc.yaml b/Documentation/netlink/specs/tc.yaml
index c5579a5412fc9..043f205bc1ae7 100644
--- a/Documentation/netlink/specs/tc.yaml
+++ b/Documentation/netlink/specs/tc.yaml
@@ -227,7 +227,7 @@ definitions:
         type: u8
         doc: log(P_max / (qth-max - qth-min))
       -
-        name: Scell_log
+        name: Scell-log
         type: u8
         doc: cell size for idle damping
       -
@@ -248,7 +248,7 @@ definitions:
         name: DPs
         type: u32
       -
-        name: def_DP
+        name: def-DP
         type: u32
       -
         name: grio
-- 
2.39.5



