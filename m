Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4408D1FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE14C433D2;
	Fri,  3 Feb 2023 10:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419360;
	bh=3gN4Ub4grtZnQaSSRAejTV95S513QlFlsiZh4LY97go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QB2i4tdjQNHBVNVYWLOaQEDvVzVomFgJzAze8WUSl6nd8LDuWVz7LS0v6Slfi2hyg
	 PIdMJjV3DYjOfxOs/cqcaFCFF2/l1Z20UI0+0rpFVYgp1YzIw6QB2oqGDZWMsi1BSa
	 ns+MWXTmqkyaWwx3feLYpwGPIZHPDelL1KzHyOZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4.14 43/62] x86/asm: Fix an assembler warning with current binutils
Date: Fri,  3 Feb 2023 11:12:39 +0100
Message-Id: <20230203101014.812689172@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mikulas Patocka <mpatocka@redhat.com>

commit 55d235361fccef573990dfa5724ab453866e7816 upstream.

Fix a warning: "found `movsd'; assuming `movsl' was meant"

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/iomap_copy_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/lib/iomap_copy_64.S
+++ b/arch/x86/lib/iomap_copy_64.S
@@ -22,6 +22,6 @@
  */
 ENTRY(__iowrite32_copy)
 	movl %edx,%ecx
-	rep movsd
+	rep movsl
 	ret
 ENDPROC(__iowrite32_copy)


