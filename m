Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8801B26E;
	Sat,  3 Feb 2024 04:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933722; cv=none; b=qBTwBsiAeS4imbwY5HvHUZYvIy3CzYy4u5/yoJ21V4sPyhvO6tov9wbuif17s880Q3oh/F18gNvHeNBhj9r0wcM+2M8gjtFeMTjKtd+ozAqgKycZCJ9r3YWjgAQYCMwF5bw3sY1bT+1i6VQP/EyThWh6BK4EQZ2GmnCxP3iFEgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933722; c=relaxed/simple;
	bh=qQtpXz8puYJcujvt8Za5s9PVlHAbG39wrBxLGd2kwCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDvnNB+P3dqK5iy8I94thUpY1+fc12XshcReczw9Om96YnWEKlc2eDMYm4kMlkjSDv7FnMyU8GenLjSsUYDHJRfTEf++9gatvhRKSsPHiGVq23Mt97nPmW/zpwre/QtT9L81TbvxkWKGxyz6aZJKNX2IngNjSIH3MX1ZkMTq1bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACbHecy+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACbHecy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CCCC433C7;
	Sat,  3 Feb 2024 04:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933722;
	bh=qQtpXz8puYJcujvt8Za5s9PVlHAbG39wrBxLGd2kwCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACbHecy+dOU2+HORaqkONHRc6lg+GFsZbNrFi8G5TP5BTIsZRHk9EkByIyxgTNZTt
	 t8+eBzEa3YUwWT9LtzlNgpPO67Dfnl/zSR82COLnT2wZds92Q8heuUIuo8hUa0aOYg
	 7kr+xP5lLQPq720Y+2pdux2gvyKOW6kge9klSq8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 322/322] bonding: remove print in bond_verify_device_path
Date: Fri,  2 Feb 2024 20:06:59 -0800
Message-ID: <20240203035409.437774286@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

commit 486058f42a4728053ae69ebbf78e9731d8ce6f8b upstream.

As suggested by Paolo in link[1], if the memory allocation fails, the mm
layer will emit a lot warning comprising the backtrace, so remove the
print.

[1] https://lore.kernel.org/all/20231118081653.1481260-1-shaozhengchao@huawei.com/

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2973,11 +2973,8 @@ struct bond_vlan_tag *bond_verify_device
 
 	if (start_dev == end_dev) {
 		tags = kcalloc(level + 1, sizeof(*tags), GFP_ATOMIC);
-		if (!tags) {
-			net_err_ratelimited("%s: %s: Failed to allocate tags\n",
-					    __func__, start_dev->name);
+		if (!tags)
 			return ERR_PTR(-ENOMEM);
-		}
 		tags[level].vlan_proto = BOND_VLAN_PROTO_NONE;
 		return tags;
 	}


