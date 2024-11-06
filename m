Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A5F1E0488;
	Wed,  6 Nov 2024 13:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898521; cv=none; b=pWE2k1Uk6KWsZc5VbSS0LtpODcSKEChzDGmGx8b0xhyXfuinUSas+4nNGdWXvWR+GAkVZxOlfs7Y/6pW8O7lcBEMsjY4jX4JLGpECCAQ9mJdMkAW4fGBUgkb8yC7QiSClIp8IbNua01XWTPJFb9iCTTYJi60DZMFSbi2r4Eij6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898521; c=relaxed/simple;
	bh=TSsQWLUh16BAE56JJMn5uuNkO/Fbs0zVuCG0Cyb2cTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEgB4zpl1eI8aqTz8HOB6vnK24u7MSGPPYBiVSELxqGcCbyFL49ojvPx71PldQrvM4K5jb/+5E2I4RDsAEYajP8njvPVoXTUfLp5zrbsfHyQRy1vJE0pFCjpTbSzp8Ec8O1SMNNdRJBtL87WKLmXA0rtd97dKkAbq2fZ6fVhR18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGJfu/Qm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGJfu/Qm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8418C4CED3;
	Wed,  6 Nov 2024 13:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898521;
	bh=TSsQWLUh16BAE56JJMn5uuNkO/Fbs0zVuCG0Cyb2cTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGJfu/Qmn/A0+AtA97OY9NbdTAx9m8ehcGsmqk/xcxMKt4moHBSmeL4/sd8o7Fp2Q
	 9uwbEJoiX2ZxydW10eoNVl274Xo+2HeY1vR4SV4Kwk1uWTSzT4arEkwxPN2+sHzpci
	 hRngJjWbTvXUkzA0XOlxejmJgtAeuy64+D+AH270=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.4 265/462] riscv: define ILLEGAL_POINTER_VALUE for 64bit
Date: Wed,  6 Nov 2024 13:02:38 +0100
Message-ID: <20241106120338.074705300@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

commit 5c178472af247c7b50f962495bb7462ba453b9fb upstream.

This is used in poison.h for poison pointer offset. Based on current
SV39, SV48 and SV57 vm layout, 0xdead000000000000 is a proper value
that is not mappable, this can avoid potentially turning an oops to
an expolit.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Fixes: fbe934d69eb7 ("RISC-V: Build Infrastructure")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240705170210.3236-1-jszhang@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -139,6 +139,11 @@ config GENERIC_HWEIGHT
 config FIX_EARLYCON_MEM
 	def_bool y
 
+config ILLEGAL_POINTER_VALUE
+	hex
+	default 0 if 32BIT
+	default 0xdead000000000000 if 64BIT
+
 config PGTABLE_LEVELS
 	int
 	default 3 if 64BIT


