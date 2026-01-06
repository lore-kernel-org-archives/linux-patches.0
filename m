Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA4236D51C;
	Tue,  6 Jan 2026 17:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722388; cv=none; b=EV+266/Ap1ZpK1eRkmTPNLFw4pBUDHhLAigkZA9+uvT7Hdo1Mqou0L2xWVaQq8Yu4AYxrKr5I2avf4aa8S1HKs5uui6jElI/TfD5aq/MTd6486dKG3kJxtR2tDiA10eK2WIwJ/OSTYK1UNS0McYDV8PbcLjAzRswMSjejTPXgcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722388; c=relaxed/simple;
	bh=kcvtB15/4dMETGjshNDk+d7StsIovOxiT/pZm/zQRrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jlr41mHpVB2I78URximA1kRjpcfG8AmAzSHCmvECaQPkruMmGg3gfvLrKdPGx+1GuabwIoHHVt3hEQ5zvfggFH8T7UMi7Eg9yQo3uQN0hnVB5ImBa+7ils73yZQnqRZC6Fb7tI2KD3sg7N+6Uw1ChWKqYmQG/ETWKXHui/XxTYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOxriuHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOxriuHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF2EC116C6;
	Tue,  6 Jan 2026 17:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722388;
	bh=kcvtB15/4dMETGjshNDk+d7StsIovOxiT/pZm/zQRrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOxriuHMEP0EG/TzGdkFPDBKM7e7kB/SQwgti3V11k7ZX/XwipNIyNBVyDEOcxSE/
	 9Jqff4j4m5PYYNAPft/s2+bmE109tPaLE3d3yJe0KIvU1a/UDDnzCHyKkBuMCSkeRw
	 tfdgFhcAzrJL+maS4s49myybEw7Wm5/INX+VjwR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.18 232/312] x86/microcode/AMD: Fix Entrysign revision check for Zen5/Strix Halo
Date: Tue,  6 Jan 2026 18:05:06 +0100
Message-ID: <20260106170556.244463794@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Rong Zhang <i@rong.moe>

commit 150b1b97e27513535dcd3795d5ecd28e61b6cb8c upstream.

Zen5 also contains family 1Ah, models 70h-7Fh, which are mistakenly missing
from cpu_has_entrysign(). Add the missing range.

Fixes: 8a9fb5129e8e ("x86/microcode/AMD: Limit Entrysign signature checking to known generations")
Signed-off-by: Rong Zhang <i@rong.moe>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@kernel.org
Link: https://patch.msgid.link/20251229182245.152747-1-i@rong.moe
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -258,7 +258,7 @@ static bool cpu_has_entrysign(void)
 	if (fam == 0x1a) {
 		if (model <= 0x2f ||
 		    (0x40 <= model && model <= 0x4f) ||
-		    (0x60 <= model && model <= 0x6f))
+		    (0x60 <= model && model <= 0x7f))
 			return true;
 	}
 


