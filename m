Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28099371449;
	Sat, 28 Feb 2026 17:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301456; cv=none; b=gQe2WQTNeJE1TOv0HMXy6jeL1lwTzuFZDAaDji1aRXCcsAq+xxlYrC3gaomtD6gPq+WiP3whg4wPBQMqU3wq6GoAhLoLbRTMYThINELgk4AC7mK+Tlu2gpqx4lPL1yARtlq17PbGH8ex+0qgdKdn4Ux3uRgUpEFNf8rHjSiGofk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301456; c=relaxed/simple;
	bh=kKnit95le2+dEaHuxkHCZ4Z5TC3ZZdIrDO+rIBCKDpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hP5egGwrGHoKtceuBlM458ecyURKJ5ve9p5v5e+hAyX0ftprEyf0BDT4iBJPFbrJV+n4Z9RSU5d8i0XQhW3ewjR/YWgmupkql5awA0XzFKSOdmvXohYThIXf+gxKLzFlAcoPgT+iCuizDARCihATBhBiXGq6CcNsJ3Tkpnfbk8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jQkV3sqx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jQkV3sqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAADC19424;
	Sat, 28 Feb 2026 17:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301456;
	bh=kKnit95le2+dEaHuxkHCZ4Z5TC3ZZdIrDO+rIBCKDpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQkV3sqx3Jwu3YTuuyFn7H5PAZWoMTuTr2F8AVkJymgzaH3sqCzXoWY1pxq10CEHj
	 znID9fGW8kSJ8cpZ54pWnOMNL5FL6h51bCKQ7tOjeajhd9YQwrk6h0y5Y25BxbmAzn
	 g0lgpXLMabUbB9getGEpGEsJIRgExJ02B64qITDEVD2C9bXICZmXxDGD06+YQMB1N5
	 ILaBJduCZV5h4Qb9oJxxQ78qNaBYGY0ZaIYjoOdi/TZ9MYLsAVAB+l6QqsMpIkiLrl
	 615BthIkX/50bARu+IVZGqR/5UMvT9yQkkwIM9ILyYALQvnOCTM8RgzApFsxUbP77D
	 tgm43DcqqYqnQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 642/752] rapidio: replace rio_free_net() with kfree() in rio_scan_alloc_net()
Date: Sat, 28 Feb 2026 12:45:53 -0500
Message-ID: <20260228174750.1542406-642-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 666183dcdd9ad3b8156a1df7f204f728f720380f ]

When idtab allocation fails, net is not registered with rio_add_net() yet,
so kfree(net) is sufficient to release the memory.  Set mport->net to NULL
to avoid dangling pointer.

Link: https://lkml.kernel.org/r/20260121013508.195836-1-lihaoxiang@isrc.iscas.ac.cn
Fixes: e6b585ca6e81 ("rapidio: move net allocation into core code")
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/rio-scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index c12941f71e2cb..dcd6619a4b027 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -854,7 +854,8 @@ static struct rio_net *rio_scan_alloc_net(struct rio_mport *mport,
 
 		if (idtab == NULL) {
 			pr_err("RIO: failed to allocate destID table\n");
-			rio_free_net(net);
+			kfree(net);
+			mport->net = NULL;
 			net = NULL;
 		} else {
 			net->enum_data = idtab;
-- 
2.51.0

