Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9040B1DDDB;
	Thu, 13 Jun 2024 12:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282737; cv=none; b=oOprLC2qhL3GntLZHes0vH+AYrzM6JGTqtrksnpXmgI0XWQNQvn4bsSJrmPmKdWYThkkKjAJFwhuD874ct5grgHHmSyuwefbbic9l3lNTDmtFqBxWYrsASTP/nbYCmXp4gT64NSlT3Spy/CtZF3OKid305QzfJPWgdA9iUZ08Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282737; c=relaxed/simple;
	bh=iTDIb1eJlfYJDKlk890dWtVfM+07ugmxKpEuMhy/xaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVdig8ecFvQGh6rP0jAac6ceRUb5fVGRrN3/K4vAo0ZCCoUFN4HZ/PXpykdjubQ40C0jotJRp8kyMLwvjqJolQUWdGNAmoq/vDVkmRV1kXxHvS38A+EhtXXs8Vd2Kz+4kTfpfmGU86sdPeV/yYc6il30JFvInsThu9ruSkrsCnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wr3u5Ips; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wr3u5Ips"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EC8C2BBFC;
	Thu, 13 Jun 2024 12:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282737;
	bh=iTDIb1eJlfYJDKlk890dWtVfM+07ugmxKpEuMhy/xaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wr3u5IpsnHpWMPcheyQ7Jx16Y5NQeNw97g7XVjPhwp77gpyqXUZYmIP1rSdfJmJxZ
	 8y50skwKFxLzSrKErsdW6I93byFUriUkkeka7sSw9zGlAmKZW4rnNp055FLpIIeEbD
	 GcNII6UrxRynhZIXV2npzHAY6/YxPAxScU0yqeVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Christian Brauner <brauner@kernel.org>,
	Hao Ge <gehao@kylinos.cn>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 351/402] scripts/gdb: fix SB_* constants parsing
Date: Thu, 13 Jun 2024 13:35:08 +0200
Message-ID: <20240613113315.827782825@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

commit 6a59cb5158bff13b80f116305155fbe4967a5010 upstream.

--0000000000009a0c9905fd9173ad
Content-Transfer-Encoding: 8bit

After f15afbd34d8f ("fs: fix undefined behavior in bit shift for
SB_NOUSER") the constants were changed from plain integers which
LX_VALUE() can parse to constants using the BIT() macro which causes the
following:

Reading symbols from build/linux-custom/vmlinux...done.
Traceback (most recent call last):
  File "/home/fainelli/work/buildroot/output/arm64/build/linux-custom/vmlinux-gdb.py", line 25, in <module>
    import linux.constants
  File "/home/fainelli/work/buildroot/output/arm64/build/linux-custom/scripts/gdb/linux/constants.py", line 5
    LX_SB_RDONLY = ((((1UL))) << (0))

Use LX_GDBPARSED() which does not suffer from that issue.

f15afbd34d8f ("fs: fix undefined behavior in bit shift for SB_NOUSER")
Link: https://lkml.kernel.org/r/20230607221337.2781730-1-florian.fainelli@broadcom.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Acked-by: Christian Brauner <brauner@kernel.org>
Cc: Hao Ge <gehao@kylinos.cn>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gdb/linux/constants.py.in |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/scripts/gdb/linux/constants.py.in
+++ b/scripts/gdb/linux/constants.py.in
@@ -46,12 +46,12 @@ if IS_BUILTIN(CONFIG_COMMON_CLK):
     LX_GDBPARSED(CLK_GET_RATE_NOCACHE)
 
 /* linux/fs.h */
-LX_VALUE(SB_RDONLY)
-LX_VALUE(SB_SYNCHRONOUS)
-LX_VALUE(SB_MANDLOCK)
-LX_VALUE(SB_DIRSYNC)
-LX_VALUE(SB_NOATIME)
-LX_VALUE(SB_NODIRATIME)
+LX_GDBPARSED(SB_RDONLY)
+LX_GDBPARSED(SB_SYNCHRONOUS)
+LX_GDBPARSED(SB_MANDLOCK)
+LX_GDBPARSED(SB_DIRSYNC)
+LX_GDBPARSED(SB_NOATIME)
+LX_GDBPARSED(SB_NODIRATIME)
 
 /* linux/htimer.h */
 LX_GDBPARSED(hrtimer_resolution)


