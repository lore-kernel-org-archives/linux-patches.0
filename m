Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B6B185C
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE14C433C8;
	Sun,  9 Jul 2023 11:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901262;
	bh=+WHFJjUrMwolUAWbF0/L7OwyJp6Po2fQZ723RPilcXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GlTrwd45ZdAP7dcH/Y5FNcrwr0DF/O7mAOgAyTxYz/P/9+FnOiBABof8T/kiJcesp
	 inZyhPxwiQRfs08e7KfHEPsIZpasO0VqWhgbH8p9aDobFFuSD/ZgM6PzfIqN0E6W1E
	 SYM4TlsgKTHoprsFKMtB2YXwV+aI0qZ3VXqNBgzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Jacob Young <jacobly.alt@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Holger=20Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 1/8] mm: disable CONFIG_PER_VMA_LOCK until its fixed
Date: Sun,  9 Jul 2023 13:14:07 +0200
Message-ID: <20230709111345.351078148@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111345.297026264@linuxfoundation.org>
References: <20230709111345.297026264@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Suren Baghdasaryan <surenb@google.com>

commit f96c48670319d685d18d50819ed0c1ef751ed2ac upstream.

A memory corruption was reported in [1] with bisection pointing to the
patch [2] enabling per-VMA locks for x86.  Disable per-VMA locks config to
prevent this issue until the fix is confirmed.  This is expected to be a
temporary measure.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=217624
[2] https://lore.kernel.org/all/20230227173632.3292573-30-surenb@google.com

Link: https://lkml.kernel.org/r/20230706011400.2949242-3-surenb@google.com
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Closes: https://lore.kernel.org/all/dbdef34c-3a07-5951-e1ae-e9c6e3cdf51b@kernel.org/
Reported-by: Jacob Young <jacobly.alt@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217624
Fixes: 0bff0aaea03e ("x86/mm: try VMA lock-based page fault handling first")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Holger Hoffstätte <holger@applied-asynchrony.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1198,8 +1198,9 @@ config ARCH_SUPPORTS_PER_VMA_LOCK
        def_bool n
 
 config PER_VMA_LOCK
-	def_bool y
+	bool "Enable per-vma locking during page fault handling."
 	depends on ARCH_SUPPORTS_PER_VMA_LOCK && MMU && SMP
+	depends on BROKEN
 	help
 	  Allow per-vma locking during page fault handling.
 


