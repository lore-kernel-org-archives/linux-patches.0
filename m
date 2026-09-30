Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB4B4A441D;
	Wed, 30 Sep 2026 17:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790223; cv=none; b=PWkJK7HWkybUd3JC6I+FDxLX5omW7XyqpAR3B9JCHa41nPd5XWSUeNprVTnCH2OpwqkvlUeE4nrBTu7GwoSrGWDd74XhxyPp5Tolt4SGQuiHidzfOh9NAHyzdR6KE/IgbjcJ8j07F+Ijqg2Mn5r3V9q+CdTSRu+g950oKTYoAF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790223; c=relaxed/simple;
	bh=l+P+Ht8CkC+36g+sS+IkAPH7+gz14vuHZzNW/Rm1fow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I2hS9JvJ3Qcz1jSO85kcviJa5oBt+Bgg6u1rMTPoXuByuYcaAEh/5U4W3/9dQOFg0kK4pPQusrylw8RQK9+2sqcBw3Gds212T/n2Hnbof8Ag+CFKSxhbkEkWuqbHY2xWVPJKP+XJ4O+zFW6GG8rL5hE4iLjptTU/k8zj3JQWWKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7WoSvTj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7WoSvTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326201F000FF;
	Wed, 30 Sep 2026 17:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790221;
	bh=T7Mry7ZYraT9AgStEC3SgwbDid6+V1HdZYHrQ3t41cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7WoSvTjMEWuCiKXamyjGAphJs4p9H2px5Nz7QJcV9nczZnQlU1zv8veWe7Cib1X7
	 el3jF+zeLNwg9kdjOzTjHKtG02bHZ0F+J/Uqj1RiDjjQRHy9HdexKsAs9z3+HKF9+8
	 ib0w2jZqBLRyL5i1LB4IRTqh1AaWG/YUONUozBc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 753/877] landlock: Clarify documentation for the IOCTL access right
Date: Wed, 30 Sep 2026 17:27:44 +0200
Message-ID: <20260930152430.945998923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -156,6 +156,23 @@ struct landlock_net_port_attr {
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
@@ -216,26 +233,6 @@ struct landlock_net_port_attr {
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


