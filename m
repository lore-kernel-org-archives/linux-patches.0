Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2551646B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FA9C433D2;
	Mon, 16 Jan 2023 16:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885441;
	bh=EPGwsnmI2cCSq2FZmtgkZDVlbHhNuGc5wdCx//jrdwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=edEJLLo8ZxVt7XuSC8XhQzbuGzzq+kDVQ4sI0odFHHqjfZe0mhXNyi3IM/JxDZ7vt
	 H6U/SgLwCBJaCt2v0ubqFrSwtaeuAlYjsi5F1ujKOdlqjy7hpS3NZEKDo+pzKbr/ai
	 1Yae1f5rrjxh0VPlhgVLFST0qRh4PsT1dTvoZJI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xiongxin <xiongxin@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/658] PM: hibernate: Fix mistake in kerneldoc comment
Date: Mon, 16 Jan 2023 16:42:20 +0100
Message-Id: <20230116154912.034521873@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: xiongxin <xiongxin@kylinos.cn>

[ Upstream commit 6e5d7300cbe7c3541bc31f16db3e9266e6027b4b ]

The actual maximum image size formula in hibernate_preallocate_memory()
is as follows:

max_size = (count - (size + PAGES_FOR_IO)) / 2
	    - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE);

but the one in the kerneldoc comment of the function is different and
incorrect.

Fixes: ddeb64870810 ("PM / Hibernate: Add sysfs knob to control size of memory for drivers")
Signed-off-by: xiongxin <xiongxin@kylinos.cn>
[ rjw: Subject and changelog rewrite ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/snapshot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 46455aa7951e..5092b8bfa1db 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1680,8 +1680,8 @@ static unsigned long minimum_image_size(unsigned long saveable)
  * /sys/power/reserved_size, respectively).  To make this happen, we compute the
  * total number of available page frames and allocate at least
  *
- * ([page frames total] + PAGES_FOR_IO + [metadata pages]) / 2
- *  + 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
+ * ([page frames total] - PAGES_FOR_IO - [metadata pages]) / 2
+ *  - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
  *
  * of them, which corresponds to the maximum size of a hibernation image.
  *
-- 
2.35.1



