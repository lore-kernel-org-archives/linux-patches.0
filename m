Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065601;
	b=Ylcpi+PQd8OwlMDQI61TaJloxSvPu7TE41dZVtyXXqV9EbznL3xkwBQIbZ+Vo1jWtTeN
	 Y9idzTZ1/MX4KNMrEcc7c37JlETBha7APgkwXPwXpVaOkMBSFEW9Z/NkgqA02/+IjT0fV
	 AYlhI4waOqeHJrUwLLmIeLdXMxzgWjvCfb9unj6880pcICt1KuT6hyNVQvkeepjJMe/+b
	 seUQASJXPhRgC8Kr+8mO4PeJe93zHQ8I8yBDZEKkuWyF2M3VuMyQ33GMLfAX5WzPi3JMD
	 h/cQFiPF/rFAr9bLtTtFeXy5HFZJKpPBthRGHeBJQQ5O5iDSXjvnzspxOroVDdOoPVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xDVls9iNcCWyDy8oGpdI68RbHviAseCereRvii6M3yo=;
	b=WlGwBmAxlPRxg6QAIkLNe5veK6bpeu5N9hbnKlzif2yO+mpcLCcOx9B5Ovr7E+nm/QXv
	 BKVfA1AlxUzCEr4JKvVqWA7dSuuLVviTWnjxBp+O6UbPe7LJGRIgPhXbjdWMWAdAFFdUd
	 xyySpByUgzktLFILLYPTJOMeBT2vzByPUjm/bwoRsBPPN7MwiRoxw2xuedIeeln3qbDxk
	 EqgXynZtu+KDafNItquz/bSqzh0/ihIDbXXSoSLayntepjBCxADlFzlthZNKtGA6QG7Sp
	 n2QwpquJKJcjBU37YrmHHCE8PCPuwMQWM8lFrZk8YVmM1YbGSt/Yk8fq1gHfN+lpgPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MrIj7wek;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633C9606A32C;
	Sat,  7 Nov 2026 15:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MrIj7wek
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F871F0089F;
	Sat,  7 Nov 2026 15:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065601;
	bh=xDVls9iNcCWyDy8oGpdI68RbHviAseCereRvii6M3yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MrIj7wekxbHY15M2l6C343ZKIZelEGPs6k5vNh/FiGC3JHUOM2JOKepTiaM3DezUu
	 gwSli8ur/xw9CXZadP4F749K7Ve3sv2+CHLB9KEyKa2vwtnJkcFwCd374V58BqGv2z
	 8k7P4mVZRzleSuNxNgFTDUDIjGf28yOAKGlKglyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1256/1257] apparmor: fix uninitialized variable warning in aa_inherit_files
Date: Sat,  7 Nov 2026 08:59:12 -0500
Message-ID: <20261107135013.998565437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit ed35bbe7d06e6505401eff3f3c7a36bd1f167a17 ]

Fix the following warning

All warnings (new ones prefixed by >>):

>> security/apparmor/file.c:737:53: warning: variable 'file' is uninitialized when used here [-Wuninitialized]
     737 |                 int error = aa_file_perm(OP_INHERIT, cred, label, file,
         |                                                                   ^~~~
   security/apparmor/file.c:724:36: note: initialize the variable 'file' to silence this warning
     724 |         struct file *devnull = NULL, *file;
         |                                           ^
         |                                            = NULL
   1 warning generated.

vim +/file +737 security/apparmor/file.c

   719
   720	/* based on selinux's flush_unauthorized_files */
   721	void aa_inherit_files(const struct cred *cred, struct files_struct *files)
   722	{
   723		struct aa_label *label = aa_get_newest_cred_label(cred);
   724		struct file *devnull = NULL, *file;
   725		bool devnull_tried = false;
   726		unsigned int n = 0;
   727
   728		revalidate_tty(cred, label);
   729
   730		/*
   731		 * Revalidate access to inherited open files. Each file is
   732		 * revalidated holding only a reference to it, with no locks
   733		 * held, as revalidation may sleep (e.g. unix socket mediation
   734		 * dropping path refs, or allocating path buffers).
   735		 */
   736		while ((n = iterate_fd(files, n, get_next_file, &file)) != 0) {
 > 737			int error = aa_file_perm(OP_INHERIT, cred, label, file,

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610292346.ehqNujiE-lkp@intel.com/
Fixes: a913281f60015 ("apparmor: don't revalidate inherited files under files->file_lock")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/file.c b/security/apparmor/file.c
index b52781e05a5a1..baca370ddfc02 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -721,7 +721,7 @@ static int get_next_file(const void *p, struct file *file, unsigned int fd)
 void aa_inherit_files(const struct cred *cred, struct files_struct *files)
 {
 	struct aa_label *label = aa_get_newest_cred_label(cred);
-	struct file *devnull = NULL, *file;
+	struct file *devnull = NULL, *file = NULL;
 	bool devnull_tried = false;
 	unsigned int n = 0;
 
-- 
2.53.0



