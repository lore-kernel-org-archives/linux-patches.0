Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D19747CC71;
	Mon, 31 Aug 2026 13:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184692; cv=none; b=PypwwDVLiL1H3ZNByuTIQ07dJ0NgRVc+xLQVBu/b7oLngh/OEtSqj5l/RW9XsYrWuA/M2CenP58bye2TUO0aYgI/6wnOHQv1ySFyYD4+Opgu3Q6xmcsXq3d0QjgjncPSGrciDzweYzYlzOJihYum+Zt7bvVm/K+gxmG0XzeyL3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184692; c=relaxed/simple;
	bh=EkjEM3BVNz6GwlySbG99E3r+1CJlounx8+HiGqbEGuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejjG4Ydo46rQmGSUMhWcYpdOfMFZoHedivcn1B1gPPxdLy9b0QKKdzme3Sp1Hf9vcXuEO0h+BGX3tHhw7HhgPxq8ciPlJFpnKsuDfDfMBVA72IbV/3fJBA3AsfESRHYfIYm3PmHC+TntbXpLierAWjZwZwGlHGuOKJ74IQw+LdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z83T3Agx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z83T3Agx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E866E1F000E9;
	Mon, 31 Aug 2026 13:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184691;
	bh=0E8IUwmxA38CNpQZlGymnQ/7tppJDccTn4pB0P1WsHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z83T3AgxxJ3L0q0NS7fHE74h1LcZHaYAHyDgN7Sl4KDZsPKp6bHYAnACaIUiqXY53
	 JQZBloJfRans1hNnjh8ngQ/ZZRu0h4CW0Hm+7QiZJ4wXQzITR/wxWJ6XX5ZnyrjsKx
	 iXa7bsL/Jg9injAULmgRHdK2fn29Bze1CzJjUb2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.6 71/91] x86/CPU/AMD: Carve out a Zen5 models range
Date: Mon, 31 Aug 2026 15:34:59 +0200
Message-ID: <20260831133403.327835213@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>

commit 52075128273ace53e6254e37899a47d40d4baf45 upstream.

Family 0x1a, model 0xd0..0xd7 belongs to the Zen5 generation. Carve it
out from the larger, Zen6 range where former doesn't belong.

  [ bp: Rewrite commit message, add tags. ]

Fixes: b5f53e6d3d32 ("x86/CPU/AMD: Add more Zen6 models")
Signed-off-by: Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>
[ bp: Backport only the Zen5 bits. ]
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20260729055459.15904-1-Pratik.Vishwakarma@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -706,6 +706,7 @@ static void bsp_init_amd(struct cpuinfo_
 		case 0x00 ... 0x2f:
 		case 0x40 ... 0x4f:
 		case 0x60 ... 0x7f:
+		case 0xd0 ... 0xd7:
 			setup_force_cpu_cap(X86_FEATURE_ZEN5);
 			break;
 		default:


