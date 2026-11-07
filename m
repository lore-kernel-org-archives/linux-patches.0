Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063919;
	b=T0vtyn9RxKL/iyloJmdKkb24nLfUBGCctvjuxB+bAX8qByb7i7jJLNRqAqwQf8usBPzY
	 oexHin23YsWjwF51OwCk8W4RSRDH/ou13YGoQ6TsP83+j5olei2O5kS8TMtHtmrY/VmKv
	 q0S9tcBFj0V4y/qCLoDogRNqH3t2NTwbUTP4cIobQcW2R2FZa1GaSfTLJ7wz6upxzkrYu
	 8GDppNKyaVTyA9cro9UcURuMyxc/bPS/k0Xl7dzYnNms9u3vrQzysNrU2BfOJhUrFF1xs
	 yjm5g4HctdHCtT8bQtRH9jQLM2nm0GKAz0OXpt9KUQLMK3kVh12GvibzsREh7gRoRLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O1lk7XeyKauQj8y4N5FE7VEGVNE+eMiTBSoRpyR1x64=;
	b=fWXYCnmy0o8HdMscG8gT4NBgv1a9X/tM0OHcKQi2RAjOsjJsssI2Nkek8PV/gxCEB1Bc
	 F0z/SLGTX9QoLPzO1pMKkDQe7AW2Pt56Qu9IjsBDctxM/MHgfomHUtcr/yQFj7KyfDy7v
	 5eI9PsAaLEqBd74MduBSPllHUdP1VbShuWMF513Odk+1fRkiq6ya7uidZVO+k9YAekUWg
	 z4/JT4Lz+ebfj+HJ/pYbGmmCr8UY2twNFUQpvVr4viaIgXnC/BKM2gP1z6m5Ac2/pQzx4
	 ecpEiRyhCQTlSmEt9/Jpten+wibH4AUoeS6fvfhr5MXSmKfeoC5cQSBWrrPv3XlO0SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qHvMqOwy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ABB606E8E9;
	Sat,  7 Nov 2026 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qHvMqOwy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DF11F0089F;
	Sat,  7 Nov 2026 15:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063919;
	bh=O1lk7XeyKauQj8y4N5FE7VEGVNE+eMiTBSoRpyR1x64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qHvMqOwynxsqveRTNnpm6WbRqcghSlPdUqoEhqxBBjQ/HIuuiOFue6+VLDuYxmcmN
	 bAfLzLuGLZGFbLDaUXOQMsnwQWW+708MTtlhkS4r9Mw8zxCGV0oV5s5iFoYGUeLhLz
	 Ey39t8cKuakjKANVSvsp5xRZxClgWj8NyuGrau0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0115/1257] media: stm32: csi: unregister async notifier on cleanup
Date: Sat,  7 Nov 2026 08:40:11 -0500
Message-ID: <20261107134942.521033865@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 4957d480a0c87cf3d024e6ff1f57d1222f9212cb ]

stm32_csi_parse_dt() registers the async notifier before probe finishes.
If a later operation fails, the error path only cleans up the notifier's
connections.  It does not unregister the notifier, leaving its entry on
the global notifier list after the devm-allocated csidev is freed.

The remove path has the same problem.  A later async operation can then
walk the stale notifier entry and access freed memory.

Unregister the notifier before cleaning up its resources on both paths.

Fixes: dcb0f4c16be5 ("media: stm32: csi: addition of the STM32 CSI driver")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/st/stm32/stm32-csi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/st/stm32/stm32-csi.c b/drivers/media/platform/st/stm32/stm32-csi.c
index ecd0ed8e76b59..78c68cf90ffcb 100644
--- a/drivers/media/platform/st/stm32/stm32-csi.c
+++ b/drivers/media/platform/st/stm32/stm32-csi.c
@@ -1059,6 +1059,7 @@ static int stm32_csi_probe(struct platform_device *pdev)
 	return 0;
 
 err_cleanup:
+	v4l2_async_nf_unregister(&csidev->notifier);
 	v4l2_async_nf_cleanup(&csidev->notifier);
 	return ret;
 }
@@ -1067,6 +1068,8 @@ static void stm32_csi_remove(struct platform_device *pdev)
 {
 	struct stm32_csi_dev *csidev = platform_get_drvdata(pdev);
 
+	v4l2_async_nf_unregister(&csidev->notifier);
+	v4l2_async_nf_cleanup(&csidev->notifier);
 	v4l2_async_unregister_subdev(&csidev->sd);
 
 	pm_runtime_disable(&pdev->dev);
-- 
2.53.0



