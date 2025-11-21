Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C7334C98F;
	Fri, 21 Nov 2025 13:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733140; cv=none; b=VqPzNLTSPotAANfA+Q/YK180TI0Ep6gQi9zEIbUPpX+1GacS0UljoItW12XQlGokPVjQPyfdNIgIFAgcgcrtkqqwUISKXTlqJRi+A8unZ8JCR9Rhf4G1IBNY/6Y1KOYZbuONSpUc4XWeAkccyoxIJuPBnzX4hTfEUX21zlj9UwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733140; c=relaxed/simple;
	bh=f/EF6eQRIdl4JSvzy1c3wKN64EqupkMRa+S7e48YbqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwFLkQdBD5nixWWeE/AWH3MupBUsiPgzfK1m3XgsDBgFHnTUSjHAZvI2JeulyczpEFWE35ftgJfE5le7AN2BmweVdXTxxcI+Va4QuRkPfSUMhcH3/KjcMCTsQ1jwcABWf4ba4zhjLaPVJkd+ptrnb+npP0NffTudJkxReNzPoKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMkl4SIn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMkl4SIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE3DC4CEF1;
	Fri, 21 Nov 2025 13:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733140;
	bh=f/EF6eQRIdl4JSvzy1c3wKN64EqupkMRa+S7e48YbqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMkl4SInqeLB7oCeMvkGaIs8dKtctzV0aoJ3S1Ib7jdboE7hwpQpnQIL6fFVzdsQ2
	 87ZdqJdOo9a1ZD0yR4X57gn5ZBcsuY8umsT84z+xsYhr/zx8tsgAlt2cZ7nhZ8h51h
	 HiMxFWtDYHMiTeWCSkvctXk8G4fMKWmrzUjJc1Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.6 366/529] x86/microcode/AMD: Add more known models to entry sign checking
Date: Fri, 21 Nov 2025 14:11:05 +0100
Message-ID: <20251121130244.051336012@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

commit d23550efc6800841b4d1639784afaebdea946ae0 upstream.

Two Zen5 systems are missing from need_sha_check(). Add them.

Fixes: 50cef76d5cb0 ("x86/microcode/AMD: Load only SHA256-checksummed patches")
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20251106182904.4143757-1-superm1@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -210,10 +210,12 @@ static bool need_sha_check(u32 cur_rev)
 	case 0xaa001: return cur_rev <= 0xaa00116; break;
 	case 0xaa002: return cur_rev <= 0xaa00218; break;
 	case 0xb0021: return cur_rev <= 0xb002146; break;
+	case 0xb0081: return cur_rev <= 0xb008111; break;
 	case 0xb1010: return cur_rev <= 0xb101046; break;
 	case 0xb2040: return cur_rev <= 0xb204031; break;
 	case 0xb4040: return cur_rev <= 0xb404031; break;
 	case 0xb6000: return cur_rev <= 0xb600031; break;
+	case 0xb6080: return cur_rev <= 0xb608031; break;
 	case 0xb7000: return cur_rev <= 0xb700031; break;
 	default: break;
 	}


