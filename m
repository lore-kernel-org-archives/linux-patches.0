Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB7074E23;
	Tue, 23 Jan 2024 02:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975494; cv=none; b=hxpggCki0zkoUeyZRQmuEyLsd4jVB+P1JPKXjWO4PtTs3d6T2HQb+Idrv3PMN3SbIuviWRY5ixI2KdPmIji5zB/8XRcHawDWgNauBqW9vrxdXJrJWLR0vXcVON9Mg/bejCJJpiS+wRHStReK965U1zE7zS6kPe1iedqIe7cbDHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975494; c=relaxed/simple;
	bh=/969F0yWUQvOD2F1Nod44ifp6Cvr6Txc43Xx41aDjew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sa7jvh+xJK/nZ2eg7hDk+GnoqQss4t5XI0ol52ebXxg+DDuDdC08JMv1Hra3TMnooqRPspwQKWwbSX5y/JXXiJVmIjTtbQNFEJ5O9ZrTdCy0hJcNNXcxBA5knb2OTIwqON2VxMR8+nxvEHbyEJp5vQSp4Ex2uzfINeqjFQe8UfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3JJEgNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3JJEgNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C2EC433C7;
	Tue, 23 Jan 2024 02:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975494;
	bh=/969F0yWUQvOD2F1Nod44ifp6Cvr6Txc43Xx41aDjew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3JJEgNgRBohK1O9nS7Orkrt7VoeTnvg/VauFQ0ctUhWGvfgaPcxq1lO+9IU1OXJo
	 azfrNoSRkW9Qbsm5+Xk839xhxU/K/7zyMvNA6fdYV3P1R4MxwZVjTtUCY7aMj9NuvR
	 MV06Nyncz+uhbUj/fOCKsbNAaRRqeAM9i6XqFx/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Whitchurch <vincent.whitchurch@axis.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 448/583] um: virt-pci: fix platform map offset
Date: Mon, 22 Jan 2024 15:58:19 -0800
Message-ID: <20240122235825.688440415@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 32253f00ac8a8073bf6db4bfe9d6511cc93c4aef ]

The offset is currently always zero so the backend can't distinguish
between accesses to different ioremapped areas.

Fixes: 522c532c4fe7 ("virt-pci: add platform bus support")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virt-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/drivers/virt-pci.c b/arch/um/drivers/virt-pci.c
index ffe2ee8a0246..97a37c062997 100644
--- a/arch/um/drivers/virt-pci.c
+++ b/arch/um/drivers/virt-pci.c
@@ -971,7 +971,7 @@ static long um_pci_map_platform(unsigned long offset, size_t size,
 	*ops = &um_pci_device_bar_ops;
 	*priv = &um_pci_platform_device->resptr[0];
 
-	return 0;
+	return offset;
 }
 
 static const struct logic_iomem_region_ops um_pci_platform_ops = {
-- 
2.43.0



