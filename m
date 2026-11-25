Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619697;
	b=aNvOty0UyEyx4Gx0/HvHSBIFiBcZ2IFnOLQAC8Ib9yHq0qcBf9tOLttyeiAXZkg4hMPm
	 12up999gBevRzIulPvIxyw37VFViR48Fqcr8FjXLGJ3Q3hCcTdVM7szLfiBEHrrgTFwvZ
	 PYwQZ82P1C8eUSIC9qxjc1KUu2zlBIJuXa2K43divTTlDXxYCM2TEk2YvvpT5vtQHmuYQ
	 o8r5QJd+bV4Pi8zNExMA/wL8p/7N1UVsPS8w94Ihg+HFiv3cEzfufnaGFAexJoIzbKIv7
	 uFvJlXku6UAzUW89qy4WEVeRkX1BTwa98b/kv9eqFgkWI7m6QxcE35l//dEhhffQfnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xIv2NkbQZHVJzRjICSEzAKCpqYHqE5yjPWeQRr6GpGI=;
	b=ySf11fiUXmnil56Qc7+XiJlFLrqD30DFG7OOcl0oJhYxVCDlwifTAClEc6MoxaKtAagb
	 4tgN2vJnYzOl9sAQ/Z+L6wR6lsgpwluVizbRHInw5j0DdDtCca5NOGcqByDDaaa2DaF0S
	 qmXjz+K6f+vbK7ypc0OW1n4rOY3peWvy5TxDGAxhW8vyI1+xdedohEwsBKWQrn8X9yU1g
	 j5KDAA4RnrWBUboIMumyjP1q1t5xN5YdOlDTwtnI3yGnEEBUblR46HSN188vJdMoccNYe
	 CfDn8QkBSeonjsbPmedreJtAd1q3U3NLxgKr+PBppJE1eSD63c3vwmNf4f1a5bjpR0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pvT0pG0J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70746606A321;
	Wed, 25 Nov 2026 15:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pvT0pG0J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F041F000C6;
	Wed, 25 Nov 2026 15:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619697;
	bh=xIv2NkbQZHVJzRjICSEzAKCpqYHqE5yjPWeQRr6GpGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pvT0pG0JvP+iLcGRlVKSZw4Tj1psThzFauTrYvJnZEfgZTbEyW4VnRNZ8wwDQe/QH
	 37t20KvJy+07CMWs5L9UWaZQDmeGawMwcePnC/1Ol7P1qReslZDSt+x/TkFeC7R3h9
	 x65rr9uwrTNacd/QTsYwqeiph8xNa8HzOjoT4SUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Chen <dechen@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.3 0679/1005] Revert "powercap: intel_rapl: Expose all package CPUs in PMU cpumask"
Date: Wed, 25 Nov 2026 15:33:37 +0100
Message-ID: <20261125143837.661428033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dennis Chen <dechen@redhat.com>

commit a74c332aaf46270101b32a32311275d86953a2b5 upstream.

Commit 525e0064f3d8 ("powercap: intel_rapl: Expose all package CPUs in
PMU cpumask") expanded cpumask to include all CPUs in the package.
Since perf opens an event for every CPU in cpumask, the value returned
for power/energy-pkg/ is roughly scaled by the number of CPUs.

On a single-socket 72-core DMR machine the reported value is roughly
72x higher than when perf is restricted to reading from a single CPU:

$ perf stat -e power/energy-pkg/ -- sleep 1
 Performance counter stats for 'system wide':

          8,052.48 Joules power/energy-pkg/

       1.010483558 seconds time elapsed

$ perf stat -C 5 -e power/energy-pkg/ -- sleep 1

 Performance counter stats for 'CPU(s) 5':

            112.15 Joules power/energy-pkg/

       1.009685587 seconds time elapsed

Reverting this commit restores the expected behavior for perf.

Fixes: 525e0064f3d8 ("powercap: intel_rapl: Expose all package CPUs in PMU cpumask")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Dennis Chen <dechen@redhat.com>
Link: https://patch.msgid.link/20261106203115.237269-1-dechen@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/powercap/intel_rapl_common.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 70cab5f08bc6..f58649ff4f53 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -1139,21 +1139,23 @@ static struct rapl_pmu rapl_pmu;
 
 /* PMU helpers */
 
-static void set_pmu_cpumask(struct rapl_package *rp, cpumask_var_t mask)
+static int get_pmu_cpu(struct rapl_package *rp)
 {
 	int cpu;
 
 	if (!rp->has_pmu)
-		return;
+		return nr_cpu_ids;
 
 	/* Only TPMI & MSR RAPL are supported for now */
 	if (rp->priv->type != RAPL_IF_TPMI && rp->priv->type != RAPL_IF_MSR)
-		return;
+		return nr_cpu_ids;
 
 	/* TPMI/MSR RAPL uses any CPU in the package for PMU */
 	for_each_online_cpu(cpu)
 		if (topology_physical_package_id(cpu) == rp->id)
-			cpumask_set_cpu(cpu, mask);
+			return cpu;
+
+	return nr_cpu_ids;
 }
 
 static bool is_rp_pmu_cpu(struct rapl_package *rp, int cpu)
@@ -1435,6 +1437,7 @@ static ssize_t cpumask_show(struct device *dev,
 {
 	struct rapl_package *rp;
 	cpumask_var_t cpu_mask;
+	int cpu;
 	int ret;
 
 	if (!alloc_cpumask_var(&cpu_mask, GFP_KERNEL))
@@ -1446,7 +1449,9 @@ static ssize_t cpumask_show(struct device *dev,
 
 	/* Choose a cpu for each RAPL Package */
 	list_for_each_entry(rp, &rapl_packages, plist) {
-		set_pmu_cpumask(rp, cpu_mask);
+		cpu = get_pmu_cpu(rp);
+		if (cpu < nr_cpu_ids)
+			cpumask_set_cpu(cpu, cpu_mask);
 	}
 	cpus_read_unlock();
 
-- 
2.56.1



