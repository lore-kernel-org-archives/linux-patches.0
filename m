Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E428D15D5B3;
	Mon, 29 Jan 2024 17:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548404; cv=none; b=E0Ug3KBUogs206ma31sYbt/NqUKzqb3R8DyU9bCMcKF9Xd2X9lMkJ/9g3PbCFCdmlTMQ5QdI4Quu7Yyd8VhHsFr7h0YoNoNn//MBGN1xLdd5hpiVSBJnVmEkQCAlCpuTZSAgDS2aJiPKDCkk0ds2M+OJsnkUN4qTQbr/HDZ9Ti0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548404; c=relaxed/simple;
	bh=hJZreGN6t4ekz6AWVu9mBbN9ommLfV9ayhopMB+aTi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0aWwX8RLdep+1uRP4NM4u5RlSiykYdVstH8EjhpK4YqrMkqDhG+WWTEuIxTAwSN2fGf/O42vQKbj/Mr/3RIcnLNJsMNA1jhDZH54+wulFsdVnTtsPWfzscHJCZ3Rrr/mC0UkHshEn3sgCCI2nUFAqghnRt/vXmqTnFU8ty+HpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0FH7Fnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0FH7Fnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCA1C433C7;
	Mon, 29 Jan 2024 17:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548403;
	bh=hJZreGN6t4ekz6AWVu9mBbN9ommLfV9ayhopMB+aTi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0FH7Fnj36AtHcxaRoju2sj2DkjRvQ/Qgje1GxKkQ4i5AK8VY+tW5rFFGY0k87IHX
	 1XBnG2u5tbG7WiIjmuSERBQ4tpAGddoFpcbcrj8l1QyKPkGcRg93Zq1B9AZrorEaYg
	 BH4DH9gSSbZuWlxDEvyG0lG+mF4VYKqL+Ne6sWKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/185] Revert "powerpc/64s: Increase default stack size to 32KB"
Date: Mon, 29 Jan 2024 09:06:05 -0800
Message-ID: <20240129170003.894415139@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 9ccf64e763aca088b0d25c1274af42b1a6a45135 which is
upstream commit 18f14afe281648e31ed35c9ad2fcb724c4838ad9.

Breaks the build:

arch/powerpc/kvm/book3s_hv_rmhandlers.S:2689: Error: operand out of range (0x0000000000008310 is not between 0xffffffffffff8001 and 0x0000000000008000)
make[3]: *** [scripts/Makefile.build:382: arch/powerpc/kvm/book3s_hv_rmhandlers.o] Error 1

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 2c94f9cf1ce0..6050e6e10d32 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -806,7 +806,6 @@ config THREAD_SHIFT
 	int "Thread shift" if EXPERT
 	range 13 15
 	default "15" if PPC_256K_PAGES
-	default "15" if PPC_PSERIES || PPC_POWERNV
 	default "14" if PPC64
 	default "13"
 	help
-- 
2.43.0



