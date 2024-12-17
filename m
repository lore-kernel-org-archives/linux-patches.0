Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A3D1F8937;
	Tue, 17 Dec 2024 17:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456640; cv=none; b=J9sd+dWWJVzXWWFxuQk7Jrfu/vvqMdZam47hz6rvAxTJcyA3P1p9oRGZnWHF/c2ZdDKeyHeLfGyJJSt7TzgluwQzjP4KYLOXor1GavOR9VeSlAJf1v2b9vAm85ioEKUdr+wbai+lOTsyYByXv8HAUF5WYQ+deRn2Da/BdRwWHBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456640; c=relaxed/simple;
	bh=48/LTCIBiGDH+ICxZ7p+9GVZJo9kXYupM8bvR2vyLhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5rFiVe91mDGh0LhNmLpe0OL6kbgseycDAHwf91tnLPxgVeTOKrbVV+QSaWhbBidew0tQPPMDNXNeo734w0kS7bgevaCZAeW6Yim9X6Ucwqihjw3GvbjDYsD+4m88nronaj9xkaJocDLgvOhK0dOYFRGVzThw5RL2syB8IfO8z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPyWsjmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPyWsjmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A371C4AF0B;
	Tue, 17 Dec 2024 17:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456639;
	bh=48/LTCIBiGDH+ICxZ7p+9GVZJo9kXYupM8bvR2vyLhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qPyWsjmhq80qHoQwQ8zq0qboL9KxWK99oJOV7U0JFBVeIzDKQC9Tmh8C5JfRA4Vvt
	 BoAtRsXHZTJ9dXpQx3KiMhuIg/UNzkWQMB8kbUrN31TQldL39IJ9j9arLvC3DTefcv
	 3c5LuvOK4K2HTcp6JZKvEExhSwtzhJFZsnJHAMpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/172] Documentation: networking: Add a caveat to nexthop_compat_mode sysctl
Date: Tue, 17 Dec 2024 18:07:57 +0100
Message-ID: <20241217170551.352900480@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit bbe4b41259a3e255a16d795486d331c1670b4e75 ]

net.ipv4.nexthop_compat_mode was added when nexthop objects were added to
provide the view of nexthop objects through the usual lens of the route
UAPI. As nexthop objects evolved, the information provided through this
lens became incomplete. For example, details of resilient nexthop groups
are obviously omitted.

Now that 16-bit nexthop group weights are a thing, the 8-bit UAPI cannot
convey the >8-bit weight accurately. Instead of inventing workarounds for
an obsolete interface, just document the expectations of inaccuracy.

Fixes: b72a6a7ab957 ("net: nexthop: Increase weight to u16")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/b575e32399ccacd09079b2a218255164535123bd.1733740749.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/ip-sysctl.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index eacf8983e230..dcbb6f6caf6d 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2170,6 +2170,12 @@ nexthop_compat_mode - BOOLEAN
 	understands the new API, this sysctl can be disabled to achieve full
 	performance benefits of the new API by disabling the nexthop expansion
 	and extraneous notifications.
+
+	Note that as a backward-compatible mode, dumping of modern features
+	might be incomplete or wrong. For example, resilient groups will not be
+	shown as such, but rather as just a list of next hops. Also weights that
+	do not fit into 8 bits will show incorrectly.
+
 	Default: true (backward compat mode)
 
 fib_notify_on_flag_change - INTEGER
-- 
2.39.5



