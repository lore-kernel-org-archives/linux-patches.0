Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACE22AF0E;
	Thu, 12 Dec 2024 15:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016844; cv=none; b=D7PfLUKhwLfm+h6z9zq5BS86cBKAUXtFYdDqPjZGkKQ7cZpJcRo7M9ClB44Nwxdq3rEC802UeC5WTixT5SmvHo2rCX5aTi+TcAOtZRO0YA8oRr889vCjZRpx+2aItf1ofSbjnU5VUNpufPoVXs0CHA9THKtADYksikEBDslLLcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016844; c=relaxed/simple;
	bh=3aeGxPRiOcP7zyq12u+oAPISoSDxqZ6K8eunCEhztvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amZmD3VXr93GC3ulLLzmi8hbY92+D6aO4I4Ec1ocd6FSm/G3EpLN79gfwnnm3wiOI+wZtomJTU24aDdEe6/bt6ezGS5zLW+LKZn3uw/vC7dyHZuxPDSsYJyeUyrkS0wN0M1akJxJDz/764iCk9LHp/kKPvPSc0EncqaXxq5oDjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVEE90Y1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVEE90Y1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05058C4CECE;
	Thu, 12 Dec 2024 15:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016844;
	bh=3aeGxPRiOcP7zyq12u+oAPISoSDxqZ6K8eunCEhztvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVEE90Y12bySGjMK4Nzm+JS/t/HJpYpGet3WUBbBGC4j+1Piy7oPw08QOKYVsidDr
	 KZnPOUql3Zps9vovfgHzRRqocIqyoQqvbOrpCad/4OZbBvtnDnzKo3lFJEf0Vts7we
	 OJ5i5SWjEoW8RhxWvxFOMB+RwMJsgXYH9o67nNGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Donald Hunter <donald.hunter@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 312/466] netlink: specs: Add missing bitset attrs to ethtool spec
Date: Thu, 12 Dec 2024 15:58:01 +0100
Message-ID: <20241212144319.106338673@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Donald Hunter <donald.hunter@gmail.com>

[ Upstream commit b0b3683419b45e2971b6d413c506cb818b268d35 ]

There are a couple of attributes missing from the 'bitset' attribute-set
in the ethtool netlink spec. Add them to the spec.

Reported-by: Kory Maincent <kory.maincent@bootlin.com>
Closes: https://lore.kernel.org/netdev/20241017180551.1259bf5c@kmaincent-XPS-13-7390/
Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Tested-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20241018090630.22212-1-donald.hunter@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/ethtool.yaml | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index 6a050d755b9cb..f6c5d8214c7e9 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -96,7 +96,12 @@ attribute-sets:
         name: bits
         type: nest
         nested-attributes: bitset-bits
-
+      -
+        name: value
+        type: binary
+      -
+        name: mask
+        type: binary
   -
     name: string
     attributes:
-- 
2.43.0



