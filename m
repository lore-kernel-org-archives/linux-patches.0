Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E074F2D626;
	Fri, 24 Nov 2023 18:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qi4z8hv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBAEC433C7;
	Fri, 24 Nov 2023 18:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851331;
	bh=ifaAyk5ygZJH25X27x7blYTmzWTycFU2S3mTgenxKIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qi4z8hv83K0tIf/ePqzGPboqXEyrkyjc87Z70BI2lLmBvhRykcv7U7WT4dIoNYVbv
	 GwiDjjDK913kOGf/IvABf6+/JsZwp4v/+97AMPDF+uj2asCwoSNxBSu2WoDs40LIlZ
	 5mEyXSUvD7wtKkGNSm3LaBjRE7V3EpRsbejAVmKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.5 381/491] parisc: Prevent booting 64-bit kernels on PA1.x machines
Date: Fri, 24 Nov 2023 17:50:17 +0000
Message-ID: <20231124172036.045468399@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit a406b8b424fa01f244c1aab02ba186258448c36b upstream.

Bail out early with error message when trying to boot a 64-bit kernel on
32-bit machines. This fixes the previous commit to include the check for
true 64-bit kernels as well.

Signed-off-by: Helge Deller <deller@gmx.de>
Fixes: 591d2108f3abc ("parisc: Add runtime check to prevent PA2.0 kernels on PA1.x machines")
Cc:  <stable@vger.kernel.org> # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/head.S |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/parisc/kernel/head.S
+++ b/arch/parisc/kernel/head.S
@@ -70,9 +70,8 @@ $bss_loop:
 	stw,ma          %arg2,4(%r1)
 	stw,ma          %arg3,4(%r1)
 
-#if !defined(CONFIG_64BIT) && defined(CONFIG_PA20)
-	/* This 32-bit kernel was compiled for PA2.0 CPUs. Check current CPU
-	 * and halt kernel if we detect a PA1.x CPU. */
+#if defined(CONFIG_PA20)
+	/* check for 64-bit capable CPU as required by current kernel */
 	ldi		32,%r10
 	mtctl		%r10,%cr11
 	.level 2.0


