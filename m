Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3990222540E;
	Thu, 12 Dec 2024 15:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018246; cv=none; b=DI24jmMianL0mySurDsf4sViJ6L6uWLvoCaKlzyYJdcX7Syildn3ujI4rcOUMRhBkwQpwFQOb4n0JoOihVPLpk54ViBg8wZ1htE6RKeU8gwRaku+JzrUo60CMxze8QAsCNZgCE19j1Kyh2lxylAd1f9Ux959O1w++UYLpQtngaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018246; c=relaxed/simple;
	bh=Kji1KNWRcaq07U+6LLVzGCQTNIAvMqG6zNdot4V2tvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pg/G+eob3jMhpkNJCQsKVErGNvOA/IC3DVRa9t1enlU1c5Xg5S7b3zuzFYHXTmqK0mDlMKO7TB33SWJbLTFIK0JI8goVrYXEYHc0PJS4MjWMBofcuOLUgCVvQC39g7It8Ji0sLAWqDE2DmTriFEwTHXS+S/4cryb8bQqkC9u6BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rFTfcxZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rFTfcxZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80567C4CEDE;
	Thu, 12 Dec 2024 15:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018246;
	bh=Kji1KNWRcaq07U+6LLVzGCQTNIAvMqG6zNdot4V2tvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFTfcxZbC/efugAbyjqMUrTnTJFdlnbs5BH9Bvr5e8Gw6gzYYqfEz5Yu4QHuPoFyK
	 R+teVnoz7DqgRjHQoxudtiZC+Z2CjsTMtSV76adf+8f8EbSTIvzMpi1+xCfEVsM90u
	 PAwCUPrlA3i9zUYV3H+c/YrqDryHFAkgRkllVVaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Donald Hunter <donald.hunter@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 240/356] netlink: specs: Add missing bitset attrs to ethtool spec
Date: Thu, 12 Dec 2024 15:59:19 +0100
Message-ID: <20241212144254.095621232@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 837b565577ca6..3e38f69567939 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -64,7 +64,12 @@ attribute-sets:
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



