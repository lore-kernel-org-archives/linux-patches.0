Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282587E0E9;
	Wed,  7 Aug 2024 15:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043661; cv=none; b=de3eXFs99K0B9WDq6xKeDmzFFjUKEOK2eCJACHy8uVJpBhjqjs/iY3yj3h6MXCAJioVhIF59SqxgRRb9UOtOU2Z2nAGqw2xK2wys1zT4acYt4iS5lgsZgG/OOE8FtAKUKTcaG5EGhzQ8XBVomrS5ekzbaziunV8AdeYvTk0NfAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043661; c=relaxed/simple;
	bh=udfNYq/9jZtP1+7ofpnIPgdpYzZxZpEdugZrOorLB1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KV+aqhQLPN4yQvjtN6ZRireTkgQl8MTFtbGdmopY6ccyJO9TFudI/xIcuRxq9R4CZis26dcekQ3UQWf5Kg9X2RcsVTyMzb6Qf69rwo/+vzE1zv2z6Gm/5/4lnLHNkxzz2WViTIvU8dMXvigJ4DdI+G51sjFIyx0ge8E/7niZgSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AD+EIk4c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AD+EIk4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BAFC4AF0D;
	Wed,  7 Aug 2024 15:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043661;
	bh=udfNYq/9jZtP1+7ofpnIPgdpYzZxZpEdugZrOorLB1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AD+EIk4c/55zxroGHYb8w3uwDCbS7tmDT1xmPIbr60Gmu1IB/Rr6y/ohWFcANLPG0
	 YeYk+KQkxd3zVxaqOLV09iI9lnkfL9lrlvoXnupZpYZBECwGhIE6trYqJM0lK6IPta
	 FqhkJKdVAfi/Jgxo1JcQvOkjcFAXCnNNnvYFejqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 25/86] irqdomain: Use return value of strreplace()
Date: Wed,  7 Aug 2024 17:00:04 +0200
Message-ID: <20240807150040.064267100@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 67a4e1a3bf7c68ed3fbefc4213648165d912cabb ]

Since strreplace() returns the pointer to the string itself, use it
directly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20230628150251.17832-1-andriy.shevchenko@linux.intel.com
Stable-dep-of: 6ce3e98184b6 ("irqdomain: Fixed unbalanced fwnode get and put")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irqdomain.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 607c0c3d3f5e1..e03baca901e76 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -182,9 +182,7 @@ static struct irq_domain *__irq_domain_create(struct fwnode_handle *fwnode,
 			return NULL;
 		}
 
-		strreplace(name, '/', ':');
-
-		domain->name = name;
+		domain->name = strreplace(name, '/', ':');
 		domain->fwnode = fwnode;
 		domain->flags |= IRQ_DOMAIN_NAME_ALLOCATED;
 	}
-- 
2.43.0



