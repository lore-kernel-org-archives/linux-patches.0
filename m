Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4EE6FB1;
	Tue,  5 Dec 2023 03:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtvACu10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED4FC433C8;
	Tue,  5 Dec 2023 03:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747112;
	bh=P+gMd9kUE+NuFmxG3RGdXoRYQP4QpZNkzyRYwMSxyDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtvACu10xlsOAC5RUxL6SbITbz4kdWo0PzSv+0kqs14Pet4X5z6bWluc3rF5wwyil
	 7ERaTBze5yCMBt9/1vb3eySU9F3PIXZTm/aVisO84xe1caU6MgXgM4lRId8TLuAPc6
	 7/ny4GxiMC/o/pT8N/Z0mRd3iIU1bVI3Bdk/RyTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 039/107] parisc: Mark lock_aligned variables 16-byte aligned on SMP
Date: Tue,  5 Dec 2023 12:16:14 +0900
Message-ID: <20231205031533.869445436@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit b28fc0d8739c03e7b6c44914a9d00d4c6dddc0ea upstream.

On parisc we need 16-byte alignment for variables which are used for
locking. Mark the __lock_aligned attribute acordingly so that the
.data..lock_aligned section will get that alignment in the generated
object files.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org   # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/ldcw.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/include/asm/ldcw.h
+++ b/arch/parisc/include/asm/ldcw.h
@@ -56,7 +56,7 @@
 })
 
 #ifdef CONFIG_SMP
-# define __lock_aligned __section(".data..lock_aligned")
+# define __lock_aligned __section(".data..lock_aligned") __aligned(16)
 #endif
 
 #endif /* __PARISC_LDCW_H */


