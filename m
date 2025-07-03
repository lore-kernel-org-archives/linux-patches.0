Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57E615442C;
	Thu,  3 Jul 2025 15:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555165; cv=none; b=GEOPCQncaKTY38H31raHF6rFq6ubXSIdKPITdrqfceQ5ofvdkR6AKJKToioztzzG3BkRfrQZ3gBG2QgG/wcHkCgrZQaKHErHWwD3LQmizm+GgAX9WoBYkow0BnyeGfqB+X2FVJv6tB+SnUzvu3rVDuhW8ftKenu7gWouFZMGHk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555165; c=relaxed/simple;
	bh=s6nRi7MQrKWX9IU+z7DzB6ixT+QwuVfmh5oenphuiXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUsjGm/XfV+fwCO59K4ynUGxYsnTJOcVmWNnDfj3iOa+OmeiyOV5g7AsYPT7YABi6hDLstFhQXHTkN41zPqwYTlyN4zTn43Zsr7ekPbNxetbWTxw+W3XJPLm6Q/Q+HI+j9TVRCC5Joe7jrtzn/Jx2h+4djByZn+WFCOzPVF17oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMgpP+Da; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMgpP+Da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E22C4CEE3;
	Thu,  3 Jul 2025 15:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555165;
	bh=s6nRi7MQrKWX9IU+z7DzB6ixT+QwuVfmh5oenphuiXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMgpP+Daivkucenp5WRvljnsPqIKo7nD5gVhaxJPcMv6yQEH0xAr4DnIB+R84w6CD
	 Np7cp4I9fyANLR3fZWmF63wMfCws88q2yb4tX9dI+ZEejtKWyFbHyUu7aSc0Vz1XXf
	 kAdAznqwaekv6XAr5vMpv1Ah/MeyCn3xYTAkkL8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 156/263] netlink: specs: tc: replace underscores with dashes in names
Date: Thu,  3 Jul 2025 16:41:16 +0200
Message-ID: <20250703144010.617751490@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 953aa837958b3..5702a6d21038c 100644
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



