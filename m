Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB52953365;
	Thu, 12 Dec 2024 16:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020805; cv=none; b=Oy1C9LEdWpzfr5lrIk+0k/QszdbeLnaeU/quljJx5o7Yo9HM1VX1e/bb2S8pePAFT96efxNYic5evAK1Ey78VzT2Gc5VLyNSjdHkbNIFGI5UofaKHGmgbLnwYEPVDPAsZEn5ESWyDSAw9KYtODHClCZ8bqnbe7Q2kqSp96Hsf+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020805; c=relaxed/simple;
	bh=y5kGi0Cpr3TriYG7xH5GJx5hCVMwVmWeoTJ0L+oTYUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWBeL184yg1XXdbaL2CCFjGSKPL5OkKzqnLjVWNBSK3JnTJHFkNTT8ZhY1YqwcIKKKB+oRvdCpA1zZSy4KD6eQFCdKj2nsY7/0VwvVAjI8VaqzGrYjCxmQ2LgAslB6JoVS4v41y3y6ZfdtgY0wO0KaoZwQEiuy8dbHLT5o5penY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lY+h9KcC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lY+h9KcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077D7C4CECE;
	Thu, 12 Dec 2024 16:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020805;
	bh=y5kGi0Cpr3TriYG7xH5GJx5hCVMwVmWeoTJ0L+oTYUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lY+h9KcCbi/h8RPnspDCas7tZA5/p3PXEtJH0uc8dawSUO75HaVxy1QQKyTi08ZjA
	 IQNKKhGkprSnq/57B/lTzAVMK9C2ldylbDb+Wu3hvtfongekHiFxCIx/KwGcwdQPzg
	 utuZFNBkxFKQ966obht45ztXTjSUCUgTBOAzbHHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 565/772] driver core: Add FWLINK_FLAG_IGNORE to completely ignore a fwnode link
Date: Thu, 12 Dec 2024 15:58:30 +0100
Message-ID: <20241212144413.305926739@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit b7e1241d8f77ed64404a5e4450f43a319310fc91 ]

A fwnode link between specific supplier-consumer fwnodes can be added
multiple times for multiple reasons. If that dependency doesn't exist,
deleting the fwnode link once doesn't guarantee that it won't get created
again.

So, add FWLINK_FLAG_IGNORE flag to mark a fwnode link as one that needs to
be completely ignored. Since a fwnode link's flags is an OR of all the
flags passed to all the fwnode_link_add() calls to create that specific
fwnode link, the FWLINK_FLAG_IGNORE flag is preserved and can be used to
mark a fwnode link as on that need to be completely ignored until it is
deleted.

Signed-off-by: Saravana Kannan <saravanak@google.com>
Acked-by: "Rafael J. Wysocki" <rafael@kernel.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20240305050458.1400667-3-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: bac3b10b78e5 ("driver core: fw_devlink: Stop trying to optimize cycle detection logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c    | 9 ++++++++-
 include/linux/fwnode.h | 2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index f0a66fec4fa75..e1436e351826c 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1082,7 +1082,8 @@ static struct fwnode_handle *fwnode_links_check_suppliers(
 		return NULL;
 
 	list_for_each_entry(link, &fwnode->suppliers, c_hook)
-		if (!(link->flags & FWLINK_FLAG_CYCLE))
+		if (!(link->flags &
+		      (FWLINK_FLAG_CYCLE | FWLINK_FLAG_IGNORE)))
 			return link->supplier;
 
 	return NULL;
@@ -1973,6 +1974,9 @@ static bool __fw_devlink_relax_cycles(struct device *con,
 	}
 
 	list_for_each_entry(link, &sup_handle->suppliers, c_hook) {
+		if (link->flags & FWLINK_FLAG_IGNORE)
+			continue;
+
 		if (__fw_devlink_relax_cycles(con, link->supplier)) {
 			__fwnode_link_cycle(link);
 			ret = true;
@@ -2051,6 +2055,9 @@ static int fw_devlink_create_devlink(struct device *con,
 	int ret = 0;
 	u32 flags;
 
+	if (link->flags & FWLINK_FLAG_IGNORE)
+		return 0;
+
 	if (con->fwnode == link->consumer)
 		flags = fw_devlink_get_flags(link->flags);
 	else
diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
index 5700451b300fb..525cc031596b6 100644
--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -51,8 +51,10 @@ struct fwnode_handle {
  * fwnode link flags
  *
  * CYCLE:	The fwnode link is part of a cycle. Don't defer probe.
+ * IGNORE:	Completely ignore this link, even during cycle detection.
  */
 #define FWLINK_FLAG_CYCLE			BIT(0)
+#define FWLINK_FLAG_IGNORE			BIT(1)
 
 struct fwnode_link {
 	struct fwnode_handle *supplier;
-- 
2.43.0



