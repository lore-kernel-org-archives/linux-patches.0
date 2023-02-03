Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A8E1FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA89C433EF;
	Fri,  3 Feb 2023 10:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419642;
	bh=NpIcMv6liOdVHf2PZXzPDLHYoNp54e/OD+2ATZPye6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nY6TJJlv32tNuUt+HgSnJcfFbVzx355Y1GrUVfdN4U+eyECfZptIflDueewL+qXJU
	 ySsnhg1iBZZxT5GHyxqPzFQ8Q8BsX/949/Up+ygggPPIAMjBLlmlHyAXHtAveQXJA3
	 tegLuROhoZnU8OTMlf2kaT1RFMkxTAZLI1U6SLGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Tony Luck <tony.luck@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.19 70/80] ia64: make IA64_MCA_RECOVERY bool instead of tristate
Date: Fri,  3 Feb 2023 11:13:04 +0100
Message-Id: <20230203101018.227499813@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

commit dbecf9b8b8ce580f4e11afed9d61e8aa294cddd2 upstream.

In linux-next, IA64_MCA_RECOVERY uses the (new) function
make_task_dead(), which is not exported for use by modules.  Instead of
exporting it for one user, convert IA64_MCA_RECOVERY to be a bool
Kconfig symbol.

In a config file from "kernel test robot <lkp@intel.com>" for a
different problem, this linker error was exposed when
CONFIG_IA64_MCA_RECOVERY=m.

Fixes this build error:

  ERROR: modpost: "make_task_dead" [arch/ia64/kernel/mca_recovery.ko] undefined!

Link: https://lkml.kernel.org/r/20220124213129.29306-1-rdunlap@infradead.org
Fixes: 0e25498f8cd4 ("exit: Add and use make_task_dead.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/ia64/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -445,7 +445,7 @@ config ARCH_PROC_KCORE_TEXT
 	depends on PROC_KCORE
 
 config IA64_MCA_RECOVERY
-	tristate "MCA recovery from errors other than TLB."
+	bool "MCA recovery from errors other than TLB."
 
 config PERFMON
 	bool "Performance monitor support"


