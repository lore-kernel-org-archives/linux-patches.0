Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6143A34EF19;
	Fri, 21 Nov 2025 13:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733477; cv=none; b=ebb18clbdatot+zXkcAcphUWX3pScWcIjXsiA13CM5IJCsu8ysexS6w6FyltrRL08UfHpSXvtJ/Sj9S1/anJr5FMf28zPNv3KNSgZ9p/Rlsf32KsXT1pHQ2bTuz/R/WNaiKPkU46FHWMlF4OiUwydUvPeHeGD6N0WQG/4nBYQUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733477; c=relaxed/simple;
	bh=DX8xHgO3c72RSXkei1fAWhuSv16FAd36eUCurKPm7Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZLtiaf2Q1Y/UR9fR8A9yfuC4DvtadX1/xDbuYExyRE46xn4Ms1U5MnAd4PybT/BGU24xN7pkDiaqqj7jtMtzsgdEIXQhdhEVfDdW6WeAwaV/uoJoYHLwt0l8kbZlxk+p2NPPxJFYSVbAe/jLIkyyJRuDm5uWF70jX2rKCO5MA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVkuuaF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVkuuaF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6D3C4CEF1;
	Fri, 21 Nov 2025 13:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733477;
	bh=DX8xHgO3c72RSXkei1fAWhuSv16FAd36eUCurKPm7Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVkuuaF0PzsP2cIlpBTCORORFf15LFNwFCjC0pC6FfRGZbtm4vvm0IWVIh18nUPnl
	 7fxVibX1JQo5O7ZAZZldi7X3JwDlF4QJstH+CwvGIahUnfaVZjaldDDtQAmOyelnHU
	 2n0TXK/QRtehLC/nN2dS6frGxC9pa2c98iyYokeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.6 481/529] x86/microcode/AMD: Add Zen5 model 0x44, stepping 0x1 minrev
Date: Fri, 21 Nov 2025 14:13:00 +0100
Message-ID: <20251121130248.123430353@linuxfoundation.org>
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

From: Borislav Petkov (AMD) <bp@alien8.de>

commit dd14022a7ce96963aa923e35cf4bcc8c32f95840 upstream.

Add the minimum Entrysign revision for that model+stepping to the list
of minimum revisions.

Fixes: 50cef76d5cb0 ("x86/microcode/AMD: Load only SHA256-checksummed patches")
Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/e94dd76b-4911-482f-8500-5c848a3df026@citrix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -214,6 +214,7 @@ static bool need_sha_check(u32 cur_rev)
 	case 0xb1010: return cur_rev <= 0xb101046; break;
 	case 0xb2040: return cur_rev <= 0xb204031; break;
 	case 0xb4040: return cur_rev <= 0xb404031; break;
+	case 0xb4041: return cur_rev <= 0xb404101; break;
 	case 0xb6000: return cur_rev <= 0xb600031; break;
 	case 0xb6080: return cur_rev <= 0xb608031; break;
 	case 0xb7000: return cur_rev <= 0xb700031; break;


