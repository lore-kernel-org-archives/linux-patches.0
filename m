Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCD41FB9
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2319C4339B;
	Fri,  3 Feb 2023 10:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675420189;
	bh=wlhF59pgf4V8qDjElfKhTcj52TEZtrqe3q44xNjnm4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJTMWIsJfVhk1jMqrbkljOIK69NbbBYixDMKEj75SxbNUMsvr9Ney3DjtJn5RnLQp
	 V0ATdwTFpcRzZbnDVS8Pz2W/X74nr0bfSF3tRz8J1C3CQW1qPGBMkomMik5QfYbPz3
	 XAYTCLrmlqKilkG33yTHMEQHDExUzZEdjFZ7kwb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5.4 109/134] x86/asm: Fix an assembler warning with current binutils
Date: Fri,  3 Feb 2023 11:13:34 +0100
Message-Id: <20230203101028.732656549@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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
@@ -10,6 +10,6 @@
  */
 ENTRY(__iowrite32_copy)
 	movl %edx,%ecx
-	rep movsd
+	rep movsl
 	ret
 ENDPROC(__iowrite32_copy)


