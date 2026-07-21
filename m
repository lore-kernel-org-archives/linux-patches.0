Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF622471252;
	Tue, 21 Jul 2026 19:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660942; cv=none; b=X/HYyc+ERj7KYbtnOEGimKyWwO5C892tMKNV4gbu1VpSxH1kXVp/Y4E0aVmjOD+Z4XWlmT4tImh5UA/VZMNoqlSrlUrByYsQdMudPYj6P47Y0KR0r6dP+jJ3yG5NfHbj2PHFdAqup/pWmFe5utvrT+V4dSp1eRHRw0aCnIrNPLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660942; c=relaxed/simple;
	bh=Qal5kgyXnDS9UauJNKIIqu+pTUvj2YOHHrynoKdZ+Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEDreys3CvVp7KX1qZFAHuAX2lsbVRw2+lnWmu0MLuh5AdQ4e9vmj7HhqZO6edRQ3nX59K7NTjnRfvF62kle2obfxgfkOwJ9nCM0pp1rFk+Wua7hVOGmWGjuh47/Uoexw5dbmxkm7SHnMIjGshsN5qjYrBim6HdDPdqew8GwPQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FrkHMFMr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FrkHMFMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CF81F000E9;
	Tue, 21 Jul 2026 19:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660941;
	bh=bSqwOBeSUHN+A6BGPL4Zh7cqXncaF9hkici5ckv4eds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FrkHMFMrELrMdbiif1mkF0z4Cd42k4HDHyj75/a5GmLyXVuLQFvomhdH9iZ4owqUW
	 0dcqdj2N0OI0gQHvQVsUIv6HIz0SgZFw+Ep6Z92SVdU1Tr80R1j+mszu6cjzZJMLJh
	 gVoI5Z6qO40K+HU7gNjcUY37Y4OvNu4Z31VR5c6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sayali Patil <sayalip@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1171/2077] selftests/mm: clarify alternate unmapping in compaction_test
Date: Tue, 21 Jul 2026 17:14:04 +0200
Message-ID: <20260721152620.441149080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sayali Patil <sayalip@linux.ibm.com>

[ Upstream commit 69ba1d76d93ab818245333cf400928477ba72053 ]

Add a comment explaining that every other entry in the list is unmapped to
intentionally create fragmentation with locked pages before invoking
check_compaction().

Link: https://lore.kernel.org/da5e0a8d5152e54152c0d2f456aac2fac35af291.1779296493.git.sayalip@linux.ibm.com
Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/compaction_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
index 30209c40b69778..e1610e2fbdf64f 100644
--- a/tools/testing/selftests/mm/compaction_test.c
+++ b/tools/testing/selftests/mm/compaction_test.c
@@ -261,6 +261,9 @@ int main(int argc, char **argv)
 		mem_fragmentable_MB -= MAP_SIZE_MB;
 	}
 
+	/* Unmap every other entry in the list to create fragmentation with
+	 * locked pages before invoking check_compaction().
+	 */
 	for (entry = list; entry != NULL; entry = entry->next) {
 		munmap(entry->map, MAP_SIZE);
 		if (!entry->next)
-- 
2.53.0



