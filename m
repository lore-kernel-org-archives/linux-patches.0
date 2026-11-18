Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044077;
	b=vW60CSa4jyqRb3kTxY9N8s/p24dFgpbXgw2V7j7IMmnfoLUgS1YhZWVVug8IR/liIlr8
	 bsFoBUilFBEnOwE+fmACSwPO8b91pOAgt0N93njgBHRx2lJ36QuPWvsQDeZoP3JhBXHZT
	 6I0kNlWWnvw72KCsSCwqYMDoEIv3Mr3wiIbBDVTCuXTCwXkjhP/qIif3Bl4aZSBHq3f9X
	 xKPBhiTJCDWU7ErN17+DpBqtrr+yqhcqF2y4nLQ3/qr0n9p/VsUD/QqG/VXMdolkVO71i
	 EV14bXuT1xtuRfsi9YrXo2B9OnDcR/Q/JJBfPTPpJQtdzsmQdji99Y7ihODB22IQ2DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XBoFSnbXaZxIDb6+j/Dn8r4DqdO/FPvY5Y/yZX0Gh28=;
	b=vCjM7tBc0xEUVrAyBtVRdlyytpy44cK9N66eSEBszcZZuwwWZ0fmSQVIz5eGkYWCl7Ju
	 15CaDG5/N7rc/2VnXd3MVxEZ7wr2ySrGXi5NBetqKjCSHiqiSYuP/EQvVpLaXcjvF3Agj
	 U9lWOSeUgX3M/fiS6jBIs13NYcVOrObAqz5ej3M77sIdZYktSeOC9U054Mrwz9u1Wim2e
	 xpMlohMpjGeWYvOvvICxjAXnkh7r5h655mY3WELO79llzwElhIRApUkEAxyh8akSjbqSV
	 LF7YdRZJA2o0qCp9p+uJ7rp4K3tzs8vILsxMxOVEVfLOLT/W7OzJLghsvH8Dn9VtItg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YsAId7Ba;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D825B606A320;
	Wed, 18 Nov 2026 23:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YsAId7Ba
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C76E1F000C4;
	Wed, 18 Nov 2026 23:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044077;
	bh=XBoFSnbXaZxIDb6+j/Dn8r4DqdO/FPvY5Y/yZX0Gh28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YsAId7Ba2sAbNSUY7OhRunet/92skTQGk6gZ8V7RaOIzyaNVYJja20bzjlYYZy26E
	 0tb/bHEtM8Nu/0zg5vshm/7cNUKqJ4duQg1Vu1JuDqObNGWfGPl2fIFw/je5uJcF+E
	 EFgliyHuTPg02K1pvM4TPvAurhr1W6cJG8/OK6aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengjun Yao <Chengjun.Yao@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0439/2857] drm/amdgpu: fix rmmio iounmap skipped on device removal
Date: Wed, 18 Nov 2026 15:24:33 +0100
Message-ID: <20261118150217.183554847@linuxfoundation.org>
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

From: Chengjun Yao <Chengjun.Yao@amd.com>

[ Upstream commit 5155002b03b24ba3ef91c5c313b8cf0171b24904 ]

amdgpu_pci_remove() calls drm_dev_unplug() before fini_sw(), so
drm_dev_enter() is already false there and the iounmap() guarded by it
is skipped. This .remove path runs on both hot-unplug and plain rmmod,
so the register BAR ioremap mapping leaks one instance per unload.

Unmap rmmio unconditionally (guard only on non-NULL) and drop the now
unused idx.

Fixes: 62d5f9f7110a ("drm/amdgpu: Unmap MMIO mappings when device is not unplugged")
Signed-off-by: Chengjun Yao <Chengjun.Yao@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit dd6f86a97260e5207d3329ad03aa89fdad61b1e6)
Cc: stable@vger.kernel.org
[ sashal: Removed the unused idx declaration and kept amdgpu_device_doorbell_fini() inside the new if (adev->rmmio) block, since this tree's guarded block also had that call. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 25748ca1c3d5c..81eb14997d923 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4189,7 +4189,6 @@ void amdgpu_device_fini_hw(struct amdgpu_device *adev)
 
 void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 {
-	int idx;
 	bool px;
 
 	amdgpu_device_ip_fini(adev);
@@ -4221,12 +4220,10 @@ void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 	if ((adev->pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA)
 		vga_client_unregister(adev->pdev);
 
-	if (drm_dev_enter(adev_to_drm(adev), &idx)) {
-
+	if (adev->rmmio) {
 		iounmap(adev->rmmio);
 		adev->rmmio = NULL;
 		amdgpu_device_doorbell_fini(adev);
-		drm_dev_exit(idx);
 	}
 
 	if (IS_ENABLED(CONFIG_PERF_EVENTS))
-- 
2.53.0



