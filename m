Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639811DE4CC;
	Tue,  8 Oct 2024 12:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390805; cv=none; b=X/JOuwHtyFk2dIJALPZOOQY1QHBoR2pORkUy90mmP3V4R4AJeJc/gxkfPIEbBVCD97/AM22n6wGvy6YdE8K0vK/kbMi6IzO90TwSWwL/MevfrecrL4Q98pwjgJyJTicEh3RiUMo+r1u27Dqy/ZTmYPPqWGoHLYnc3E1SlozVnV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390805; c=relaxed/simple;
	bh=Wzw2rGRg610jnvXOAuJzm/NGhjmbnfYoqZpSHY7f69s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPer+BrTbI+ecJ4XY+mRYN+Ah5GlDPCMuyA08o8grUDxu1eq0adiP+CmG3N74rdmX39MgUZK/IBK8w59usVaJtvvZvc3Z7vWztBh5WJaxobOp0f+HjBdA30tBOR+uRIUg2Ptw8q2hEhV+Gx4oNzMzFloty+G9w5zbGOHjNGiehE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVCsRytl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVCsRytl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93195C4CEC7;
	Tue,  8 Oct 2024 12:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390805;
	bh=Wzw2rGRg610jnvXOAuJzm/NGhjmbnfYoqZpSHY7f69s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QVCsRytlXpNXSvYI3r0DhzGZIby1GUolfI8Re6K/mjQaHUBB1IvWG8i8Zw5I5bJeX
	 Q7V4xfQb2QEqWfynnAWTkkJPFJOuFlApr8IB0diYXrijCKHNZfEElu1XhYMs2gX8iy
	 c2sCrvyPXCtmnERjdV0qXUCsdOAZHxg1Evm0lIEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.10 367/482] riscv: define ILLEGAL_POINTER_VALUE for 64bit
Date: Tue,  8 Oct 2024 14:07:10 +0200
Message-ID: <20241008115702.864304586@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -312,6 +312,11 @@ config GENERIC_HWEIGHT
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


