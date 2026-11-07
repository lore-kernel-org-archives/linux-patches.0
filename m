Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060640;
	b=wJpBr8h9KnkLx3d+1iCmRfJDp9FgGvf/ml3Ug7eCmregtFQNRicfJ5UaP0Q+0rlFGp2D
	 iu60TyY5votZ6e/YOupwfANO/v4HcWGidlrO3BhdW4cl1qpPlHmLEM2MUCj3ac8YWj2em
	 r901wDN9JvU4F7MXFyLvXSkgCTGqEs/dKCDzEpZ8zNFiAI0nWDXzydVmH+rQRvw7D8h/2
	 8IpJzLO/o6KURhYwgFe3suHs3LMKpwT65j8GOhQ895uSedoOqkMU6W+x7dBwfTB07JjX9
	 mBFSRxSL/2V7EiWGsuinpy4iCtDCroSmmOTVkd3z9F2snwXjIFArxkiMOxwE5DAsE1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tC/67AqmrdU+FSLdAxhoQ++H1vqErlT52JsJG7n4RXM=;
	b=5oCoGa1kvhJY4lrNuhDAcq3tvuSMXCy/g9DQQWjBEddbr2vtv/IFLr0epSYTni3LF9P6
	 Fbo5x6jmYjY+McKJhLbL834JJn2pXPoIDgbp6uXqsRLQo7tyeTiErJo0cr4FehaDxkq9d
	 qyzKpHZFQHMX8rMS5VULHENll4lX3o7KRxkY4PpT30iIlDsvdbOZFeJYEo1bKMNt32jrC
	 hylrtmF3oElRkOeuC7hBi71GSosUSiBJTJLm3A1gpbh4w0Mme76BUc9h3UeLyadmzkk63
	 i4Kf9NjXZ/b/G9QA89iY3idwlGcafLX1RCelhhbfLog+QIsIrlPzhLM/3ZcLViwfZow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U9Q6rOXs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C65606A326;
	Sat,  7 Nov 2026 14:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U9Q6rOXs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43ED51F008A1;
	Sat,  7 Nov 2026 14:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060640;
	bh=tC/67AqmrdU+FSLdAxhoQ++H1vqErlT52JsJG7n4RXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U9Q6rOXs4kTiZzVZEStKvEpVZfbvVSOl9MWPD1CbpJK4pbfRiscPGJ1fNK9s3/W9/
	 AmFhHIDo4h+PPMO+eY2XGe2jjld9VaNfrB7vnNsPK+qx3fFky0fZR8yH0P/JJh4KjK
	 b2gOStyOs7SSyGw0Z25PkCyX3djxHZPo4fIn+VQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0044/1536] perf/x86/intel/uncore: Fix PCI PMU cleanup on setup failure
Date: Sat,  7 Nov 2026 08:34:20 -0500
Message-ID: <20261107134958.897747387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2cc80848e3188..60afd0dd6bc6a 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1179,6 +1179,7 @@ static int uncore_pci_pmu_register(struct pci_dev *pdev,
 	/* First active box registers the pmu */
 	ret = uncore_pmu_register(pmu);
 	if (ret) {
+		atomic_dec(&pmu->activeboxes);
 		pmu->boxes[die] = NULL;
 		uncore_box_exit(box);
 		kfree(box);
@@ -1244,6 +1245,9 @@ static void uncore_pci_pmu_unregister(struct intel_uncore_pmu *pmu, int die)
 {
 	struct intel_uncore_box *box = pmu->boxes[die];
 
+	if (!box)
+		return;
+
 	pmu->boxes[die] = NULL;
 	if (atomic_dec_return(&pmu->activeboxes) == 0)
 		uncore_pmu_unregister(pmu);
@@ -1268,7 +1272,6 @@ static void uncore_pci_remove(struct pci_dev *pdev)
 				break;
 			}
 		}
-		WARN_ON_ONCE(i >= UNCORE_EXTRA_PCI_DEV_MAX);
 		return;
 	}
 
-- 
2.53.0



