Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050956;
	b=Tb2iWOdG/GCPzIK3Qz+X2flY5DGFThhvZmWrUGlJpkokoDZ+MgCegjfqpyy6MntLGObC
	 PGxLmaUyG87II3lfdTB7pspV8vcJIEwt6K3rEODjiITn5Gdy6eZLR55mQ2Vw2HALy2fjp
	 OEt1Ow6g8xGSd4DoIsmp5Vthjlxgy1pkIxWNC709Gh3iSS9DMAHJn5ZjcKqPKp/KhFr9C
	 UE/dml98Qs07yf5UXbsFGhltIEk37xusxxzPciB4gJl3RVH92oD6F0zeTHBT+3SArQltp
	 loCv1eEcPPEP93X79qIMNNEbtaEDDRPPQpg+8NYTnN2W4I92y2NhCVNeJDqIOBq8vSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EEBPHoAZ4kUxng4vo84Gxe0R5i51Czf06WeAv/E1uSo=;
	b=qCv20qlZqMe+sUXzcENaKr/BqZLgWniL6WMnaaN5UnGZXjEnHegvocXsRCMmbyK03r4n
	 9Rwe3ZrTPva8z8ZvZqGg+3XM8ZLtXebHARndT70D2KzxJNAv7nmMQA3uMxdlIP7FVCQgW
	 Qt3pBHERYaYjH2h8zRD+12T/W8t+67yl+3zGzzySGxgfyuuwbSWxP6jmspATXtxWrxfJP
	 5oiDgXmFqtHV4oG6SDlPvYD2yjMmdmVv8pti5Hs/Vx1U5Yy/AoknJp5NX/U7PIosZPiJT
	 sOJdAoC0hl/PI31aKkuL0IMq9pRb0CyXfahSuzo7G6sVrAGnlZo5rR+0ZhpzUFaNfAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g4toww2g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48AF606A325;
	Thu, 19 Nov 2026 01:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g4toww2g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9531F000C4;
	Thu, 19 Nov 2026 01:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050956;
	bh=EEBPHoAZ4kUxng4vo84Gxe0R5i51Czf06WeAv/E1uSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g4toww2gFRMLUZ/+UOLFuf5dHvrEORc337ZpGfHC2Y3hF/kOrfOnw6quDBiE1Xh9K
	 jREPZi8z1nMmnOQY73ZoXCExDiqyJU5rWchH9P6PNyzhnBtw3vOCLNsHnxatRePOv7
	 z5bBYZ0pZlYuQqi6UgH0Vljt81QdRqRngVsLnTk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0037/2214] perf/x86/intel/uncore: Fix PCI PMU cleanup on setup failure
Date: Wed, 18 Nov 2026 15:28:33 +0100
Message-ID: <20261118150011.557374935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 25bf8dcaa9a28..5719f1bc70574 100644
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



