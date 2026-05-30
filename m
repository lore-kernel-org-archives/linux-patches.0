Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458FF3C5DCD;
	Sat, 30 May 2026 18:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165726; cv=none; b=r3Hsot/tlSrvPnOKqIAPTrKDajHJ8RGG3xffWUqqYv7433uLFIvYMDGn7yb5QMta9QSZ0HSVSITFDgInC2Q0H3TSSuMloU8zp/c7YMLurCaKwRxItoCuVdNeMBvHuv2AxIaZ940i2t1HGsRTVM1U5uIZMc5xMWvbieZL3QNPyQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165726; c=relaxed/simple;
	bh=GbzLRVc9oOeCQ6FAbI1frTrpO46OESceADJkI8aZY/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ita4YaZbb6mgAMi8IziqaSdmnu28xiBif5cnrgf7AZwcuRQ7w7EFX0JB9xctjTS3alcEDuUCbYz3J5mUfykO4EBZxawud87XnORVDUbSGsctU2AnfKAiDNVrNOEFBl+lgLlWrSW4jCU6Rwg3YJFH/nNt7mHtmYmET6IjaL5375s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pad1iDkO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pad1iDkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A071F00898;
	Sat, 30 May 2026 18:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165725;
	bh=boxXx8jXwH4gK0hd8lE6Q9D/yy+PzSuKdJJmyoMILbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pad1iDkO74kqgThPDIo939msuQDnI4FxDeQpWo7p9ZFnNJSRVmzz/AxY+juDV2HwB
	 acEhY8FN7eCmfNHtMBkoYwwZeoGbb9UKVcUIvomJknDQQOpbZ9XXfFBs99WNcQilrY
	 IR6mbSPM/6wllv2cyW6PbJ1AARtvAU8pDLSl+QXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 163/589] parisc: _llseek syscall is only available for 32-bit userspace
Date: Sat, 30 May 2026 18:00:44 +0200
Message-ID: <20260530160229.071018010@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit da3680f564bd787ce974f9931e6e924d908b3b2a upstream.

Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/syscalls/syscall.tbl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -154,7 +154,7 @@
 # 137 was afs_syscall
 138	common	setfsuid		sys_setfsuid
 139	common	setfsgid		sys_setfsgid
-140	common	_llseek			sys_llseek
+140	32	_llseek			sys_llseek
 141	common	getdents		sys_getdents			compat_sys_getdents
 142	common	_newselect		sys_select			compat_sys_select
 143	common	flock			sys_flock


