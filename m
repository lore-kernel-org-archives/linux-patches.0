Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA83730C375;
	Mon, 13 Oct 2025 15:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368013; cv=none; b=kOIBd8Fv2YmTrVXQv1Gu2n5k0P3XzsIrUrcM92b52g6j7wAgWaGEbCvx2Gckfx+mHEzm8GZC9d5HSceKOcRLHTVl9vS0ImoLlLwYtIzcw3mAXcrSU500DTEMuVmApIuAK+R5dJKM1AYTyLqFlht7AzeqJU/a8FkReSaOoe/lwJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368013; c=relaxed/simple;
	bh=ualfuXBdZOApZF4uCQRs1N9PkN/fkVnBBew3DDLuiRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcXCSWX6XYnvvner5q3mMMXeC0fRMs66M1iMX+1nunu/5Ianoly+1f2MRnOJSIXAeZqfGIeY9Eg8SWJsQ24mjnQ9wkaIgbohgrJnvqSdhNfHc8OCmI2jfdBF3iVYLVQ2xR6pNDZP54drby57OMhSAfwe2A2DSBOU5kATZ9WFrPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SF3vXd5Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SF3vXd5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75491C4CEE7;
	Mon, 13 Oct 2025 15:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368012;
	bh=ualfuXBdZOApZF4uCQRs1N9PkN/fkVnBBew3DDLuiRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SF3vXd5Qw9Hi4L/QH5Rma7CRU5N0MBpMKYrngv4noyRL6An40k+palbujrAK6eGal
	 o9JJTB4KhnidnPmQ7+ieHSJ5IWe5lq9qZxc3NAkMWSzgrErA+UV2FoXxc1FLWTKIC2
	 1oVdXeKtLxhBOm7YgbwFayBCVNOjIuxJ0ctfYspY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/262] lsm: CONFIG_LSM can depend on CONFIG_SECURITY
Date: Mon, 13 Oct 2025 16:42:36 +0200
Message-ID: <20251013144326.641052826@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 54d94c422fed9575b74167333c1757847a4e6899 ]

When CONFIG_SECURITY is not set, CONFIG_LSM (builtin_lsm_order) does
not need to be visible and settable since builtin_lsm_order is defined in
security.o, which is only built when CONFIG_SECURITY=y.

So make CONFIG_LSM depend on CONFIG_SECURITY.

Fixes: 13e735c0e953 ("LSM: Introduce CONFIG_LSM")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
[PM: subj tweak]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/Kconfig b/security/Kconfig
index 28e685f53bd1a..ce9f1a651ccc3 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -264,6 +264,7 @@ endchoice
 
 config LSM
 	string "Ordered list of enabled LSMs"
+	depends on SECURITY
 	default "landlock,lockdown,yama,loadpin,safesetid,smack,selinux,tomoyo,apparmor,ipe,bpf" if DEFAULT_SECURITY_SMACK
 	default "landlock,lockdown,yama,loadpin,safesetid,apparmor,selinux,smack,tomoyo,ipe,bpf" if DEFAULT_SECURITY_APPARMOR
 	default "landlock,lockdown,yama,loadpin,safesetid,tomoyo,ipe,bpf" if DEFAULT_SECURITY_TOMOYO
-- 
2.51.0



