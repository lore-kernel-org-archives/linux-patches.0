Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A771A3176;
	Wed,  5 Mar 2025 18:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197914; cv=none; b=GHgUR0Y4ha6HlMji/v2B0z5bp6RxnQoxQEsSdAf7G4/ysSZRH2IHIoFK5MlyS/R546PC8att5aUW+DGCbDD1iwQOoHGNDGKHdBIDfSavHjUxUO8YBZeCEJSwFGX7qxJYilcRWO5bTU+mnou3zR+Vasadi7IIWs1+OGjkWni/x0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197914; c=relaxed/simple;
	bh=K+kCQjMbeQVBQy8T6Ew76ubfbAjojJIv1ByUrs420aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3jSpdn4swvSAbdxl25dKVft53y3cLiqCYMaHDq94HgT4ySjjDQCl+C0BHG0xftt+UXPHgBFCaO7xB59KGddTtC+IAqP8Y8/vQxGCOer59qeQQMejrU3tHJfPmhntB07+nAV3Dqc46Ak2ZU3v7CA7yal5cx+leZzwj1N2PR/m+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFTGeuX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFTGeuX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CFDC4CED1;
	Wed,  5 Mar 2025 18:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197913;
	bh=K+kCQjMbeQVBQy8T6Ew76ubfbAjojJIv1ByUrs420aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IFTGeuX8eTwUUVgkAEviqWLROxe8UN3tvvqErFUpOZn0UsAGQRS+65GZU56LGuqOo
	 DYvUcbsEHULR+bt9C3p+K9BIjv1W/JxR4TvpkxVeTgUMeODRKi3eUCQU5EuTD8zSqZ
	 KgQRbYjOnujYX6LFMnhX12Yh0Qc7MmESxm1lNKXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 111/142] x86/microcode/amd: Cache builtin microcode too
Date: Wed,  5 Mar 2025 18:48:50 +0100
Message-ID: <20250305174504.788729475@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit d419d28261e72e1c9ec418711b3da41df2265139 upstream

save_microcode_in_initrd_amd() fails to cache builtin microcode and only
scans initrd.

Use find_blobs_in_containers() instead which covers both.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231010150702.495139089@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -533,7 +533,7 @@ int __init save_microcode_in_initrd_amd(
 	enum ucode_state ret;
 	struct cpio_data cp;
 
-	cp = find_microcode_in_initrd(ucode_path);
+	find_blobs_in_containers(cpuid_1_eax, &cp);
 	if (!(cp.data && cp.size))
 		return -EINVAL;
 


