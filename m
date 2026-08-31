Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7799B555C1F;
	Mon, 31 Aug 2026 13:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184024; cv=none; b=n+RkYp95mGpPQGrhn41lk9518yK+2z7V83SlN0gkimjRrTXqpTC0CmyQoL7rqLmr3EAdaLvkrpViad5YqGZSyEWMPmwLWEmCb4KzhI4ZeGZD6GOpFjIncyCZ3HVGvnN0Mz6vHqCT51FNRC4jnMcSpz+/vvuyIIrnB2+Jhox6Ew8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184024; c=relaxed/simple;
	bh=1ZZ1eeQOEdUy41d0QHZwk6h2phOu6RFv/KITv3gcBRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gcwamv1AB5psf8Du6V2un3xInDzJWGjFpMCy4Kq3CtF2FNIsr/5iO2xjV0DlewYlR94IyyPTLu50kwaWDlhF/6mlLsRdKawsf0OYDiNiz03JQIU8Uc3SczcplyezbrtUWA2whT5drbIfLT+0zwQdJOG1w3qqnC5kkX6fvlkfCCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vd5B7lwF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vd5B7lwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D111B1F00A3D;
	Mon, 31 Aug 2026 13:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184022;
	bh=nIDgvbEbPezfQbI6b/eB2QyGTh7yRnLTykRNtU38lBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vd5B7lwFSc4MeHh/7t18WJLfRY4I1J+SXbe/+TBLAIMr6pz6y5wlcG+aF29ZALkQA
	 BzKYqNYx0nBvE5f5NDhbKUwKrISIXPdwv3xX0XMJo/QI9q2QRne0n4pOdjaSOdCAXB
	 AzWpxGdGbkYRnENdCmTz4LLTTHA2jE+OgL828zgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.18 47/83] x86/CPU/AMD: Carve out a Zen5 models range
Date: Mon, 31 Aug 2026 15:34:23 +0200
Message-ID: <20260831133401.901231480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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
@@ -513,6 +513,7 @@ static void bsp_init_amd(struct cpuinfo_
 		case 0x00 ... 0x2f:
 		case 0x40 ... 0x4f:
 		case 0x60 ... 0x7f:
+		case 0xd0 ... 0xd7:
 			setup_force_cpu_cap(X86_FEATURE_ZEN5);
 			break;
 		case 0x50 ... 0x5f:


