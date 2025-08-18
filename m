Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490DE1F462D;
	Mon, 18 Aug 2025 13:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522143; cv=none; b=Vju6MOvl1sRZJFcQxgG/3sgMjPdxqAhE0mYmqZmAGkbLTFvZ7WagEAqJLarM6AjRWi4qFlDXyWkwNTwqwqDrkhm4VT3TbKUZFfS19CzVjdpM4UVZ+kKDyqVo5JpzcBH9RuxKfTkuw2cSyjBxUSfif3EsTLw5ElhFH/R6bCQPjWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522143; c=relaxed/simple;
	bh=fWyefhSZHgPqDg3ygr+o1tqx7WGaIDpy67mzagh0rME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAZxws47M6SH0WMUY7SaZiXthV4+5IWSJrIi/o/jBwxW6iH4mJ5nLOg8P4TeWubtu9L1j66+iuB6TZVul0E1hogeqI3nwmTF4x77COE7OibtY1sZIV5PoiN5Q/mECQVZdMPeXJ7u8QXw3eombNVJUHTvsbTZQQ6uctgZgX1OgvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gkAZDkVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gkAZDkVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7170C4CEEB;
	Mon, 18 Aug 2025 13:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522143;
	bh=fWyefhSZHgPqDg3ygr+o1tqx7WGaIDpy67mzagh0rME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gkAZDkVX5E4hRYNvp4L8PSwnHNUXm5ZCxZqrXliCKA4nV1ota8+GVqfmdYTtgACIX
	 b+6oQg8UeVHZBRzgITCtNCAWvBOXRhSA+Fk2TCvhmy1tE4HZkOZPsyI0ijWB6yS2xG
	 eK9ANqeV6oqN44H6GQmO45Kio0UTW6B6MpA8/Ol8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathan.lynch@amd.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 229/444] lib: packing: Include necessary headers
Date: Mon, 18 Aug 2025 14:44:15 +0200
Message-ID: <20250818124457.429062123@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathan.lynch@amd.com>

[ Upstream commit 8bd0af3154b2206ce19f8b1410339f7a2a56d0c3 ]

packing.h uses ARRAY_SIZE(), BUILD_BUG_ON_MSG(), min(), max(), and
sizeof_field() without including the headers where they are defined,
potentially causing build failures.

Fix this in packing.h and sort the result.

Signed-off-by: Nathan Lynch <nathan.lynch@amd.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20250624-packing-includes-v1-1-c23c81fab508@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/packing.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/packing.h b/include/linux/packing.h
index 8d6571feb95d..60117401c7ee 100644
--- a/include/linux/packing.h
+++ b/include/linux/packing.h
@@ -5,8 +5,12 @@
 #ifndef _LINUX_PACKING_H
 #define _LINUX_PACKING_H
 
-#include <linux/types.h>
+#include <linux/array_size.h>
 #include <linux/bitops.h>
+#include <linux/build_bug.h>
+#include <linux/minmax.h>
+#include <linux/stddef.h>
+#include <linux/types.h>
 
 #define QUIRK_MSB_ON_THE_RIGHT	BIT(0)
 #define QUIRK_LITTLE_ENDIAN	BIT(1)
-- 
2.39.5



