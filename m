Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DCF26A0A6;
	Tue,  8 Apr 2025 12:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115333; cv=none; b=lisz5HMEpsMAGEqyE5+07hmxmkL9iiF/s1S2dVzLeFLZyIzFn7mfkAX8CRRFicvktu5KhKJbtOZhj58s0s7b8p8HZ1hsDhBI1sEq13+DVLh4cE242IqwAXIKQh+xiZhCcSEvIVJYIa2xks5koVDhrjVPxpUlUO9owkE1agBGrFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115333; c=relaxed/simple;
	bh=kBq547XsgDXIbVoD5nzuF9VTprRKC6NBfdHUtSb7JkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaNzZmgMDB3cj9DU3D2sTiybiJC2InYDIsFs7LnmeSG+kvQlt99G4hN0x5vDiQt4fx9XJhC+jYbbBSh/Yx8J8jgMZ8WHK/IzxMcw/j2fcxYUlzKxk42xUy4R9QrhD1bD0c83lVqGpz4l0lQ/PB/ClDPbIn4GmmfwTSroOSSRo+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eu21UAQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eu21UAQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D513C4CEE5;
	Tue,  8 Apr 2025 12:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115332;
	bh=kBq547XsgDXIbVoD5nzuF9VTprRKC6NBfdHUtSb7JkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eu21UAQIPxvj0EhoaV06tF9HKgmIwRSf2vwz2Q61lnkEERsWL15X+eVaKMmbQkUj6
	 Glsq8XYlr8g8uPrI6GG3htnWxyzfmQgP+9uJoxheKrhXtbpaAyYETC+wTN5g36iau+
	 V/QEJWk/kCoGMl+WzcZdUHRJ0HnQT/psqBzK/r2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingcong Bai <baimingcong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.13 436/499] LoongArch: Increase MAX_IO_PICS up to 8
Date: Tue,  8 Apr 2025 12:50:48 +0200
Message-ID: <20250408104902.103650384@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


