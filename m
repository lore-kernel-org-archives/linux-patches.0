Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5DD33CE
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1495AC433EF;
	Mon, 30 Jan 2023 14:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088403;
	bh=JDU3GiYudntjq13yWE6def9ZLGThxEoAzAbiWzPFh7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=osG2EC/pBYS44n1O0k4Jxvf0WR7jiut4ol+8plA/yxWWN/FsjR2zlGOM3QrZSjRIf
	 DZxpTnqkJbYjCvXplf5jpOTe3nXlSI85bUY7yZ+wba9JFC73GTYBuaahOkigWCuCHX
	 1tMevFDhZdTWD6g0BNdNyKjhj4CDVCZEXlDwV2lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 198/204] cpufreq: Move to_gov_attr_set() to cpufreq.h
Date: Mon, 30 Jan 2023 14:52:43 +0100
Message-Id: <20230130134325.278464775@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kevin Hao <haokexin@gmail.com>

commit ae26508651272695a3ab353f75ab9a8daf3da324 upstream.

So it can be reused by other codes.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq_governor_attr_set.c |    5 -----
 include/linux/cpufreq.h                     |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/cpufreq/cpufreq_governor_attr_set.c
+++ b/drivers/cpufreq/cpufreq_governor_attr_set.c
@@ -8,11 +8,6 @@
 
 #include "cpufreq_governor.h"
 
-static inline struct gov_attr_set *to_gov_attr_set(struct kobject *kobj)
-{
-	return container_of(kobj, struct gov_attr_set, kobj);
-}
-
 static inline struct governor_attr *to_gov_attr(struct attribute *attr)
 {
 	return container_of(attr, struct governor_attr, attr);
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -643,6 +643,11 @@ struct gov_attr_set {
 /* sysfs ops for cpufreq governors */
 extern const struct sysfs_ops governor_sysfs_ops;
 
+static inline struct gov_attr_set *to_gov_attr_set(struct kobject *kobj)
+{
+	return container_of(kobj, struct gov_attr_set, kobj);
+}
+
 void gov_attr_set_init(struct gov_attr_set *attr_set, struct list_head *list_node);
 void gov_attr_set_get(struct gov_attr_set *attr_set, struct list_head *list_node);
 unsigned int gov_attr_set_put(struct gov_attr_set *attr_set, struct list_head *list_node);


