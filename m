Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628E31FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F57C433EF;
	Fri,  3 Feb 2023 10:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419855;
	bh=nDJYyc8RduOEUqDjGaxbvoJ+hp/XJuYSmIvoWNB6hZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XynaghXUL8YurPjq/LbH5paFg1RPG9B9hRIZKay7EC7HChifVcQjVUjk6WR5aT96H
	 Z+WVE5rRmawiwZwIIW1VESGWZqv/53f7A+SS94vZH9w+MS28VoJ7DBkxFIFI+X7Q11
	 dpHoGh1bNXG46OeGJM91NOs7c8T9afjEiX17j5No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Rong Chen <rong.a.chen@intel.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Marek Vasut <marex@denx.de>
Subject: [PATCH 5.15 13/20] extcon: usbc-tusb320: fix kernel-doc warning
Date: Fri,  3 Feb 2023 11:13:40 +0100
Message-Id: <20230203101008.560374551@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>
References: <20230203101007.985835823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rong Chen <rong.a.chen@intel.com>

commit 08099ecd9216219f51cc82637f06797cf81890b6 upstream.

Fix the warning:
drivers/extcon/extcon-usbc-tusb320.c:19: warning: expecting prototype
for drivers/extcon/extcon-tusb320.c(). Prototype was for TUSB320_REG8()
instead

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Rong Chen <rong.a.chen@intel.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Marek Vasut <marex@denx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/extcon/extcon-usbc-tusb320.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/extcon/extcon-usbc-tusb320.c
+++ b/drivers/extcon/extcon-usbc-tusb320.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/**
+/*
  * drivers/extcon/extcon-tusb320.c - TUSB320 extcon driver
  *
  * Copyright (C) 2020 National Instruments Corporation


