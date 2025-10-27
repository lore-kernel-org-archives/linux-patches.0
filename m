Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89967274FD0;
	Mon, 27 Oct 2025 19:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592813; cv=none; b=RlQ5zcjU3U9nJwrtTPiuQLUM3eDTC037m7iFSJ9OA8bXFRPWTDzMMoWQ07bGxpIuZ3tofX8AZWcrYuayFNpnvhCzHP8sVi7oh9uwGPid5K+cwWDrs0D3veR6dB07dUF0LmetaoukBORCuruvWG92786Wxn55/mHOpWiYpF/xVV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592813; c=relaxed/simple;
	bh=GpdUjxTyZ0lgkCjn7yRhAOxnzpMcbWBS3GYstG5CViY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1QPy5wUpenqEdoXnp+ina4NB4Al0ypQIVDwWhKU06bFsvQSeOAKCZrYdqX3sIC5jSnB2/H/haQAyPD6KaFPfaShSlorx2+HXTX+Xma63rnbdugT1HESuyCDJ4QX5hoaQRNhEQCJtyvWyWTi6EldElYQHYkzittXXoNR5Lcdrdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYn2v9JX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYn2v9JX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18EC7C116B1;
	Mon, 27 Oct 2025 19:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592813;
	bh=GpdUjxTyZ0lgkCjn7yRhAOxnzpMcbWBS3GYstG5CViY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYn2v9JXNXCkkOonNN0lddhALXUOyEorcad2MSJ5XG3Ge4G8SWAKQaKpWS7FSlJNR
	 eENrjHpMaceH2uME241/LP+5YFkczsrBZHuRfREgP5RPaxOfIR+tww5rzzUF3bLTms
	 8LIe7yaoxuDZ2j1VBVlAlCsucT4xhqS+/eznepGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/117] PM: EM: Drop unused parameter from em_adjust_new_capacity()
Date: Mon, 27 Oct 2025 19:35:47 +0100
Message-ID: <20251027183454.528588602@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 5fad775d432c6c9158ea12e7e00d8922ef8d3dfc ]

The max_cap parameter is never used in em_adjust_new_capacity(), so
drop it.

No functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/2369979.ElGaqSPkdT@rjwysocki.net
Stable-dep-of: 1ebe8f7e7825 ("PM: EM: Fix late boot with holes in CPU topology")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/energy_model.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -723,8 +723,7 @@ free_em_table:
  * are correctly calculated.
  */
 static void em_adjust_new_capacity(struct device *dev,
-				   struct em_perf_domain *pd,
-				   u64 max_cap)
+				   struct em_perf_domain *pd)
 {
 	struct em_perf_table *em_table;
 
@@ -795,7 +794,7 @@ static void em_check_capacity_update(voi
 			 cpu, cpu_capacity, em_max_perf);
 
 		dev = get_cpu_device(cpu);
-		em_adjust_new_capacity(dev, pd, cpu_capacity);
+		em_adjust_new_capacity(dev, pd);
 	}
 
 	free_cpumask_var(cpu_done_mask);


