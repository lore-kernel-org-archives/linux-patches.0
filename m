Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7763A8BEA;
	Tue,  5 Dec 2023 03:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwEMKTcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10233C433C9;
	Tue,  5 Dec 2023 03:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746594;
	bh=irV3VRf29Vi/bza9aU7qQ0GrHVALOIGLSDLV/lFHoV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwEMKTcvR8nP94/pe2yfOzJQjqnMpzi9RZ77qcWASjXa8OKHjBcirxoT0eMkJtLyo
	 Z4TVIqPkjdW2DiFuTrFAKYK5DwUPOWwrf+tGjqpj+mNAKkCXOI0uLvZ+E1/CIuh/d0
	 Wt0kZYtJvwY2X4p46y/kOBGpZ1yTtgdNDVIUjycU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Bruno Haible <bruno@clisp.org>
Subject: [PATCH 6.6 060/134] parisc: Drop the HP-UX ENOSYM and EREMOTERELEASE error codes
Date: Tue,  5 Dec 2023 12:15:32 +0900
Message-ID: <20231205031539.338390820@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit e5f3e299a2b1e9c3ece24a38adfc089aef307e8a upstream.

Those return codes are only defined for the parisc architecture and
are leftovers from when we wanted to be HP-UX compatible.

They are not returned by any Linux kernel syscall but do trigger
problems with the glibc strerrorname_np() and strerror() functions as
reported in glibc issue #31080.

There is no need to keep them, so simply remove them.

Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: Bruno Haible <bruno@clisp.org>
Closes: https://sourceware.org/bugzilla/show_bug.cgi?id=31080
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/uapi/asm/errno.h       |    2 --
 lib/errname.c                              |    6 ------
 tools/arch/parisc/include/uapi/asm/errno.h |    2 --
 3 files changed, 10 deletions(-)

--- a/arch/parisc/include/uapi/asm/errno.h
+++ b/arch/parisc/include/uapi/asm/errno.h
@@ -75,7 +75,6 @@
 
 /* We now return you to your regularly scheduled HPUX. */
 
-#define ENOSYM		215	/* symbol does not exist in executable */
 #define	ENOTSOCK	216	/* Socket operation on non-socket */
 #define	EDESTADDRREQ	217	/* Destination address required */
 #define	EMSGSIZE	218	/* Message too long */
@@ -101,7 +100,6 @@
 #define	ETIMEDOUT	238	/* Connection timed out */
 #define	ECONNREFUSED	239	/* Connection refused */
 #define	EREFUSED	ECONNREFUSED	/* for HP's NFS apparently */
-#define	EREMOTERELEASE	240	/* Remote peer released connection */
 #define	EHOSTDOWN	241	/* Host is down */
 #define	EHOSTUNREACH	242	/* No route to host */
 
--- a/lib/errname.c
+++ b/lib/errname.c
@@ -111,9 +111,6 @@ static const char *names_0[] = {
 	E(ENOSPC),
 	E(ENOSR),
 	E(ENOSTR),
-#ifdef ENOSYM
-	E(ENOSYM),
-#endif
 	E(ENOSYS),
 	E(ENOTBLK),
 	E(ENOTCONN),
@@ -144,9 +141,6 @@ static const char *names_0[] = {
 #endif
 	E(EREMOTE),
 	E(EREMOTEIO),
-#ifdef EREMOTERELEASE
-	E(EREMOTERELEASE),
-#endif
 	E(ERESTART),
 	E(ERFKILL),
 	E(EROFS),
--- a/tools/arch/parisc/include/uapi/asm/errno.h
+++ b/tools/arch/parisc/include/uapi/asm/errno.h
@@ -75,7 +75,6 @@
 
 /* We now return you to your regularly scheduled HPUX. */
 
-#define ENOSYM		215	/* symbol does not exist in executable */
 #define	ENOTSOCK	216	/* Socket operation on non-socket */
 #define	EDESTADDRREQ	217	/* Destination address required */
 #define	EMSGSIZE	218	/* Message too long */
@@ -101,7 +100,6 @@
 #define	ETIMEDOUT	238	/* Connection timed out */
 #define	ECONNREFUSED	239	/* Connection refused */
 #define	EREFUSED	ECONNREFUSED	/* for HP's NFS apparently */
-#define	EREMOTERELEASE	240	/* Remote peer released connection */
 #define	EHOSTDOWN	241	/* Host is down */
 #define	EHOSTUNREACH	242	/* No route to host */
 


