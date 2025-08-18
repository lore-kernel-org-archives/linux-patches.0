Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAD4322760;
	Mon, 18 Aug 2025 13:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525569; cv=none; b=WqFZcSrA2uJq2YxEBKEscxyzRnTz39JRUQLlYQjlVZEWalwMo1NMDiBHM0U3/2m04/8dQD1EepP7Z6fZIBn7YuER7zRZfybul6XYY6BfCaoDEwMhcEu3FfClQDOH8ljKCiB0sBfxS1JUQcujsscWbnh4XJskX4h/REUdaIy90x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525569; c=relaxed/simple;
	bh=3jb6NtrIRc6pqp40mAkL8Lkg+VIG5V5VGDytvT57fgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtsX0y+An7w/WJZg1MxgxnMXQLjIkL6P8zRqugeDNYpCJ/7ncdqU1m7PTsfw/+a8JjBRMqfweoKiLN8zk43x4ISkBbmxfeSXBU6stH2ZCPPE6WmtXwUbXGPUFrKwz10R/B8L74KwwgFe49ss+riKmDiGsyUm7L6Iey4eZoAVRo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuMRdjNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuMRdjNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EA7C4CEEB;
	Mon, 18 Aug 2025 13:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525569;
	bh=3jb6NtrIRc6pqp40mAkL8Lkg+VIG5V5VGDytvT57fgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zuMRdjNSa8gsDbivIHOaP93jZ3VNj+zyWH4RiVuZJhcJfrnvcVwY7iqMaXgTA0ZsG
	 AX07x8zigl/DjtaqRCbCErcey8DxM4ZcY069/ZdNJhWV9ZNty36W6ZGsf1NzrqIIX2
	 TqUN2Km8hhHqHGc/NsSG3DaXFqRqjxV8QETUXEdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathan.lynch@amd.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 301/570] lib: packing: Include necessary headers
Date: Mon, 18 Aug 2025 14:44:48 +0200
Message-ID: <20250818124517.457007341@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 0589d70bbe04..20ae4d452c7b 100644
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
 
 #define GEN_PACKED_FIELD_STRUCT(__type) \
 	struct packed_field_ ## __type { \
-- 
2.39.5



