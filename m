Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A7E20C004;
	Wed,  5 Mar 2025 18:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197832; cv=none; b=lmZVKw1cfrqq+ec4sFWgeNDx0RvDAVpt6enpEKi7MNSxgVS0sSlLfG6CpStL5tBLqdI+re72y/1COiTvVhfb0A4Oq+jvviYor/jf2dGP1+c+7ddCL1Bqg0FieU5HMjnntmXQsqb8Xoa6de2Zzf3PBozpJr5esVXpwM0HvkYpSRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197832; c=relaxed/simple;
	bh=qzV3OFH9JVnEhsNT1RJXgjBFkZJaWDTHYCVZFtb4pGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GR7SrUDG9ftAFsaHw1CIQ+J8CMIicq3oI0Shy0hmopBwI5efzEjgviInNByTjL9o4oDUbg9KRcKk4bgIcveFaAwgtcMDy66z8PM5AAGoWQkejR4AUjKy8gJDI4z1fZ19RRFnZT01VFvZ/mCYK0KtXYK+MHevbPwE/ZtcSyEWtCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eK2tBCml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eK2tBCml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4523C4CEE2;
	Wed,  5 Mar 2025 18:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197832;
	bh=qzV3OFH9JVnEhsNT1RJXgjBFkZJaWDTHYCVZFtb4pGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eK2tBCmlGNKcpBIEnodldJFgpbEJHwaUJs3WQFf+Y98/zGonQsIZQdcZPbZse9zLQ
	 Dl9sPpiTHnaT6z1Z2RT5etA+JZ6fpwmrdhEB0Cb4elQcfN8FjI33FVS/67XlTwlrtb
	 SaRhX2B3GexNM6OOTB+46qfkGx0zd6ZhYzU2FV48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 116/142] x86/microcode: Clean up mc_cpu_down_prep()
Date: Wed,  5 Mar 2025 18:48:55 +0100
Message-ID: <20250305174504.990748557@linuxfoundation.org>
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

commit ba48aa32388ac652256baa8d0a6092d350160da0 upstream

This function has nothing to do with suspend. It's a hotplug
callback. Remove the bogus comment.

Drop the pointless debug printk. The hotplug core provides tracepoints
which track the invocation of those callbacks.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231002115903.028651784@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/core.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -498,16 +498,10 @@ static int mc_cpu_online(unsigned int cp
 
 static int mc_cpu_down_prep(unsigned int cpu)
 {
-	struct device *dev;
-
-	dev = get_cpu_device(cpu);
+	struct device *dev = get_cpu_device(cpu);
 
 	microcode_fini_cpu(cpu);
-
-	/* Suspend is in progress, only remove the interface */
 	sysfs_remove_group(&dev->kobj, &mc_attr_group);
-	pr_debug("%s: CPU%d\n", __func__, cpu);
-
 	return 0;
 }
 


