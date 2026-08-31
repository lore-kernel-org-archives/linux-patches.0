Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54486478861;
	Mon, 31 Aug 2026 13:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184432; cv=none; b=es1881noyKRtzI3CwFt+M+eEKN6B6WOOX1OVAqFCqFWlSOMop0480NNG0oHAXQADmaCq4G2zKxXYGLSSqqGnF28imlqJpOI/wQsdxzA/oUwLfE/O5H998dnGdOwKW3Ve4rCU39td2F+rswer4Q4zdNaAWfdDqGOvThq3N+oS334=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184432; c=relaxed/simple;
	bh=bc9z8b4w07mWqPltng+wmNrJObE4qQSNe5NLYess9zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urUqexHN98tk0wpcle+hQNnY9c8s20KYfAKqzpnRmb5GU/9R/gWbWmMxEIDcgXLCbAd3zP04QQ2NoaLW+SZslEx2ZwfbEBUV7y1hSlrBSxoY6/EdRUmHc4+CnzD6LSOoSdj18ZNjXrEAjSH8zzY9OzjBuNElBTM2HCRVz+p8Oow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LiSeNlOL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LiSeNlOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9991F00ADB;
	Mon, 31 Aug 2026 13:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184431;
	bh=LRGcDtgI8Pcg45S25iL4jloZAT7plJF/sKHHVC3Im/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LiSeNlOL82dRPzUuULAiWFgvvS1bUCMi0/f7JKEzzMLRkuNI64pBmETq2Uwq00pfo
	 T7XZ1Gci8HJt+3UoVkJLuAkDJaijELoUOhXrBGCkV5vrk3p1s5gBaFsjDUcYyBaZhI
	 beRDVpLPYdaI+ut+/F5YDIG6PVy555LVd86d0N3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.12 67/99] x86/CPU/AMD: Carve out a Zen5 models range
Date: Mon, 31 Aug 2026 15:34:36 +0200
Message-ID: <20260831133403.320608107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -523,6 +523,7 @@ static void bsp_init_amd(struct cpuinfo_
 		case 0x00 ... 0x2f:
 		case 0x40 ... 0x4f:
 		case 0x60 ... 0x7f:
+		case 0xd0 ... 0xd7:
 			setup_force_cpu_cap(X86_FEATURE_ZEN5);
 			break;
 		default:


