Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829316;
	b=5kT/b5fkQE0upuiKrlzEhtvnDTkZ0NJm8lJ0sfKQeDCgcTf6ZJTGK9Pnes17GvJqzakv
	 o4tAJ6EaKbgr0ec/JYge7pzqdl7jt4Y+fs2HMVqHzobRp6Wq/tuwXFrrKlQqh32YtDQN3
	 jYanAXKEgt89laELTjyvsWX84wHsmSBvqNvDODALQbQIYSwI36eAjCE8wbBCbhScdS8ii
	 /DYnayT4x4xIPIsTByrFSk2SIgqsbgucOr6Gf7APHRYrNbYDmHTEGRaEH0sEZaOhS1QLh
	 kbvtKfoE+JGCwGuF6omMlRrwyRco7AK/2dCeEnw/KF7A3P39twBLwqOVBfTvINRVcwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e6/cZgK1/qd/ZcJ551DcnlFqNmke/MvIffv0wXHoZiw=;
	b=0iUb10FeFRTw87KjqWlZ2F77mBof/tZNzQf/fb/sLSiXIT+levyIIvlDL/UNOMZRNVmn
	 qKNwhS4BaIKrTcMONS98b25JLcmev0sCYDerxoGJ3JF60gFYRnNwcQAavDldOYuWHZ8rx
	 f6chJbbONXI/+1hbzIoQFz3ZSwRYXwLIO10aRHllDisR1hTfJmm7/ASJtWXIkd3pXVXal
	 Nm7qmg3EtBoV+T7E73hTruU0OTmpkUFh4ZQAEh9xgimCTFsZKwoozbJHQhRUUnn3CGZYD
	 9BVa/gEgbgQiV/gU4cLD/AAsEdDhcIUYkEih86uk7/ZqhgPgvgIzqOTyqB3/kSij/fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z2tU3H49;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DF16074917;
	Wed,  4 Nov 2026 21:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z2tU3H49
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C031F000C1;
	Wed,  4 Nov 2026 21:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829315;
	bh=e6/cZgK1/qd/ZcJ551DcnlFqNmke/MvIffv0wXHoZiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z2tU3H49cW/xPQppJ4rKjDSUTwqmX90Z03NdjS9zFF5HeUeIIA8SmWMBMbRNCBff2
	 aNtBSOjlsJO1TT8DLH0PcmgXX4tHnOEgrlLa4lvcMOMtzxvUdHIiyNRdNedKT/po3o
	 oDDYC4t1eQbbhs9j0bCSg8VltYCxgz2DrMNyODmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0047/1005] perf/x86/intel/uncore: Fix PCI PMU cleanup on setup failure
Date: Wed,  4 Nov 2026 15:56:20 -0500
Message-ID: <20261104211044.906069838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zide Chen <zide.chen@intel.com>

[ Upstream commit 003267cb94e21d762eb72d6977d84f44f1705bb7 ]

When uncore_pci_pmu_register() fails, pmu->boxes[die] is set to NULL
before returning.  In the uncore_pci_remove() path, this causes
uncore_pci_pmu_unregister() to be skipped entirely, leaking
pmu->activeboxes.  In the uncore_bus_notify() path,
uncore_pci_pmu_unregister() may still be called and must exit early
when pmu->boxes[die] is NULL to avoid a NULL pointer dereference, and
to ensure activeboxes is only decremented for a previously active box.

Additionally, since pci_get_drvdata() returns NULL on registration
failure, uncore_pci_remove() can no longer treat NULL drvdata as an
indicator of an auxiliary PCI device.  Remove the associated
WARN_ON_ONCE().

Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://sashiko.dev/#/patchset/20260512233048.9577-1-zide.chen@intel.com?part=1
Link: https://patch.msgid.link/20260611160033.66760-2-zide.chen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index a5793847ed5a9..3d9973c416ecf 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1165,6 +1165,7 @@ static int uncore_pci_pmu_register(struct pci_dev *pdev,
 	/* First active box registers the pmu */
 	ret = uncore_pmu_register(pmu);
 	if (ret) {
+		atomic_dec(&pmu->activeboxes);
 		pmu->boxes[die] = NULL;
 		uncore_box_exit(box);
 		kfree(box);
@@ -1230,6 +1231,9 @@ static void uncore_pci_pmu_unregister(struct intel_uncore_pmu *pmu, int die)
 {
 	struct intel_uncore_box *box = pmu->boxes[die];
 
+	if (!box)
+		return;
+
 	pmu->boxes[die] = NULL;
 	if (atomic_dec_return(&pmu->activeboxes) == 0)
 		uncore_pmu_unregister(pmu);
@@ -1254,7 +1258,6 @@ static void uncore_pci_remove(struct pci_dev *pdev)
 				break;
 			}
 		}
-		WARN_ON_ONCE(i >= UNCORE_EXTRA_PCI_DEV_MAX);
 		return;
 	}
 
-- 
2.53.0



