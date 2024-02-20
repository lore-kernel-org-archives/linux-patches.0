Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86EF14F9C8;
	Tue, 20 Feb 2024 21:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463069; cv=none; b=F5ohSMqYErzWNsEDHcKh/8MYueKXU6XnJkfBTRMgyN65oWvp1KnAph17o8G3Sd7a0ZGRU6IPjKlXxVv37/pRDniTVrWe8YH6LibT4ytUZHB3X5AACn9xvdWSBHbDB43cdZbOTwpG9z7Y2NZ0Y0wQRjjHMpMOarRQM4CZsuV8lU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463069; c=relaxed/simple;
	bh=YQc+0ErxYSoUX+A6E/zgi31fDVBjpgNb1jnKbd2zqnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7LSbgE4AU+lkdru02YBMwUxy52EajzqvdFs/mlGcVlPQ3ePUsVSogcFVZ5Mvng3cte0eT1EceiJUdZe+eOa9eV/IA3rTs7yOXF0irRVr3WCu+O9CJgcjQKC1EEA9sKrkLfGa7PaMgeX+Qj7g4rZ3lxEfvws7YW90BBfc2D3QVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRlgZAQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRlgZAQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1407EC433C7;
	Tue, 20 Feb 2024 21:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463069;
	bh=YQc+0ErxYSoUX+A6E/zgi31fDVBjpgNb1jnKbd2zqnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRlgZAQYxCL4EaGyKqa+Z9CX2N9runEAUHDbaW1tQjcefoxT9EbRRKa4vnePJdLm1
	 UBSugrRjodGctnpq2goJTXhPwmJJ0ePRivmdIQCj+T3iw2ywH3k4FcRtazycwsxt2m
	 CLXdQW6MOxxMdPC8tPstdsMUY8CjPI9uWzKmW6CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Engraf <david.engraf@sysgo.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.1 125/197] powerpc/cputable: Add missing PPC_FEATURE_BOOKE on PPC64 Book-E
Date: Tue, 20 Feb 2024 21:51:24 +0100
Message-ID: <20240220204844.814522539@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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


