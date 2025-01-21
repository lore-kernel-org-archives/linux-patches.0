Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209BC1F0E36;
	Tue, 21 Jan 2025 18:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482636; cv=none; b=fPJAp9CQIHI/MSNcclvsTA52i9I9WGSuaC3XD+4IaPwaKZMv28tF5cIUKkaSWN5EuhO24BHExqRGjEcp9nXGvZQkXZySztwi3gHkh6ed8nRizVWY4ua0MjK0i+cKKieGFnZAAumjP/aER6y3W1cGb79K0ucWwFkLEhIvZNZ73zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482636; c=relaxed/simple;
	bh=GoFJ7L+769UDBwyNR2KHSWhtHH0S+/Wi2ji4cOgFiUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnO9zirfAySjyJ+7XXeo+kfh0GWvsgMJocpci6ov8rXSLPAJdERtj4qbucj+lRoNLMgHrtoMGPj5NyIHK4J831ZL9U+RzF6ob98NXqfV1ji+pNWnitNWiqoafSbN3GVAgWU8zkuUhfFrPmA5k6gktbbzuSWCHg45Zx/SSpdXFMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbsPkZSk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbsPkZSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99724C4CEDF;
	Tue, 21 Jan 2025 18:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482636;
	bh=GoFJ7L+769UDBwyNR2KHSWhtHH0S+/Wi2ji4cOgFiUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbsPkZSktbh3pGYNe3vXipUjyl8RtSaWSfH18tbhA1oIU9eKobjs51xSkNHI6URLX
	 PRruzXFLs3YTURzAZQDCOj7FbW4VFDHbdfAashZb2lxg4GswJOEWhWxZ82nZYWB3oF
	 Ty/pGSxs040YN41/AvH4sU+72igw6hnBc7c8fHaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Kunbo <zhangkunbo@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 21/64] fs: fix missing declaration of init_files
Date: Tue, 21 Jan 2025 18:52:20 +0100
Message-ID: <20250121174522.367193093@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Kunbo <zhangkunbo@huawei.com>

[ Upstream commit 2b2fc0be98a828cf33a88a28e9745e8599fb05cf ]

fs/file.c should include include/linux/init_task.h  for
 declaration of init_files. This fixes the sparse warning:

fs/file.c:501:21: warning: symbol 'init_files' was not declared. Should it be static?

Signed-off-by: Zhang Kunbo <zhangkunbo@huawei.com>
Link: https://lore.kernel.org/r/20241217071836.2634868-1-zhangkunbo@huawei.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/file.c b/fs/file.c
index 48f0b28da5247..bc0c087b31bbd 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -21,6 +21,7 @@
 #include <linux/rcupdate.h>
 #include <linux/close_range.h>
 #include <net/sock.h>
+#include <linux/init_task.h>
 
 #include "internal.h"
 
-- 
2.39.5



