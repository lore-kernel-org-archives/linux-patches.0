Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2151E519E18;
	Thu, 17 Sep 2026 17:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667170; cv=none; b=HCtuq4w+CKH++kjp9HYDhRwN/B1jVHf5zKWTVTIB7iS5GEPBdqX8b+4hov7RU0zpJkyHRTr9J3qCca0Uwuof6cBLyItOUgLzcUag7MhVKnHzFyIPZzuflR9jWYz5J3F4foEKNLvL1ZOcixD3Ecve2dLCaDfM7XJBnS+9X9S7/hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667170; c=relaxed/simple;
	bh=LmM1CSEAvkAHy6u/+syi85Xyh/nF9HkOWVIIwAjxjDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CbaA7AhnVFtsjWY+YQ2/lhj1Cqlf75FViuN+xGL3S84NYNPlCbG/ouTlf1d9FGkEpWNTYYofPB4lWxRfmtvSRvPm9SBQXm37jHfRsiMhH4iG83X3p7OFAbbWpmRTJbWZqWK5jsu54k5uZdV9xUVX+pqBPMX+dpIM95vs4V5c4Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wW57ANHr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wW57ANHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1AA1F000FF;
	Thu, 17 Sep 2026 17:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667167;
	bh=w2Prl19yFN0pmm0VYU3dwVOil9PzytnjxcwYjf/J+V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wW57ANHrqebHUyWW51K5KqnzmYETx65T8+uDMEqWaiT3VEu/ERZKFSCLwAN0odeaZ
	 bSlPJhDa5NU+C8lyxxgt2tUeW5SiOOa3BmIsKbGZDoIIiy6S2SfBbDlMLbckv/7XfK
	 fLKGCVnW3sIvQR9BhwmgrwBLZEoo9HkuqmyQ+91E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1228/1250] landlock: Clarify documentation for the IOCTL access right
Date: Thu, 17 Sep 2026 16:17:03 +0100
Message-ID: <20260917151625.574138085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Günther Noack <gnoack3000@gmail.com>

[ Upstream commit 6abbb8703aeeb645a681ab6ad155e0b450413787 ]

Move the description of the LANDLOCK_ACCESS_FS_IOCTL_DEV access right
together with the file access rights.

This group of access rights applies to files (in this case device
files), and they can be added to file or directory inodes using
landlock_add_rule(2).  The check for that works the same for all file
access rights, including LANDLOCK_ACCESS_FS_IOCTL_DEV.

Invoking ioctl(2) on directory FDs can not currently be restricted
with Landlock.  Having it grouped separately in the documentation is a
remnant from earlier revisions of the LANDLOCK_ACCESS_FS_IOCTL_DEV
patch set.

Link: https://lore.kernel.org/all/20260108.Thaex5ruach2@digikod.net/
Signed-off-by: Günther Noack <gnoack3000@gmail.com>
Link: https://lore.kernel.org/r/20260111175203.6545-2-gnoack3000@gmail.com
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Stable-dep-of: 2c6dc7925382 ("landlock: Fix use-after-free of the source's parent directory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/landlock.h |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

--- a/include/uapi/linux/landlock.h
+++ b/include/uapi/linux/landlock.h
@@ -216,6 +216,23 @@ struct landlock_net_port_attr {
  *   :manpage:`ftruncate(2)`, :manpage:`creat(2)`, or :manpage:`open(2)` with
  *   ``O_TRUNC``.  This access right is available since the third version of the
  *   Landlock ABI.
+ * - %LANDLOCK_ACCESS_FS_IOCTL_DEV: Invoke :manpage:`ioctl(2)` commands on an opened
+ *   character or block device.
+ *
+ *   This access right applies to all `ioctl(2)` commands implemented by device
+ *   drivers.  However, the following common IOCTL commands continue to be
+ *   invokable independent of the %LANDLOCK_ACCESS_FS_IOCTL_DEV right:
+ *
+ *   * IOCTL commands targeting file descriptors (``FIOCLEX``, ``FIONCLEX``),
+ *   * IOCTL commands targeting file descriptions (``FIONBIO``, ``FIOASYNC``),
+ *   * IOCTL commands targeting file systems (``FIFREEZE``, ``FITHAW``,
+ *     ``FIGETBSZ``, ``FS_IOC_GETFSUUID``, ``FS_IOC_GETFSSYSFSPATH``)
+ *   * Some IOCTL commands which do not make sense when used with devices, but
+ *     whose implementations are safe and return the right error codes
+ *     (``FS_IOC_FIEMAP``, ``FICLONE``, ``FICLONERANGE``, ``FIDEDUPERANGE``)
+ *
+ *   This access right is available since the fifth version of the Landlock
+ *   ABI.
  *
  * Whether an opened file can be truncated with :manpage:`ftruncate(2)` or used
  * with `ioctl(2)` is determined during :manpage:`open(2)`, in the same way as
@@ -276,26 +293,6 @@ struct landlock_net_port_attr {
  *   If multiple requirements are not met, the ``EACCES`` error code takes
  *   precedence over ``EXDEV``.
  *
- * The following access right applies both to files and directories:
- *
- * - %LANDLOCK_ACCESS_FS_IOCTL_DEV: Invoke :manpage:`ioctl(2)` commands on an opened
- *   character or block device.
- *
- *   This access right applies to all `ioctl(2)` commands implemented by device
- *   drivers.  However, the following common IOCTL commands continue to be
- *   invokable independent of the %LANDLOCK_ACCESS_FS_IOCTL_DEV right:
- *
- *   * IOCTL commands targeting file descriptors (``FIOCLEX``, ``FIONCLEX``),
- *   * IOCTL commands targeting file descriptions (``FIONBIO``, ``FIOASYNC``),
- *   * IOCTL commands targeting file systems (``FIFREEZE``, ``FITHAW``,
- *     ``FIGETBSZ``, ``FS_IOC_GETFSUUID``, ``FS_IOC_GETFSSYSFSPATH``)
- *   * Some IOCTL commands which do not make sense when used with devices, but
- *     whose implementations are safe and return the right error codes
- *     (``FS_IOC_FIEMAP``, ``FICLONE``, ``FICLONERANGE``, ``FIDEDUPERANGE``)
- *
- *   This access right is available since the fifth version of the Landlock
- *   ABI.
- *
  * .. warning::
  *
  *   It is currently not possible to restrict some file-related actions


