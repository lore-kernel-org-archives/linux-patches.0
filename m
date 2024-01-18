Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E671B96D;
	Thu, 18 Jan 2024 10:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575424; cv=none; b=W1O/dkkBiL0DZzzYaKuIhdO8ObMSU22h4dUD8uqQELfK7mEs+dGUHwydO0FSd2aFuiR7KXSUPWwu4bVNKBev3DFfeyv76ccyX/XJtR8c2Ov1FXmW7CngOzdEn7/Z9xtDkrLP5YAi6caGQxwfusAeTJaQkQ9LiF2Mh7D+IYZkDtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575424; c=relaxed/simple;
	bh=FrM4zZKZub0x3JQXjdzywuhuZEp/RWpsWJDeXRuwS+4=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=LcKKJMXPk7GOSh9xquLw2yJdCvr+Ia/nQtDfrBSwXmsA0rEwfIpV43ecFdTw/JtjuHaDRtr+XxrNYNhfTN2nSjwjfuibcqQGCRDEOXJpmvV1+T7RN+5lESCWUeEvT6fqZPJA5GVRobedaS/pJDgbL90rJxU/IZkctEcTBPTE3cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FU+Ji6MB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FU+Ji6MB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D124AC433C7;
	Thu, 18 Jan 2024 10:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575424;
	bh=FrM4zZKZub0x3JQXjdzywuhuZEp/RWpsWJDeXRuwS+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FU+Ji6MBvVsBrc+ntmnhtxStIX2I8fLLW55UXTWEKr2mDEflKiN1zlodUms7P3qoK
	 4GFprsDpg2kxA/8EHSLkNagSmGqvhddi6dSpow0xnlgnaoK5umx/aiY/7RB0N2SK55
	 DUL3JPhYS3jonBTbZZWAW/Wi3AgQ/c0OdtZoK92o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/150] driver core: Add a guard() definition for the device_lock()
Date: Thu, 18 Jan 2024 11:48:40 +0100
Message-ID: <20240118104324.490920909@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 134c6eaa6087d78c0e289931ca15ae7a5007670d ]

At present there are ~200 usages of device_lock() in the kernel. Some of
those usages lead to "goto unlock;" patterns which have proven to be
error prone. Define a "device" guard() definition to allow for those to
be cleaned up and prevent new ones from appearing.

Link: http://lore.kernel.org/r/657897453dda8_269bd29492@dwillia2-mobl3.amr.corp.intel.com.notmuch
Link: http://lore.kernel.org/r/6577b0c2a02df_a04c5294bb@dwillia2-xfh.jf.intel.com.notmuch
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/170250854466.1522182.17555361077409628655.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/device.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/device.h b/include/linux/device.h
index 56d93a1ffb7b..99496a0a5ddb 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1007,6 +1007,8 @@ static inline void device_unlock(struct device *dev)
 	mutex_unlock(&dev->mutex);
 }
 
+DEFINE_GUARD(device, struct device *, device_lock(_T), device_unlock(_T))
+
 static inline void device_lock_assert(struct device *dev)
 {
 	lockdep_assert_held(&dev->mutex);
-- 
2.43.0



