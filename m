Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4863E151CE9;
	Tue, 20 Feb 2024 21:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463982; cv=none; b=giqmfSf16gJx8Ti2nIXlqqdg2IyTHqIAwZNoAvdLdjqw3hqz/2Fd7DaN8FXDHevA0Y2jdZf06f2ab5luozmT8pwdoQx26fLcGdS8IFGtyUG5TywUsdEnmpvslVuUcETyXBKrvBuiTIX+7ylL5RTmGEobxuR9v9WbCwulxx9XP5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463982; c=relaxed/simple;
	bh=4dwTk5xDCm7fZ+nZ2TFu7K3y4JcuB+kjPej8v+F5V/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khe/WIAKBDkwvTp+54f2X3weoZNXunXExCZx9kt367MNeZ+KmtOHEkoLBfR8Owtpyu/9PqNdzLUFkcNCKUxciKgT/YTmdHEbRKXyxfdJl69W0GRj0/5+69mJblZz4Stta18SK+w6Nfo8+h8B5JbVm2wQ0ELC+v9LVdirT1mg9jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9OM8DUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9OM8DUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB45C433C7;
	Tue, 20 Feb 2024 21:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463981;
	bh=4dwTk5xDCm7fZ+nZ2TFu7K3y4JcuB+kjPej8v+F5V/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9OM8DUkhXmVq4tGeqvvjEw/Y5Kn1yStB1Kjk1k/iRj6kar9YebPGznTKefLgLAJd
	 3eOUS7fUO+2AmmzCjpppsk/YjwVW6x3NBB/K+ywrigOQ4qOC6OJcCWbYV1LAAZ6ejq
	 mtV3kW2tslLgXmjNO4Wfyc7ErqKDQE/5TK0+w7FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Engraf <david.engraf@sysgo.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.6 185/331] powerpc/cputable: Add missing PPC_FEATURE_BOOKE on PPC64 Book-E
Date: Tue, 20 Feb 2024 21:55:01 +0100
Message-ID: <20240220205643.366588863@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: David Engraf <david.engraf@sysgo.com>

commit eb6d871f4ba49ac8d0537e051fe983a3a4027f61 upstream.

Commit e320a76db4b0 ("powerpc/cputable: Split cpu_specs[] out of
cputable.h") moved the cpu_specs to separate header files. Previously
PPC_FEATURE_BOOKE was enabled by CONFIG_PPC_BOOK3E_64. The definition in
cpu_specs_e500mc.h for PPC64 no longer enables PPC_FEATURE_BOOKE.

This breaks user space reading the ELF hwcaps and expect
PPC_FEATURE_BOOKE. Debugging an application with gdb is no longer
working on e5500/e6500 because the 64-bit detection relies on
PPC_FEATURE_BOOKE for Book-E.

Fixes: e320a76db4b0 ("powerpc/cputable: Split cpu_specs[] out of cputable.h")
Cc: stable@vger.kernel.org # v6.1+
Signed-off-by: David Engraf <david.engraf@sysgo.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240207092758.1058893-1-david.engraf@sysgo.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/cpu_specs_e500mc.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/cpu_specs_e500mc.h
+++ b/arch/powerpc/kernel/cpu_specs_e500mc.h
@@ -8,7 +8,8 @@
 
 #ifdef CONFIG_PPC64
 #define COMMON_USER_BOOKE	(PPC_FEATURE_32 | PPC_FEATURE_HAS_MMU | \
-				 PPC_FEATURE_HAS_FPU | PPC_FEATURE_64)
+				 PPC_FEATURE_HAS_FPU | PPC_FEATURE_64 | \
+				 PPC_FEATURE_BOOKE)
 #else
 #define COMMON_USER_BOOKE	(PPC_FEATURE_32 | PPC_FEATURE_HAS_MMU | \
 				 PPC_FEATURE_BOOKE)


