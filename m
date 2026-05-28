Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EDA2F260C;
	Thu, 28 May 2026 20:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998806; cv=none; b=rUaQYiCP9P7Hzrkqb9cz1aaYNrA5puA8xZWJlXV6aKYmm06Vj8yuPLxK4EVbnx5O2gx+kR7D5qv/1ttn82iEWpJMBXoz687GWtD72xjW9/vutoBW6NZkNIhT0XY2sZVw9e76F/PtfRcvkKwz1hEr7anD/PSLmqwjzD4XXLsyyqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998806; c=relaxed/simple;
	bh=l0384P8aD67LKl0hFKVLZZBk3BWeC6CaoiWnec3R7eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJMVbGkZCHpPW0ZJlbdXPrBLspu1TacIu0FZuZAssfcj9VC4xxVka6D0Kt1SXQMVCDC2nu11ZQXSh1IPOJOmbODCwaFMbFq6d9Vj6Z/SFzVJBKY/lXERFJxrxIP0yPPlYvgeai9ty0fff5vo+v4O7r9H8e1Q+58zhJMbZxEPfRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJNbtx6B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJNbtx6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF351F000E9;
	Thu, 28 May 2026 20:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998805;
	bh=x7StZ03QLOVV5kI2NWVJV+/e5VhWiJ6FfTUdeZRNz0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJNbtx6B0ZXHIUT3qm0um7leY2ojS58CWMH7ItLYQiEC9UG6zWvMAIb8XlG5a7WIS
	 tDs/QXOC5EEcLicK8xcA+KZl2Pn5uEa0fJsFuHSeCbHxTH8Oi4NQc6P3OUcPIjT1o+
	 UUNtQQSdUcS2VueZz9k4JLQZqGqS1hyiHpcDgTYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 303/461] Documentation: intel_pstate: Fix description of asymmetric packing with SMT
Date: Thu, 28 May 2026 21:47:12 +0200
Message-ID: <20260528194656.020748566@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

[ Upstream commit ee047fc7a2da90554410128195058c409a391d43 ]

Patchset [1], including commits

 046a5a95c3b0 ("x86/sched/itmt: Give all SMT siblings of a core the same priority")
 995998ebdebd ("x86/sched: Remove SD_ASYM_PACKING from the SMT domain flags")

overhauled asym_packing handling in the scheduler on x86 hybrid
processors with SMT. It removed SD_ASYM_PACKING from the x86 SMT
scheduling domain and made all SMT siblings of a core share the same
priority. As a result, asym_packing operates only across physical
cores, spreading tasks among them and only using idle SMT siblings
once all physical cores are busy.

Fix the documentation to reflect this behavior.

Fixes: f20af84c29b2 ("cpufreq: intel_pstate: Document hybrid processor support")
Link: https://lore.kernel.org/r/20230406203148.19182-1-ricardo.neri-calderon@linux.intel.com [1]
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
[ rjw: Changelog edits ]
Link: https://patch.msgid.link/20260424-rneri-fix-intel-pstate-doc-smt-asym-packing-v1-1-317bf7d5c362@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/pm/intel_pstate.rst | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/pm/intel_pstate.rst b/Documentation/admin-guide/pm/intel_pstate.rst
index fde967b0c2e0e..25fe5d88fea6c 100644
--- a/Documentation/admin-guide/pm/intel_pstate.rst
+++ b/Documentation/admin-guide/pm/intel_pstate.rst
@@ -355,11 +355,12 @@ HyperThreading (HT) in the context of Intel processors, is enabled on at least
 one core, ``intel_pstate`` assigns performance-based priorities to CPUs.  Namely,
 the priority of a given CPU reflects its highest HWP performance level which
 causes the CPU scheduler to generally prefer more performant CPUs, so the less
-performant CPUs are used when the other ones are fully loaded.  However, SMT
-siblings (that is, logical CPUs sharing one physical core) are treated in a
-special way such that if one of them is in use, the effective priority of the
-other ones is lowered below the priorities of the CPUs located in the other
-physical cores.
+performant CPUs are used when the other ones are fully loaded.  SMT siblings
+(that is, logical CPUs sharing one physical core) are given the same priority.
+The scheduler can pull tasks from lower-priority cores and place them on any
+sibling.  Since the scheduler spreads tasks among physical cores, tasks will be
+placed on the SMT siblings of physical cores only after all physical cores are
+busy.
 
 This approach maximizes performance in the majority of cases, but unfortunately
 it also leads to excessive energy usage in some important scenarios, like video
-- 
2.53.0



