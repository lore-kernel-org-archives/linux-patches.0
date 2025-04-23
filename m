Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDC7280A2C;
	Wed, 23 Apr 2025 14:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420184; cv=none; b=FGAzqU+D572G/3qb0w4qHKsPKRg8rXmGftdl+uF+w67NSCe1dlREaS3SnNDY7g1q6v+ki9CCZez6ZBBy1He7ov5UixN6m9jwpBwU+h6BLURlKvLYVvP5iM5UyOoWUKxZ/rEtPqbEzoeFgwNCnKApD5xCLSZyE/3jrp497Uyyy2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420184; c=relaxed/simple;
	bh=l4VI4LuuokTOXOCexe95w/l/6Ky6RCkesZUKsW/Dp3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9NePJt+pXasGFqYwR+NGRb4N74QVA9Yzr6KOdY7wyWQNxpMY8PY4hlvEA+VLDALp12DP7Ob4NJMpSXHK8SEvQcsptfpFVD8OaCKk/NAKLCl7gSOH6Q6KV2Ei1ZCTfh5ZJDt3e08P9tmmjSPMVwa4ytOGmduxLmqqH3kg3zuc1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPqaE7QU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPqaE7QU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDF4C4CEE2;
	Wed, 23 Apr 2025 14:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420184;
	bh=l4VI4LuuokTOXOCexe95w/l/6Ky6RCkesZUKsW/Dp3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zPqaE7QUv/gHuhDVyU7Ob1cen8jL+lS+DZOFGSJqSho5hNwwUXMqWXv9gyQMQb7Fd
	 pmPBbQHFLuIM9YGyqTU2edZvk/XjC15xfbLpge2Ci27GwY6VndhEdwjiPQBkDMHAVr
	 kEAWVjQQBh+VWeXHTvuckmiMlVI9j0Nu/RwsJzAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 069/241] netlink: specs: rt-link: adjust mctp attribute naming
Date: Wed, 23 Apr 2025 16:42:13 +0200
Message-ID: <20250423142623.416765269@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

[ Upstream commit beb3c5ad8829b52057f48a776a9d9558b98c157f ]

MCTP attribute naming is inconsistent. In C we have:
    IFLA_MCTP_NET,
    IFLA_MCTP_PHYS_BINDING,
         ^^^^

but in YAML:
    - mctp-net
    - phys-binding
      ^
       no "mctp"

It's unclear whether the "mctp" part of the name is supposed
to be a prefix or part of attribute name. Make it a prefix,
seems cleaner, even tho technically phys-binding was added later.

Fixes: b2f63d904e72 ("doc/netlink: Add spec for rt link messages")
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250414211851.602096-8-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/rt_link.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/rt_link.yaml b/Documentation/netlink/specs/rt_link.yaml
index 9f0ca05df0b98..78d3bec72f0e7 100644
--- a/Documentation/netlink/specs/rt_link.yaml
+++ b/Documentation/netlink/specs/rt_link.yaml
@@ -2166,9 +2166,10 @@ attribute-sets:
         type: u32
   -
     name: mctp-attrs
+    name-prefix: ifla-mctp-
     attributes:
       -
-        name: mctp-net
+        name: net
         type: u32
       -
         name: phys-binding
-- 
2.39.5



