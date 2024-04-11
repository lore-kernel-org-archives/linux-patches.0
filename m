Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2580F149C7F;
	Thu, 11 Apr 2024 10:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831803; cv=none; b=YGkEwCghVOPx6Aaw6wK2ZHTloKG0ZP0zY5VDLfwFK75QZIK3ASdaNiJpprXSrKE92Da/wD9/bEQAPnBcc9IWbOMQXQx4XC1+q/cl30K+MkRxD89qniC7YMbYjZ6MbQcKS0RcTpahCwnuDgpHiR8sL0vrLtVUQfdoXQZneAJTXl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831803; c=relaxed/simple;
	bh=LKXVCi6/COgxcFi3/vzW+5vClJtbgopADyjWuVsBDF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dstHb9q96c4GsrPQGVFQitK7BNOEFX+yL7AFb3YWwrN//4atMsCtcK5+XTQPIj0NlXsiMCAPe8hGYbahCy6On0wH4N3e0vEuaslD2BXvc1OOjnmUaI/WgygTZqmDiuagKYfZMMDNJCH35HRsfDmTOg4jcSKiPNQlqN2I9ESb1FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THOQhq68; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THOQhq68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E018C433C7;
	Thu, 11 Apr 2024 10:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831803;
	bh=LKXVCi6/COgxcFi3/vzW+5vClJtbgopADyjWuVsBDF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THOQhq68aG5EJDh9SbDG8GdLQVq81btH2B/Fpf9W/s59oM+98vy+nhVaij6EKDoo4
	 xXn/M9Y0DNWzHKu/mdf7nCIGAGSMrPPGsNC+Ecy7Rq9By4eBGhTFt9+eMDLNxCgcTq
	 uMZ2qPc66AG2CCeOcJW3q/wwM8XeK8HuADntQ/Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/294] x86/CPU/AMD: Update the Zenbleed microcode revisions
Date: Thu, 11 Apr 2024 11:54:27 +0200
Message-ID: <20240411095438.804005380@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit 5c84b051bd4e777cf37aaff983277e58c99618d5 ]

Update them to the correct revision numbers.

Fixes: 522b1d69219d ("x86/cpu/amd: Add a Zenbleed fix")
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f29c6bed9d657..3b02cb8b05338 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1049,11 +1049,11 @@ static bool cpu_has_zenbleed_microcode(void)
 	u32 good_rev = 0;
 
 	switch (boot_cpu_data.x86_model) {
-	case 0x30 ... 0x3f: good_rev = 0x0830107a; break;
-	case 0x60 ... 0x67: good_rev = 0x0860010b; break;
-	case 0x68 ... 0x6f: good_rev = 0x08608105; break;
-	case 0x70 ... 0x7f: good_rev = 0x08701032; break;
-	case 0xa0 ... 0xaf: good_rev = 0x08a00008; break;
+	case 0x30 ... 0x3f: good_rev = 0x0830107b; break;
+	case 0x60 ... 0x67: good_rev = 0x0860010c; break;
+	case 0x68 ... 0x6f: good_rev = 0x08608107; break;
+	case 0x70 ... 0x7f: good_rev = 0x08701033; break;
+	case 0xa0 ... 0xaf: good_rev = 0x08a00009; break;
 
 	default:
 		return false;
-- 
2.43.0



