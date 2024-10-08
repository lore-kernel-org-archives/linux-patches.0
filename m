Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2C71E0DFE;
	Tue,  8 Oct 2024 13:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393829; cv=none; b=AIh8P8lsndLK9gTWz0xozD5E/kkAZ0oIBDf/DlVPUK+co8q58Sj0ulToQ+TGcIi8ytl/k0X8rScGfYQShr1nhUOnxIDuwSfESWoL+4PMvcJmv/rMxjazEV2VSdtnnm7/YqJJXRj1bpoKO+n4X9HzqnKharUX5Lr+u/0Q8lYrp18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393829; c=relaxed/simple;
	bh=VI+JN1XYTgd+rFKLLWgcU7w6xx2kACg63qiUsH4iClU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HldX6wt4qx5PKl+339Nsh/biAewZrJEuVuJgUET0T72HHWpSCQk4z+MjKaXHbQkZrijxGNkmIo1P8q3Fc51gMOm6kl1Qc7Gpd/0uVtaPy78IT0xR1cHRqtYjQ16q2UJw4rOv/OA4Nl7afe03w+KhXs3rTiYyrX+/GHC7bsyv5vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYHfRFko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYHfRFko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6BBC4CECC;
	Tue,  8 Oct 2024 13:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393828;
	bh=VI+JN1XYTgd+rFKLLWgcU7w6xx2kACg63qiUsH4iClU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYHfRFkoIEs7L8I0/ZyCfP4RFiC346V0Sr+0qEg8mjIzjh/dXKPn2EAehKzVQ8uRU
	 PWFOUbY6Hsoue82RuSqF2vh6OSsW+tHKQ2WjczHXaihzWpjqpMsf86F/2zN3bhqtzq
	 Tt/RAjQTDdR5dMpDHlR+nmkXyvTrcLxQpE3qi1Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.6 268/386] riscv: define ILLEGAL_POINTER_VALUE for 64bit
Date: Tue,  8 Oct 2024 14:08:33 +0200
Message-ID: <20241008115639.937930116@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -259,6 +259,11 @@ config GENERIC_HWEIGHT
 config FIX_EARLYCON_MEM
 	def_bool MMU
 
+config ILLEGAL_POINTER_VALUE
+	hex
+	default 0 if 32BIT
+	default 0xdead000000000000 if 64BIT
+
 config PGTABLE_LEVELS
 	int
 	default 5 if 64BIT


