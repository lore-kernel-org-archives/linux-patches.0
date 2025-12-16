Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A2E221F0C;
	Tue, 16 Dec 2025 11:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885407; cv=none; b=mSjv6ouR/RWJSHVqoW8FYG43iPNQ9DIpXkETpDK+8GPyJj3X2Zv5Zp2Ik0PKx1/iUH+pBcDutky5RDDn1brVbtvyLuEo5mQh/UUxAFdB9R+Ye3M/74t2mxFlnvFfqvGQ2ZgTc5Lewq6ZHpH0B6PUS3S/XNBGRdv5ZYcxD/Y7ha4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885407; c=relaxed/simple;
	bh=z9rMpE9DspyfHwQtzB/uGbZBR99l+X3QxoJ2YShsfCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nG/CWxxC2kUNzedRwO7RE5YQ8G27SQLAnj3C13cur8VVqbvNDez5peeDLInOYwI56FV2SahQsGSTLkqQfJP96eglDAi5nVEowFTOM+OIAdoI3w2RosbdmoFGW/E16gKBuZDZd5ws6CRmpLKSVPhceEb+6aptDq1xbELidrBImKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hyvts7GR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hyvts7GR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32561C4CEF1;
	Tue, 16 Dec 2025 11:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885407;
	bh=z9rMpE9DspyfHwQtzB/uGbZBR99l+X3QxoJ2YShsfCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hyvts7GR56/552Ss9z6a4+oZj02miqZIbATjuOI0SceyWVu5ADSDzMJ1xGr1msf2v
	 MymiK+MIuVNMCvUn4mU+y+R0+rYF1umJBTw9vhZjR2CMT9kiwFtVgsjsLzzP3L4TMN
	 Ch30nZwfNcvzKNZkmw9PnYuXREDNwd19IP7Xyxo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 129/507] drm: nova: select NOVA_CORE
Date: Tue, 16 Dec 2025 12:09:30 +0100
Message-ID: <20251216111350.204822648@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 97ad568cd6a58804129ba071f3258b5c4782fb0d ]

The nova-drm driver does not provide any value without nova-core being
selected as well, hence select NOVA_CORE.

Fixes: cdeaeb9dd762 ("drm: nova-drm: add initial driver skeleton")
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Link: https://patch.msgid.link/20251028110058.340320-2-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nova/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nova/Kconfig b/drivers/gpu/drm/nova/Kconfig
index cca6a3fea879b..bd1df08791911 100644
--- a/drivers/gpu/drm/nova/Kconfig
+++ b/drivers/gpu/drm/nova/Kconfig
@@ -4,6 +4,7 @@ config DRM_NOVA
 	depends on PCI
 	depends on RUST
 	select AUXILIARY_BUS
+	select NOVA_CORE
 	default n
 	help
 	  Choose this if you want to build the Nova DRM driver for Nvidia
-- 
2.51.0



