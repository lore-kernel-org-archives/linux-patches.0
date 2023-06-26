Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F5311CAB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106E7C433C8;
	Mon, 26 Jun 2023 18:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804781;
	bh=cGw9QHCVuDwSqJtvv4C0gVXI19jHMBQvtscjn1aNeiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6qfBGHSKfEQ/15isDxdbatebConqq8cTcLmhDKczQY+zfl5S9FWT4NrvKW11EkvH
	 32UTfesJ4rNP3Pnw08Ajme+DIh/+fjsM21kcADI2h8757IzEzjjCqHbUVBdqoOolyz
	 igeFPKbBtmSZhUksWzklYaYqKIQirilIjghEUjUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	Hardik Garg <hargar@linux.microsoft.com>
Subject: [PATCH 5.15 10/96] selftests/mount_setattr: fix redefine struct mount_attr build error
Date: Mon, 26 Jun 2023 20:11:25 +0200
Message-ID: <20230626180747.365210276@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shuah Khan <skhan@linuxfoundation.org>

commit d8e45bf1aed2e5fddd8985b5bb1aaf774a97aba8 upstream.

Fix the following build error due to redefining struct mount_attr by
removing duplicate define from mount_setattr_test.c

gcc -g -isystem .../tools/testing/selftests/../../../usr/include -Wall -O2 -pthread     mount_setattr_test.c  -o .../tools/testing/selftests/mount_setattr/mount_setattr_test
mount_setattr_test.c:107:8: error: redefinition of ‘struct mount_attr’
  107 | struct mount_attr {
      |        ^~~~~~~~~~
In file included from /usr/include/x86_64-linux-gnu/sys/mount.h:32,
                 from mount_setattr_test.c:10:
.../usr/include/linux/mount.h:129:8: note: originally defined here
  129 | struct mount_attr {
      |        ^~~~~~~~~~
make: *** [../lib.mk:145: .../tools/testing/selftests/mount_setattr/mount_setattr_test] Error 1

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Hardik Garg <hargar@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mount_setattr/mount_setattr_test.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/tools/testing/selftests/mount_setattr/mount_setattr_test.c
+++ b/tools/testing/selftests/mount_setattr/mount_setattr_test.c
@@ -104,13 +104,6 @@
 	#else
 		#define __NR_mount_setattr 442
 	#endif
-
-struct mount_attr {
-	__u64 attr_set;
-	__u64 attr_clr;
-	__u64 propagation;
-	__u64 userns_fd;
-};
 #endif
 
 #ifndef __NR_open_tree


