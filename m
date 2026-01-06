Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87615200C2;
	Tue,  6 Jan 2026 17:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721122; cv=none; b=UizNiFE9k0Nuz8CBEBIv+SXs1lOjTiBW/uwIk1R2WGOlVpymxM1YvaM4l1B5xXNx1UllYuyikg2kVIr3SOXfr+YnyVVLvw5+ogSgfD8IKWiL5JSnciA4dOXTNX+Jg/cByuCC878Ptcg31KaMOVnYVIK7tdjxuguM8qmiyfVeL10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721122; c=relaxed/simple;
	bh=fH2VY3SnH8lj8elrJ2byb6MnhfRl7Lgd0GnIklED/74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5ykUTnbbJPKDCpnNV7Abt/OqRC7FVFQlfwSGqHiW3v0QSJw4sUgvbty9r4+HFn/CJuuFlKlhlP0IzjbxMXOSshlcT8UmqOAzGs3cDVmNX4RJg1OkNdGhlOTGiAm8+/HDnRWwQGGK+tZIPD6bKwyqDKfycpiD1ARGGrs4TE6h2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zp9dXDaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zp9dXDaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B22C116C6;
	Tue,  6 Jan 2026 17:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721122;
	bh=fH2VY3SnH8lj8elrJ2byb6MnhfRl7Lgd0GnIklED/74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zp9dXDaj5vhDlRWEBUbnyYChSgKwqPZvwe2eBrvyJEks7etFHbmGc+sBrzpwwmVq3
	 Bu+ZnYTtpFDLx+jT4SZvhATZifZJG2+wXqAqSPTSYmnL2UHuMR71MmZUCsRTvB0Q1Z
	 /8NnlTImSOup2t8adETDYTiITDZaQqMJAOM9ebu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.12 442/567] x86/microcode/AMD: Fix Entrysign revision check for Zen5/Strix Halo
Date: Tue,  6 Jan 2026 18:03:44 +0100
Message-ID: <20260106170507.702459250@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
@@ -235,7 +235,7 @@ static bool cpu_has_entrysign(void)
 	if (fam == 0x1a) {
 		if (model <= 0x2f ||
 		    (0x40 <= model && model <= 0x4f) ||
-		    (0x60 <= model && model <= 0x6f))
+		    (0x60 <= model && model <= 0x7f))
 			return true;
 	}
 


