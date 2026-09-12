Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D73D2F90C5;
	Sat, 12 Sep 2026 19:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240119; cv=none; b=sL85Ka+GeiLbgaOPbbLy3If/AANGPaxgIZarGK1bJfH5ZsxSY2WTsDK1NhvwsdhkPx4aXJ9TmWkuqWwblL1KqORQt9VBYuuSIjOp1EGlfA48fYU55cKn8+cqWIcy+9ds2SKnlCWHSvWREF8TXp2G74OffgybamlOmmgCAArWAfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240119; c=relaxed/simple;
	bh=cf/B4Zg7aBz8rmVU82et7pPB9nRvBWLKsX7jzCcBuKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yj7OJswTFUoxk717pJL2OzNUm+S7rKezhRXjIy4xoGJz7/pSmGVanaZy7CMl41hLqGppf6kdJjPcBp6YalhLGtJb2usFIqknEyppng+LREIYBkbq8xwJ95jD1dg68wVxxtHqp5qLD0HHK0Nu+r4fRdPvBpOGiAk2+IBxor0Kggs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xlwci0PD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xlwci0PD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED691F000FF;
	Sat, 12 Sep 2026 19:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240118;
	bh=tndO+jc9YuttLzukpEofI+5yf1x2OjiqOS1bwsiGjC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xlwci0PDsKBWgQ30k2NxDnN3NeQtb1QiY2ElGlisUrlHfgA0ilb/Tz8eqRY5hAtZU
	 QBrLjMJay2TItMmncTkCyiKUCTD6uTPNqHJS5Fude/BritSd56rRbN/KQJSwqlsRbr
	 gOMM6XZ/Bvxe5IA4mfWmNng3APk5XSYG8M44wN/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yucong Sun <sunyucong@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 802/935] selfetests/bpf: Update vmtest.sh defaults
Date: Sat, 12 Sep 2026 09:03:52 +0200
Message-ID: <20260912065545.233483816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yucong Sun <sunyucong@gmail.com>

[ Upstream commit 547208a386fa2066fa2d6d48bda145f78c38604f ]

Increase memory to 4G, 8 SMP core with host cpu passthrough. This
make it run faster in parallel mode and more likely to succeed.

Signed-off-by: Yucong Sun <sunyucong@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20211025223345.2136168-2-fallentree@fb.com
Stable-dep-of: 3a59f11e0f98 ("selftests/bpf: vmtest.sh: Preserve command quoting when running in the VM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/vmtest.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/vmtest.sh b/tools/testing/selftests/bpf/vmtest.sh
index 8889b3f552367..027198768fad3 100755
--- a/tools/testing/selftests/bpf/vmtest.sh
+++ b/tools/testing/selftests/bpf/vmtest.sh
@@ -224,10 +224,10 @@ EOF
 		-nodefaults \
 		-display none \
 		-serial mon:stdio \
-		-cpu kvm64 \
+		-cpu host \
 		-enable-kvm \
-		-smp 4 \
-		-m 2G \
+		-smp 8 \
+		-m 4G \
 		-drive file="${rootfs_img}",format=raw,index=1,media=disk,if=virtio,cache=none \
 		-kernel "${kernel_bzimage}" \
 		-append "root=/dev/vda rw console=ttyS0,115200"
-- 
2.53.0



