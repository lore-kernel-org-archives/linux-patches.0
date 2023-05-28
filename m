Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE08F611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA8DC433D2;
	Sun, 28 May 2023 19:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302521;
	bh=f7t2ldgANhpQoF1Q/P/4/m8ikNgrW8/ejigJltQAi3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ou64YGBqrWSgP+1tu8wtd75N+JW6In14Ca0290QBD36I7pd9+ybxma9p36mlFdV+z
	 GTRrTgGN3SXUdIre7qM5Q0HBlZzbZZMPZHYn3T79d/6+B9WiG+iFzk+LhdlE6Z+iHi
	 3tR9YGSgY3Mj0QCJtJuTuDViW8Y7wC7Z01aowJl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 036/119] parisc: Enable LOCKDEP support
Date: Sun, 28 May 2023 20:10:36 +0100
Message-Id: <20230528190836.578361685@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit adf8e96a7ea670d45b5de7594acc67e8f4787ae6 upstream.

Cc: <stable@vger.kernel.org> # v6.0+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -129,6 +129,10 @@ config PM
 config STACKTRACE_SUPPORT
 	def_bool y
 
+config LOCKDEP_SUPPORT
+	bool
+	default y
+
 config ISA_DMA_API
 	bool
 


