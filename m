Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FE73D3321;
	Sat, 17 Oct 2026 16:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255376; cv=none; b=bLsLCP8OGfg1u89pRqaqnw1G6HfZ1bF6pXhNERAk6pOOtw9LMKcOSR3EuCFE47skGGPRg3X9bbHCJfJwtaipAHdr0qGSkuGUNbB0XKnUCIVGF4Tfhy827U3I0zj/13lTcuXxW4J4rnWL3SpJwT4zWUGlC6eB1sYhCOilDHozN+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255376; c=relaxed/simple;
	bh=8AdJElvEOnPZ+9Gn2nQ7rHyMCVAWj8qKHks+uNmzxk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xm9k8HejBxZnJoZrwi4fHtZBF8sE4pJlh2PudqJOtZi1I6gSXIGd9xD/fT1VLV+zgExeT1/tdVdWi06OJSsuhSxuPtvA+s+u4OmyhYQTHGWMVN5e2U1Un1rbW2ogwgnav3YpCGfTw+AgpfSiVAsDSZZOEYHekaUOuHfkGwDQyJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=le1Pe9LO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="le1Pe9LO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BAC1F000C8;
	Sat, 17 Oct 2026 16:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255374;
	bh=uy5JhmZ1NMN7wpxMAf1jF8hYWtlnNGSYaf12hV70ZnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=le1Pe9LOTk/4t+Qt7bb5iom+pamUEIj114CQfKqeFKeBsE5ot4QcTPXCt4OjKVZBS
	 rzlM5r4Bsc89J9//6rnzqnGyYsjYYK0JizZ+upj4SAY8BlfVISSyk9mM2R7ajjASZ+
	 nRdE4Jp7RullsuiAyqEDQ0QVSr6jUOYdwFxMcxk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 756/869] genirq: Consistently use %u format specifier for unsigned int variables
Date: Sat, 17 Oct 2026 17:59:57 +0200
Message-ID: <20261017160056.314392078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 47af06c9d31fe558493de4e04f9a07847dc4992f ]

There are three cases in the genirq code when the irq, as an unsigned
integer variable, is converted to text representation by sprintf().
In two cases it uses '%d' specifier which is for signed values. While
it's not a problem right now, potentially it might be in the future
in case too big (> INT_MAX) number will appear there.

Consistently use '%u' format specifier for @irq which is declared as
unsigned int in all these cases.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250509154643.1499171-1-andriy.shevchenko@linux.intel.com
Stable-dep-of: c2c7983c93f5 ("genirq/proc: Size interrupt directory names for 10-digit interrupt numbers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/debugfs.c | 2 +-
 kernel/irq/proc.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/debugfs.c b/kernel/irq/debugfs.c
index c6ffb97966bed..8bcde325b05c0 100644
--- a/kernel/irq/debugfs.c
+++ b/kernel/irq/debugfs.c
@@ -231,7 +231,7 @@ void irq_add_debugfs_entry(unsigned int irq, struct irq_desc *desc)
 	if (!irq_dir || !desc || desc->debugfs_file)
 		return;
 
-	sprintf(name, "%d", irq);
+	sprintf(name, "%u", irq);
 	desc->debugfs_file = debugfs_create_file(name, 0644, irq_dir, desc,
 						 &dfs_irq_ops);
 }
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 24fe3bd56d86f..6cb9e19e710cf 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -309,7 +309,7 @@ static bool name_unique(unsigned int irq, struct irqaction *new_action)
 
 void register_handler_proc(unsigned int irq, struct irqaction *action)
 {
-	char name [MAX_NAMELEN];
+	char name[MAX_NAMELEN];
 	struct irq_desc *desc = irq_to_desc(irq);
 
 	if (!desc->dir || action->dir || !action->name || !name_unique(irq, action))
@@ -345,7 +345,7 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 		return;
 
 	/* create /proc/irq/1234 */
-	sprintf(name, "%d", irq);
+	sprintf(name, "%u", irq);
 	desc->dir = proc_mkdir(name, root_irq_dir);
 	if (!desc->dir)
 		return;
-- 
2.53.0



