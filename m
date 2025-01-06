Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4608155352;
	Mon,  6 Jan 2025 15:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177853; cv=none; b=kEQ0Q/qkrxNxFAez3ZicYJSGz5zqtjLyNX1rk9bj9V/YO7vmRKsAmOYKbTKPQr6XeqEgfa2n1EeZjhOM1VNmwTYsK1h0zN3kI7QOLRO8E6T7jtzgr53tyr9zwBGlgWf5ZCDvntkG7WwSJcfkyqugGVt9ShGLrsU8tjFXbW2QNRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177853; c=relaxed/simple;
	bh=dyRFPv79fwQs5GNFLl+0OdWB9B/GDm1r5ZyHQMKpMzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdAf/BI8EmcTBNyDEzcfbW0xSJ/ZF/V0cRNQJ2HdQzyulAYLYus8JZIzYaTmNeLLHJftyiMsHWrQywIvnh26DXx1dN4q8EmzkfyGF4o6waYPrFRmEiAuLmXM10fygN54dNf+D5e/UP+/exreDKibfNho/N81HFBlReyD3CUhTfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pcGDx7uy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pcGDx7uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CB0C4CED2;
	Mon,  6 Jan 2025 15:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177852;
	bh=dyRFPv79fwQs5GNFLl+0OdWB9B/GDm1r5ZyHQMKpMzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pcGDx7uyBbKbxlJTLcvCXN5Did/fvg6gizyLkWlpvKI+yLjhaAzKw9+kTmV4Z9E4J
	 ZiLjC43U4jNx8VWqrfKXlIZkameAfmnIihjCxZemNd6JHFbcnf1chqPuenYJ/MvhRV
	 U/GW3+zj+b91O4qPreFSNso7MvC61FBWlR3AAaNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/156] perf/x86/intel: Add Arrow Lake U support
Date: Mon,  6 Jan 2025 16:16:03 +0100
Message-ID: <20250106151144.632646266@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 4e54ed496343702837ddca5f5af720161c6a5407 ]

>From PMU's perspective, the new Arrow Lake U is the same as the
Meteor Lake.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20241121180526.2364759-1-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 28b4312f2563..f558be868a50 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -7067,6 +7067,7 @@ __init int intel_pmu_init(void)
 
 	case INTEL_METEORLAKE:
 	case INTEL_METEORLAKE_L:
+	case INTEL_ARROWLAKE_U:
 		intel_pmu_init_hybrid(hybrid_big_small);
 
 		x86_pmu.pebs_latency_data = cmt_latency_data;
-- 
2.39.5



