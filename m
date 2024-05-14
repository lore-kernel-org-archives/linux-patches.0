Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255242CCA3;
	Tue, 14 May 2024 10:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683503; cv=none; b=IRnHeHyL+dsP7ZgVtJMYv0LXrzY8Kqt//fj1ohYNpzHzbMESfJuc08Yueu0Z3jY4SSQsdX0aVHkeQEKO/D8h074SliN8vR0FbSCgc71L51vbUmKuhnte7j++pxfoaesN9tW7xk3N3wOVlM00rVPXc2dK+pr2l1jenZ6WQztTQ3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683503; c=relaxed/simple;
	bh=12OZdOIN8pWf8HXmOIgLkLEY9Wq1xPnRQV62m3+BHi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlbEMB0mx+oWwOx7tT4qXdv0GPFl8zGlP0slCswuIzyoxoVQh+N0W3nls6fup3e93Vg74tTKasXGUMP+yirvgqLTDpAWSqRJHvIDewjGcHPGzYRHM0Krf9gMqUcnYROo4eUyqWI6WUAgmFMeSchFif35t2AqbakiREhjS4lC80Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtQ8iIeS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtQ8iIeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7C1C2BD10;
	Tue, 14 May 2024 10:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683502;
	bh=12OZdOIN8pWf8HXmOIgLkLEY9Wq1xPnRQV62m3+BHi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtQ8iIeSg9SMRTIbGkOUI6bMNIJtuWgvG383OFtaOFaBcftb38ttnW6EViVqfo1Qa
	 f1VrHCzPhSaPysV84mMHKUukBt3ISdmyZx1YSIoARs6pM9fqPl3bC3SUYcCbVWmvTG
	 GxYv58Fh779Sb+UsOdXKZrIz3nAYcG/E3KKGNsCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 211/336] netlink: specs: Add missing bridge linkinfo attrs
Date: Tue, 14 May 2024 12:16:55 +0200
Message-ID: <20240514101046.578947660@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donald Hunter <donald.hunter@gmail.com>

[ Upstream commit 9adcac6506185dd1a727f1784b89f30cd217ef7e ]

Attributes for FDB learned entries were added to the if_link netlink api
for bridge linkinfo but are missing from the rt_link.yaml spec. Add the
missing attributes to the spec.

Fixes: ddd1ad68826d ("net: bridge: Add netlink knobs for number / max learned FDB entries")
Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/r/20240503164304.87427-1-donald.hunter@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/rt_link.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/netlink/specs/rt_link.yaml b/Documentation/netlink/specs/rt_link.yaml
index 8e4d19adee8cd..4e702ac8bf66b 100644
--- a/Documentation/netlink/specs/rt_link.yaml
+++ b/Documentation/netlink/specs/rt_link.yaml
@@ -1144,6 +1144,12 @@ attribute-sets:
       -
         name: mcast-querier-state
         type: binary
+      -
+        name: fdb-n-learned
+        type: u32
+      -
+        name: fdb-max-learned
+        type: u32
   -
     name: linkinfo-brport-attrs
     name-prefix: ifla-brport-
-- 
2.43.0



