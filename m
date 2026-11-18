Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042933;
	b=Y+2MfLOVtDpHW5zPNUT8cqooW4XoE+qd0pY0cAXtYM4/KhDM4EfsgbDaKAqoRUihLX0z
	 knOeMaHuOREB83htTJEpnqPvpDPLXOax7PvztbyQuUciVGWj4665DE3MJm7LWpSfFU3NH
	 m1Vl/vU6TGkGCMACeqxhegIM2mifKlvkJsFC4M1n+o2WtqNjI2iRy2W2R1BGDeKhA6pTx
	 7lLUMFI1dwxTy1LlHuV31tErI9YIZWLYlDP1a18zXm9WwcLBbaM4RcJJgsICK5eQT0s2r
	 NnjkM84aV1XOKgAZIiEblTd5sDt/k3DxhUmHlgect+bd3DlOmI6JMhDT5hSzpghYBIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042933;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=87a601Fb1a2e79/wOt0y9lixD/lOHyINjfN00Ki0VkA=;
	b=D2jR95BHSY7IVR3x8l+k047bSXqbcpp7hfp0ZWxIFyv3+pjYtENDou12gzKwAfezwrZX
	 Qi3aPgg89hkRQX7Hpae19LxSI2vn8nQKEb0psm+9rx7Zs75Jsb4L92Mp2i30GugI1x5Ju
	 5y9vxXaQ61TanXU6mN7gF3mzIJpWJECDN3RwpoJRuovm6Qv9EbAZer10r50rdUJmX2mL4
	 s7X3LAI9r0or1Jag5mGZqUq1XPJ/9hsn9vbMkXLr6LJpXcC8SQso2DF45xre9JK3bhs4P
	 AFK5CMJLGko00BFAHPaSpqzPFLKVpPDiUrhE6/1P1F97icafgIBwECDUk86izfjTpBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gg4NNSu7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1BD606A336;
	Wed, 18 Nov 2026 23:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gg4NNSu7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882C71F000C4;
	Wed, 18 Nov 2026 23:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042933;
	bh=87a601Fb1a2e79/wOt0y9lixD/lOHyINjfN00Ki0VkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gg4NNSu7uk4QC7QsCSuaCpk2kMATtbqVddUsV9yK2m/9Siq9Xy2MmYPaz4eucv4hW
	 xqS5ALIRfGKu4/nd7eQYexd9urNm97j0kAGp1h4PGFAFcJxNC2fFjPWlau06e8WrKn
	 3NOAlInK8Ks7laxhANcYld+ZMbqcbI7Ow8fLME5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0032/2857] perf/x86/intel/uncore: Fix PCI PMU cleanup on setup failure
Date: Wed, 18 Nov 2026 15:17:46 +0100
Message-ID: <20261118150202.501281004@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 527e6d11af470..609a3a75b5deb 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1151,6 +1151,7 @@ static int uncore_pci_pmu_register(struct pci_dev *pdev,
 	/* First active box registers the pmu */
 	ret = uncore_pmu_register(pmu);
 	if (ret) {
+		atomic_dec(&pmu->activeboxes);
 		pmu->boxes[die] = NULL;
 		uncore_box_exit(box);
 		kfree(box);
@@ -1216,6 +1217,9 @@ static void uncore_pci_pmu_unregister(struct intel_uncore_pmu *pmu, int die)
 {
 	struct intel_uncore_box *box = pmu->boxes[die];
 
+	if (!box)
+		return;
+
 	pmu->boxes[die] = NULL;
 	if (atomic_dec_return(&pmu->activeboxes) == 0)
 		uncore_pmu_unregister(pmu);
@@ -1240,7 +1244,6 @@ static void uncore_pci_remove(struct pci_dev *pdev)
 				break;
 			}
 		}
-		WARN_ON_ONCE(i >= UNCORE_EXTRA_PCI_DEV_MAX);
 		return;
 	}
 
-- 
2.53.0



