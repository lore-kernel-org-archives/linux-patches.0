Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E3243E490;
	Tue, 16 Jun 2026 17:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629752; cv=none; b=KIEjvbHdksNSOw0m2G9HUz3XajehGWqhCtHbmA/1jONfsCVG6pIrlXe01699F38/FuBnodZtUx2y4zG4fKXjw8Ke1Z99ZKsTF9B3OFgRyl8YQhDPlm0dndowaknalWSITtVM/AtRjRurJbgxPZB2JW7Z5CeW9sSJQN4E7pIsCiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629752; c=relaxed/simple;
	bh=ilg+wBRfySU4Af6lKmaV7UtgBF+3+a1caEnDIsc5oVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scwZE8pCat3MtXz5II/GQ27Ookn232GWq4rfep9We1XaS8hwkfspEbtYFm8/kuICtcamZLZ/61e6yuQraJJwKINJkhDWOOd4HE5p4XUWoLiVBSynFlL6eQ8slZ9ZtkkYPDNYUXgh44zaMgHjc751qqa81P7Nfq7fAHuPxOEDcLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHyKR4G6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHyKR4G6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536331F000E9;
	Tue, 16 Jun 2026 17:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629751;
	bh=fflmoGkNn7oneBcmY3x1rntzsngO6rt3tKmIPCOWbHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FHyKR4G6feC+fKfF0nTn1nsaFOAJuO4TyP/8l64fOVBRqMobJraitOQc+gjR20uon
	 6GZ8QjJSuJoXrZZxiw/F9RmdJloz4YHKZq37GtlyfwPTmlb+nPejfalkM3bomqePt+
	 +qJ1kc2y4TpJolaljwpBLrGttHKIeCuarShBdHbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Zhenzhong Wu <jt26wzz@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 346/452] selftests/bpf: Update comments find_equal_scalars->sync_linked_regs
Date: Tue, 16 Jun 2026 20:29:33 +0530
Message-ID: <20260616145135.422038678@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit cfbf25481d6dec0089c99c9d33a2ea634fe8f008 ]

find_equal_scalars() is renamed to sync_linked_regs(),
this commit updates existing references in the selftests comments.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240718202357.1746514-5-eddyz87@gmail.com
[ zhenzhong: only two pre-existing comments still needed updating in 6.6.y. ]
Signed-off-by: Zhenzhong Wu <jt26wzz@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/verifier_spill_fill.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/verifier_spill_fill.c b/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
index 1f71f596d33f8b..07a2527a8f47a7 100644
--- a/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
+++ b/tools/testing/selftests/bpf/progs/verifier_spill_fill.c
@@ -392,7 +392,7 @@ __naked void spill_32bit_of_64bit_fail(void)
 	*(u32*)(r10 - 8) = r1;				\
 	/* 32-bit fill r2 from stack. */		\
 	r2 = *(u32*)(r10 - 8);				\
-	/* Compare r2 with another register to trigger find_equal_scalars.\
+	/* Compare r2 with another register to trigger sync_linked_regs.\
 	 * Having one random bit is important here, otherwise the verifier cuts\
 	 * the corners. If the ID was mistakenly preserved on spill, this would\
 	 * cause the verifier to think that r1 is also equal to zero in one of\
@@ -431,7 +431,7 @@ __naked void spill_16bit_of_32bit_fail(void)
 	*(u16*)(r10 - 8) = r1;				\
 	/* 16-bit fill r2 from stack. */		\
 	r2 = *(u16*)(r10 - 8);				\
-	/* Compare r2 with another register to trigger find_equal_scalars.\
+	/* Compare r2 with another register to trigger sync_linked_regs.\
 	 * Having one random bit is important here, otherwise the verifier cuts\
 	 * the corners. If the ID was mistakenly preserved on spill, this would\
 	 * cause the verifier to think that r1 is also equal to zero in one of\
-- 
2.53.0



