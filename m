Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324F943E9D5;
	Mon, 31 Aug 2026 13:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184687; cv=none; b=rNZtBcObSQa+M1yQKJ+uh0aqO9Xq7zUbwkuVYfB8dyRPfUjC5Ki+sHJXASASxEpfFewjJjI1Z3yFHJApbxXfp7aVxlO7riR1X596jzRk1uohzi7qiXeoApGN3coxh+hHs576MzAKeK7RuywIVvo02XObgfD/869LRsuyg1qfEaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184687; c=relaxed/simple;
	bh=hdMqa9EhoRLy0FTULbHTvxOt/JTxVHouXYTEqbtPMVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gro+SMpPfksgEzunyotzIFosRtgD6ZQopA9WeA7Osye74e3QnIKgoeQ8vq1jIlH9wgOTkXRHirfhdegKjfnpAiv68wxhy6HLzzN6gXCc7l7zF+8oSmDADSuVAKrRZMEdNz2ZZP7tLuhtPT0QIdLmiboev68MhUTrD6cN8vGzAnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjRMnhGm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjRMnhGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432B31F000E9;
	Mon, 31 Aug 2026 13:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184685;
	bh=tbKy8XslqhtS1xNwNodwG0l1jUcfASw1WkNmPE28Szo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NjRMnhGmGsZfBK93223oo9D3k25hVzGJHjqd4KfeRV0waIaXSAvNVrrkzLnXRvEhY
	 xl2XAn7vXbNj/eafMCfbMWoj2V31+zBIv+luRyUJ/77VAraD0Qgbru+1F8g4rNfW1I
	 uZUwOpmZc4eKwfOLFdSpr3cEm8C147qtVVTap6qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenkuan Wang <Wenkuan.Wang@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 69/91] x86/CPU/AMD: Add models 0x10-0x1f to the Zen5 range
Date: Mon, 31 Aug 2026 15:34:57 +0200
Message-ID: <20260831133403.241426946@linuxfoundation.org>
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

From: Wenkuan Wang <Wenkuan.Wang@amd.com>

commit 2718a7fdf292b2dcb49c856fa8a6a955ebbbc45f upstream.

Add some more Zen5 models.

Fixes: 3e4147f33f8b ("x86/CPU/AMD: Add X86_FEATURE_ZEN5")
Signed-off-by: Wenkuan Wang <Wenkuan.Wang@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240423144111.1362-1-bp@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -703,8 +703,7 @@ static void bsp_init_amd(struct cpuinfo_
 
 	case 0x1a:
 		switch (c->x86_model) {
-		case 0x00 ... 0x0f:
-		case 0x20 ... 0x2f:
+		case 0x00 ... 0x2f:
 		case 0x40 ... 0x4f:
 		case 0x70 ... 0x7f:
 			setup_force_cpu_cap(X86_FEATURE_ZEN5);


