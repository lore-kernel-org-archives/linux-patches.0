Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BC6268FD2;
	Tue,  8 Apr 2025 11:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112072; cv=none; b=EYi+r/vC1/ReFwK3N7Qmg8wARKJVTC8duMmApZx8figT30/aw8ZbEzyDO+hWxNwiCswvWdu+64xU1faLPPLN9huJ50dAxRrQywoYqzBEi475Nhjl1WOgLKC8GYi6M41mD4TzHMaVMn99pSivUzejFTwYCfMw4gHV8rtRkUQKHxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112072; c=relaxed/simple;
	bh=MJlqyszdqfmj423nCLSVV+kshOwRACU4NPiXuzwpyWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdlImgZltJz+MPGqaPr1blV2ra7Ay8RxwbzlobE17c5/i0ONSrjbR8GRkCiZDpzOf4y0u2qsdpsy62uCobmpU2yunXlAe/Ve+tbwVRJ0rYo2AETQtCe0AAjbFAtSd/OglV6tflNJl9mIqWmhPooWLOWvivtElXIJ2edVz19yng0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXZ+rpY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXZ+rpY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95C9C4CEE5;
	Tue,  8 Apr 2025 11:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112072;
	bh=MJlqyszdqfmj423nCLSVV+kshOwRACU4NPiXuzwpyWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXZ+rpY93Na/HuC8bYcIw1CuyNEIunEOe0jyhHTDdenoPXqnGe6b6Vq1xzqGEbo5w
	 EA1s8qwZdZnEyuEpd9DUGzk8ZuvQ2EoBnyL2BkJXhoQMzfDZMKuUT/MW2v5vrsziRA
	 D2vlqiR8AvPBaYfDHhuqOfQDkPWt61dmQ8Zq0oaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingcong Bai <baimingcong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.14 664/731] LoongArch: Increase MAX_IO_PICS up to 8
Date: Tue,  8 Apr 2025 12:49:21 +0200
Message-ID: <20250408104929.711942701@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit ec105cadff5d8c0a029a3dc1084cae46cf3f799d upstream.

Begin with Loongson-3C6000, the number of PCI host can be as many as
8 for multi-chip machines, and this number should be the same for I/O
interrupt controllers. To support these machines we also increase the
MAX_IO_PICS up to 8.

Cc: stable@vger.kernel.org
Tested-by: Mingcong Bai <baimingcong@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/irq.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/irq.h
+++ b/arch/loongarch/include/asm/irq.h
@@ -53,7 +53,7 @@ void spurious_interrupt(void);
 #define arch_trigger_cpumask_backtrace arch_trigger_cpumask_backtrace
 void arch_trigger_cpumask_backtrace(const struct cpumask *mask, int exclude_cpu);
 
-#define MAX_IO_PICS 2
+#define MAX_IO_PICS 8
 #define NR_IRQS	(64 + NR_VECTORS * (NR_CPUS + MAX_IO_PICS))
 
 struct acpi_vector_group {


