Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D522BD5A2;
	Tue, 16 Dec 2025 12:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887182; cv=none; b=kOA9W6AUnFXSCk6lPQlj84SC9v4KQNzgRscPgDxdx+k6RpE4jm7IDIvo/dKkh9yhK7IBvwLAN50oCvbKGrTEJ4qPpDFYwrbvCrT6XKHWPaVVhvRJpsXPU6ZnZ0PiPzkr94fstNlVigCDtBEL0Vykv7VaRdv0X0rho+Kd5TacCZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887182; c=relaxed/simple;
	bh=4JdbDHcJRDtNTrd6rREW6Fw0SJaE3HCpM6QAo6Bxh18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAR/Z6U6YHmQGreMqAp2RKgTqMuOA9kSi+F+vK3i8LrywaK0NB+mDCDYkU/XqiJ1Dfzp/d0MMfmJE5TGg2tUQLQo2z6/NwjPOa1ytTLOx7ElJ4XFSTZtea0czPuJY+RpguG4/9Z3xk9N3PtHZDXmpaulVEPkMggocPRWV5sG48w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGTeNc20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGTeNc20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7EBC4CEF1;
	Tue, 16 Dec 2025 12:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887182;
	bh=4JdbDHcJRDtNTrd6rREW6Fw0SJaE3HCpM6QAo6Bxh18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGTeNc20tZNh3SFKvQX3On4tgPWnw5HHS2RgMMrkAPKKlciXPWQ2wkdJMM5tcNRi7
	 e5mzsGs9/24ROaBNHRfZMduGYwJpNZiPMNZqsl0IBJw9BZFFc3dTXnO5mgYE0e8rbA
	 EA444jqSybN2P3qde01NH4OKVRqo7ANPoV9+SUTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 151/614] drm: nova: select NOVA_CORE
Date: Tue, 16 Dec 2025 12:08:38 +0100
Message-ID: <20251216111406.805669045@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



