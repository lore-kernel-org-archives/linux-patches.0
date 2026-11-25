Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618688;
	b=dd9snBCkH8cQ7ByXluyZHf//7GSBlhxYEytiCCHlX/dXgMcZJ15SRGw1Hm81arBlVnKc
	 KI/9HKBLQgKrW9hWxpObOM7i7LYX9K0gWKAsXp0xvSAzK3x6YXGQc2b8t7Vza5dUEHSzx
	 Jr0LYXnjzwcYHCPR6O+ej1m1wrL0wk/XDgjtiWhoMCFIH57pZA3xOghqrwsmeoA45kIpm
	 nzo8JRORbjx9xqndU7RYcLn7M/ifv09fyMg+beHu2VYudvhwgERHYsrdYKtRlzsUs2IQX
	 MTszpEKNL03qYcZRJEIiA9Ti7Chrv++zzVufJTtJc+6E8uDfhnDF2Bz8qRv9zrKikHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D/yofcwLoVyqNaY2zBD416R8BB6egFVG/cvphwEEq8A=;
	b=VywZh7EmLg57tD/5zhkfbzL+lkLHzNglcR2zZlZvOkRoOB04F3Ok+AH6RMHD2QBcIKCf
	 AucQcfXWfpNYGqMsV4t1tD7Lo/Qqj4UVA0g4we4XVdDmH7vRqdMuy4vWTyVOjfH8MbMCY
	 VNpSJODV7Jvy9F0YPoJ9Wjp4i4WVZ53PbjjDlP8q1qefiqIkxlUHiF47W/3GP3LqSNwit
	 +RUNjJlx8MjPx5r6g4mCYSo1RByb5GiYw5ujWtVwooDqAZrOtEllKgOJchU0Xa9phewRB
	 OgiIrHPasheL2uLgDpxEeGdo/7H1QqC0xbIVWZEtT+Q6UVNZcabOIztCesYqiPfDWHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LYDALb3b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8137A606A321;
	Wed, 25 Nov 2026 14:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LYDALb3b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF551F000EF;
	Wed, 25 Nov 2026 14:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618688;
	bh=D/yofcwLoVyqNaY2zBD416R8BB6egFVG/cvphwEEq8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYDALb3b1R+hsQFVnjn12k7N129L0BFUee9azp2wsX9c7i2Eaw/ZSMyvd15Ip4VBL
	 h5yAq+jlQ++DzLVk+lTQ6NqVZUGOu3wm7f8y00rPJ0FzVqTAvThaYnqRIhWCsgddhe
	 NyZl1Wtc5zSQc6xq3yOdyG4mnIG12GEd1fsHlH2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0356/1005] perf/x86/amd/uncore: Avoid context migration from non-owners
Date: Wed, 25 Nov 2026 15:28:14 +0100
Message-ID: <20261125143830.072873044@linuxfoundation.org>
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

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit 0ae655bce1934857fa3e316ddcb4be38c30dbd38 ]

Each uncore context is owned by a single CPU that hosts all events for
the corresponding uncore domain and is advertised through the sysfs
cpumask attribute. When a CPU goes offline, the context is migrated to
an online sibling if the departing CPU is the owner.

Before commit d6389d3ccc13 ("perf/x86/amd/uncore: Refactor uncore
management"), uncore_down_prepare() checked whether the CPU going
offline owned the context. The check was lost when the function was
replaced by amd_uncore_ctx_move(). Hence, when a CPU that is not the
owner goes offline, ownership is always handed over to the first online
sibling in the uncore domain irrespective of whether another sibling
already owns it. This goes unnoticed as long as the owner is the
lowest-numbered online CPU in the domain, since the first online
sibling is then the owner itself. Once ownership has moved, that no
longer holds.

For example, consider an L3 domain spanning CPUs 8-15,136-143 and owned
by CPU 8.

  $ cat /sys/bus/event_source/devices/amd_l3/cpumask
  0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120

  $ echo 0 | sudo tee /sys/devices/system/cpu/cpu8/online
  $ cat /sys/bus/event_source/devices/amd_l3/cpumask
  0,9,16,24,32,40,48,56,64,72,80,88,96,104,112,120

  $ echo 1 | sudo tee /sys/devices/system/cpu/cpu8/online
  $ cat /sys/bus/event_source/devices/amd_l3/cpumask
  0,9,16,24,32,40,48,56,64,72,80,88,96,104,112,120

  $ echo 0 | sudo tee /sys/devices/system/cpu/cpu10/online
  $ cat /sys/bus/event_source/devices/amd_l3/cpumask
  0,8-9,16,24,32,40,48,56,64,72,80,88,96,104,112,120

Offlining CPU 8 correctly moves ownership to CPU 9 and onlining it
again leaves CPU 9 as the owner. However, offlining CPU 10 then makes
CPU 8 the owner while existing events remain on CPU 9. Both CPUs are
now advertised for the same domain, so tools that open an event on
every CPU in the cpumask count the domain twice, and the context gets
modified from two CPUs without any synchronization.

Restore the ownership check that was lost during the refactor.

Fixes: d6389d3ccc13 ("perf/x86/amd/uncore: Refactor uncore management")
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/273135a6d33a40f442fb18e140a90689fae7cd32.1793614726.git.sandipan.das@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/uncore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index 7181973b5b127..b58e0ada85467 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -610,7 +610,7 @@ static void amd_uncore_ctx_move(struct amd_uncore *uncore, unsigned int cpu)
 	for (i = 0; i < uncore->num_pmus; i++) {
 		pmu = &uncore->pmus[i];
 		curr = *per_cpu_ptr(pmu->ctx, cpu);
-		if (!curr)
+		if (!curr || curr->cpu != cpu)
 			continue;
 
 		/* Migrate to a shared sibling if possible */
-- 
2.53.0



