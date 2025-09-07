Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2243214D29B;
	Sun,  7 Sep 2025 20:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277944; cv=none; b=iO+5dxtiE5aB7mV0uG2ZI1YsVNf8MLQeXwtR6yjJsDumGfM2f8ZEQxQnfOp5FkEC0erNb7p9t76xrflI2EYFk1mMRQww+DhDMvezXsKQ2kxwAxPGdWl18tgqhThWffXB+bin3xZhFqDyL7aqSg2Wqz/LghmwWo0DVRqdm8R+FdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277944; c=relaxed/simple;
	bh=/z5j9yqiUaD3yi9kJFYSSzzEI1FN0aHAJhfizJxgQ94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOtcsaSL0ZLg1uAjWpa+3I+gtAdlhp+OGWDXcGdlT0pu15XhMua1A0Afko8HmKwzZ2ruBSjIcA7agHAsxIRoUujWCRBg/Ev61jt65qPlW0W6DJ7sZEz2g1M1NyEiTKZhdpNNCgJXGCmUW2XiY/zp9D8Vydu+5vxGo1Z5EvAygPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXWBgirR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXWBgirR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71059C4CEF0;
	Sun,  7 Sep 2025 20:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277944;
	bh=/z5j9yqiUaD3yi9kJFYSSzzEI1FN0aHAJhfizJxgQ94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXWBgirRNVSHDqfk8u5g8+WhUu/TnbPpCgPDmnfPPspUDqn0Yl2hc0U3kzyLedyDz
	 l9IOCBRZF5L2kLSUWS2KxiJB3jrgc0gwhi6614Fes5CYxxbpxzdM+ITkLHdwt/NIfG
	 y4UACevZIFbRU0MHaZgPirngoTNkYx63t5hL/Uzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <apatel@ventanamicro.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Troy Mitchell <troy.mitchell@linux.dev>,
	Sunil V L <sunilvl@ventanamicro.com>,
	Nutty Liu <nutty.liu@hotmail.com>,
	Atish Patra <atishp@rivosinc.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.16 173/183] ACPI: RISC-V: Fix FFH_CPPC_CSR error handling
Date: Sun,  7 Sep 2025 22:00:00 +0200
Message-ID: <20250907195619.928485661@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anup Patel <apatel@ventanamicro.com>

commit 5b3706597b90a7b6c9ae148edd07a43531dcd49e upstream.

The cppc_ffh_csr_read() and cppc_ffh_csr_write() returns Linux error
code in "data->ret.error" so cpc_read_ffh() and cpc_write_ffh() must
not use sbi_err_map_linux_errno() for FFH_CPPC_CSR.

Fixes: 30f3ffbee86b ("ACPI: RISC-V: Add CPPC driver")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Troy Mitchell <troy.mitchell@linux.dev>
Reviewed-by: Sunil V L <sunilvl@ventanamicro.com>
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250818143600.894385-2-apatel@ventanamicro.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/riscv/cppc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/riscv/cppc.c
+++ b/drivers/acpi/riscv/cppc.c
@@ -119,7 +119,7 @@ int cpc_read_ffh(int cpu, struct cpc_reg
 
 		*val = data.ret.value;
 
-		return (data.ret.error) ? sbi_err_map_linux_errno(data.ret.error) : 0;
+		return data.ret.error;
 	}
 
 	return -EINVAL;
@@ -148,7 +148,7 @@ int cpc_write_ffh(int cpu, struct cpc_re
 
 		smp_call_function_single(cpu, cppc_ffh_csr_write, &data, 1);
 
-		return (data.ret.error) ? sbi_err_map_linux_errno(data.ret.error) : 0;
+		return data.ret.error;
 	}
 
 	return -EINVAL;


