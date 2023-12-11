Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CBA51C53;
	Mon, 11 Dec 2023 18:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nwd2dXZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C577C433C9;
	Mon, 11 Dec 2023 18:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319865;
	bh=cZE452f8YPHdbVsA+b1uc/h5DbUGuVzHmCdJDexVwh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nwd2dXZBJ/Kx7vpDivH+Cr6uifbJvhM4q5Mphx6LOgB+ksyVYRlT6Bpt9vVzFyi37
	 KEa4pn7vpkmL31i99WMPlC6KReisDZOTw1vh5T6aJ9LqyBiXQScgyLNbWLck6mOY07
	 lNyTn12uOcvz4Orvj9FEZSZq8t6Ywy5MpRle4TIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	devicetree@vger.kernel.org,
	Lee Jones <lee.jones@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/97] of: base: Fix some formatting issues and provide missing descriptions
Date: Mon, 11 Dec 2023 19:21:20 +0100
Message-ID: <20231211182020.542156072@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
References: <20231211182019.802717483@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee.jones@linaro.org>

[ Upstream commit 3637d49e11219512920aca8b8ccd0994be33fa8b ]

Fixes the following W=1 kernel build warning(s):

 drivers/of/base.c:315: warning: Function parameter or member 'cpun' not described in '__of_find_n_match_cpu_property'
 drivers/of/base.c:315: warning: Function parameter or member 'prop_name' not described in '__of_find_n_match_cpu_property'
 drivers/of/base.c:315: warning: Function parameter or member 'cpu' not described in '__of_find_n_match_cpu_property'
 drivers/of/base.c:315: warning: Function parameter or member 'thread' not described in '__of_find_n_match_cpu_property'
 drivers/of/base.c:315: warning: expecting prototype for property holds the physical id of the(). Prototype was for __of_find_n_match_cpu_property() instead
 drivers/of/base.c:1139: warning: Function parameter or member 'match' not described in 'of_find_matching_node_and_match'
 drivers/of/base.c:1779: warning: Function parameter or member 'np' not described in '__of_add_property'
 drivers/of/base.c:1779: warning: Function parameter or member 'prop' not described in '__of_add_property'
 drivers/of/base.c:1800: warning: Function parameter or member 'np' not described in 'of_add_property'
 drivers/of/base.c:1800: warning: Function parameter or member 'prop' not described in 'of_add_property'
 drivers/of/base.c:1849: warning: Function parameter or member 'np' not described in 'of_remove_property'
 drivers/of/base.c:1849: warning: Function parameter or member 'prop' not described in 'of_remove_property'
 drivers/of/base.c:2137: warning: Function parameter or member 'dn' not described in 'of_console_check'
 drivers/of/base.c:2137: warning: Function parameter or member 'name' not described in 'of_console_check'
 drivers/of/base.c:2137: warning: Function parameter or member 'index' not described in 'of_console_check'

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: devicetree@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20210318104036.3175910-5-lee.jones@linaro.org
Stable-dep-of: d79972789d17 ("of: dynamic: Fix of_reconfig_get_state_change() return value documentation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/base.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index a44a0e7ba2510..fa45a681267cd 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -305,7 +305,7 @@ bool __weak arch_match_cpu_phys_id(int cpu, u64 phys_id)
 	return (u32)phys_id == cpu;
 }
 
-/**
+/*
  * Checks if the given "prop_name" property holds the physical id of the
  * core/thread corresponding to the logical cpu 'cpu'. If 'thread' is not
  * NULL, local thread number within the core is returned in it.
@@ -1128,7 +1128,7 @@ EXPORT_SYMBOL(of_match_node);
  *			will; typically, you pass what the previous call
  *			returned. of_node_put() will be called on it
  *	@matches:	array of of device match structures to search in
- *	@match		Updated to point at the matches entry which matched
+ *	@match:		Updated to point at the matches entry which matched
  *
  *	Returns a node pointer with refcount incremented, use
  *	of_node_put() on it when done.
@@ -1779,6 +1779,8 @@ EXPORT_SYMBOL(of_count_phandle_with_args);
 
 /**
  * __of_add_property - Add a property to a node without lock operations
+ * @np:		Caller's Device Node
+ * @prob:	Property to add
  */
 int __of_add_property(struct device_node *np, struct property *prop)
 {
@@ -1800,6 +1802,8 @@ int __of_add_property(struct device_node *np, struct property *prop)
 
 /**
  * of_add_property - Add a property to a node
+ * @np:		Caller's Device Node
+ * @prob:	Property to add
  */
 int of_add_property(struct device_node *np, struct property *prop)
 {
@@ -1844,6 +1848,8 @@ int __of_remove_property(struct device_node *np, struct property *prop)
 
 /**
  * of_remove_property - Remove a property from a node.
+ * @np:		Caller's Device Node
+ * @prob:	Property to remove
  *
  * Note that we don't actually remove it, since we have given out
  * who-knows-how-many pointers to the data using get-property.
@@ -2130,9 +2136,9 @@ EXPORT_SYMBOL_GPL(of_alias_get_highest_id);
 
 /**
  * of_console_check() - Test and setup console for DT setup
- * @dn - Pointer to device node
- * @name - Name to use for preferred console without index. ex. "ttyS"
- * @index - Index to use for preferred console.
+ * @dn: Pointer to device node
+ * @name: Name to use for preferred console without index. ex. "ttyS"
+ * @index: Index to use for preferred console.
  *
  * Check if the given device node matches the stdout-path property in the
  * /chosen node. If it does then register it as the preferred console and return
-- 
2.42.0



