Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C61F342526;
	Fri, 21 Nov 2025 13:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731087; cv=none; b=urEEQ5COi5zgaCd7iR+DRu6pc/o8xOBV/4SgqbZJxapjZtrNPvt5UoDb7Aku3e/QbRZd4fvkX7vPEqBg8caOCiYHTZn4XO/eyruvpFUFmA6RTECDRzCkUh6P8vfxXceS/hzDR4P2EYBXmzoogyFIOBSA/2iVnoO5CrsfMGq+brs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731087; c=relaxed/simple;
	bh=iE6ulZQAz/XuEjPzg9Js1SaWNmQbChXt5xPLusUcNfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoZG9fDEsyR94ZaMN52ikb+BEDMWkoOuIPQ9nQ10SimEyrEpCX1dVE8G3ayVMpcoA20hJH3X5cwKDnOlfBmiyqHMr75mCULsCdRdndasrumOiL6kUsigoIXWgqHMP4Xx5zifxk6JjP8UeuD/2rlxgFEFvkQqB/6zYV4d4/BNQdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lF37V1Np; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lF37V1Np"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F09C4CEF1;
	Fri, 21 Nov 2025 13:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731086;
	bh=iE6ulZQAz/XuEjPzg9Js1SaWNmQbChXt5xPLusUcNfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lF37V1NpZuyv8YxOiUXVrpRSreD1ERLM2+WddyhL3iQpApcZNU8PUCtSUghIpiONy
	 1OAbkyHVC+nP3PXSNCKWfqf9Dk/f8Bh9DpKwjy/7PNBgno3MBRtrKr8B2/o4404mrn
	 54C5Xi+sb3/VYYBIZCxxNSjVKLHuln1YQfgOBBtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Mingcong Bai <jeffbai@aosc.io>,
	Xi Ruoyao <xry111@xry111.site>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 053/247] rust: Add -fno-isolate-erroneous-paths-dereference to bindgen_skip_c_flags
Date: Fri, 21 Nov 2025 14:10:00 +0100
Message-ID: <20251121130156.509582780@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Ruoyao <xry111@xry111.site>

[ Upstream commit fe4b3a34e9a9654d98d274218dac0270779db0ae ]

It's used to work around an objtool issue since commit abb2a5572264
("LoongArch: Add cflag -fno-isolate-erroneous-paths-dereference"), but
it's then passed to bindgen and cause an error because Clang does not
have this option.

Fixes: abb2a5572264 ("LoongArch: Add cflag -fno-isolate-erroneous-paths-dereference")
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Tested-by: Mingcong Bai <jeffbai@aosc.io>
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/Makefile b/rust/Makefile
index 9ec1119c02d39..403ce8518381d 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -299,7 +299,7 @@ bindgen_skip_c_flags := -mno-fp-ret-in-387 -mpreferred-stack-boundary=% \
 	-fno-inline-functions-called-once -fsanitize=bounds-strict \
 	-fstrict-flex-arrays=% -fmin-function-alignment=% \
 	-fzero-init-padding-bits=% -mno-fdpic \
-	--param=% --param asan-%
+	--param=% --param asan-% -fno-isolate-erroneous-paths-dereference
 
 # Derived from `scripts/Makefile.clang`.
 BINDGEN_TARGET_x86	:= x86_64-linux-gnu
-- 
2.51.0



