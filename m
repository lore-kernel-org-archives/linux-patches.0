Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D5614A4E6;
	Tue, 20 Feb 2024 21:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464575; cv=none; b=fKbj0+wUDc6cAGAGWvrETSNdN+8FYcotIaA5gi5MqpU7TUAuXfRjl0vgpCJuzXcTOnpUOQBtoTBjsrqQqE9Qoh7q9PagpuNcW9CiZmIgqes7mufLSx0lqyF+ZiUHk+97e9FUYaCudClc0+CRyTm1TKAlN1JBI3UyaBcDjUotnkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464575; c=relaxed/simple;
	bh=TguUUsSJgZ4W4YoJtfLSE+kZi6o3/cTg4oY1CgMzj9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqUxIfT3yawLL/BDKI+MAqOrk0o8kQh5QzX8rW72AxiSzApZYmvB7lb45e1yne+GCN2CSlCgXKRnjpoQ+i+IoXuJ578pNDt8Wg8cHsoqo5D3h1DdjZopqhRzgMJETP+8MOwAzsGyI8E47meuMGJ26Z5911f9QHd+uoe2uTM715Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eb78KcAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eb78KcAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173BCC433F1;
	Tue, 20 Feb 2024 21:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464575;
	bh=TguUUsSJgZ4W4YoJtfLSE+kZi6o3/cTg4oY1CgMzj9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eb78KcAdtXPO2fOJ2337/pxE4M0/1gmCxJ3e/vkr2onNMfYTi+1Zc4aXpGRaZVtMn
	 Z/ykYD7dUcEtDsbCsWAALHJflD0/Kna9IikW6yOxsPdPfFLTWXKF0uuIuAilLbzmwc
	 58cFVRpLfpLP4YmhyX23wKH500bgmcGu7guuH8ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Shuah Khan <shuah@kernel.org>,
	David Laight <David.Laight@ACULAB.COM>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 069/309] selftests/mm: switch to bash from sh
Date: Tue, 20 Feb 2024 21:53:48 +0100
Message-ID: <20240220205635.368039342@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

commit bc29036e1da1cf66e5f8312649aeec2d51ea3d86 upstream.

Running charge_reserved_hugetlb.sh generates errors if sh is set to
dash:

./charge_reserved_hugetlb.sh: 9: [[: not found
./charge_reserved_hugetlb.sh: 19: [[: not found
./charge_reserved_hugetlb.sh: 27: [[: not found
./charge_reserved_hugetlb.sh: 37: [[: not found
./charge_reserved_hugetlb.sh: 45: Syntax error: "(" unexpected

Switch to using /bin/bash instead of /bin/sh.  Make the switch for
write_hugetlb_memory.sh as well which is called from
charge_reserved_hugetlb.sh.

Link: https://lkml.kernel.org/r/20240116090455.3407378-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/charge_reserved_hugetlb.sh |    2 +-
 tools/testing/selftests/mm/write_hugetlb_memory.sh    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
 # Kselftest framework requirement - SKIP code is 4.
--- a/tools/testing/selftests/mm/write_hugetlb_memory.sh
+++ b/tools/testing/selftests/mm/write_hugetlb_memory.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
 set -e


