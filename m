Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033499;
	b=DztDZ7ogJCQFGIrWXeVuLq6ZxWhVanTHwUeH9DbFeNupg9phn7+n/QmdctqpB1OXgrNp
	 KP6nwb4OlRN7Lcox5xLtu7J3DAf+RjAxTCiaAOoFyzU2m8A6k0Ri1F9vv7VvvsGP76EF8
	 2wX6nP0ZiSyGyxyBLvHEkmhI39cXWKADYtcuqozx8t9PPXTHKCosNCRPiEiw01RDrKFpL
	 N3tyXXDHZyVf5Wz/ZlRDSWlpEDQmVyqDiZKG1ospFSazZ1GlWsHEQ2wvV28EzzhpOV+pA
	 d1GdvOv+5IrXZ13x26GQJ6MZN5aUf7HNmzUlfURBD46DZz2bepWO0u+VnumeJ2l4TIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6eRlsWV8YJhhaSKOH+jGjNolrM7mMBWHfu1HfrYcGU8=;
	b=emi50lOXFIeqF9MyPR1V8HWS0YYwPxkAq/QzfVO9QKT1C1tzG5bmaCPFRddDlQH59uu/
	 lLI4EjJeinGpA+zN6fVvNfE29mxupwCzsI+WcZqS+EtPcXyPOCednvAcMD6kKw+TQEafq
	 Kk/giKn1flBvsacBxfWGNOyGyNS17kexUXjT1UCH0FVMTBps8+MRXOceTr81XXQKElUNH
	 hsL8jsYzA1z/Ke8d0s+soWj72quVyQ9NgVm7Q406QN6sePqsoGngPaX0ZzROg60Kv0l09
	 31rYRZDTP/9v7Dhz4lRy7CWzmFi/svemS4PiTzOepvlf6Cmh58m0xp+2EamuHcaDmkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=twu6BL81;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B5A606A31C;
	Wed, 18 Nov 2026 20:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=twu6BL81
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC9F1F000C4;
	Wed, 18 Nov 2026 20:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033499;
	bh=6eRlsWV8YJhhaSKOH+jGjNolrM7mMBWHfu1HfrYcGU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=twu6BL81zHt0GEZRAfryuHmolUDFOTB5oPJhghDZlA2ejZczDC4tYAz6Cnv+0HgiU
	 3Zxehklzp3kKuOegF+SV78/itei4n0po2ZEEQ2zcoPhaw/0DcwUHtZwCNRQczrpEYa
	 812zTTY9W4ckoJqKbpWKlmfIGb8yAnwMddNHtl3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0037/3318] perf/x86/intel/uncore: Fix PCI PMU cleanup on setup failure
Date: Wed, 18 Nov 2026 15:10:59 +0100
Message-ID: <20261118150314.951271983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6769820a007b7..0b9c3144a7037 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1173,6 +1173,7 @@ static int uncore_pci_pmu_register(struct pci_dev *pdev,
 	/* First active box registers the pmu */
 	ret = uncore_pmu_register(pmu);
 	if (ret) {
+		atomic_dec(&pmu->activeboxes);
 		pmu->boxes[die] = NULL;
 		uncore_box_exit(box);
 		kfree(box);
@@ -1238,6 +1239,9 @@ static void uncore_pci_pmu_unregister(struct intel_uncore_pmu *pmu, int die)
 {
 	struct intel_uncore_box *box = pmu->boxes[die];
 
+	if (!box)
+		return;
+
 	pmu->boxes[die] = NULL;
 	if (atomic_dec_return(&pmu->activeboxes) == 0)
 		uncore_pmu_unregister(pmu);
@@ -1262,7 +1266,6 @@ static void uncore_pci_remove(struct pci_dev *pdev)
 				break;
 			}
 		}
-		WARN_ON_ONCE(i >= UNCORE_EXTRA_PCI_DEV_MAX);
 		return;
 	}
 
-- 
2.53.0



