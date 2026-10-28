Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212942;
	b=VkRu/C4I8GbqW86HheHKVvESJInDNCCsJyKJ6c124pYNscwFsAcGTKsajA90dGknLmKm
	 ZrQANQOZ9hB49kJ29sPN2kixNZS8x53P8L5HWTKx8LZnjg0KDP1Gait8pQ8aAb5nhit2G
	 XYgDOugwBmRbW4t/nrglGXyQ1BDQ8gYmrhLc6ikCCTkq3aU9RDq10nC0Hwwd7tl62mBaf
	 tI/7bUAL+J+ieO44ZeW3dHMnB9d02fgW6Ls/F9qP67qN8ytbg6Bya5SA+bqkDY0Vj+7ZQ
	 kNWeQWSA1kS36HoyBUF/IIfsfLFtXcN2luYdQ8swLvx2Y4L89UJ9eay8MURG7QM2ILQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ic0j1A0NG4+j3QH98JXX2gWEHFwo6HhQtofWILbYvVk=;
	b=ag7NrAvdkYW1BHTzGmeraNZYDldF7uwGPuYt3GVOe+Zdhq4oLgLR8f6ac4J7rVqPBfdh
	 n3AfL99R9xSJ4PmlGrVeMXkEAzYeX1QYUtkOTM3I29cMT2v3LfxGhhJAnSrRfW23e4tNK
	 alLWScRAI2OMI9MHsRmrXWhedP20HMP9pAM8BKLiEuSrac7tJYXBrQy4qdrRo/q2K8xY+
	 aJ8ZqXRC8suBdieoGmlr4hOcNRPWAa/Nd+BT9xvFfntNDAFsotSZoGSQYrnN6L2kQHOLG
	 j+Yk1xYnQUlb9Vm8FbkwRYm1NIZwXqshFXMCTFeTF/TvKx46sNcOK76A4De4Nd81rsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jhS+IqUG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56803606A31A;
	Wed, 28 Oct 2026 18:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jhS+IqUG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA14B1F01825;
	Wed, 28 Oct 2026 18:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212942;
	bh=Ic0j1A0NG4+j3QH98JXX2gWEHFwo6HhQtofWILbYvVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jhS+IqUGrSvhdtSfee6LqPj9L58XggcVSuF+W36MBxSCHRK8GTHNIT6ljwAVmBuVl
	 uPgCswDOIuINNKN4JN4WShgnAVMdb8uEVT7n6Tm5TJQqhg3juZYvIbIcbkMfdh5C8q
	 Ggll2guf312UqHSRWM6xHdJI2aAgut537Xg6jqkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Lieber <kurt@lieber.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 0330/1887] thunderbolt: Disable CL states for the Anker Prime TB5 dock
Date: Wed, 28 Oct 2026 17:40:26 +0100
Message-ID: <20261028170506.741017754@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Kurt Lieber <kurt@lieber.org>

commit 395e9f2967a7ac6898026e8f136c369805dc2fd9 upstream.

The Anker Prime TB5 dock identifies itself in the DROM as 01ea:83b5.
Its router config space is an Intel Barlow Ridge 80G hub (8087:5786).
The upstream lane adapter advertises CL0s, CL1, and CL2. With CLx left
enabled, TMU uni-directional LowRes setup fails with -ENOTCONN, the USB3
and DisplayPort tunnels are aborted, and the router reconnects in a loop.
Loading thunderbolt with clx=0 keeps the link up on this machine.

Match the DROM id together with the Barlow Ridge hub id and disable CL
states for this dock only. QUIRK_NO_CLX takes the same early-out as the
module parameter, without disabling CLx for every other router.

Closes: https://lore.kernel.org/linux-usb/SJ0PR15MB4696D491504DB667AA8E0617A3812@SJ0PR15MB4696.namprd15.prod.outlook.com/
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Kurt Lieber <kurt@lieber.org>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/thunderbolt/quirks.c
+++ b/drivers/thunderbolt/quirks.c
@@ -92,6 +92,9 @@ static const struct tb_quirk tb_quirks[]
 		  quirk_usb3_maximum_bandwidth },
 	{ 0x8087, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HUB_40G_BRIDGE, 0x0000, 0x0000,
 		  quirk_usb3_maximum_bandwidth },
+	/* CLx is unstable on the Anker Prime TB5 dock (DROM 01ea:83b5) */
+	{ 0x8087, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HUB_80G_BRIDGE, 0x01ea, 0x83b5,
+		  quirk_clx_disable },
 	/*
 	 * Block Runtime PM in DP redrive mode for Intel Barlow Ridge host
 	 * controllers.


