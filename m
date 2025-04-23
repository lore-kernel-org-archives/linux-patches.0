Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E71657C9F;
	Wed, 23 Apr 2025 15:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421231; cv=none; b=QLXCt726O0vy7a5y5tAqBall7i/Z2TaZYzFgwfeXDRyl65kUvbA/Vz9ND6BcAMvFrrzmO3e5RgjoOji3CSnihObCaH/u4K2barux/+XIsk0a0Yt7K2ZHweMOd5fguU3C21NLqdzXgcP4BmoPmS7JgjHOsvgrJo6bGHZzUnbBNck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421231; c=relaxed/simple;
	bh=DdBU2tJJar09JQkTZMRtJCK3xZmjch3QFbNJhn+7iy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kI27ds6KW3lMCG0hTlXEDc4tQosgh/gwWaxVlUUn8I/ERwETP2G6kj8bwh0U7YCS9oixz1wqt28fVt50/o2gvIklheFzZR6rfic0EyHXVUdNIlw6ieNdlApbGkXL0JhZ3j9Uct8zIeut6gqvM86tDq0Xmn7mB7BGUWPa7qIJAd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qWwNbsH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qWwNbsH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AD0C4CEE3;
	Wed, 23 Apr 2025 15:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421230;
	bh=DdBU2tJJar09JQkTZMRtJCK3xZmjch3QFbNJhn+7iy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qWwNbsH4bkdBOr/JJBIo211m6fOAM+vptKhL2QIGlFU0L/SaO/YAznQPKBRpnKO7y
	 pmT3BXL5MrWCcvve+vAW+Z06ISN0IW/AaW9lDZYTkkUWeU7n/FCV7FdEKY+aZugtLa
	 h+KtiOgM/MRooZPztBExFVvve16Huwp+zYa+IY3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuli Wang <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 203/223] LoongArch: Eliminate superfluous get_numa_distances_cnt()
Date: Wed, 23 Apr 2025 16:44:35 +0200
Message-ID: <20250423142625.438801395@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Yuli Wang <wangyuli@uniontech.com>

commit a0d3c8bcb9206ac207c7ad3182027c6b0a1319bb upstream.

In LoongArch, get_numa_distances_cnt() isn't in use, resulting in a
compiler warning.

Fix follow errors with clang-18 when W=1e:

arch/loongarch/kernel/acpi.c:259:28: error: unused function 'get_numa_distances_cnt' [-Werror,-Wunused-function]
  259 | static inline unsigned int get_numa_distances_cnt(struct acpi_table_slit *slit)
      |                            ^~~~~~~~~~~~~~~~~~~~~~
1 error generated.

Link: https://lore.kernel.org/all/Z7bHPVUH4lAezk0E@kernel.org/
Signed-off-by: Yuli Wang <wangyuli@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/acpi.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/arch/loongarch/kernel/acpi.c
+++ b/arch/loongarch/kernel/acpi.c
@@ -249,18 +249,6 @@ static __init int setup_node(int pxm)
 	return acpi_map_pxm_to_node(pxm);
 }
 
-/*
- * Callback for SLIT parsing.  pxm_to_node() returns NUMA_NO_NODE for
- * I/O localities since SRAT does not list them.  I/O localities are
- * not supported at this point.
- */
-unsigned int numa_distance_cnt;
-
-static inline unsigned int get_numa_distances_cnt(struct acpi_table_slit *slit)
-{
-	return slit->locality_count;
-}
-
 void __init numa_set_distance(int from, int to, int distance)
 {
 	if ((u8)distance != distance || (from == to && distance != LOCAL_DISTANCE)) {


