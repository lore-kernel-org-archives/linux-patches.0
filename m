Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047305;
	b=ToSomOlT+516xyfTjKbX3xrrgY5Osd4CTJ/cF5GPBTQFh6u1O5rlrwTLWXG/Gb8WP4dT
	 SMktZjqfVnsFFtnD5JXKSd89TyKkQHvxprRrjUh7sC2TcoTWCSJm9O+ZmRd/PnzpH3ARC
	 HVtI6RroWpBo1pnlc8VdgbN9nyVtUoF2ag+O243xrKXbrcm2hLg8cwQcy8V/oQGUyz82g
	 K/gzF+qdOGDvDmdyPQ+zeBHi92ke+RwfB4ya5a8+0LCuUKwYYUbC8sFZdp20prAsK15y6
	 ZWBVv/AlxaBvTYNbs7elKRjN5Hhz9jhJZ3Igw1huAwNx+qzM0ogH3keGkVOGN1Kh6sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=cVAphct8VLRvZ0ldKQZ+EkkHiJgNeAePiDu8Z21/KBM=;
	b=vGAcuc0tVFpYU124RXzaveUDNDNGmFpYk6Z1qq4RwwOoIitymKE7lFwkXpaNJtL5mzR5
	 /ujhGOqSdEnulzZxK1id5L0iVcLYtIp8gYpFTsd606+cOGwH1h0Dp1kGK07BFFZ/wi7kh
	 08t8VON27zzaQ1W7vWhgNxmicv0Ccp852431TZ1oYBzMDgZFhSRfTHC0kXsFBqL8H0YHT
	 MJU3ROLDW5fHTMSoBqXR50DMalEXU/w/haMUJRiymtyC+U6RN8AHcwLMD1Ijme23ReexK
	 GhhmiZjE44Y+zQnUywQ7psfCN4z1OIOipo0adbucCzJ+uIf/4ODMnXAtdIOYqO1uGCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UYGssIXO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E900B606A320;
	Thu, 19 Nov 2026 00:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UYGssIXO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8D71F000C4;
	Thu, 19 Nov 2026 00:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047304;
	bh=cVAphct8VLRvZ0ldKQZ+EkkHiJgNeAePiDu8Z21/KBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UYGssIXOVR8ejDWC3x7yY+gmH/vXfaZgl6rOEOKD94nBOX2SlEpFVvqtf1UPYSFAn
	 qXnZ+qZoUY48l0x79ujE2vbWLvTuHkR00d8lABJlt5PM9OeFEr07rmoEp0/DndtL9u
	 dRc2gHSafDtxKiiBmfS63AId/JF9tK1i+uLJBG4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1589/2857] platform/x86/amd/pmf: Add AMDI0112 ACPI ID
Date: Wed, 18 Nov 2026 15:43:43 +0100
Message-ID: <20261118150258.584979972@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 325bcc126cf7a512a0e2da0efddad665f69badac ]

The AMDI0112 ID is used to bind the PMF driver to some platforms.
It doesn't have any Linux side code changes relative to the most
similar AMDI0105.

Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260826163611.2268377-1-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ sashal: Adjusted ACPI table context to place the entry after AMDI0102 because AMDI0109 is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/amd/pmf/core.c b/drivers/platform/x86/amd/pmf/core.c
index d10c097380c56..ca08a659c1606 100644
--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -339,6 +339,7 @@ static void amd_pmf_deinit_features(struct amd_pmf_dev *dev)
 static const struct acpi_device_id amd_pmf_acpi_ids[] = {
 	{"AMDI0100", 0x100},
 	{"AMDI0102", 0},
+	{"AMDI0112", 0},
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, amd_pmf_acpi_ids);
-- 
2.53.0



