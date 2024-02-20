Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1DB612D7;
	Tue, 20 Feb 2024 21:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463580; cv=none; b=BF/OQEMwkonY9P3rY4SIp9UIxxiOowgiz0ejjLWZ6ac1xfjuZAmvsXHCLlIe4EoYIi5vVCFhSsZUMO38H4pPF/q9VyVGVJuZZsCTCqjIl32e35to1MIsDKXc1aDf2xklH/blBYfnoJEFCqpymLQn8hWH3vnC6X4uSjAOfjeI8zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463580; c=relaxed/simple;
	bh=Gf+PXDv/glCN2r6YuCThsHY5oQTQvwnWlGxQFmYII0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4X1vWRRA70rLXS/qnrmxK+aIWl52N9Y4kskP5v51xiSxj4CiUP7haZmnD4+WPRpN4x7RRfM0Y2OCxB6VNklqjInW5JRLpkApzIiFvoQHRGEnCfuojktsEW/trKdP6sK72YNJnA046sAy951Ewvnh0Oz/zxDn+gxsrGVfDsQR/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQTakN6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQTakN6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37E6C433C7;
	Tue, 20 Feb 2024 21:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463580;
	bh=Gf+PXDv/glCN2r6YuCThsHY5oQTQvwnWlGxQFmYII0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQTakN6+IrrXN1vQTVtt7jqmjOLUidxJTzVQ6QMu5DXXVYWHw7lgEJBtswZe/T5+d
	 iO1DdizyLgYvhE9EMxmpAhoreCk1BC49BSYeIWfuaG2OAO/TSe7u95xgZUPmb53ao1
	 8UvAY8CrZ4eL9ex87atDN4zMt7hvXRIj71KPrQow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Shuah Khan <shuah@kernel.org>,
	David Laight <David.Laight@ACULAB.COM>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 059/331] selftests/mm: switch to bash from sh
Date: Tue, 20 Feb 2024 21:52:55 +0100
Message-ID: <20240220205639.454006459@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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


